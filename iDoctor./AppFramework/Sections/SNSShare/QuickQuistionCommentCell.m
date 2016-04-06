//
//  QuickQuistionCommentCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/4/22.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "QuickQuistionCommentCell.h"

@implementation QuickQuistionCommentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupSubViews];
    }
    
    return self;
}


- (void)setupSubViews {
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.commentContentLabel];
    
    //AutoLayout
    {
        [self addConstraint:[self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0f]];
        [self addConstraint:[self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        
        [self addConstraint:[self.commentContentLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self addConstraint:[self.commentContentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:10.0f]];
        [self addConstraint:[self.commentContentLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20]];
    }
}


- (UILabel *)commentContentLabel {
    
    if (nil == _commentContentLabel) {
        
        _commentContentLabel = [[UILabel alloc] init];
        _commentContentLabel.font = [UIFont systemFontOfSize:14.0f];
        _commentContentLabel.lineBreakMode = UILineBreakModeWordWrap;
        _commentContentLabel.numberOfLines = 0;
    }
    
    return _commentContentLabel;
}

- (UILabel *)titleLabel {
    
    if (nil == _titleLabel) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.text = @"我的回答";
    }
    
    return _titleLabel;
}

+ (CGFloat)cellHeightWithComment:(Comment *)comment {
    
    NSMutableString *infoText = [[NSMutableString alloc] init];
    [infoText appendString:comment.commentDescription];
    
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 20.0f, MAXFLOAT);
    CGSize textSize = [infoText sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraintSize];
    return 50.0f + textSize.height;
}

@end
