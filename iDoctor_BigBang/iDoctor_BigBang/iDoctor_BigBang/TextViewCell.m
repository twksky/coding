//
//  TextViewCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TextViewCell.h"
#import "TextViewRowModel.h"

@interface TextViewCell ()<UITextViewDelegate>
@property(nonatomic, strong) UITextView *textView;
@property(nonatomic, strong) TextViewRowModel *descModel;

@end
@implementation TextViewCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    TextViewRowModel *descModel = (TextViewRowModel *)model;
    self.descModel = descModel;
    
    self.textView.text = descModel.text;
    [self.textView becomeFirstResponder];
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"TextViewCell";
    TextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[TextViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
//        make.edges.equalTo(self.contentView);

    }];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (self.descModel.textViewDidEndEditingBlock) {
        self.descModel.textViewDidEndEditingBlock(textView.text);
    }
}
- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
//        _textView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _textView.textColor = GDColorRGB(143, 143, 143);
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
    }
    return _textView;
}

@end
