//
//  AvatarRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ArrowRowModel.h"

@interface AvatarRowModel : ArrowRowModel
@property(nonatomic, copy) NSString *avatarImageURLStr;

+ (instancetype)avatarRowWithTitle:(NSString *)title avatarImageURLStr:(NSString *)avatarImageURLStr;
@end
