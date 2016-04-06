//
//  QuickDiagnoseCell.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QuickDiagnose;
@interface QuickDiagnoseCell : UITableViewCell


// 张丽修改
- (void)loadData:(QuickDiagnose *)quickDiagnose ishiden:(BOOL)ishiden;

+ (CGFloat)cellHeight;

@end
