//
//  BankCardCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BankCardCell.h"
#import "BankCardRowModel.h"
#import "BankCardListRowModel.h"
#import "GlideManger.h"
@implementation BankCardCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    if ([model isKindOfClass:[BankCardListRowModel class]]) {
        
        BankCardListRowModel *bkl = (BankCardListRowModel *)model;
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:bkl.bankCard.bank_logo_url] placeholderImage:[UIImage imageNamed:@"health_file"]];
        self.textLabel.text = bkl.bankCard.bankname;

        NSString *st = [bkl.bankCard.bank_account substringFromIndex:bkl.bankCard.bank_account.length - 4];
        self.detailTextLabel.text = [NSString stringWithFormat:@"尾号 %@ 储蓄卡",st];
        if (bkl.bankCard.is_default) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    } else {
        
        BankCardRowModel *bk = (BankCardRowModel *)model;
        self.imageView.image = bk.icon;
        self.textLabel.text = bk.title;
        self.detailTextLabel.text = bk.subtitle;

    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"BankCardCell";
    BankCardCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[BankCardCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    cell.detailTextLabel.font = GDFont(12);
    return cell;
}
@end
