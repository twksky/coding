//
//  BaseCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseCell.h"

#import "BaseRowModel.h"
#import "ArrowRowModel.h"
#import "CheckMarkRowModel.h"

@implementation BaseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"BaseCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

+ (instancetype)defaultCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"BaseDefaultCell";
    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[BaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
- (void)setDataWithModel:(BaseRowModel *)model
{
    
    
    if ([model isKindOfClass:[ArrowRowModel class]]) {
        
        //设置cell右面的accessoryView
        UIImageView *accessoryView = [[UIImageView alloc] init];
        accessoryView.bounds = CGRectMake(0, 0, 6, 11);
        accessoryView.image = [UIImage imageNamed:@"next"];
        self.accessoryView = accessoryView;
        
    } else {
        self.accessoryView = nil;
    }
    
    [self setSelfDataWith:model];
}

- (void)setSelfDataWith:(BaseRowModel *)model
{
    
    if ([model isKindOfClass:[BaseRowModel class]]) {
        
        if (model.icon) {
            self.imageView.image = model.icon;
        }
        
        self.textLabel.text = model.title;
        if (model.textAlignment) {
            self.textLabel.textAlignment = model.textAlignment;
            
        }
        self.detailTextLabel.text = [model.subtitle copy];
        self.detailTextLabel.font = GDFont(12);
        self.detailTextLabel.textColor = UIColorFromRGB(0xa8a8aa);
    }
    
    if ([model isKindOfClass:[CheckMarkRowModel class]]) {
        
        if ([self.textLabel.text isEqualToString:kAccount.sex ] ||
            [self.textLabel.text isEqualToString:kAccount.title] ||
            [self.textLabel.text isEqualToString:kAccount.department] ||
            [self.textLabel.text isEqualToString:kAccount.hospital]
            )
        {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    } else {
        
        
    }
}

@end
