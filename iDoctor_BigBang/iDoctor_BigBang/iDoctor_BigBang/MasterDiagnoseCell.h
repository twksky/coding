//
//  MasterDiagnoseCell.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

@class MasterDiagnose;

@interface MasterDiagnoseCell : UITableViewCell

// 张丽修改
- (void)loadDataWithMasterDiagnose:(MasterDiagnose *)masterDiagnose ishiden:(BOOL)ishiden;

+ (CGFloat)cellHeight;

@end
