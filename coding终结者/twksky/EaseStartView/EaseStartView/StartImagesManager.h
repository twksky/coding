//
//  StartImagesManager.h
//  EaseStartView
//
//  Created by twksky on 15/11/4.
//  Copyright © 2015年 twksky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Group : NSObject
@property (strong, nonatomic) NSString *name, *author;
@end

@interface StartImage : NSObject
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) Group *group;
@property (strong, nonatomic) NSString *fileName, *descriptionStr, *pathDisk;

+ (StartImage *)defautImage;
+ (StartImage *)midAutumnImage;

- (UIImage *)image;
- (void)startDownloadImage;
@end

@interface StartImagesManager : NSObject

+ (instancetype)shareManager;//初始化

- (StartImage *)randomImage;//返回随机图片
- (StartImage *)curImage;//

- (void)refreshImagesPlist;
- (void)startDownloadImages;

@end
