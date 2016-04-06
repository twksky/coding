//
//  DFDFollowUpReportTableViewCell.m
//  AppFramework
//
//  Created by DebugLife on 2/11/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDFollowUpReportTableViewCell.h"
#import "FollowUpReport.h"
#import "UIView+AutoLayout.h"
#import "MedicalRecordCollectionViewCell.h"
#import "AccountManager.h"
#import "ManagerUtil.h"
#import "SkinManager.h"
#import "UIImageView+WebCache.h"
#import "UIResponder+Router.h"
#import "TTTAttributedLabel.h"

@interface DFDFollowUpReportTableViewCell ()
<
UICollectionViewDataSource, UICollectionViewDelegate
>

@property (nonatomic, weak) FollowUpReport      *followUpReport;
@property (nonatomic, strong) UICollectionView  *imageCollectionView;
@property (nonatomic, strong) NSLayoutConstraint *imageCollectionViewHeightLayoutConstraint;

+ (CGFloat)imageCollectionViewHeightWithFollowUpReport:(FollowUpReport *)followUpReport;

@end

@implementation DFDFollowUpReportTableViewCell

static NSString *CollectionViewReuseIdentifier = @"25A38372-DB19-43EF-ADE1-AA0C2289BE09";

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imageCollectionView];
        
        [self.subtitleLabel removeFromSuperview];
        [self.contentView addSubview:self.subtitleLabel];
        
        [self.contentView addConstraint:[self.subtitleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[self.subtitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarImageView withOffset:5.0f]];
        [self.contentView addConstraint:[self.subtitleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        [self.contentView addConstraint:[self.subtitleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.imageCollectionView withOffset:-5.0f]];
        
        self.imageCollectionViewHeightLayoutConstraint = [self.imageCollectionView autoSetDimension:ALDimensionHeight toSize:0.0f];
        [self.contentView addConstraint:self.imageCollectionViewHeightLayoutConstraint];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:0.0f]];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:0.0f]];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5.0f]];
    }
    return self;
}


#pragma mark - Property

- (UICollectionView  *)imageCollectionView
{
    if (!_imageCollectionView) {
        //层声明实列化
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(64.0f, 64.0f)]; //设置每个cell显示数据的宽和高必须
        //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
        flowLayout.sectionInset = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        flowLayout.minimumInteritemSpacing = 5.0f;
        
        _imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //对Cell注册(必须否则程序会挂掉)
        [_imageCollectionView registerClass:[MedicalRecordCollectionViewCell class] forCellWithReuseIdentifier:CollectionViewReuseIdentifier];
        //[_imageCollectionView setBackgroundColor:[RFQSkinManager sharedInstance].defaultBackgroundColor];
        [_imageCollectionView setUserInteractionEnabled:YES];
        
        [_imageCollectionView setDelegate:self]; //代理－视图
        [_imageCollectionView setDataSource:self]; //代理－数据
        
        _imageCollectionView.backgroundColor = self.backgroundColor;
    }
    return _imageCollectionView;
}


#pragma mark - Public Method

+ (CGFloat)cellHeightWithFollowUpReport:(FollowUpReport *)report
{
    return 150.0f + [DFDFollowUpReportTableViewCell imageCollectionViewHeightWithFollowUpReport:report];
}

+ (CGFloat)imageCollectionViewHeightWithFollowUpReport:(FollowUpReport *)followUpReport
{
    if (followUpReport.imagesCount == 0) {
        return 0.0f;
    }
    
    if ((followUpReport.imagesCount * 64.0f + (followUpReport.imagesCount + 1) * 5.0f) > App_Frame_Width) {
        return 64.0f * 2 + 15.0f;
    }
    return 64.0 + 10.0f;
}

- (void)loadFollowUpReport:(FollowUpReport *)report
{
    self.followUpReport = report;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:report.patient.avatarURLString] placeholderImage:[SkinManager sharedInstance].defaultContactAvatarIcon];
    
    NSDictionary *nameAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, nil];
    NSMutableString *infoText = [[NSMutableString alloc] initWithString:report.patient.realName];
    [infoText appendFormat:@"\t%@\n", [ManagerUtil parseGender:report.patient.firstFamilyMember.gender]];
    NSMutableAttributedString *infoAttributedString = [[NSMutableAttributedString alloc] initWithString:infoText attributes:nameAttributeDic];
    NSDictionary *statusAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [SkinManager sharedInstance].defaultGrayColor, NSForegroundColorAttributeName, nil];
    NSDictionary *redTextAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *statusAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"现有%ld份报告", (long)report.reportItems.count] attributes:statusAttributeDic];
    [infoAttributedString appendAttributedString:statusAttributedString];
    [self.titleLabel setAttributedText:infoAttributedString];
    
    if (report.reportItems.count > 0) {
        self.timeLabel.textInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 10.0f);
        self.timeLabel.font = [UIFont systemFontOfSize:10.0f];
        self.timeLabel.textColor = [SkinManager sharedInstance].defaultGrayColor;
       
        NSDate *createDate = ((FollowUpItem *)[report.reportItems firstObject]).createTime;
        for (NSInteger index = 1; index < report.reportItems.count; index++) {
            NSDate *tmpDate = ((FollowUpItem *)[report.reportItems objectAtIndex:index]).createTime;
            // 将当前对象与参数传递的对象进行比较，如果相同，返回0(NSOrderedSame)；
            // 对象时间早于参数时间，返回-1(NSOrderedAscending)；
            // 对象时间晚于参数时间，返回1(NSOrderedDescending)
            if ([tmpDate compare:createDate] == NSOrderedDescending) {
                createDate = tmpDate;
            }
        }
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
        //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        [self.timeLabel setText:[dateFormatter stringFromDate:createDate]];
    } else {
        [self.timeLabel setText:@""];
    }
    
    NSDictionary *imageCountAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [SkinManager sharedInstance].defaultNavigationBarBackgroundColor, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *subtitleAttributedString = nil;
    NSString *statusText = nil;
    if (report.reportItems.count > 0) {
        statusText = report.isReceive ? @"所有报告已阅" : @"有未阅读的报告";
        subtitleAttributedString = [[NSMutableAttributedString alloc] initWithString:statusText attributes:(report.isReceive ? statusAttributeDic : redTextAttributeDic)];
    } else {
        statusText = @"还没有报告";
        subtitleAttributedString = [[NSMutableAttributedString alloc] initWithString:statusText attributes:statusAttributeDic];
    }
    NSString *countText = [NSString stringWithFormat:@"\n报告：每隔%ld天一次，共%ld次（价值%ld元）", (long)report.reportFrequencyInDay, (long)report.reportCount, (long)report.totalPrice / 100];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:countText attributes:statusAttributeDic]];
    NSString *medicalRecordIDText = [NSString stringWithFormat:@"\n病历号：%@", report.medicalRecordNumber];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:medicalRecordIDText attributes:nameAttributeDic]];
    NSString *imageCountText = [NSString stringWithFormat:@"\n病历/处方图片%ld张", (long)report.imagesCount];
    [subtitleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:imageCountText attributes:imageCountAttributeDic]];
    [self.subtitleLabel setAttributedText:subtitleAttributedString];
    
    self.imageCollectionViewHeightLayoutConstraint.constant = [DFDFollowUpReportTableViewCell imageCollectionViewHeightWithFollowUpReport:report];
    [self.imageCollectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.followUpReport.imagesCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewReuseIdentifier forIndexPath:indexPath];
    NSString *imageURLString = [self.followUpReport.imagesURLStrings objectAtIndex:[indexPath row]];
    
    // 下载缩略图
    [[AccountManager sharedInstance] asyncDownThumbnailImageWithURLString:imageURLString withCompletionHandler:^(UIImage *image) {
        [cell.imageView setImage:image];
    } withErrorHandler:^(NSError *error) {
    }];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.followUpReport, kFollowUpReportKey, @(indexPath.row), kImageIndexKey, self, kFollowUpReportTableViewCellKey, nil];
    [self routerEventWithName:kFollowUpReportThumbnailImageClickedEvent userInfo:userInfoDic];
}


#pragma mark - Selector

- (void)avatarImageViewTapGestureRecognizerFired:(UIGestureRecognizer *)gestureRecognizer
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.followUpReport, kFollowUpReportKey, self, kFollowUpReportTableViewCellKey, nil];
    [self routerEventWithName:kAvatarClickEvent userInfo:userInfoDic];
}

@end
