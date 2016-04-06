//
//  IDIDPatientCaseTagTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  IDIDPatientCaseTagTableViewCell <NSObject>



@end



@interface IDIDPatientCaseTagTableViewCell : UITableViewCell

- (void)getCellWithTagName:(NSString *)tagName  tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
