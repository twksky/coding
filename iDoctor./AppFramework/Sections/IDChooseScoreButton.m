//
//  IDChooseScoreButton.m
//  AppFramework
//
//  Created by hexy on 15/7/6.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "IDChooseScoreButton.h"

@implementation IDChooseScoreButton
{
   UIFont *_titleFont;
}

/**
 *  当一个对象从xib或者storyboard中加载完毕后,就会调用一次
 */
- (void)awakeFromNib
{
    _titleFont = [UIFont systemFontOfSize:16];
}
- (void)setHighlighted:(BOOL)highlighted
{
    
}
/**
 *  从文件中解析一个对象的时候就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 *  通过代码创建控件的时候就会调用
 */
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
 *  初始化
 */
- (void)setup
{
    _titleFont = [UIFont systemFontOfSize:16];
    self.titleLabel.font = _titleFont;
    
    // 图标居中
    self.imageView.contentMode = UIViewContentModeCenter;
    self.titleLabel.contentMode = UIViewContentModeCenter;
}


/**
 *  控制器内部label的frame
 *  contentRect : 按钮自己的边框
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 16;
    CGFloat titleY = 0;
    
    NSDictionary *attrs = @{NSFontAttributeName : _titleFont};

    CGFloat titleW = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;

    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

/**
 *  控制器内部imageView的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = 50;
    CGFloat imageX = contentRect.size.width - imageW;
    CGFloat imageY = 0;
    CGFloat imageH = contentRect.size.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}

@end
