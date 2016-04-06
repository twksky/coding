//
//  AddTemplateDiyQuestionCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "AddTemplateDiyQuestionCell.h"
#import <PureLayout.h>

@interface AddTemplateDiyQuestionCell ()

@property (nonatomic, strong) UILabel *questionContentLabel;
@property (nonatomic, strong) UIButton *deleteButton;

@end

@implementation AddTemplateDiyQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    [self addSubview:self.deleteButton];
    {
        [self addConstraint:[self.deleteButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [self addConstraint:[self.deleteButton autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraints:[self.deleteButton autoSetDimensionsToSize:CGSizeMake(30.0f, 30.0f)]];
    }
    
    [self addSubview:self.questionContentLabel];
    {
        [self addConstraint:[self.questionContentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20.0f]];
        [self addConstraint:[self.questionContentLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self addConstraint:[self.questionContentLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.deleteButton withOffset:-10.0f]];
    }
}

#pragma mark - selector

- (void)deleteButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeItemWith:)]) {
        
        [self.delegate removeItemWith:self];
    }
}

#pragma mark - loaddata

- (void)loadDataWithDiyQuestion:(NSString *)diyQuestion {
    
    self.questionContentLabel.text = diyQuestion;
}


#pragma mark - properties

- (UILabel *)questionContentLabel {
    
    if (!_questionContentLabel) {
        
        _questionContentLabel = [[UILabel alloc] init];
        _questionContentLabel.numberOfLines = 1;
        _questionContentLabel.textColor = UIColorFromRGB(0x737373);
    }
    
    return _questionContentLabel;
}

- (UIButton *)deleteButton {
    
    if (!_deleteButton) {
        
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"icon_diyquestion_delete"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _deleteButton;
}

@end
