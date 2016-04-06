//
//  ZoomHeaderView.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/3/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZoomHeaderView : UIView
@property (nonatomic, strong) UILabel *headerTitleLabel;
@property (nonatomic, strong) UIImage *headerImage;

+ (id)zoomHeaderViewWithImage:(UIImage *)image forSize:(CGSize)headerSize;
+ (id)zoomHeaderViewWithCGSize:(CGSize)headerSize;
- (void)layoutHeaderViewForScrollViewOffset:(CGPoint)offset;

@end
