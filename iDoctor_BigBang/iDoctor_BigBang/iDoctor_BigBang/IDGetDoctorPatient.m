//
//  IDGetDoctorPatient.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/25.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDGetDoctorPatient.h"
#import <MJExtension.h>


@implementation IDGetDoctorPatient

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"patient_id":@"id"};
}

- (NSString *)getDisplayName
{
    if (self.noteName && ![self.realname isEqual:[NSNull null]] && [self.noteName length] > 0) {
        
        return self.noteName;
    }
    
    if (self.realname && ![self.realname isEqual:[NSNull null]] && [self.realname length] > 0) {
        return self.realname;
    }
    
    return [NSString stringWithFormat:@"%ld", (long)self.patient_id];
}

- (NSString *)getNoteName
{
    if (self.noteName && ![self.noteName isEqual:[NSNull null]] && [self.noteName length] > 0) {
        return self.noteName;
    }
    return nil;
}

@end
