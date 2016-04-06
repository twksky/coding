//
//  QuickDiagnoseCell.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/13.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseCell.h"
#import "QuickDiagnose.h"

#import <Masonry.h>
#import <UIImageView+WebCache.h>

@interface QuickDiagnoseCell()

@property (nonatomic, strong) UIImageView *patientIcon;
@property (nonatomic, strong) UILabel *patientNameLabel;
@property (nonatomic, strong) UIImageView *patientSexIcon;
@property (nonatomic, strong) UILabel *patientAgeLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *replyStatusLabel;
@property (nonatomic, strong) UILabel *replyNumberLabel;
@property (nonatomic, strong) UILabel *imageNumberLabel;
@property (nonatomic, strong) UIView *seperatorLine;

@end

@implementation QuickDiagnoseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupView];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    frame.origin.x = 10.0f;
    frame.origin.y += 10.0f;;
    frame.size.width -= 10.0f * 2;
    frame.size.height -= 10.0f;;
    [super setFrame:frame];
}

- (void)setupView {
    
    UIView *contentView = self;
    contentView.backgroundColor = [UIColor whiteColor];
    ViewBorderRadius(contentView, 10.0f, 0.7f, UIColorFromRGB(0xdddfe0));
    
//    [self addSubview:contentView];
//    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.top.and.left.equalTo(self).with.offset(15.0f);
//        make.right.equalTo(self).with.offset(-15.0f);
//        make.bottom.equalTo(self);
//    }];
    
    [contentView addSubview:self.patientIcon];
    [self.patientIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.and.width.equalTo(50.0f);
        make.top.equalTo(contentView).with.offset(15.0f);
        make.left.equalTo(contentView).with.offset(15.0f);
    }];
    
    [contentView addSubview:self.patientNameLabel];
    [self.patientNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(contentView).with.offset(17.5f);
        make.left.equalTo(self.patientIcon.right).with.offset(10.0f);
    }];
    
    [contentView addSubview:self.patientSexIcon];
    [self.patientSexIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.and.width.equalTo(17.5f);
        make.left.equalTo(self.patientNameLabel.right).with.offset(4.0f);
        make.centerY.equalTo(self.patientNameLabel);
    }];
    
    [contentView addSubview:self.patientAgeLabel];
    [self.patientAgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.patientSexIcon.right).with.offset(20.0f);
        make.centerY.equalTo(self.patientSexIcon);
    }];
    
    [contentView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.patientNameLabel);
        make.right.equalTo(contentView).offset(-15.0f);
    }];

    
    [contentView addSubview:self.departmentLabel];
    [self.departmentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.patientIcon.right).with.equalTo(10.0f);
        make.top.equalTo(self.patientNameLabel.bottom).with.offset(10.0f);
    }];
    
    [contentView addSubview:self.contentLabel];
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.patientIcon.bottom).with.offset(17.5f);
        make.left.equalTo(contentView).with.offset(15.0f);
        make.right.equalTo(contentView).with.offset(-15.0f);
    }];
    
    [contentView addSubview:self.seperatorLine];
    [self.seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(contentView);
        make.height.equalTo(0.7f);
        make.bottom.equalTo(contentView).with.offset(-52.0f);
        make.left.equalTo(contentView);
    }];
    
    UIView *bottomContainer = [[UIView alloc] init];
    ViewRadius(bottomContainer, 10.0f);
    
    [contentView addSubview:bottomContainer];
    [bottomContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.seperatorLine.bottom);
        make.left.and.right.and.bottom.equalTo(contentView);
    }];
    
    [bottomContainer addSubview:self.replyStatusLabel];
    [self.replyStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bottomContainer);
        make.left.equalTo(bottomContainer).with.offset(15.0f);
    }];
    
    [bottomContainer addSubview:self.replyNumberLabel];
    [self.replyNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bottomContainer);
        make.right.equalTo(bottomContainer).with.offset(-15.0f);
    }];
    
    [bottomContainer addSubview:self.imageNumberLabel];
    [self.imageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(bottomContainer);
        make.centerY.equalTo(bottomContainer);
    }];
    
    //TODO
//    [self.patientIcon sd_setImageWithURL:[NSURL URLWithString:@"http://img10.360buyimg.com/vclist/jfs/t1597/87/558594419/2920/280f74e3/5595fa39N042df605.jpg"]];
//    self.patientNameLabel.text = @"东方不败";
//    [self.patientSexIcon sd_setImageWithURL:[NSURL URLWithString:@"http://img10.360buyimg.com/vclist/jfs/t1597/87/558594419/2920/280f74e3/5595fa39N042df605.jpg"]];
//    self.patientAgeLabel.text = @"36岁";
//    self.departmentLabel.text = @"全科急诊科";
//    self.contentLabel.text = @"20年来，小川(化名，24岁)一直记得，那年他只有4岁，下午放学回家的路上，一名男子拿糖给他，然后把他从四川凉山带到了千里之外的广东揭阳。而这20年来，四川凉山的孙正华也只做了一件事，那就是找儿子。为此他每年离家外出八九个月，远到内蒙古、黑龙江等地，边打工边找儿子。他们俩再次产生交集是在昨天，经过D N A信息比对，失散了20年的这对父子昨日在深圳团圆。";
//    self.timeLabel.text = @"今天 12:30";
//    self.replyStatusLabel.text = @"您未回复";
//    self.replyNumberLabel.text = @"已有45个回复";
//    self.imageNumberLabel.text = @"有图3张";
}

#pragma mark - 
- (void)loadData:(QuickDiagnose *)quickDiagnose ishiden:(BOOL)ishiden {
    
    [self.patientIcon sd_setImageWithURL:[NSURL URLWithString:quickDiagnose.user.avatar_url] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];

    //名字超过4个字则显示省略号
    if (quickDiagnose.user.realname.length > 4) {
        
        NSRange nameRange = NSMakeRange(0, 4);
        NSString *subName = [quickDiagnose.user.realname substringWithRange:nameRange];
        self.patientNameLabel.text = [NSString stringWithFormat:@"%@...", subName];
    } else {
        
        self.patientNameLabel.text = quickDiagnose.user.realname;
    }
    
    
    if ([quickDiagnose.sex isEqualToString:@"男"]) {
        
        [self.patientSexIcon setImage:[UIImage imageNamed:@"quickdiagnose_female"]];
    } else if ([quickDiagnose.sex isEqualToString:@"女"]) {
        
        [self.patientSexIcon setImage:[UIImage imageNamed:@"quickdiagnose_male"]];
    } else {
        
        //无性别的时候是女
        [self.patientSexIcon setImage:[UIImage imageNamed:@"quickdiagnose_male"]];
    }
    
    self.patientAgeLabel.text = [NSString stringWithFormat:@"%ld岁", quickDiagnose.age];
    self.departmentLabel.text = quickDiagnose.department;
    self.contentLabel.text = quickDiagnose.quickDiagnoseDescription;
    
    
    /*
     * 处理快速问诊的问题时间显示
     *  如果是今天内的提问 时间显示为"今日XX时"
     *  如果是昨天内的提问 时间显示为"昨日XX时"
     *  如果是昨天以前的提问 时间显示为"年-月-日"
     */
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *fromDate = [dateFormatter dateFromString:quickDiagnose.ctime_iso];
    NSDate *toDate = [[NSDate alloc] init];
    
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:quickDiagnose.ctime_iso]];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];;

    fromDate = [dateFormatter dateFromString:quickDiagnose.ctime_iso];
    if (dayComponents.day == 0) {
        
        [dateFormatter setDateFormat:@"今日 HH时"];
        self.timeLabel.text = [dateFormatter stringFromDate:fromDate];
    } else if (dayComponents.day == 1) {
        
        [dateFormatter setDateFormat:@"昨日 HH时"];
        self.timeLabel.text = [dateFormatter stringFromDate:fromDate];
    } else {
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.timeLabel.text = [dateFormatter stringFromDate:fromDate];
    }
    
    if (quickDiagnose.answer) {
        
        self.replyStatusLabel.text = @"您已回复";
        
    } else {
        
        self.replyStatusLabel.text = @"您未回复";
    }
    
    self.replyNumberLabel.text = [NSString stringWithFormat:@"已有%ld个回复", quickDiagnose.comments_count];
    self.imageNumberLabel.text = [NSString stringWithFormat:@"有图%ld张", quickDiagnose.images_count];
}

#pragma mark -
+ (CGFloat)cellHeight {
    
    return 210.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    UIColor *lineBgColor = self.seperatorLine.backgroundColor;
    [super setSelected:selected animated:animated];
    self.seperatorLine.backgroundColor = lineBgColor;
}


#pragma mark - Properties
- (UIImageView *)patientIcon {
    
	if(_patientIcon == nil) {
        
		_patientIcon = [[UIImageView alloc] init];
        ViewRadius(_patientIcon, 25.0f);
	}
	return _patientIcon;
}

- (UILabel *)patientNameLabel {
    
	if(_patientNameLabel == nil) {
        
		_patientNameLabel = [[UILabel alloc] init];
        _patientNameLabel.font = [UIFont systemFontOfSize:15.0f];
        _patientNameLabel.textColor = UIColorFromRGB(0x353d3f);
	}
	return _patientNameLabel;
}

- (UIImageView *)patientSexIcon {
    
	if(_patientSexIcon == nil) {
        
		_patientSexIcon = [[UIImageView alloc] init];
	}
	return _patientSexIcon;
}

- (UILabel *)patientAgeLabel {
    
	if(_patientAgeLabel == nil) {
        
		_patientAgeLabel = [[UILabel alloc] init];
        _patientAgeLabel.font = [UIFont systemFontOfSize:13.0f];
        _patientAgeLabel.textColor = UIColorFromRGB(0x353d3f);
	}
	return _patientAgeLabel;
}

- (UILabel *)departmentLabel {
    
	if(_departmentLabel == nil) {
        
		_departmentLabel = [[UILabel alloc] init];
        _departmentLabel.font = [UIFont systemFontOfSize:13.0f];
        _departmentLabel.textColor = UIColorFromRGB(0xa8a8aa);
	}
	return _departmentLabel;
}

- (UILabel *)contentLabel {
    
	if(_contentLabel == nil) {
        
		_contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.textColor = UIColorFromRGB(0x353d3f);
        _contentLabel.numberOfLines = 3;
	}
	return _contentLabel;
}

- (UILabel *)timeLabel {
    
	if(_timeLabel == nil) {
        
		_timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0xbfbfbf);
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
	}
	return _timeLabel;
}

- (UILabel *)replyStatusLabel {
    
	if(_replyStatusLabel == nil) {
        
		_replyStatusLabel = [[UILabel alloc] init];
        _replyStatusLabel.font = [UIFont systemFontOfSize:12.0f];
        _replyStatusLabel.textColor = UIColorFromRGB(0xbfbfbf);
	}
	return _replyStatusLabel;
}

- (UILabel *)replyNumberLabel {
    
	if(_replyNumberLabel == nil) {
        
		_replyNumberLabel = [[UILabel alloc] init];
        _replyNumberLabel.font = [UIFont systemFontOfSize:12.0f];
        _replyNumberLabel.textColor = UIColorFromRGB(0x89c997);
    }
	return _replyNumberLabel;
}

- (UILabel *)imageNumberLabel {
    
	if(_imageNumberLabel == nil) {
        
		_imageNumberLabel = [[UILabel alloc] init];
        _imageNumberLabel.font = [UIFont systemFontOfSize:12.0f];
        _imageNumberLabel.textColor = UIColorFromRGB(0x89c997);
	}
	return _imageNumberLabel;
}

- (UIView *)seperatorLine {
    
    if (_seperatorLine == nil) {
        
        _seperatorLine = [[UIView alloc] init];
        _seperatorLine.backgroundColor = UIColorFromRGB(0xeaeaea);
    }
    
    return _seperatorLine;
}

@end
