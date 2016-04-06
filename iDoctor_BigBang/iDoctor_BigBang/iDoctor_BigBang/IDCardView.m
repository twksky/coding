//
//  CardView.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/17.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "IDCardView.h"

#import "Account.h"
#import "AccountManager.h"

#import <SDWebImage/UIImageView+WebCache.h>


@interface IDCardView()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

@property (weak, nonatomic) IBOutlet UIImageView *Q_RImageView;
@property (weak, nonatomic) IBOutlet UILabel *tiplabel;


@end

@implementation IDCardView


- (void)getData
{
    Account *model = [AccountManager sharedInstance].account;
    
    // 头像
    self.iconImage.layer.masksToBounds = YES;
    self.iconImage.layer.cornerRadius = 45.0f;
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:model.avatar_url] placeholderImage:[UIImage imageNamed:@"wantP_avatar"]];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ | %@", model.realname, model.title];
    self.hospitalLabel.text = model.hospital;
    self.departmentLabel.text = model.department;
    
    
    [self.Q_RImageView sd_setImageWithURL:[NSURL URLWithString:model.qr_code_url] placeholderImage:[UIImage imageNamed:@"regist_success"]];
    
//    self.tiplabel.text = @"让您的患者扫二维码加您";
//    self.tiplabel.backgroundColor = [UIColor redColor];
    
}


@end
