//
//  QuickDiagnoseCell.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

@class QuickDiagnose;
@interface RepliedQuickDiagnoseCell : UITableViewCell


// 张丽修改
- (void)loadData:(QuickDiagnose *)quickDiagnose;

+ (CGFloat)cellHeight;

@end
