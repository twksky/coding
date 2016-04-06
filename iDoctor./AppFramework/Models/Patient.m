//
//  Patient.m
//  AppFramework
//
//  Created by ABC on 7/20/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "Patient.h"

@implementation Patient

- (NSString *)getDisplayName
{
    if (self.noteName && ![self.realName isEqual:[NSNull null]] && [self.noteName length] > 0) {
        
        return self.noteName;
    }
    
    if (self.realName && ![self.realName isEqual:[NSNull null]] && [self.realName length] > 0) {
        return self.realName;
    }
    
    return [NSString stringWithFormat:@"%ld", (long)self.userID];
}

- (NSString *)getNoteName
{
    if (self.noteName && ![self.noteName isEqual:[NSNull null]] && [self.noteName length] > 0) {
        return self.noteName;
    }
    return nil;
}

@end
