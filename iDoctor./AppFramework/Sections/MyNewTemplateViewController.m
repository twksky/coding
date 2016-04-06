//
//  TemplateSettingViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/16.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "MyNewTemplateViewController.h"
#import "TemplateCollectionViewCell.h"
#import <PureLayout.h>
#import "MyTemplateCollectionViewAdapter.h"
#import "TemplateSettingTemplateLibsCollectionViewAdapter.h"
#import "TemplateModel.h"
#import "TemplateCategoryCollectionViewCell.h"
#import "SkinManager.h"
#import "AccountManager.h"
#import "EditTemplateViewController.h"
#import "CategoryStandardTemplatesViewController.h"
#import "MyTemplateViewController.h"
#import "AddTemplateViewController.h"

@interface MyNewTemplateViewController ()
<
MyTemplateCollectionViewAdapterDelegate,
TemplateSettingTemplateLibsCollectionViewAdapterDelegate,
MyTemplateViewControllerDelegate,
EditTemplateViewControllerDelegate,
CategoryStandardTemplatesViewControllerDelegate,
AddTemplateViewControllerDelegate
>

@property (nonatomic, strong) UIScrollView *scrollContentView;
@property (nonatomic, strong) UILabel *mTemplatesTitle;
@property (nonatomic, strong) UICollectionView *mTemplatesCollectionView;
@property (nonatomic, strong) UILabel *templateLibTitle;
@property (nonatomic, strong) UICollectionView *templateLibCollectionView;
@property (nonatomic, strong) UIButton *newTemplateButton;

//@property (nonatomic, strong) NSArray *mTemplates;
//@property (nonatomic, strong) NSArray *templateLibs;

@property (nonatomic, strong) MyTemplateCollectionViewAdapter *mTemplateAdapter;
@property (nonatomic, strong) TemplateSettingTemplateLibsCollectionViewAdapter *templateLibsAdapter;

@property (nonatomic, strong) NSLayoutConstraint *mTemplateCollectionViewHeightConstraint;
@property (nonatomic, strong) NSLayoutConstraint *templateLibsCollectionViewHeightConstraint;

@end

@implementation MyNewTemplateViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBarWithTitle:@"模板" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self setupViews]; //TODO 加载网络的时候才。。。
    
    [self updateMyTemplates];
    [self updateTemplateCategories];
}

- (void)setupViews {
    
    [self.view addSubview:self.scrollContentView];
    {
        [self.view addConstraints:[self.scrollContentView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    }
    
    UIView *contentView = self.scrollContentView;
    
    [contentView addSubview:self.mTemplatesTitle];
    {
        [contentView addConstraint:[self.mTemplatesTitle autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
        [contentView addConstraint:[self.mTemplatesTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    }
    
    [contentView addSubview:self.mTemplatesCollectionView];
    {
        [contentView addConstraint:[self.mTemplatesCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mTemplatesTitle withOffset:10.0f]];
        [contentView addConstraint:[self.mTemplatesCollectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:contentView]];
        
        CGFloat cellHeight = (App_Frame_Width - 80.0f) / 4 + 50.0f;
        CGFloat mTemplatesCollectionViewHeight = (self.mTemplateAdapter.templates.count / 4 + (self.mTemplateAdapter.templates.count % 4 == 0 ? 0 : 1)) * (cellHeight + 15.0f);
        [contentView addConstraint:[self.mTemplatesCollectionView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width]];
        self.mTemplateCollectionViewHeightConstraint = [self.mTemplatesCollectionView autoSetDimension:ALDimensionHeight toSize:mTemplatesCollectionViewHeight];
        [contentView addConstraint:self.mTemplateCollectionViewHeightConstraint];
    }
    
    [contentView addSubview:self.newTemplateButton];
    {
        [contentView addConstraint:[self.newTemplateButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mTemplatesCollectionView withOffset:10.0f]];
        [contentView addConstraint:[self.newTemplateButton autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [contentView addConstraints:[self.newTemplateButton autoSetDimensionsToSize:CGSizeMake(120.0f, 40.0f)]];
    }
    
    UIImageView *newTemplateBtnIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_template_addnew"]];
    [self.newTemplateButton addSubview:newTemplateBtnIcon];
    {
        [self.newTemplateButton addConstraints:[newTemplateBtnIcon autoSetDimensionsToSize:CGSizeMake(17.0f, 17.0f)]];
        [self.newTemplateButton addConstraint:[newTemplateBtnIcon autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.newTemplateButton.titleLabel withOffset:-5.0f]];
        [self.newTemplateButton addConstraint:[newTemplateBtnIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
    }

    [contentView addSubview:self.templateLibTitle];
    {
        [contentView addConstraint:[self.templateLibTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.newTemplateButton withOffset:30.0f]];
        [contentView addConstraint:[self.templateLibTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    }
    
    [contentView addSubview:self.templateLibCollectionView];
    {
        [contentView addConstraint:[self.templateLibCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.templateLibTitle withOffset:10.0f]];
        [contentView addConstraint:[self.templateLibCollectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:contentView]];
        
        CGFloat cellHeight = (App_Frame_Width - 80.0f) / 4 + 50.0f;
        CGFloat templateLibsCollectionViewHeight = (self.templateLibsAdapter.templateLibs.count / 4 + (self.templateLibsAdapter.templateLibs.count % 4 == 0 ? 0 : 1)) * (cellHeight + 15.0f);
        [contentView addConstraint:[self.templateLibCollectionView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width]];
        self.templateLibsCollectionViewHeightConstraint = [self.templateLibCollectionView autoSetDimension:ALDimensionHeight toSize:templateLibsCollectionViewHeight];
        [contentView addConstraint:self.templateLibsCollectionViewHeightConstraint];
    }
    
    UIImageView *line1 = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    [contentView addSubview:line1];
    {
        [contentView addConstraints:[line1 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
        [contentView addConstraint:[line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [contentView addConstraint:[line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.mTemplatesCollectionView]];
    }
    
    UIImageView *line2 = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    [contentView addSubview:line2];
    {
        [contentView addConstraints:[line2 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
        [contentView addConstraint:[line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [contentView addConstraint:[line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.templateLibTitle withOffset:-10.0f]];
    }
    
    UIImageView *line3 = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    [contentView addSubview:line3];
    {
        [contentView addConstraints:[line3 autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
        [contentView addConstraint:[line3 autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [contentView addConstraint:[line3 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.templateLibCollectionView]];
    }
}


#pragma mark - MyTemplateCollectionViewAdapterDelegate Methods

- (void)moreMyTemplate {

    MyTemplateViewController *mvc = [[MyTemplateViewController alloc] init];
    mvc.delegate = self;
    [self.navigationController pushViewController:mvc animated:YES];
}

- (void)didSelectedTemplate:(TemplateModel *)templateModel {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTemplateModelFromTemplateSetting:)]) {
        
        [self.delegate didSelectedTemplateModelFromTemplateSetting:templateModel];
    }
//    EditTemplateViewController *evc = [[EditTemplateViewController alloc] initWithTemplate:templateModel];
//    evc.delegate = self;
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TemplateSettingTemplateLibsCollectionViewAdapterDelegate Methods

- (void)didSelectedTemplateCategory:(TemplateCategoryModel *)category {
    
    CategoryStandardTemplatesViewController *cvc = [[CategoryStandardTemplatesViewController alloc] initWithCategory:category];
    cvc.delegate = self;
    [self.navigationController pushViewController:cvc animated:YES];
}

#pragma mark - MyTemplateViewControllerDelegate Methods

- (void)selectedTemplate:(TemplateModel *)templateModel {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTemplateModelFromTemplateSetting:)]) {
        
        [self.delegate didSelectedTemplateModelFromTemplateSetting:templateModel];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - EditTemplateViewControllerDelegate Methods

- (void)didUpdateTemplate:(TemplateModel *)templateModel {
    
    [self updateMyTemplates];
}

#pragma mark - CategoryStandardTemplatesViewControllerDelegate Methods

- (void)savedAnyTemplate:(TemplateModel *)templateModel {
    
    NSMutableArray *mutableTemplates = [[NSMutableArray alloc] initWithArray:self.mTemplateAdapter.templates];
    [mutableTemplates addObject:templateModel];
    
    self.mTemplateAdapter.templates = mutableTemplates;
    
    [self reloadCollectionViews];
}

#pragma mark - AddTemplateViewControllerDelegate Methods

- (void)didSavedNewTemplate:(TemplateModel *)templateModel {
    
    NSMutableArray *mutableTemplates = [[NSMutableArray alloc] initWithArray:self.mTemplateAdapter.templates];
    [mutableTemplates addObject:templateModel];
    
    self.mTemplateAdapter.templates = mutableTemplates;
    
    [self reloadCollectionViews];
}

#pragma mark - selector

- (void)toAddTemplateViewController {
    
    AddTemplateViewController *avc = [[AddTemplateViewController alloc] init];
    avc.delegate = self;
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark - private methods

- (void)updateMyTemplates {
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncGetMyTemplatesWithCompletionHandler:^(NSArray *templates) {
        [self dismissLoading];
        
        if ([templates count] > 7) {
            
            NSRange range = NSMakeRange(0, 7);
            self.mTemplateAdapter.templates = [templates subarrayWithRange:range];
        }
        else {
            
            self.mTemplateAdapter.templates = templates;
        }
        
        [self reloadCollectionViews];
        
    } withErrorHandler:^(NSError *error) {
        
        [self dismissLoading];
        [self showHint:[error localizedDescription]];
    }];
}

- (void)updateTemplateCategories {
    
    [[AccountManager sharedInstance] asyncGetTemplateCategoriesWithCompletionHandler:^(NSArray *templateCategories) {
        
        self.templateLibsAdapter.templateLibs = templateCategories;
        [self reloadCollectionViews];
        
    } withErrorHandler:^(NSError *error) {
        
        [self showHint:[error localizedDescription]];
    }];
}

- (void)reloadHeight {
    
    CGFloat cellHeight = (App_Frame_Width - 80.0f) / 4 + 50.0f;
    
    //TODO mTemplatesCollectionView的高度
    CGFloat mTemplatesCollectionViewHeight = ((self.mTemplateAdapter.templates.count + 1) / 4 + ((self.mTemplateAdapter.templates.count + 1) % 4 == 0 ? 0 : 1)) * (cellHeight + 15.0f);
    self.mTemplateCollectionViewHeightConstraint.constant = mTemplatesCollectionViewHeight;
    
    //TODO templateLibCollectionView的高度
    CGFloat templateLibsCollectionViewHeight = (self.templateLibsAdapter.templateLibs.count / 4 + (self.templateLibsAdapter.templateLibs.count % 4 == 0 ? 0 : 1)) * (cellHeight + 15.0f);
    self.templateLibsCollectionViewHeightConstraint.constant = templateLibsCollectionViewHeight;
    
    //TODO scrollview的contentView的高度
    [self.scrollContentView setContentSize:CGSizeMake(App_Frame_Width, mTemplatesCollectionViewHeight + templateLibsCollectionViewHeight + 130.0f)];
}

- (void)reloadCollectionViews {
    
    [self reloadHeight];
    
    [self.mTemplatesCollectionView reloadData];
    [self.templateLibCollectionView reloadData];
}


#pragma mark - properties

- (UIScrollView *)scrollContentView {
    
    if (!_scrollContentView) {
        
        _scrollContentView = [[UIScrollView alloc] init];
        _scrollContentView.contentSize = CGSizeMake(App_Frame_Width, 300);//TODO 计算两个collectionview的高度
    }
    
    return _scrollContentView;
}

- (UILabel *)mTemplatesTitle {
    
    if (!_mTemplatesTitle) {
        
        _mTemplatesTitle = [[UILabel alloc] init];
        _mTemplatesTitle.text = @"我的模板";
    }
    
    return _mTemplatesTitle;
}

- (UICollectionView *)mTemplatesCollectionView {
    
    if (!_mTemplatesCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat cellWidth = (App_Frame_Width - 80.0f) / 4;
        [flowLayout setItemSize:CGSizeMake(cellWidth, cellWidth + 50.0f)]; //设置每个cell显示数据的宽和高必须
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        _mTemplatesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //对Cell注册(必须否则程序会挂掉)
        [_mTemplatesCollectionView registerClass:[TemplateCollectionViewCell class] forCellWithReuseIdentifier:NewMyTemplateCollectionViewReuseIdentifier];
        [_mTemplatesCollectionView setUserInteractionEnabled:YES];
        
        [_mTemplatesCollectionView setDelegate:self.mTemplateAdapter]; //代理－视图
        [_mTemplatesCollectionView setDataSource:self.mTemplateAdapter]; //代理－数据
        
        _mTemplatesCollectionView.backgroundColor = self.view.backgroundColor;
    }
    
    return _mTemplatesCollectionView;
}

- (UIButton *)newTemplateButton {
    
    if (!_newTemplateButton) {
        
        _newTemplateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_newTemplateButton setTitle:@"新建模板" forState:UIControlStateNormal];
        [_newTemplateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_newTemplateButton setBackgroundColor:UIColorFromRGB(0x34d2b4)];
        _newTemplateButton.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _newTemplateButton.layer.cornerRadius = 3.0f;
        UIEdgeInsets insets = _newTemplateButton.titleEdgeInsets;
        insets.right = -20.0f;
        _newTemplateButton.titleEdgeInsets = insets;
        [_newTemplateButton addTarget:self action:@selector(toAddTemplateViewController) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _newTemplateButton;
}

- (UILabel *)templateLibTitle {
    
    if (!_templateLibTitle) {
        
        _templateLibTitle = [[UILabel alloc] init];
        _templateLibTitle.text = @"模板库";
    }
    
    return _templateLibTitle;
}

- (UICollectionView *)templateLibCollectionView {
    
    if (!_templateLibCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat cellWidth = (App_Frame_Width - 80.0f) / 4;
        [flowLayout setItemSize:CGSizeMake(cellWidth, cellWidth + 50.0f)]; //设置每个cell显示数据的宽和高必须
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        _templateLibCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //对Cell注册(必须否则程序会挂掉)
        [_templateLibCollectionView registerClass:[TemplateCategoryCollectionViewCell class] forCellWithReuseIdentifier:NewTemplateLibCollectionViewReuseIdentifier];
        [_templateLibCollectionView setUserInteractionEnabled:YES];
        
        [_templateLibCollectionView setDelegate:self.templateLibsAdapter]; //代理－视图
        [_templateLibCollectionView setDataSource:self.templateLibsAdapter]; //代理－数据
        
        _templateLibCollectionView.backgroundColor = self.view.backgroundColor;
    }
    
    return _templateLibCollectionView;
}

//- (NSArray *)mTemplates {
//    
//    if (!_mTemplates) {
//        
//        _mTemplates = [[NSArray alloc] init];
//    }
//    
//    return _mTemplates;
//}
//
//- (NSArray *)templateLibs {
//    
//    if (!_templateLibs) {
//        
//        _templateLibs = [[NSArray alloc] init];
//    }
//    
//    return _templateLibs;
//}

- (MyTemplateCollectionViewAdapter *)mTemplateAdapter {
    
    if (!_mTemplateAdapter) {
        
        _mTemplateAdapter = [[MyTemplateCollectionViewAdapter alloc] initWithReusedIdentifer:NewMyTemplateCollectionViewReuseIdentifier];
        _mTemplateAdapter.delegate = self;
    }
    
    return _mTemplateAdapter;
}

- (TemplateSettingTemplateLibsCollectionViewAdapter *)templateLibsAdapter {
    
    if (!_templateLibsAdapter) {
        
        _templateLibsAdapter = [[TemplateSettingTemplateLibsCollectionViewAdapter alloc] initWithReusedIdentifer:NewTemplateLibCollectionViewReuseIdentifier];
        _templateLibsAdapter.delegate = self;
    }
    
    return _templateLibsAdapter;
}

@end











