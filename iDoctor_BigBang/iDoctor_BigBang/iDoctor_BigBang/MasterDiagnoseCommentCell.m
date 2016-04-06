//
//  MasterDiagnoseCommentCell.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/28.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "MasterDiagnoseCommentCell.h"
#import "QuickDiagnoseComment.h"

@interface MasterDiagnoseCommentCell ()

@property (nonatomic, strong) UIImageView *starIcon;
@property (nonatomic, strong) UIImageView *tagIcon;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *colorBottomLinem;

@end

@implementation MasterDiagnoseCommentCell

- (void)setupView {
    [super setupView];
    
    [self addSubview:self.starIcon];
    [self.starIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.right.equalTo(self).with.offset(-15.0f);
    }];
    
    [self addSubview:self.tagIcon];
    [self.tagIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).with.offset(-15.0f);
        make.right.equalTo(self).with.offset(-30.0f);
    }];
    
    [self addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.doctorTitleLabel);
        make.right.equalTo(self.starIcon.left).with.offset(-10.0f);
    }];
    
    [self addSubview:self.colorBottomLinem];
    [self.colorBottomLinem mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(self);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - loadData
- (void)loadDataComment:(QuickDiagnoseComment *)comment {
    [super loadDataComment:comment];
    
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
    
    NSDate *fromDate = [dateFormatter dateFromString:comment.ctime_iso];
    NSDate *toDate = [[NSDate alloc] init];
    
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&fromDate interval:NULL forDate:[dateFormatter dateFromString:comment.ctime_iso]];
    [gregorian rangeOfUnit:NSDayCalendarUnit startDate:&toDate interval:NULL forDate:[NSDate date]];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];;
    
    fromDate = [dateFormatter dateFromString:comment.ctime_iso];
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
}

#pragma mark - cell Height
+ (CGFloat)cellHeightWithQuickDiagnoseComment:(QuickDiagnoseComment *)quickDiagnoseComment {
    
    return [[super class] cellHeight:quickDiagnoseComment] + 60.0f;
}


#pragma mark - Properties
- (UIImageView *)starIcon {
    
	if(_starIcon == nil) {
        
		_starIcon = [[UIImageView alloc] init];
        [_starIcon setImage:[UIImage imageNamed:@"master_diagnose_star_icon"]];
	}
	return _starIcon;
}

- (UIImageView *)tagIcon {
    
	if(_tagIcon == nil) {
        
		_tagIcon = [[UIImageView alloc] init];
        [_tagIcon setImage:[UIImage imageNamed:@"master_diagnose_tag"]];
	}
	return _tagIcon;
}

- (UILabel *)timeLabel {
    
	if(_timeLabel == nil) {
        
		_timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:11.0f];
        _timeLabel.textColor = UIColorFromRGB(0xa8a8aa);
	}
	return _timeLabel;
}

- (UIImageView *)colorBottomLinem {
    
	if(_colorBottomLinem == nil) {
        
		_colorBottomLinem = [[UIImageView alloc] init];
        [_colorBottomLinem setImage:[UIImage imageNamed:@"master_diagnose_color_line"]];
	}
	return _colorBottomLinem;
}

@end
