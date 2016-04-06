//
//  MenuCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/16/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()
@property(nonatomic, strong) UIView *hLine;
@end
@implementation MenuCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.hLine.hidden = NO;
  
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"Menucell";
    
    MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf4f4f5);
//    cell.backgroundColor = UIColorFromRGB(0xf4f4f5);
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self setUpAllViews];
    }
    return self;

}

- (void)setUpAllViews
{
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    self.textLabel.font = GDFont(13);
    
    self.hLine = [[UIView alloc] init];
    _hLine.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [self.contentView addSubview:_hLine];
    [_hLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.contentView);
        make.height.equalTo(1);
    }];
    
    UIView *vLine = [[UIView alloc] init];
    vLine.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [self.contentView addSubview:vLine];
    [vLine makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.right.equalTo(self.contentView);
        make.width.equalTo(1);
    }];
}
@end
