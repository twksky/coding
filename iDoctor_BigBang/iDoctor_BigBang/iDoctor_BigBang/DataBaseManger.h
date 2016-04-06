//
//  DataBaseManger.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/29.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class HomeInfoRequestModel;
@interface DataBaseManger : NSObject

//加
+ (void)addHomeInfoWithData:(id)data;

//得到首页咨询的数据

+ (id)getHomeInfoWithData:(HomeInfoRequestModel*)data;

@end
