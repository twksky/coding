//
//  RegionManger.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/24/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RegionsModel;

@interface RegionManger : NSObject

+ (void)getRegionsIfSuccess:(void(^)(RegionsModel *regions))success failure:(void(^)(NSError *error))failure;

+ (void)getHospitalWithRegionId:(NSInteger)regionId success:(void(^)(NSArray *hospitalArray))success failure:(void(^)(NSError *error))failure;
@end

@interface RegionsModel : NSObject

@property (nonatomic, assign) NSInteger status_code;

@property (nonatomic, copy) NSString *status_message;

@property (nonatomic, strong) NSArray *provinces;

@end

@interface Provinces : NSObject

@property (nonatomic, strong) NSArray *cities;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@end

@interface Cities : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSArray *counties;

@property (nonatomic, copy) NSString *name;

@end

@interface Counties : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@end

@interface Hospital : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *grade;

@end