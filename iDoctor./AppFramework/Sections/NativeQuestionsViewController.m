//
//  NativeQuestionsViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/15.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "NativeQuestionsViewController.h"
#import <PureLayout.h>
#import <WEPopoverController.h>
#import "NativeQuestionsForALLSubConrollerView.h"
#import "NativeQuestionsForRepliedSubConrollerView.h"
#import "QuickQuestion.h"
#import "Comment.h"

#import "NativeQuestionsOfficeTypesTableViewController.h"
#import "ImageUtils.h" //Temp Test will delete

@interface NativeQuestionsViewController ()
<
DFDQuickQuestionDetailViewControllerDelegate,
NativeQuestionsOfficeTypesTableViewControllerDelegate
>

@property (nonatomic, strong) UIView *leftTabView;
@property (nonatomic, strong) UIView *leftSelectedLine;
@property (nonatomic, strong) UIView *rightTabView;
@property (nonatomic, strong) UIView *rightSelectedLine;

@property (nonatomic, strong) UIViewController<NativeQuestionsListPort> *allQuestionViewController;
@property (nonatomic, strong) UIViewController<NativeQuestionsListPort> *iRepliedQuestionViewController;

@property (nonatomic, strong) WEPopoverController *contentPopoverController;
@property (nonatomic, strong) UIBarButtonItem *rightItem;;

@end

@implementation NativeQuestionsViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        self.tabBarItem.title = @"快速提问";
        
        [self.tabBarItem setImage:[SkinManager sharedInstance].defaultNativeQuestionTabBarNormalIcon];
        [self.tabBarItem setSelectedImage:[SkinManager sharedInstance].defaultNativeQuestionTabBarHighlightedIcon];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"科室" style:UIBarButtonItemStylePlain target:self action:@selector(showOfficeTypeSelectMenu:)];
//    [rightItem setTitle:@"科室"];
    
    //TODO 需要右箭头
    [self setNavigationBarWithTitle:@"快速提问" leftBarButtonItem:nil rightBarButtonItem:self.rightItem];
    
//    [self.view addSubview:self.headerView];
    [self.view addSubview:self.leftTabView];
    [self.view addSubview:self.rightTabView];
    
    self.view.backgroundColor = UIColorFromRGB(0xedf2f1);
    
    //AutoLayout
    {
        [self.view addConstraint:[self.leftTabView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f]];
        [self.view addConstraint:[self.leftTabView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
        [self.view addConstraints:[self.leftTabView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width / 2 - 0.5f, 50.0f)]];
        
        [self.view addConstraint:[self.rightTabView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f]];
        [self.view addConstraint:[self.rightTabView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
        [self.view addConstraints:[self.rightTabView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width / 2 - 0.5f, 50.0f)]];
        
        [self.view addSubview:self.iRepliedQuestionViewController.view];
        [self.view addSubview:self.allQuestionViewController.view];
        
        [self addChildViewController:self.iRepliedQuestionViewController];
        [self addChildViewController:self.allQuestionViewController];
        
        [self.view addConstraints:[self.iRepliedQuestionViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50.0f, 0.0f, 0.0f, 0.0f)]];
        [self.view addConstraints:[self.allQuestionViewController.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(50.0f, 0.0f, 0.0f, 0.0f)]];
        
    }
    
    [self nativeQuestionList:nil];
}

#pragma mark - Actions

- (void)showOfficeTypeSelectMenu:(id)sender {
    
    NativeQuestionsOfficeTypesTableViewController *noc = [[NativeQuestionsOfficeTypesTableViewController alloc] init];
    noc.delegate = self;
    
//    self.contentSizeForViewInPopover = CGSizeMake(200.0f, 500.0f);
    self.contentPopoverController = [[WEPopoverController alloc] initWithContentViewController:noc];
    WEPopoverContainerViewProperties *defaultContainerViewProperties = [WEPopoverController defaultContainerViewProperties];
    defaultContainerViewProperties.upArrowImageName = @"arrow_up_bg";
    defaultContainerViewProperties.arrowMargin = 39.0f;
    defaultContainerViewProperties.leftBgMargin = 0.0f;
    defaultContainerViewProperties.rightBgMargin = 0.0f;
    defaultContainerViewProperties.topBgMargin = 0.0f;
    defaultContainerViewProperties.bottomBgMargin = 0.0f;
    defaultContainerViewProperties.topContentMargin = 0.0f;
    [self.contentPopoverController setContainerViewProperties:defaultContainerViewProperties];
    self.contentPopoverController.popoverContentSize = CGSizeMake(100, 217);
    
    [self.contentPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
    CGRect frame = self.contentPopoverController.view.frame;
    frame.origin.y = frame.origin.y + 10.0f;
    self.contentPopoverController.view.frame = frame;
}

- (void)nativeQuestionList:(id)sender {
    NSLog(@"nativeQuestionList");
    
    self.leftSelectedLine.backgroundColor = UIColorFromRGB(0x34d2b4);
    self.rightSelectedLine.backgroundColor = UIColorFromRGB(0xd4d4d4);
    
    [self.view bringSubviewToFront:self.allQuestionViewController.view];
}

- (void)myQuestionList:(id)sender {
    NSLog(@"myQuestionList");
    
    self.rightSelectedLine.backgroundColor = UIColorFromRGB(0x34d2b4);
    self.leftSelectedLine.backgroundColor = UIColorFromRGB(0xd4d4d4);
    
    [self.view bringSubviewToFront:self.iRepliedQuestionViewController.view];
}

#pragma mark - NativeQuestionsOfficeTypesTableViewControllerDelegate Methods

- (void)didSelectedOfficeType:(NSString *)officeType {
    [self.contentPopoverController dismissPopoverAnimated:YES];
    [self.rightItem setTitle:officeType];
    
    [self.allQuestionViewController officeTypeChanged:officeType];
    [self.iRepliedQuestionViewController officeTypeChanged:officeType];
}

#pragma mark - DFDQuickQuestionDetailViewControllerDelegate Methods

- (void)quickQuestionDetailViewController:(DFDQuickQuestionDetailViewController *)viewController didAddComment:(Comment *)comment forQuickQuestion:(QuickQuestion *)quickQuestion {
    
    [self.allQuestionViewController updateListWithQuestion:quickQuestion Comment:comment];
    [self.iRepliedQuestionViewController updateListWithQuestion:quickQuestion Comment:comment];
    
}


//- (UIView *)headerView {
//    
//    if (!_headerView) {
//        
//        _headerView = [[UIView alloc] init];
//        _headerView.frame = CGRectMake(0, 0, App_Frame_Width, 50.0f);
//        
//        [_headerView addSubview:self.leftTabView];
//        [_headerView addSubview:self.rightTabView];
//        
//        [_headerView addConstraint:[self.leftTabView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_headerView withOffset:0.0f]];
//        [_headerView addConstraint:[self.leftTabView autoSetDimension:ALDimensionHeight toSize:50.0f]];
//        [_headerView addConstraint:[self.leftTabView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width / 2 - 0.5]];
//        [_headerView addConstraint:[self.leftTabView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_headerView]];
//        
//        [_headerView addConstraint:[self.rightTabView autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.leftTabView withOffset:-1.0f]];
//        [_headerView addConstraint:[self.rightTabView autoSetDimension:ALDimensionHeight toSize:50.0f]];
//        [_headerView addConstraint:[self.rightTabView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width / 2 - 0.5]];
//        [_headerView addConstraint:[self.rightTabView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_headerView]];
//        
//    }
//    
//    return _headerView;
//}

- (UIView *)leftTabView {
    
    if (!_leftTabView) {
        
        _leftTabView = [[UIView alloc] init];
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:UIColorFromRGB(0x68BCAB) forState:UIControlStateNormal];
        [btn setTitle:@"快速提问" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(nativeQuestionList:) forControlEvents:UIControlEventTouchUpInside];
        
        [_leftTabView addSubview:btn];
        [_leftTabView addSubview:self.leftSelectedLine];
        
        [_leftTabView addConstraints:[btn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 2.0f, 0)]];
        [_leftTabView addConstraint:[self.leftSelectedLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn]];
        [_leftTabView addConstraint:[self.leftSelectedLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
        [_leftTabView addConstraint:[self.leftSelectedLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
        [_leftTabView addConstraint:[self.leftSelectedLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f]];
        [_leftTabView addConstraint:[self.leftSelectedLine autoSetDimension:ALDimensionHeight toSize:2.0f]];
        
    }
    
    return _leftTabView;
}

- (UIView *)rightTabView {
    
    if (!_rightTabView) {
        
        _rightTabView = [[UIView alloc] init];
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:UIColorFromRGB(0x68BCAB) forState:UIControlStateNormal];
        [btn setTitle:@"回复记录" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(myQuestionList:) forControlEvents:UIControlEventTouchUpInside];
        
        [_rightTabView addSubview:btn];
        [_rightTabView addSubview:self.rightSelectedLine];
        
        [_rightTabView addConstraints:[btn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 2.0f, 0)]];
        [_rightTabView addConstraint:[self.rightSelectedLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn]];
        [_rightTabView addConstraint:[self.rightSelectedLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
        [_rightTabView addConstraint:[self.rightSelectedLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
        [_rightTabView addConstraint:[self.rightSelectedLine autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f]];
        [_rightTabView addConstraint:[self.rightSelectedLine autoSetDimension:ALDimensionHeight toSize:2.0f]];
    }
    
    return _rightTabView;
}

- (UIView *)leftSelectedLine {
    
    if (!_leftSelectedLine) {
        
        _leftSelectedLine = [[UIView alloc] init];
        _leftSelectedLine.backgroundColor = UIColorFromRGB(0x34d2b4);
    }
    
    return _leftSelectedLine;
}

- (UIView *)rightSelectedLine {
    
    if (!_rightSelectedLine) {
        
        _rightSelectedLine = [[UIView alloc] init];
        _rightSelectedLine.backgroundColor = UIColorFromRGB(0x34d2b4);
    }
    
    return _rightSelectedLine;
}

- (UIViewController *)allQuestionViewController {
    
    if (!_allQuestionViewController) {
        
        _allQuestionViewController = [[NativeQuestionsForALLSubConrollerView alloc] init];
    }
    
    return _allQuestionViewController;
}

- (UIViewController *)iRepliedQuestionViewController {
    
    if (!_iRepliedQuestionViewController) {
        
        _iRepliedQuestionViewController = [[NativeQuestionsForRepliedSubConrollerView alloc] init];
    }
    
    return _iRepliedQuestionViewController;
}

- (UIBarButtonItem *)rightItem {
    
    if (!_rightItem) {
        
        _rightItem = [[UIBarButtonItem alloc] initWithTitle:@"科室" style:UIBarButtonItemStylePlain target:self action:@selector(showOfficeTypeSelectMenu:)];
    }
    
    return _rightItem;
}

@end
