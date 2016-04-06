//
//  RecruitRatioRowModel.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/21/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "RecruitRatioRowModel.h"

@implementation RecruitRatioRowModel
+ (instancetype)recruitRatioRowModelWithRecruitList:(RecruitList *)recruitList
{
    RecruitRatioRowModel *rr = [[self alloc] init];
    rr.recruitList = recruitList;
    return rr;
}
@end
