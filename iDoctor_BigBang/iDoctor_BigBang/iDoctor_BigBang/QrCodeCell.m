//
//  QrCodeCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "QrCodeCell.h"
#import "QrCodeRowModel.h"

@interface QrCodeCell ()
@property(nonatomic, strong) UIImageView *qrCode;
@end
@implementation QrCodeCell
- (void)setSelfDataWith:(BaseRowModel *)model
{
    QrCodeRowModel *qrCodeModel = (QrCodeRowModel *)model;
    self.textLabel.text = qrCodeModel.title;
    self.qrCode.image = qrCodeModel.qrCodeImage;
    //    GDMemberAvatarRowModel *avatarRowModel = (GDMemberAvatarRowModel *)model;
    //    UIImage *avatar = [[UIImage alloc] initWithContentsOfFile:GDAvatarPath];
    //    if (!avatar) {
    //        avatar = [UIImage imageNamed:@"instructor"];
    //    }
    //    [self.avatar sd_setImageWithURL:[NSURL URLWithString:avatarRowModel.avatarImageUrl] placeholderImage:avatar];
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"QrCodeCell";
    QrCodeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[QrCodeCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
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
    self.qrCode = [[UIImageView alloc] init];
    
    [superView addSubview:_qrCode];
    [_qrCode makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(superView).offset(-15);
        make.centerY.equalTo(superView);
        make.width.height.equalTo(20);
    }];
}

@end
