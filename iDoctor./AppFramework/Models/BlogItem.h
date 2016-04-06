//
//  BlogItem.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/9.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogItem : NSObject

@property (nonatomic ,assign) NSInteger blogId;
@property (nonatomic ,strong) NSString *username;
@property (nonatomic ,strong) NSString *bannerUrl;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic ,strong) NSString *url;
@property (nonatomic ,strong) NSString *shortDesc;
@property (nonatomic, assign) NSInteger commentCount;

@end
