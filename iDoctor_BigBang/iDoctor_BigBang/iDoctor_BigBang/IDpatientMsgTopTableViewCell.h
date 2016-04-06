//
//  IDpatientMsgTopTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDGetPatientInformation;

@interface IDpatientMsgTopTableViewCell : UITableViewCell

+ (IDpatientMsgTopTableViewCell *)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)dataWithName:(NSString *)name patientInfo:(IDGetPatientInformation *)patientInfo IndexPath:(NSIndexPath *)indexPath;

@end
