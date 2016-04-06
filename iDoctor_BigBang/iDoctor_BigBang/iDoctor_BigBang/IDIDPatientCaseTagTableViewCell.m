//
//  IDIDPatientCaseTagTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDIDPatientCaseTagTableViewCell.h"


@interface IDIDPatientCaseTagTableViewCell()


// 标签名
@property (nonatomic, strong) UILabel *tagLabel;

// 输入框
@property (nonatomic, strong) UITextField *tagTextField;

@end


@implementation IDIDPatientCaseTagTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupUI];
    }
    
    
    return self;
}

- (void)setupUI
{
    
}

@end
