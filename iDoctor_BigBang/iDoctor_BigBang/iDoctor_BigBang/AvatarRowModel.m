//
//  AvatarRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "AvatarRowModel.h"

@implementation AvatarRowModel
+ (instancetype)avatarRowWithTitle:(NSString *)title avatarImageURLStr:(NSString *)avatarImageURLStr
{
    AvatarRowModel *avatar = [self baseRowModelWithTitle:title];
    avatar.avatarImageURLStr = avatarImageURLStr;
    return avatar;
}
@end
