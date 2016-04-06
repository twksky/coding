//
//  IDAddTemplateTableViewCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 8/4/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "IDAddTemplateTableViewCell.h"

@interface IDAddTemplateTableViewCell()

// 名字
@property (nonatomic, strong) UILabel *nameLabel;

// 小叉
@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation IDAddTemplateTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI
{
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.contentView).with.offset(15);
        make.centerY.equalTo(self.contentView);
        
    }];
    
    [self.contentView addSubview:self.closeButton];
    [self.closeButton makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self.contentView).offset(-15);
        make.centerY.equalTo(self.contentView);
        make.size.equalTo(CGSizeMake(23, 23));
        
    }];
    
    
}

- (void)dataWithText:(NSString *)text
{
    self.nameLabel.text = text;
}

+ (IDAddTemplateTableViewCell *)cellWithTableView:(UITableView *)tableView indexpath:(NSIndexPath *)indexpath
{
    static NSString *ident = @"IDAddTemplateTableViewCell";
    
    IDAddTemplateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        
        cell = [[IDAddTemplateTableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
    }

    return cell;

}

#pragma mark - 懒加载
- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14.0f];
        _nameLabel.textColor = UIColorFromRGB(0x353d3f);
    }
    
    return _nameLabel;
}

- (UIButton *)closeButton
{
    if (_closeButton == nil) {
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"service_price_close"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _closeButton;
}

- (void)closeButtonClicked:(UIButton *)button
{
    
    if ([self.delegate respondsToSelector:@selector(closeButtonClicked:text:)]) {
        
        [self.delegate closeButtonClicked:button text:self.nameLabel.text];
    }

}


@end
