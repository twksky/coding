//
//  Account.m
//  AppFramework
//
//  Created by ABC on 7/2/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "Account.h"

@implementation Account

- (NSString *)getDisplayName
{
    if (self.realName && ![self.realName isEqual:[NSNull null]] && [self.realName length] > 0) {
        return self.realName;
    }
    return [NSString stringWithFormat:@"%ld", (long)self.accountID];
}

/*
 *avatarImageURLString的JSON返回值可能为null
 *存进Dictionary中value会变为NSNull对象
 *环信sdk对NSNull没有判断, 会当成NSString处理, 所以在和无头像的人聊天时会崩溃
 */
- (NSString *)avatarImageURLString {
    
    if ([_avatarImageURLString isEqual:[NSNull null]]) {
        _avatarImageURLString = nil;
    }
    
    return _avatarImageURLString;
}

- (NSString *)brief {
    
    if ([_brief isEqual:[NSNull null]]) {
        _brief = nil;
    }
    
    return _brief;
}

- (NSString *)schedule {
    
    if ([_schedule isEqual:[NSNull null]]) {
        _schedule = nil;
    }
    
    return _schedule;
}

- (NSString *)certificateImageURLString {
    
    if ([_certificateImageURLString isEqual:[NSNull null]]) {
        _certificateImageURLString = nil;
    }
    
    return _certificateImageURLString;
}

@end
