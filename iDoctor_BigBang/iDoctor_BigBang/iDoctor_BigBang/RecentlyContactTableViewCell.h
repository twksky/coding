//
//  RecentlyContactTableViewCell.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/19.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDGetDoctorPatient;
@class RecentlyContactTableViewCell;

@protocol RecentlyContactTableViewCellDelegate <NSObject>

- (void)recentlyContactTableViewCellDidClickedAvatarImage:(RecentlyContactTableViewCell *)cell;

@end

@interface RecentlyContactTableViewCell : UITableViewCell

+ (CGFloat)DefaultCellHeight;

@property (nonatomic, weak)   id<RecentlyContactTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView   *avatarImageView;//头像
@property (nonatomic, strong) UILabel       *nicknameLabel;//昵称
@property (nonatomic, strong) UILabel     *countLabel;//数量
@property (nonatomic, strong) UILabel       *timeLabel;//时间
//@property (nonatomic, strong) UILabel       *infoLabel;//送花
@property (nonatomic, strong) UILabel       *messageLabel;//最后消息内容
@property (nonatomic, strong) UIImageView   *reSendIMG;//发送失败

- (void)setContact:(IDGetDoctorPatient *)patient;

@end
