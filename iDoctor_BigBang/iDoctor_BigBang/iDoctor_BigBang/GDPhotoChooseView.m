//
//  GDPhotoChooseView.m
//  GoodDoctor
//
//  Created by hexy on 15/9/12.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "GDPhotoChooseView.h"

@interface GDPhotoChooseView ()
@property(nonatomic, strong) UIButton *cover;
@end
@implementation GDPhotoChooseView

- (void)setPhotoChooseFromBlock:(PhotoChooseFromBlock)photoChooseFromBlock
{
    _photoChooseFromBlock = photoChooseFromBlock;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpAllViews];
    }
    return self;
}

- (void)setUpAllViews
{
    // 拍照
    UIButton *camera = [self btnWithTitle:@"拍照" Tag:GDPhotoChooseFromCamera];
    
    [self addSubview:camera];
    [camera mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(self);
        make.height.equalTo(60);
    }];
    
    // 横线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(camera.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(1);
    }];
    
    // 相册
    UIButton *photo = [self btnWithTitle:@"从相册选择" Tag:GDPhotoChooseFromAlbum];
    
    [self addSubview:photo];
    [photo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(line.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(60);
    }];
    
    // 横线
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(photo.bottom);
        make.left.right.equalTo(self);
        make.height.equalTo(1);
    }];
    
    // 取消
    UIButton *cancel = [self btnWithTitle:@"取消" Tag:(GDPhotoChooseFrom)INT_MAX];
    
    [self addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self);
        make.height.equalTo(60);
    }];
    
    // 横线
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.bottom.equalTo(cancel.top);
        make.height.equalTo(1);
    }];
}

- (UIButton *)btnWithTitle:(NSString *)title Tag:(GDPhotoChooseFrom)tag
{
    UIButton *btn = [[UIButton alloc] init];
    
    btn.tag = tag;
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(choosePhotoBtnClick:) forControlEvents:UIControlEventTouchDown];
    
    return btn;
}

- (void)choosePhotoBtnClick:(UIButton *)btn
{

    if (INT_MAX != btn.tag) {
        if (self.photoChooseFromBlock) {
            self.photoChooseFromBlock(btn.tag);
        }
    }
    [self hidSelf];
}


- (void)show
{
    [self removeFromSuperview];
    [self addCover];
    [self addSelf];
}
- (void)hidSelf
{
    [self removeCover];
    [self removeSelf];
}

- (void)addCover
{
    self.cover = [[UIButton alloc] initWithFrame:GDAppTopView.bounds];
    _cover.backgroundColor = [UIColor blackColor];
    _cover.alpha = 0;
    
    [GDAppTopView addSubview:_cover];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        _cover.alpha = 0.5;
    }];
    
    [_cover addTarget:self action:@selector(hidSelf) forControlEvents:UIControlEventTouchDown];
}
- (void)removeCover
{
    [UIView animateWithDuration:0.4 animations:^{
        
        _cover.alpha = 0;
    } completion:^(BOOL finished) {
        
        [_cover removeFromSuperview];
        _cover = nil;
    }];
    
}

- (void)addSelf
{
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 190);
    self.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    [GDAppTopView addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, -190);
    }];
}

- (void)removeSelf
{
    [UIView animateWithDuration:0.2 animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, 200);
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
@end
