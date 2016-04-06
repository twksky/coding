//
//  BaseCell.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BaseRowModel;
@interface BaseCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
+ (instancetype)defaultCellWithTableView:(UITableView *)tableView;

- (void)setDataWithModel:(BaseRowModel *)model;
- (void)setSelfDataWith:(BaseRowModel *)model;

@end
