//
//  DFDQuickQuestionDetailViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDQuickQuestionDetailViewController.h"
#import "SkinManager.h"
#import "AccountManager.h"
#import "DFDSubtitleTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "UIResponder+Router.h"
#import "UIImageView+WebCache.h"
#import "DFDQuickQuestionDetailTableViewCell.h"
#import "TTTAttributedLabel.h"
#import "MWPhotoBrowser.h"
#import "DFDInputViewController.h"
#import "ContactInfoViewController.h"
#import "QuickQuistionCommentCell.h"
#import "QuickQuestionReplyCell.h"
#import "NativeQuestionDetailQuestionCell.h"
#import "NativeQuestionDetailCommentCell.h"
#import "NativeQuestionReplyViewController.h"

@interface DFDQuickQuestionDetailViewController ()
<
UITableViewDataSource, UITableViewDelegate,
MWPhotoBrowserDelegate,
DFDInputViewControllerDelegate,
NativeQuestionReplyViewControllerDelegate
>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) MWPhotoBrowser    *photoBrowser;
@property (nonatomic, strong) NSString      *commentText;
@property (nonatomic, strong) NSMutableArray *iRepliedComments;

@property (nonatomic, strong) UIView *bottomReplyView;
@property (nonatomic, strong) UITextView *replyTextView;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)addReplyButtonClicked:(id)sender;

@end

@implementation DFDQuickQuestionDetailViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}

bool isSpread = true;

enum QuickQuestionTableViewSection
{
    QuickQuestion_Section = 0,
    RepliedComment_Section,
    Reply_Section,
    ReplyBtn_Section
};

#define CellTextFont    [UIFont systemFontOfSize:14.0f]

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarWithTitle:@"快速提问详情" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    self.view.backgroundColor = UIColorFromRGB(0xeef1f1);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.iRepliedComments = [[NSMutableArray alloc] init];
    NSInteger accountID = [[[AccountManager sharedInstance] account] accountID];
    for (Comment *comment in self.quickQuestion.comments) {
        
        if (comment.doctor.accountID == accountID) {
            [self.iRepliedComments addObject:comment];
        }
    }
    
    [self setupSubviews];
    
    // Add Reply Button
//    UIView *tableFooterView = [[UIView alloc] init];
//    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    replyButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
//    replyButton.layer.cornerRadius = 3.0f;
//    replyButton.layer.masksToBounds = YES;
//    [replyButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
//    [replyButton setTitle:@"回复" forState:UIControlStateNormal];
//    [replyButton addTarget:self action:@selector(addReplyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [tableFooterView addSubview:replyButton];
//    // Autolayout
//    [tableFooterView addConstraints:[replyButton autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f)]];
//    self.tableView.tableFooterView = tableFooterView;
//    [tableFooterView setFrame:CGRectMake(0.0f, 0.0f, App_Frame_Width, 155.0f)];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Method

- (void)setupSubviews
{
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.backgroundColor = UIColorFromRGB(0xedf2f1);
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomReplyView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraint:[self.bottomReplyView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f]];
    [self.view addConstraint:[self.bottomReplyView autoAlignAxisToSuperviewAxis:ALAxisVertical]];
    [self.view addConstraints:[self.bottomReplyView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 50.0f)]];
    
    [self.view addConstraint:[self.tableView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f]];
    [self.view addConstraint:[self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
    [self.view addConstraint:[self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
    [self.view addConstraint:[self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.bottomReplyView]];
}


#pragma mark - Property

- (UITableView *)tableView
{
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}


- (UIView *)bottomReplyView {
    
    if (!_bottomReplyView) {
        
        _bottomReplyView = [[UIView alloc] init];
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"messageToolbarBg"] stretchableImageWithLeftCapWidth:0.5 topCapHeight:10]];
        UIButton *submitBtn = [[UIButton alloc] init];
        
        [submitBtn setTitle:@"回复" forState:UIControlStateNormal];
        submitBtn.backgroundColor = UIColorFromRGB(0x479cea);
        submitBtn.layer.cornerRadius = 6.0f;
        [submitBtn addTarget:self action:@selector(addReplyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomReplyView addSubview:bgImageView];
//        [_bottomReplyView addSubview:self.replyTextView];
        [_bottomReplyView addSubview:submitBtn];
        
        {
            [_bottomReplyView addConstraints:[bgImageView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0)]];
            [_bottomReplyView addConstraints:[submitBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(8.0f, 50.0f, 8.0f, 50.0f)]];
//            [_bottomReplyView addConstraint:[submitBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.replyTextView withOffset:8.0f]];
//            [_bottomReplyView addConstraint:[submitBtn autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:8.0f]];
//            [_bottomReplyView addConstraint:[submitBtn autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8.0f]];
//            [_bottomReplyView addConstraint:[submitBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8.0f]];
            
        }
    }
    
    return _bottomReplyView;
}

- (UITextView *)replyTextView {
    
    if (!_replyTextView) {
        
        _replyTextView = [[UITextView alloc] init];
        _replyTextView.layer.cornerRadius = 6.0f;
        _replyTextView.layer.borderWidth = 0.5f;
        _replyTextView.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    
        
        _replyTextView.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return _replyTextView;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (QuickQuestion_Section == section) {
        return 1;
    }
    else if (RepliedComment_Section == section) {
        if (isSpread) {
            return [self.iRepliedComments count];
        }
        else {
            return 0;
        }
    }
    else if (Reply_Section == section) {
        return 1;
    }
    else if (ReplyBtn_Section == section) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (QuickQuestion_Section == indexPath.section) {
        static NSString *QuestionReuseIdentifier = @"7F4B5F06-73B3-4E30-8860-E36783DC2BD0";
        NativeQuestionDetailQuestionCell *questionDetailTableViewCell = [tableView dequeueReusableCellWithIdentifier:QuestionReuseIdentifier];
        if (nil == questionDetailTableViewCell) {
            questionDetailTableViewCell = [[NativeQuestionDetailQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuestionReuseIdentifier];
        }
        
        [questionDetailTableViewCell loadQuickQuestion:self.quickQuestion];
        cell = questionDetailTableViewCell;
    }
    else if (RepliedComment_Section == indexPath.section) {
        
        static NSString *QuestionCommentCellReuseIdentifier = @"45896e61-46fb-46a3-817e-b638f82e3206";
        Comment *comment = [self.iRepliedComments objectAtIndex:indexPath.row];
        
        NativeQuestionDetailCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:QuestionCommentCellReuseIdentifier];
        if (nil == commentCell) {
            commentCell = [[NativeQuestionDetailCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuestionCommentCellReuseIdentifier];
            [commentCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

        [commentCell loadComment:comment];
        cell = commentCell;
    }
    else if (Reply_Section == indexPath.section) {
        
        static NSString *ReplyReuseIdentifier = @"4B9C85E6-C319-40E7-BBFE-4A8F37E2AD45";
        
        UITableViewCell *replyTableViewCell = [tableView dequeueReusableCellWithIdentifier:ReplyReuseIdentifier];
        if (nil == replyTableViewCell) {
            replyTableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReplyReuseIdentifier];
            replyTableViewCell.textLabel.font = CellTextFont;
            replyTableViewCell.textLabel.numberOfLines = 0;
        }
        if (nil == self.commentText) {
            replyTableViewCell.textLabel.textColor = [SkinManager sharedInstance].defaultGrayColor;
            [replyTableViewCell.textLabel setText:@"点击添加回复"];
        } else {
            replyTableViewCell.textLabel.textColor = [SkinManager sharedInstance].defaultBlackColor;
            [replyTableViewCell.textLabel setText:self.commentText];
        }
        
        cell = replyTableViewCell;
    }
    else if (ReplyBtn_Section == indexPath.section) {
        
        static NSString *ReplyBtnReuseIdentifier = @"cf489c49-fcbd-4093-be04-57d6ad0b86d9";
        QuickQuestionReplyCell *replyCell = [tableView dequeueReusableCellWithIdentifier:ReplyBtnReuseIdentifier];
        if (nil == replyCell) {
            replyCell = [[QuickQuestionReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReplyBtnReuseIdentifier];
            
            [replyCell addReplyButtonAction:@selector(addReplyButtonClicked:) withTarget:self];
        }
        
        cell = replyCell;
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (RepliedComment_Section == section) {
        return 10.0f;
    }
    
    if (QuickQuestion_Section == section) {
        
        return 10.0f;
    }
    
    return 5.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (QuickQuestion_Section == indexPath.section) {
        return [NativeQuestionDetailQuestionCell cellHeightWithQuickQuestion:self.quickQuestion];
    }
    else if (RepliedComment_Section == indexPath.section) {
        
        Comment *comment = [self.iRepliedComments objectAtIndex:indexPath.row];
        return [NativeQuestionDetailCommentCell cellHeightWithComment:comment];
    }
    else if (Reply_Section == indexPath.section) {
        if (nil == self.commentText) {
            return 44.0f;
        }
        CGSize constraintSize = CGSizeMake(App_Frame_Width - 20.0f, MAXFLOAT);
        CGSize textSize = [self.commentText sizeWithFont:CellTextFont constrainedToSize:constraintSize];
        return textSize.height > 44.0f ? textSize.height : 44.0f;
    }
    else if (ReplyBtn_Section == indexPath.section) {
        return 55.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (QuickQuestion_Section == section) {
        return 0.01f;
    }
    
    return 5.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (Reply_Section == indexPath.section) {
        [DFDInputViewController presentInputViewControllerWithTitle:@"回复" inputText:self.commentText confirmInputTextBlock:^(NSString *text) {
            self.commentText = text;
            
            [self.tableView beginUpdates];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:Reply_Section];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        } parentViewController:self];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Selector

- (void)addReplyButtonClicked:(id)sender
{
//    if (nil == self.replyTextView.text && self.replyTextView.text.length == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回复不能为空" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//        [alertView show];
//        return ;
//    }
    
    NativeQuestionReplyViewController *nvc = [[NativeQuestionReplyViewController alloc] init];
    nvc.delegate = self;
    [self.navigationController pushViewController:nvc animated:YES];
    
    
    
//    [[AccountManager sharedInstance] asyncAddComment:self.replyTextView.text withQuestionID:self.quickQuestion.questionID withCompletionHandler:^(Comment *comment) {
//        self.replyTextView.text = @"";
//        self.commentText = nil;
//        
//        [self.tableView beginUpdates];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:Reply_Section];
//        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
//        
//        if ([self.delegate respondsToSelector:@selector(quickQuestionDetailViewController:didAddComment:forQuickQuestion:)]) {
//            [self.delegate quickQuestionDetailViewController:self didAddComment:comment forQuickQuestion:self.quickQuestion];
//        }
//    } withErrorHandler:^(NSError *error) {
//        
//    }];
}

#pragma mark - private Method

- (void)uploadReplyText:(NSString *)text {
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncAddComment:text withQuestionID:self.quickQuestion.questionID withCompletionHandler:^(Comment *comment) {
//        self.replyTextView.text = @"";
//        self.commentText = nil;
        [self dismissLoading];
        
        [self.iRepliedComments insertObject:comment atIndex:0];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:RepliedComment_Section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        if ([self.delegate respondsToSelector:@selector(quickQuestionDetailViewController:didAddComment:forQuickQuestion:)]) {
            [self.delegate quickQuestionDetailViewController:self didAddComment:comment forQuickQuestion:self.quickQuestion];
        }
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        [self showHint:[error localizedDescription]];
    }];
}

//- (void)addReplyButtonClicked:(id)sender
//{
//    [_replyTextView resignFirstResponder];
//    
//    if (nil == self.replyTextView.text || self.replyTextView.text.length == 0) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"回复不能为空" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil];
//        [alertView show];
//        return ;
//    }
//    
//    [self showLoading];
//    [[AccountManager sharedInstance] asyncAddComment:self.replyTextView.text withQuestionID:self.quickQuestion.questionID withCompletionHandler:^(Comment *comment) {
//        [self dismissLoading];
//        
//        self.commentText = nil;
//        self.replyTextView.text = @"";
//        
//        [self.iRepliedComments addObject:comment];
//        [self.quickQuestion.comments addObject:comment];
//        self.quickQuestion.commentsCount++;
//        
//        [self.tableView beginUpdates];
//        [self.tableView reloadSections:[[NSIndexSet alloc] initWithIndex:RepliedComment_Section] withRowAnimation:UITableViewRowAnimationAutomatic];
//        [self.tableView endUpdates];
//        
//        if ([self.delegate respondsToSelector:@selector(quickQuestionDetailViewController:didAddComment:forQuickQuestion:)]) {
//            [self.delegate quickQuestionDetailViewController:self didAddComment:comment forQuickQuestion:self.quickQuestion];
//        }
//    } withErrorHandler:^(NSError *error) {
//        
//        [self dismissLoading];
//        [self showHint:[error localizedDescription]];
//    }];
//    
//    
//}


- (void)spreadBtnClicked:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    isSpread = !isSpread;
    
    if (isSpread) {
        [btn setTitle:@"收起" forState:UIControlStateNormal];
    }
    else {
        [btn setTitle:@"展开" forState:UIControlStateNormal];
    }
    NSIndexSet *set = [[NSIndexSet alloc] initWithIndex:RepliedComment_Section];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Event

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    if ([eventName isEqualToString:kNativeQuestionDetailAvatarClickEvent]) {
        Patient *patient = self.quickQuestion.patient;
        if (patient.userID != kDoctorAssistantID) {
            ContactInfoViewController *infoViewController = [[ContactInfoViewController alloc] initWithPatient:patient];
            [self.navigationController pushViewController:infoViewController animated:YES];
        }
    } else if ([eventName isEqualToString:kQuickQuestionDetailImageClickedEvent]) {
        NSNumber *imageIndexNumber = [userInfo objectForKey:kDetailImageCollectionViewIndexKey];
        
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        
        // Set options
        browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
        browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
        browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
        browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
        browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
        browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
        browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
        browser.wantsFullScreenLayout = YES; // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
        
        // Optionally set the current visible photo before displaying
        [browser setCurrentPhotoIndex:[imageIndexNumber integerValue]];
        
        // Present
        [self.navigationController pushViewController:browser animated:YES];
    } else {
        [self.nextResponder routerEventWithName:eventName userInfo:userInfo];
    }
}

#pragma mark - NativeQuestionReplyViewControllerDelegate Methods

- (void)replyWithText:(NSString *)text {
    
    [self uploadReplyText:text];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.quickQuestion.imagesURLStrings count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.quickQuestion.imagesURLStrings.count) {
        NSString *imageURLString = [self.quickQuestion.imagesURLStrings objectAtIndex:index];
        return [MWPhoto photoWithURL:[NSURL URLWithString:imageURLString]];
    }
    return nil;
}


#pragma mark - DFDInputViewControllerDelegate

- (void)inputViewController:(DFDInputViewController *)viewController didConfirmInputWithText:(NSString *)text
{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)inputViewControllerDidCancelInput:(DFDInputViewController *)viewController
{
    [viewController dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
