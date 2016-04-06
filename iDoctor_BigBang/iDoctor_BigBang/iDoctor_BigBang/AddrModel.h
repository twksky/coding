//
//  AddrModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddrModel : NSObject
/**
 *  最小一级的ID号
 */
@property(nonatomic, assign) NSNumber *region_id;
/**
 *  手机号
 */
@property(nonatomic, copy) NSString *phone;
/**
 *  详细地址
 */
@property(nonatomic, copy) NSString *address;
/**
 *  收货人
 */
@property(nonatomic, copy) NSString *name;
/**
 *  邮编
 */
@property(nonatomic, copy) NSString *zip_code;
/**
 *  全路径
 */
@property(nonatomic, copy) NSString *full_path;
@end
