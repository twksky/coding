//
//  RecruitRatioCell.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/21/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "RecruitRatioCell.h"
#import "RecruitRatioRowModel.h"
#define kTextColor UIColorFromRGB(0xa8a8aa)
@interface RecruitRatioCell ()
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *ratioLabel;
@property(nonatomic, strong) UILabel *stateLabel;
@end
@implementation RecruitRatioCell

- (void)setSelfDataWith:(BaseRowModel *)model
{
    RecruitRatioRowModel *rr = (RecruitRatioRowModel *)model;
    self.timeLabel.text = rr.recruitList.ctime;
    self.titleLabel.text = rr.recruitList.title;
    self.ratioLabel.text = [NSString stringWithFormat:@"%ld/%ld",rr.recruitList.patient_count, rr.recruitList.need_people];
    
    if (!rr.recruitList.is_closed) {
        self.stateLabel.text = @"招募中";
        self.stateLabel.backgroundColor = UIColorFromRGB(0x5fa0ea);
    } else {
        self.stateLabel.text = @"已结束";
        self.stateLabel.backgroundColor = UIColorFromRGB(0xc0c0c1);

    }
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"RecruitRatioCell";
    RecruitRatioCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[RecruitRatioCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
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
    
    UIView *wrapView = [[UIView alloc] init];
    
    [self.contentView addSubview:wrapView];
    [wrapView makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(15, 15, 15, 15));
    }];
    
    // 标题
    self.titleLabel = [[UILabel alloc] init];
//    _titleLabel.backgroundColor = GDRandomColor;
    _titleLabel.text = @"饭店数量将发的是徕卡的风福建代理商看景撒";
    _titleLabel.font = GDFont(15);
    _timeLabel.textColor = kDefaultFontColor;
    
    [wrapView addSubview:_titleLabel];
    [_titleLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(wrapView);
        make.width.lessThanOrEqualTo(App_Frame_Width - 90);
    }];

    // 时间
    self.timeLabel = [[UILabel alloc] init];
//    _timeLabel.backgroundColor = GDRandomColor;
    _timeLabel.text = @"10/20/30";
    _timeLabel.font = GDFont(11);
    _timeLabel.textColor = kTextColor;
    
    [wrapView addSubview:_timeLabel];
    [_timeLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(wrapView);
        make.top.equalTo(wrapView).offset(3);
    }];
    
    // 人数
    UILabel *lb = [[UILabel alloc] init];
//    lb.backgroundColor = GDRandomColor;
    lb.text = @"人数:";
    lb.font = GDFont(13);
    lb.textColor = kTextColor;
    
    [wrapView addSubview:lb];
    [lb makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.equalTo(wrapView);
    }];
    
    self.ratioLabel = [[UILabel alloc] init];
//    _ratioLabel.backgroundColor = GDRandomColor;
    _ratioLabel.text = @"50/1000";
    _ratioLabel.font = GDFont(13);
    _ratioLabel.textColor = kTextColor;
    
    [wrapView addSubview:_ratioLabel];
    [_ratioLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lb.right).offset(10);
        make.top.bottom.equalTo(lb);
    }];
    
    self.stateLabel = [[UILabel alloc] init];
    _stateLabel.backgroundColor = GDRandomColor;
    _stateLabel.text = @"招募中";
    _stateLabel.font = GDFont(13);
    _stateLabel.textColor = [UIColor whiteColor];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.layer.cornerRadius = 10;
    _stateLabel.layer.masksToBounds = YES;
    
    [wrapView addSubview:_stateLabel];
    [_stateLabel makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_ratioLabel.right).offset(5);
        make.top.bottom.equalTo(_ratioLabel);
        make.height.equalTo(20);
        make.width.equalTo(50);
    }];
    
    // 箭头
    UIImageView *nextView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"next"]];
    
    [wrapView addSubview:nextView];
    [nextView makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(wrapView);
        make.bottom.equalTo(wrapView).offset(-2);
    }];
    
}

@end
