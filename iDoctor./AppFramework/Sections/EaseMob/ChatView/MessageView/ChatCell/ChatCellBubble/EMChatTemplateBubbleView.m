//
//  EMChatExtTextBubbleView.m
//  AppFramework
//
//  Created by ABC on 7/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "EMChatTemplateBubbleView.h"
#import "UIView+Autolayout.h"
#import "UILabel+VerticalAlign.h"
#import <UIImageView+WebCache.h>


NSString *const kRouterEventTemplateBubbleTapEventName = @"kRouterEventTemplateBubbleTapEventName";

@interface EMChatTemplateBubbleView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *templateIcon;

- (void)acceptButtonClicked:(id)sender;
- (void)refuseButtonClicked:(id)sender;

@end

@implementation EMChatTemplateBubbleView

//const CGFloat RecordBubbleHeightIncrement = 25.0f;
//const CGFloat FlowerBubbleHeightIncrement = 55.0f;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect frame = self.textLabel.frame;
    if (self.model.message.ext) {
        // obj:接受到的obj对象    objKey:obj对应的key
        NSObject *obj = [self.model.message.ext objectForKey:@"type"];
        NSNumber *typeNumber = (NSNumber *)obj;
        if (0 == [typeNumber integerValue]) {
            // 普通文字信息
        } else if (1 == [typeNumber integerValue]) {
            // 病例
//            frame.size.height -= RecordBubbleHeightIncrement;
        } else if (2 == [typeNumber integerValue]) {
            // 送花
//            frame.size.height -= FlowerBubbleHeightIncrement;
        } else if (3 == [typeNumber integerValue]) {
            // 接受花
        } else if (4 == [typeNumber integerValue]) {
            // 拒绝花
        }
    }
    [self.textLabel setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (CGSize)sizeThatFits:(CGSize)size
{
//    CGSize retSize = [super sizeThatFits:size];
//    
//    if (self.model.message.ext) {
//        // obj:接受到的obj对象    objKey:obj对应的key
//        NSObject *obj = [self.model.message.ext objectForKey:@"type"];
//        NSNumber *typeNumber = (NSNumber *)obj;
//        if (0 == [typeNumber integerValue]) {
//            // 普通文字信息
//        } else if (1 == [typeNumber integerValue]) {
//            // 病例
////            retSize.height += RecordBubbleHeightIncrement;
//        } else if (2 == [typeNumber integerValue]) {
//            // 送花
////            retSize.height += FlowerBubbleHeightIncrement;
//        } else if (3 == [typeNumber integerValue]) {
//            // 接受花
//        } else if (4 == [typeNumber integerValue]) {
//            // 拒绝花
//        }
//    }
    
    NSString *title = [self.model.message.ext objectForKey:@"title"];
    
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    CGSize retSize;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        retSize = [title boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[[self class] textLabelFont]} context:nil].size;
    }else{
        retSize = [title sizeWithFont:[[self class] textLabelFont] constrainedToSize:textBlockMinSize lineBreakMode:[[self class] textLabelLineBreakModel]];
    }
    
    CGFloat height = 70.0f;
    if (2*BUBBLE_VIEW_PADDING + retSize.height > height) {
        height = 2*BUBBLE_VIEW_PADDING + retSize.height;
    }
    
    retSize = CGSizeMake(retSize.width + BUBBLE_VIEW_PADDING*2 + BUBBLE_VIEW_PADDING, height);
    
    return CGSizeMake(retSize.width + 70.0f, retSize.height);
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventTemplateBubbleTapEventName userInfo:@{KMESSAGEKEY:self.model}];
}


#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];

    NSDictionary *ext = model.message.ext;
    NSString *imageUrl = [ext objectForKey:@"image_url"];
    NSString *title = [ext objectForKey:@"title"];
    
    [self.templateIcon sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_templatemodel_default"]];
    
    self.titleLabel.text = title;
    
    [self.templateIcon removeFromSuperview];
    [self.titleLabel removeFromSuperview];
    
    [self addSubview:self.templateIcon];
    [self addSubview:self.titleLabel];
    
    {
        [self addConstraints:[self.templateIcon autoSetDimensionsToSize:CGSizeMake(50.0f, 50.0f)]];
        [self addConstraint:[self.templateIcon autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:15.0f]];
        [self addConstraint:[self.templateIcon autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f]];
        
        [self addConstraint:[self.titleLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateIcon]];
        [self addConstraint:[self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.templateIcon withOffset:10.0f]];
    }
    

    
//    self.textLabel.text = self.model.content;
}


#pragma mark - public

+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    
//    object.content = [NSString stringWithFormat:@"%@                 \n\n\n", object.content];
//    object.content = @"为了更好的对您的病症做诊断, 请您先填写简单的个人信息!\n\n\n";
    
    CGFloat bubbleHeight = [super heightForBubbleWithObject:object];
    CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
    bubbleHeight = 80.0f;
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:object.content attributes:@{NSFontAttributeName:[self textLabelFont]}];
    CGRect descRect = [attributedText boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    bubbleHeight += descRect.size.height;
    bubbleHeight += 65.0f;
    return bubbleHeight;
}

- (void)clearSubview
{
    for (UIView *theSubview in self.subviews) {
        if (theSubview != self.textLabel && theSubview != self.backImageView) {
            [theSubview removeFromSuperview];
        }
    }
}


#pragma mark - Selector

- (void)acceptButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(chatExtTextBubbleView:didAcceptFlowerWithMessageModel:)]) {
        [self.delegate chatExtTextBubbleView:self didAcceptFlowerWithMessageModel:self.model];
    }
}

- (void)refuseButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(chatExtTextBubbleView:didRefuseFlowerWithMessageModel:)]) {
        [self.delegate chatExtTextBubbleView:self didRefuseFlowerWithMessageModel:self.model];
    }
}

- (void)detailButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(chatExtTextBubbleView:didClickDetailButtonWithMessageModel:)]) {
        [self.delegate chatExtTextBubbleView:self didClickDetailButtonWithMessageModel:self.model];
    }
}

#pragma mark - properties

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.lineBreakMode = [[self class] textLabelLineBreakModel];
        _titleLabel.textColor = UIColorFromRGB(0x107763);
        _titleLabel.font = [[self class] textLabelFont];
    }
    
    return _titleLabel;
}

- (UIImageView *)templateIcon {
    
    if (!_templateIcon) {
        
        _templateIcon = [[UIImageView alloc] init];
        _templateIcon.layer.cornerRadius = 3.0f;
        _templateIcon.layer.masksToBounds = YES;
    }
    
    return _templateIcon;
}

@end
