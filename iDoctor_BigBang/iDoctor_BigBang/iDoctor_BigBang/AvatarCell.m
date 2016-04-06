//
//  AvatarCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "AvatarCell.h"
#import "AvatarRowModel.h"

@interface AvatarCell ()
/**
 *  头像
 */
@property(nonatomic, strong) UIImageView *avatar;

@end
@implementation AvatarCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    AvatarRowModel *avatarRowModel = (AvatarRowModel *)model;
    self.textLabel.text = avatarRowModel.title;
    self.avatar.image = [UIImage createImageWithColor:GDRandomColor];
//    GDMemberAvatarRowModel *avatarRowModel = (GDMemberAvatarRowModel *)model;
//    UIImage *avatar = [[UIImage alloc] initWithContentsOfFile:GDAvatarPath];
//    if (!avatar) {
//        avatar = [UIImage imageNamed:@"instructor"];
//    }
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:avatarRowModel.avatarImageURLStr] placeholderImage:[UIImage imageNamed:@"fmale"]];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"AvatarCell";
    AvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[AvatarCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
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
    UIView *superView = self.contentView;
    
    // 左边的标题
    self.textLabel.text = @"头像";
    self.textLabel.textColor = UIColorFromRGB(0x353d3f);
    
    // 头像
    self.avatar = [[UIImageView alloc] init];
    
    [superView addSubview:_avatar];
    [_avatar mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(superView).offset(15);
        make.right.equalTo(superView).offset(-15);
        make.width.height.equalTo(65);
    }];
}
@end
