//
//  RecruitRatioRowModel.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/21/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseRowModel.h"
#import "IWantPatientDataManger.h"
@interface RecruitRatioRowModel : BaseRowModel
@property(nonatomic, strong) RecruitList *recruitList;

+ (instancetype)recruitRatioRowModelWithRecruitList:(RecruitList *)recruitList;
@end
