//
//  IDpatientMsgBottomTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class IDMedicaledModel;

@interface IDpatientMsgBottomTableViewCell : UITableViewCell


+ (IDpatientMsgBottomTableViewCell *)cellWithTab:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath;

- (void)dataWithMedicalDoctorModel:(IDMedicaledModel *)model indexPath:(NSIndexPath *)indexPath;


+ (CGFloat)height;

@end
