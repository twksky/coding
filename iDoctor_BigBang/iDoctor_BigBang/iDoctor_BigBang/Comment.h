//
//  Comment.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject

@property (nonatomic, copy) NSString    *comment_description;
@property (nonatomic, strong) Account       *comment_from_account;
@property (nonatomic, copy) NSString    *ctime_iso;

@end
