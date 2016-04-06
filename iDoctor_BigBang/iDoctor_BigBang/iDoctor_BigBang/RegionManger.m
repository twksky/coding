//
//  RegionManger.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/24/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "RegionManger.h"

@implementation RegionManger

+ (void)getRegionsIfSuccess:(void (^)(RegionsModel *regions))success failure:(void (^)(NSError *))failure
{
    [[APIManager sharedManager] GET:@"v4/provinces_with_cities" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if (success) {
            RegionsModel *regions = [RegionsModel objectWithKeyValues:responseObject];
            success(regions);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getHospitalWithRegionId:(NSInteger)regionId success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    
    NSString *URLStr = [NSString stringWithFormat:@"/api/hospitals/region/%ld",regionId];
    [[APIManager sharedManager] GET:URLStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        GDLog(@"%@",responseObject[@"hospitals"]);
        if (success) {
            NSMutableArray *arrM = [Hospital objectArrayWithKeyValuesArray:responseObject[@"hospitals"]];
            success(arrM);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if (failure) {
            failure(error);
        }
    }];
}
@end

@implementation RegionsModel

+ (NSDictionary *)objectClassInArray{
    return @{@"provinces" : [Provinces class]};
}

@end

@implementation Provinces

+ (NSDictionary *)objectClassInArray{
    return @{@"cities" : [Cities class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end


@implementation Cities

+ (NSDictionary *)objectClassInArray{
    return @{@"counties" : [Counties class]};
}
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end


@implementation Counties
+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}
@end

@implementation Hospital

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}


@end