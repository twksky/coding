//
//  HomeTableViewCell.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/15.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.textColor = UIColorFromRGB(0x353d3f);
    self.contentLabel.textColor = UIColorFromRGB(0xa8a8aa);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
