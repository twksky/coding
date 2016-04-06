//
//  IDNewFeatureController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/11/2.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDNewFeatureController.h"
#import "LoginViewController.h"
#import "IDAppManager.h"

@interface IDNewFeatureController ()<UICollectionViewDataSource, UICollectionViewDelegate>

// collection
@property (nonatomic, strong) UICollectionView *collectionView;

/**
 *  流水布局
 */
@property(nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@end

@implementation IDNewFeatureController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.collectionView];
}

- (void)viewDidLayoutSubviews
{
    self.collectionView.frame = self.view.bounds;
    
    self.flowLayout.itemSize = CGSizeMake(self.view.fWidth, self.view.fHeight);;
}

#pragma mark - 流水布局的数据源 和  代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewFeatureCollectionViewCell" forIndexPath:indexPath];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgView.image = [UIImage imageNamed:[NSString stringWithFormat:@"guid%ld",indexPath.item + 1]];
    
    cell.backgroundView = bgView;
    return cell;
    
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (3 == indexPath.item) {
        [IDAppManager chooseRootController];
    }
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.flowLayout];
        
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.bounces = NO;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
        
        // 注册Cell
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"NewFeatureCollectionViewCell"];
    }
    return _collectionView;
}


@end
