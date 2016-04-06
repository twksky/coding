//
//  CheckBoxCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/23/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "CheckBoxCell.h"
#import "CheckBoxRowModel.h"
#define kMargin 10

@interface CheckBoxCell()
@property(nonatomic, strong) CheckBoxRowModel *cbModel;
@property(nonatomic, strong) UIButton *lastBtn;

@end
@implementation CheckBoxCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setSelfDataWith:(BaseRowModel *)model
{
    CheckBoxRowModel *checkbox = (CheckBoxRowModel *)model;
    self.cbModel = checkbox;
    self.textLabel.text = checkbox.title;
    __block UIButton *lastBtn;
    [checkbox.checkboxTitleArray enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        
        UIButton *btn = [self createBtnWithTitle:str];
        
        [self.contentView addSubview:btn];
        [btn makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(lastBtn ? lastBtn.right : self.contentView).offset(lastBtn ? kMargin *2 : 95);
        }];
        lastBtn = btn;
    }];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"CheckBoxCell";
    CheckBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[CheckBoxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
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
    
}
- (UIButton *)createBtnWithTitle:(NSString *)title
{
    UIButton *btn = [[UIButton alloc] init];
//    btn.backgroundColor = GDRandomColor;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, kMargin, 0, -kMargin);
    [btn setImage:[UIImage imageNamed:@"inactive"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"active"] forState:UIControlStateSelected];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kDefaultFontColor forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
- (void)btnClick:(UIButton *)btn;
{
    self.lastBtn.selected = NO;
    btn.selected = !btn.selected;
    self.lastBtn = btn;
    if (self.cbModel.checkBoxCheckedBlock) {
        self.cbModel.checkBoxCheckedBlock(btn.titleLabel.text);
    }
}
@end
