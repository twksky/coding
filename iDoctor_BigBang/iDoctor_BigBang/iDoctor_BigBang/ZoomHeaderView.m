//
//  ZoomHeaderView.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/3/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ZoomHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define kDefaultHeaderFrame CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)

static CGFloat kParallaxDeltaFactor = 0.5f;
static CGFloat kMaxTitleAlphaOffset = 100.0f;

@interface ZoomHeaderView ()
@property (strong, nonatomic) UIScrollView *imageScrollView;
@property (strong, nonatomic) UIImageView *imageView;

// *******
@property(nonatomic, strong) UIImageView *avatarView;
@end

@implementation ZoomHeaderView
+ (id)zoomHeaderViewWithImage:(UIImage *)image forSize:(CGSize)headerSize;
{
    ZoomHeaderView *headerView = [[ZoomHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    headerView.headerImage = image;
    [headerView initialSetup];
    return headerView;
    
}

+ (id)zoomHeaderViewWithCGSize:(CGSize)headerSize;
{
    ZoomHeaderView *headerView = [[ZoomHeaderView alloc] initWithFrame:CGRectMake(0, 0, headerSize.width, headerSize.height)];
    [headerView initialSetup];
    return headerView;
}

- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset
{
    CGRect frame = self.imageScrollView.frame;
    
    if (offset.y > 0)
    {
        frame.origin.y = MAX(offset.y *kParallaxDeltaFactor, 0);
        self.imageScrollView.frame = frame;
        self.clipsToBounds = YES;
    }
    else
    {
        CGFloat delta = 0.0f;
        CGRect rect = kDefaultHeaderFrame;
        delta = fabs(MIN(0.0f, offset.y));
        rect.origin.y -= delta;
        rect.size.height += delta;
        self.imageScrollView.frame = rect;
        self.clipsToBounds = NO;
        self.headerTitleLabel.alpha = 1 - (delta) * 1 / kMaxTitleAlphaOffset;
    }
}

- (void)initialSetup
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    self.imageScrollView = scrollView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = self.headerImage;
    self.imageView = imageView;
    [self.imageScrollView addSubview:imageView];
    
    // **************************************
    UIView *wrapView = [[UIView alloc] init];
//    wrapView.backgroundColor = [UIColor lightGrayColor];
    
    [self.imageScrollView addSubview:wrapView];
    [wrapView makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.imageScrollView);
        make.height.equalTo(160);
        make.width.equalTo(200);
    }];
    
    // 头像
    self.avatarView = [[UIImageView alloc] init];
    _avatarView.image = [UIImage imageNamed:@"health_file"];
    [wrapView addSubview:_avatarView];
    [_avatarView makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(wrapView);
        make.top.equalTo(wrapView);
        make.width.height.equalTo(90);
    }];
    
    // 信息
    UIView *infoView = [[UIView alloc] init];
    infoView.backgroundColor = GDRandomColor;
    
    [wrapView addSubview:infoView];
    [infoView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_avatarView.bottom).offset(14);
        make.left.bottom.right.equalTo(wrapView);
    }];
    // ***************************************
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = GDRandomColor;
    
    [infoView addSubview:topView];
    [topView makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(infoView);
        make.centerX.equalTo(infoView);
        make.height.equalTo(15);
        make.width.equalTo(200);
    }];
    
    
    [self addSubview:self.imageScrollView];
}

- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerImage = headerImage;
    self.imageView.image = headerImage;
}


@end
