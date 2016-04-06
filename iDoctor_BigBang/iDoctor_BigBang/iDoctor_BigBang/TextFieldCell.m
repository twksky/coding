//
//  TextFieldCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TextFieldCell.h"
#import "TextFieldRowModel.h"

@interface TextFieldCell ()<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *textField;
@property(nonatomic, strong) TextFieldRowModel *textFieldModel;
@end
@implementation TextFieldCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}
- (void)setSelfDataWith:(BaseRowModel *)model
{
    TextFieldRowModel *textFieldModel = (TextFieldRowModel *)model;
    self.textFieldModel = textFieldModel;
    
    self.textField.text = textFieldModel.text;
    self.textField.placeholder = textFieldModel.placeholder;
    self.textField.keyboardType = textFieldModel.keyboardType;
//    [self.textField becomeFirstResponder];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"TextFieldCell";
    TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[TextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    [self.contentView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.textFieldModel.textFieldDidEndEditingBlock) {
        self.textFieldModel.textFieldDidEndEditingBlock(textField.text);
    }
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
