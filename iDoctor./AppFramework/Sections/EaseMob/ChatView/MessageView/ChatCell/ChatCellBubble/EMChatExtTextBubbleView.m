//
//  EMChatExtTextBubbleView.m
//  AppFramework
//
//  Created by ABC on 7/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "EMChatExtTextBubbleView.h"
#import "UIView+Autolayout.h"
#import "UILabel+VerticalAlign.h"

@interface EMChatExtTextBubbleView ()

- (void)acceptButtonClicked:(id)sender;
- (void)refuseButtonClicked:(id)sender;

@end

@implementation EMChatExtTextBubbleView

const CGFloat RecordBubbleHeightIncrement = 25.0f;
const CGFloat FlowerBubbleHeightIncrement = 55.0f;

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
            frame.size.height -= RecordBubbleHeightIncrement;
        } else if (2 == [typeNumber integerValue]) {
            // 送花
            frame.size.height -= FlowerBubbleHeightIncrement;
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
    CGSize retSize = [super sizeThatFits:size];
    
    if (self.model.message.ext) {
        // obj:接受到的obj对象    objKey:obj对应的key
        NSObject *obj = [self.model.message.ext objectForKey:@"type"];
        NSNumber *typeNumber = (NSNumber *)obj;
        if (0 == [typeNumber integerValue]) {
            // 普通文字信息
        } else if (1 == [typeNumber integerValue]) {
            // 病例
            retSize.height += RecordBubbleHeightIncrement;
        } else if (2 == [typeNumber integerValue]) {
            // 送花
            retSize.height += FlowerBubbleHeightIncrement;
        } else if (3 == [typeNumber integerValue]) {
            // 接受花
        } else if (4 == [typeNumber integerValue]) {
            // 拒绝花
        }
    }
    
    return retSize;
}


#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
    
    if (model.message.ext) {
        // obj:接受到的obj对象    objKey:obj对应的key
        NSObject *obj = [model.message.ext objectForKey:@"type"];
        NSNumber *typeNumber = (NSNumber *)obj;
        if (0 == [typeNumber integerValue]) {
            // 普通文字信息
        } else if (1 == [typeNumber integerValue]) {
            // 病例
            //NSInteger recordID = [[model.message.ext objectForKey:@"record_id"] integerValue];
            NSString *name = [model.message.ext objectForKey:@"name"];
            NSString *gender = [model.message.ext objectForKey:@"sex"];
            if ([[gender lowercaseString] isEqualToString:@"male"]) {
                gender = @"男";
            } else if ([[gender lowercaseString] isEqualToString:@"female"]) {
                gender = @"女";
            }
            NSInteger age = [[model.message.ext objectForKey:@"age"] integerValue];
            NSString *desc = [model.message.ext objectForKey:@"desc"];
            NSInteger imagesCount = [[model.message.ext objectForKey:@"imagesCount"] integerValue];
            //NSInteger recordID = [[model.message.ext objectForKey:@"record_id"] integerValue];
            
            NSMutableString *contentText = [[NSMutableString alloc] init];
            [contentText appendFormat:@"患者：%@\t%@\t%ld岁\n%@\n", name, gender, age, desc];
            [contentText appendFormat:@"图片：%ld张", imagesCount];
            self.model.content = contentText;
            
            UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
            detailButton.layer.borderColor = [[UIColor grayColor] CGColor];
            detailButton.layer.borderWidth = 0.5f;
            detailButton.layer.masksToBounds = YES;
            detailButton.layer.cornerRadius = 3.0f;
            detailButton.layer.backgroundColor = [[UIColor orangeColor] CGColor];
            [detailButton setTitle:@"点击查看详情" forState:UIControlStateNormal];
            [detailButton addTarget:self action:@selector(detailButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:detailButton];
            {
                // Autolayout
                [self addConstraint:[detailButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-10.0f]];
                [self addConstraint:[detailButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-5.0f]];
            }
        } else if (2 == [typeNumber integerValue]) {
            // 送花
            // (“message”:"xxxxxx") 一些信息 ("nums":11)花朵数目 ("flower_id":xxxxx)这次交易的id
            __unused NSString *userMsg = [model.message.ext objectForKey:@"message"];
            NSInteger flowerNumber = [[model.message.ext objectForKey:@"nums"] integerValue];
            //NSInteger flowerDealID = [[model.ext objectForKey:@"flower_id"] integerValue];
            NSString *nickName = self.model.nickName;
            if (!nickName) {
                nickName = self.model.username;
            }
            self.model.content = [NSString stringWithFormat:@"赠送给您%ld朵花，是否接收？", flowerNumber];
            
            // 接受、拒绝花朵按钮
            UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
            acceptButton.layer.borderColor = [[UIColor orangeColor] CGColor];
            acceptButton.layer.borderWidth = 0.5f;
            acceptButton.layer.cornerRadius = 3.0f;
            acceptButton.layer.masksToBounds = YES;
            acceptButton.layer.backgroundColor = [[UIColor orangeColor] CGColor];
            [acceptButton setTitle:@"接收" forState:UIControlStateNormal];
            [acceptButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [acceptButton addTarget:self action:@selector(acceptButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:acceptButton];
            
            UIButton *refuseButton = [UIButton buttonWithType:UIButtonTypeCustom];
            refuseButton.layer.borderColor = [[UIColor grayColor] CGColor];
            refuseButton.layer.borderWidth = 0.5f;
            refuseButton.layer.cornerRadius = 3.0f;
            refuseButton.layer.masksToBounds = YES;
            refuseButton.layer.backgroundColor = [[UIColor grayColor] CGColor];
            [refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
            [refuseButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [refuseButton addTarget:self action:@selector(refuseButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:refuseButton];
            {
                // Autolayout
                [self addConstraints:[acceptButton autoSetDimensionsToSize:CGSizeMake(75.0f, 40.0f)]];
                [self addConstraints:[refuseButton autoSetDimensionsToSize:CGSizeMake(75.0f, 40.0f)]];
                [self addConstraint:[refuseButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self withOffset:-20.0f]];
                [self addConstraint:[refuseButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10.0f]];
                [self addConstraint:[acceptButton autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:refuseButton withOffset:-10.0f]];
                [self addConstraint:[acceptButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self withOffset:-10.0f]];
            }
        } else if (3 == [typeNumber integerValue]) {
            // 接收花
        } else if (4 == [typeNumber integerValue]) {
            // 拒绝花
        }
    }
    
    self.textLabel.text = self.model.content;
}


#pragma mark - public

+ (CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    CGFloat bubbleHeight = [super heightForBubbleWithObject:object];
    if (object.message.ext) {
        // obj:接受到的obj对象    objKey:obj对应的key
        NSObject *obj = [object.message.ext objectForKey:@"type"];
        NSNumber *typeNumber = (NSNumber *)obj;
        if (0 == [typeNumber integerValue]) {
            // 普通文字信息
        } else if (1 == [typeNumber integerValue]) {
            // 病例
            // 计算众多病历行的高度
            CGSize textBlockMinSize = {TEXTLABEL_MAX_WIDTH, CGFLOAT_MAX};
            NSString *desc = [object.message.ext objectForKey:@"desc"];
            bubbleHeight = 80.0f;
            NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:desc attributes:@{NSFontAttributeName:[self textLabelFont]}];
            CGRect descRect = [attributedText boundingRectWithSize:textBlockMinSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            bubbleHeight += descRect.size.height;
            bubbleHeight += RecordBubbleHeightIncrement;
        } else if (2 == [typeNumber integerValue]) {
            // 送花
            bubbleHeight += FlowerBubbleHeightIncrement;
        } else if (3 == [typeNumber integerValue]) {
            // 接收花
        } else if (4 == [typeNumber integerValue]) {
            // 拒绝花
        }
    }
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

@end
