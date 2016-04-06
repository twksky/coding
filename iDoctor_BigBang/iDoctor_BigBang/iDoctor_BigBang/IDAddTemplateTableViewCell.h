//
//  IDAddTemplateTableViewCell.h
//  iDoctor_BigBang
//
//  Created by hexy on 8/4/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol IDAddTemplateTableViewCellDelegate <NSObject>

- (void)closeButtonClicked:(UIButton *)button text:(NSString *)text;

@end

@interface IDAddTemplateTableViewCell : UITableViewCell

@property (nonatomic, assign) id<IDAddTemplateTableViewCellDelegate>  delegate;

// 得到相应的数据
- (void)dataWithText:(NSString *)text;

+ (IDAddTemplateTableViewCell *)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath;

@end
