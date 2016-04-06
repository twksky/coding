//
//  MasterDiagnoseDetailCell.h
//  iDoctor_BigBang
//
//  Created by tianxiewuhua on 15/10/28.
//  Copyright © 2015年 YDHL. All rights reserved.
//
#import "QuickDiagnoseDetailCell.h"

@class MasterDiagnose;

@interface MasterDiagnoseDetailCell : QuickDiagnoseDetailCell

+ (CGFloat)cellHeightWithMasterDiagnose:(MasterDiagnose *)masterDiagnose;
- (void)loadDataWithMasterDiagnose:(MasterDiagnose *)masterDiagnose;

@end
