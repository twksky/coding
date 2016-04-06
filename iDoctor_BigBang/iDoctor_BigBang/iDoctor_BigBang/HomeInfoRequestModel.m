//
//  HomeInfoRequestModel.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/9.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "HomeInfoRequestModel.h"

@implementation HomeInfoRequestModel

- (NSNumber *)page
{
    return _page ? _page : @1;
}

- (NSNumber *)size
{
    return _size ? _size : @20;
}

@end
