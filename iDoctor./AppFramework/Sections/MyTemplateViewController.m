//
//  MyTemplateViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/17.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "MyTemplateViewController.h"
#import <PureLayout.h>
#import "TemplateCollectionViewCell.h"
#import "TemplateModel.h"
#import "AccountManager.h"

@interface MyTemplateViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *templates;


@end

@implementation MyTemplateViewController

static NSString *TemplateCollectionViewReuseIdentifier = @"decc6569-411c-4864-89e7-c881aab23c64";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationBarWithTitle:@"我的模板" leftBarButtonItem:nil rightBarButtonItem:nil];

    [self setupViews];
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncGetMyTemplatesWithCompletionHandler:^(NSArray *templates) {
        
        [self dismissLoading];
        self.templates = templates;
        [self.collectionView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [self dismissLoading];
        [self showHint:[error localizedDescription]];
    }];
}

- (void)setupViews {
    
    [self.view addSubview:self.collectionView];
    {
        [self.view addConstraints:[self.collectionView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    }
}


#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedTemplate:)]) {
        
        TemplateModel *template = [self.templates objectAtIndex:indexPath.row];
        [self.delegate selectedTemplate:template];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else { [self showHint:@"未知错误502"]; }
}

#pragma mark - UICollectionView DataSource Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TemplateCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TemplateCollectionViewReuseIdentifier forIndexPath:indexPath];
    TemplateModel *template = [self.templates objectAtIndex:indexPath.row];
    [cell loadDataWithTemplateModel:template];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.templates count];
}

#pragma mark - properties

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat cellWidth = (App_Frame_Width - 80.0f) / 4;
        [flowLayout setItemSize:CGSizeMake(cellWidth, cellWidth + 50.0f)]; //设置每个cell显示数据的宽和高必须
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //对Cell注册(必须否则程序会挂掉)
        [_collectionView registerClass:[TemplateCollectionViewCell class] forCellWithReuseIdentifier:TemplateCollectionViewReuseIdentifier];
        [_collectionView setUserInteractionEnabled:YES];
        
        [_collectionView setDelegate:self]; //代理－视图
        [_collectionView setDataSource:self]; //代理－数据
        
        _collectionView.backgroundColor = self.view.backgroundColor;
    }
    
    return _collectionView;
}

- (NSArray *)templates {
    
    if (!_templates) {
        
        _templates = [[NSArray alloc] init];
    }
    
    return _templates;
}

@end








