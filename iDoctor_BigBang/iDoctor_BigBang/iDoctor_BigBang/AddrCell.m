//
//  AddrCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "AddrCell.h"
#import "AddrRowModel.h"
@interface AddrCell ()<UITextFieldDelegate>
@property(nonatomic, strong) UITextField *textField;

@property(nonatomic, strong) AddrRowModel *addrModel;
@end
@implementation AddrCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    AddrRowModel *addrModel = (AddrRowModel *)model;
    self.addrModel = addrModel;
    
    self.textLabel.text = addrModel.title;
    self.textField.text = addrModel.value;
    self.textField.placeholder = addrModel.title;
    self.textField.keyboardType = addrModel.keyboardType;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"AddrCell";
    AddrCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[AddrCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
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
    self.textLabel.text = @"修改地址";
    
    UIView *superView = self.contentView;
    
    self.textField = [[UITextField alloc] init];
    _textField.textColor = GDColorRGB(143, 143, 143);
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.delegate = self;
    
    [superView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.right.equalTo(superView);
        make.left.equalTo(superView).offset(100);
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ((UIKeyboardType)(-1) == textField.keyboardType) {
        
        textField.userInteractionEnabled = NO;
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.addrModel.textFieldDidEndEditingBlock) {
        self.addrModel.textFieldDidEndEditingBlock(textField.text);
    }
}

@end
