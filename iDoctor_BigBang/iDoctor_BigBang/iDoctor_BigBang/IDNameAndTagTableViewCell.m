//
//  IDNameAndTagTableViewCell.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDNameAndTagTableViewCell.h"
#import "TagView.h"

@interface IDNameAndTagTableViewCell()

// 名字
@property (nonatomic, strong) UILabel *nameLabel;


// 标签
@property (nonatomic, strong) TagView *tagView;


@end

@implementation IDNameAndTagTableViewCell

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
        
        
        
    }
    
    return self;
}

@end
