//
//  TemplateSettingWithoutCategoriesViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/7/8.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "TemplateWithoutCategoriesViewController.h"
#import "AddTemplateViewController.h"
#import "TemplateCollectionViewCell.h"
#import "AccountManager.h"
#import "SkinManager.h"
#import <Masonry.h>

#define WTemplateCollectionViewReuseIdentifier @"7888c09e-5827-41ff-89e2-cf0923f9cad1"

@interface TemplateWithoutCategoriesViewController ()
<
AddTemplateViewControllerDelegate,
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) UILabel *mTemplatesTitle;
@property (nonatomic, strong) UICollectionView *mTemplatesCollectionView;
@property (nonatomic, strong) UIButton *addTemplateButton;

@property (nonatomic, strong) NSArray *mTemplates;

@end

@implementation TemplateWithoutCategoriesViewController

- (instancetype)init {
    
    self = [super init];
    if (self) {
        
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBarWithTitle:@"问诊模板设置" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self setupViews];
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncGetMyTemplatesWithCompletionHandler:^(NSArray *templates) {
        [self dismissLoading];
        
        self.mTemplates = templates;
        [self.mTemplatesCollectionView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [self dismissLoading];
        [self showHint:[error localizedDescription]];
    }];
}

#pragma mark - private Methods

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *contentView = self.view;
    
    [contentView addSubview:self.mTemplatesTitle];
    [self.mTemplatesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView).offset(10.0f);
        make.left.equalTo(contentView).offset(10.0f);
    }];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    [contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(contentView);
        make.width.equalTo(contentView);
        make.height.equalTo(@(0.7f));
        make.top.equalTo(self.mTemplatesTitle.mas_bottom).offset(10.0f);
    }];
    
    UIView *addTemplateButtonContainer = [[UIView alloc] init];
    addTemplateButtonContainer.backgroundColor = [UIColor whiteColor];
    [contentView addSubview:addTemplateButtonContainer];
    [addTemplateButtonContainer mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(contentView);
        make.width.equalTo(@(App_Frame_Width));
        make.height.equalTo(@(80.0f));
        make.bottom.equalTo(contentView.mas_bottom);
    }];
    
    [addTemplateButtonContainer addSubview:self.addTemplateButton];
    [self.addTemplateButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(addTemplateButtonContainer);
        make.left.equalTo(addTemplateButtonContainer).offset(40.0f);
        make.right.equalTo(addTemplateButtonContainer).offset(-40.0f);
        make.height.equalTo(@(40.0f));
    }];
    
    [self.view addSubview:self.mTemplatesCollectionView];
    [self.mTemplatesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.and.right.equalTo(contentView);
        make.top.equalTo(line.mas_bottom);
        make.bottom.equalTo(addTemplateButtonContainer.mas_top);
    }];
}

- (void)updateMyTemplates {
    
    [self.mTemplatesCollectionView reloadData];
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncGetMyTemplatesWithCompletionHandler:^(NSArray *templates) {
        [self dismissLoading];
        
        self.mTemplates = templates;
        [self.mTemplatesCollectionView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [self dismissLoading];
        [self showHint:[error localizedDescription]];
    }];
}

#pragma mark - selectors

- (void)addNewTemplate {
    
    AddTemplateViewController *avc = [[AddTemplateViewController alloc] init];
    avc.delegate = self;
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.mTemplates count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TemplateCollectionViewCell *templateCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:WTemplateCollectionViewReuseIdentifier forIndexPath:indexPath];
    if (indexPath.row < [self.mTemplates count]) {
        
        TemplateModel *template = [self.mTemplates objectAtIndex:indexPath.row];
        [templateCollectionViewCell loadDataWithTemplateModel:template];
    }
    else {
        
        [templateCollectionViewCell setAsAddTemplateCellStyle];
    }
    
    return templateCollectionViewCell;

}

#pragma mark - UICollectionViewDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TemplateModel *model = [self.mTemplates objectAtIndex:[indexPath row]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTemplateModelFromTemplateSetting:)]) {
        
        [self.delegate didSelectedTemplateModelFromTemplateSetting:model];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - EditTemplateViewControllerDelegate Methods
//
//- (void)didUpdateTemplate:(TemplateModel *)templateModel {
//    
//    //TODO
//    [self updateMyTemplates];
//}

#pragma mark - AddTemplateViewControllerDelegate Methods

- (void)didSavedNewTemplate:(TemplateModel *)templateModel {
    
    NSMutableArray *mutableTemplates = [[NSMutableArray alloc] initWithArray:self.mTemplates];
    [mutableTemplates insertObject:templateModel atIndex:0];
    
    self.mTemplates = mutableTemplates;
    
    [self.mTemplatesCollectionView reloadData];
}

#pragma mark - properties

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
        [_mTemplatesCollectionView registerClass:[TemplateCollectionViewCell class] forCellWithReuseIdentifier:WTemplateCollectionViewReuseIdentifier];
        [_mTemplatesCollectionView setUserInteractionEnabled:YES];
        
        [_mTemplatesCollectionView setDelegate:self];
        [_mTemplatesCollectionView setDataSource:self];
        
        _mTemplatesCollectionView.backgroundColor = self.view.backgroundColor;
    }
    
    return _mTemplatesCollectionView;
}

- (UIButton *)addTemplateButton {
    
    if (!_addTemplateButton) {
        
        _addTemplateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addTemplateButton setTitle:@"+新建模板" forState:UIControlStateNormal];
        [_addTemplateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _addTemplateButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        self.addTemplateButton.backgroundColor = UIColorFromRGB(0x34d2b4);
        _addTemplateButton.layer.cornerRadius = 6.0f;
        _addTemplateButton.layer.masksToBounds = YES;
        [_addTemplateButton addTarget:self action:@selector(addNewTemplate) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addTemplateButton;
}

- (NSArray *)mTemplates {
    
    if (!_mTemplates) {
        
        _mTemplates = [[NSArray alloc] init];
    }
    
    return _mTemplates;
}

@end










