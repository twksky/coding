//
//  GDPhotoChooseView.h
//  GoodDoctor
//
//  Created by hexy on 15/9/12.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GDPhotoChooseFrom) {
    
    GDPhotoChooseFromCamera, // 相机
    GDPhotoChooseFromAlbum   // 相册
};
typedef void(^PhotoChooseFromBlock)(GDPhotoChooseFrom from);

@interface GDPhotoChooseView : UIView

@property(nonatomic, copy) PhotoChooseFromBlock photoChooseFromBlock;

- (void)setPhotoChooseFromBlock:(PhotoChooseFromBlock)photoChooseFromBlock;
- (void)show;
@end
