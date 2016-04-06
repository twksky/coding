//
//  LogoutModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "LogoutModel.h"

@implementation LogoutModel
+ (instancetype)logoutModelWithIcon:(UIImage *)icon title:(NSString *)title
{
    return [self baseRowModelWithIcon:icon title:title];
}
@end
