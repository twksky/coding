//
//  QuickDiagnoseCommentCell.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/20.
//  Copyright © 2015年 YDHL. All rights reserved.
//
@class QuickDiagnoseComment;

@interface QuickDiagnoseCommentCell : UITableViewCell

@property (nonatomic, strong) UILabel *commentContentLabel;
@property (nonatomic, strong) UILabel *doctorTitleLabel;

+ (CGFloat)cellHeight:(QuickDiagnoseComment *)comment;
- (void)setupView;
- (void)loadDataComment:(QuickDiagnoseComment *)comment;

@end
