//
//  MasterDiagnoseCell.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/26.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "MasterDiagnoseCell.h"
#import "MasterDiagnose.h"

@interface MasterDiagnoseCell ()

@property (nonatomic, strong) UIImageView *patientIcon;
@property (nonatomic, strong) UILabel *patientNameLabel;
@property (nonatomic, strong) UIImageView *patientSexIcon;
@property (nonatomic, strong) UILabel *patientAgeLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *noteLabel;
@property (nonatomic, strong) UILabel *replayStatusLabel;
@property (nonatomic, strong) UILabel *commentStatusLabel;

@end

@implementation MasterDiagnoseCell

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
        make.height.equalTo(67.5f);
    }];
    
    UIImageView *noteBgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"master_dignose_note_bg"]];
    [contentView addSubview:noteBgImageView];
    [noteBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentLabel.bottom).with.offset(15.0f);
        make.left.and.right.equalTo(contentView);
        make.height.equalTo(40.0f);
    }];
    
    [noteBgImageView addSubview:self.noteLabel];
    [self.noteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(noteBgImageView);
        make.left.equalTo(noteBgImageView).with.offset(15.0f);
        make.right.equalTo(noteBgImageView).with.offset(-15.0f);
    }];
    
    UIView *bottomContainerView = [[UIView alloc] init];
    [contentView addSubview:bottomContainerView];
    [bottomContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(noteBgImageView.bottom);
        make.left.and.right.and.bottom.equalTo(contentView);
    }];
    
    [bottomContainerView addSubview:self.replayStatusLabel];
    [self.replayStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bottomContainerView);
        make.left.equalTo(bottomContainerView).with.offset(15.0f);
    }];
    
    [bottomContainerView addSubview:self.commentStatusLabel];
    [self.commentStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(bottomContainerView);
        make.right.equalTo(bottomContainerView).with.offset(-15.0f);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - loadData
- (void)loadDataWithMasterDiagnose:(MasterDiagnose *)masterDiagnose ishiden:(BOOL)ishiden {
    
    [self.patientIcon sd_setImageWithURL:[NSURL URLWithString:masterDiagnose.user.avatar_url] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
    self.patientNameLabel.text = masterDiagnose.user.realname;
    
    if (masterDiagnose.user.realname.length > 4) {
        
        NSRange nameRange = NSMakeRange(0, 4);
        NSString *subName = [masterDiagnose.user.realname substringWithRange:nameRange];
        self.patientNameLabel.text = [NSString stringWithFormat:@"%@...", subName];
    } else {
        
        self.patientNameLabel.text = masterDiagnose.user.realname;
    }
    
    
    if ([masterDiagnose.sex isEqualToString:@"男"]) {
        
        [self.patientSexIcon setImage:[UIImage imageNamed:@"quickdiagnose_female"]];
    } else if ([masterDiagnose.sex isEqualToString:@"女"]) {
        
        [self.patientSexIcon setImage:[UIImage imageNamed:@"quickdiagnose_male"]];
    } else {
        
        //无性别的时候是女
        [self.patientSexIcon setImage:[UIImage imageNamed:@"quickdiagnose_male"]];
    }
    
    self.patientAgeLabel.text = [NSString stringWithFormat:@"%ld岁", masterDiagnose.age];
    self.departmentLabel.text = masterDiagnose.department;
    self.contentLabel.text = masterDiagnose.quickDiagnoseDescription;
    
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
    
    NSDate *fromDate = [dateFormatter dateFromString:masterDiagnose.ctime_iso];
    NSDate *toDate = [[NSDate alloc] init];
    
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:masterDiagnose.ctime_iso]];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];;
    
    fromDate = [dateFormatter dateFromString:masterDiagnose.ctime_iso];
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
    
    self.noteLabel.text = masterDiagnose.ask_for_consultation_remark;
    
//    self.timeLabel.text = masterDiagnose.ctime_iso;
    
    // 张丽改
    self.replayStatusLabel.hidden = ishiden;
    
    if (masterDiagnose.answer) {
        
        self.replayStatusLabel.text = @"您已回复";
    } else {
        
        self.replayStatusLabel.text = @"您未回复";
    }
    
    self.commentStatusLabel.text = [NSString stringWithFormat:@"有图%ld张   已有%ld个回复", masterDiagnose.images_url.count, masterDiagnose.comments_count];
}

#pragma mark - cell height
+ (CGFloat)cellHeight {
    
    return 265.0f;
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

- (UILabel *)timeLabel {
    
    if(_timeLabel == nil) {
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = UIColorFromRGB(0xbfbfbf);
        _timeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    return _timeLabel;
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


- (UILabel *)noteLabel {
    
	if(_noteLabel == nil) {
        
		_noteLabel = [[UILabel alloc] init];
        _noteLabel.font = [UIFont systemFontOfSize:13.0f];
        _noteLabel.textColor = UIColorFromRGB(0x91b8b9);
	}
	return _noteLabel;
}

- (UILabel *)replayStatusLabel {
    
	if(_replayStatusLabel == nil) {
        
		_replayStatusLabel = [[UILabel alloc] init];
        _replayStatusLabel.font = [UIFont  systemFontOfSize:12.0f];
        _replayStatusLabel.textColor = UIColorFromRGB(0xbfbfbf);
	}
	return _replayStatusLabel;
}

- (UILabel *)commentStatusLabel {
    
	if(_commentStatusLabel == nil) {
        
		_commentStatusLabel = [[UILabel alloc] init];
        _commentStatusLabel.font = [UIFont systemFontOfSize:12.0f];
        _commentStatusLabel.textColor = UIColorFromRGB(0x89c997);
	}
	return _commentStatusLabel;
}

@end
