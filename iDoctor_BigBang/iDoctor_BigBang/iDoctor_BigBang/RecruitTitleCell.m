//
//  RecruitTitleCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/21/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "RecruitTitleCell.h"
#import "RecruitTitleRowModel.h"
@interface RecruitTitleCell()<UITextFieldDelegate>
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) RecruitTitleRowModel *recruitTitleRowModel;

@end
@implementation RecruitTitleCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setSelfDataWith:(BaseRowModel *)model
{
    RecruitTitleRowModel *recruitTitleRowModel = (RecruitTitleRowModel *)model;
    self.recruitTitleRowModel = recruitTitleRowModel;
    self.titleLabel.text = recruitTitleRowModel.text;
    self.textField.placeholder = recruitTitleRowModel.placeholder;
    self.textField.keyboardType = recruitTitleRowModel.keyboardType;
//    [self.textField becomeFirstResponder];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"RecruitTitleCell";
    RecruitTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[RecruitTitleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    UIView *superView = self.contentView;
    
//    self.titleLabel = [[UILabel alloc] init];
//    _titleLabel.textColor = UIColorFromRGB(0x353d3f);
//    _titleLabel.backgroundColor = GDRandomColor;
//    _titleLabel.text = @"fdjs";
//    [superView addSubview:_titleLabel];
//    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.left.equalTo(superView).offset(15);
//        make.centerY.equalTo(superView);
//        make.width.greaterThanOrEqualTo(30);
//    }];
    
    self.textField = [[UITextField alloc] init];
    _textField.textColor = GDColorRGB(143, 143, 143);
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    
    [superView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.right.equalTo(superView);
    }];
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = UIColorFromRGB(0x353d3f);
    
    [superView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {

        make.left.equalTo(superView).offset(15);
        make.centerY.equalTo(superView);
        make.right.equalTo(_textField.left).offset(-15);
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.recruitTitleRowModel.textFieldDidEndEditingBlock) {
        self.recruitTitleRowModel.textFieldDidEndEditingBlock(textField.text);
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ((UIKeyboardType)(-1) == textField.keyboardType) {
        
        textField.userInteractionEnabled = NO;
        return NO;
    }
    return YES;
}
- (UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = GDColorRGB(143, 143, 143);
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textField.delegate = self;
    }
    return _textField;
}

@end
