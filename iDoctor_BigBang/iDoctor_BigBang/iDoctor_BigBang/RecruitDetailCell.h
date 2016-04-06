//
//  RecruitDetailCell.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/23/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecruitDetail;
@interface RecruitDetailCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (CGFloat)height;

- (void)setDataWithRecruitDetail:(RecruitDetail *)recruitDetail;
@end
