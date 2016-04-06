//
//  GoodsModel.h
//  AppFramework
//
//  Created by 周世阳 on 15/6/25.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoodsModel : NSObject

@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger needScore;
@property (nonatomic, strong) NSString *realPrice;
@property (nonatomic, strong) NSString *picUrl;

@end
