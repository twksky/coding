//
//  DFDFollowUpItemTableViewCell.m
//  AppFramework
//
//  Created by DebugLife on 2/11/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDFollowUpItemTableViewCell.h"
#import "FollowUpItem.h"
#import "UIView+AutoLayout.h"
#import "MedicalRecordCollectionViewCell.h"
#import "AccountManager.h"
#import "ManagerUtil.h"
#import "SkinManager.h"
#import "UIImageView+WebCache.h"
#import "UIResponder+Router.h"

@interface DFDFollowUpItemTableViewCell ()
<
UICollectionViewDataSource, UICollectionViewDelegate
>

@property (nonatomic, weak) FollowUpItem            *followUpItem;
@property (nonatomic, strong) UILabel               *titleLabel;
@property (nonatomic, strong) UIButton              *replyButton;
@property (nonatomic, strong) UILabel               *infoLabel;
@property (nonatomic, strong) UICollectionView      *imageCollectionView;
@property (nonatomic, strong) NSLayoutConstraint    *imageCollectionViewHeightLayoutConstraint;

+ (CGFloat)imageCollectionViewHeightFollowUpItem:(FollowUpItem *)item;

- (void)replyButtonClicked:(id)sender;

@end

@implementation DFDFollowUpItemTableViewCell

static NSString *CollectionViewReuseIdentifier = @"80EF186E-7706-4306-8BFC-E0F57FAFDED1";
#define CellTextFont [UIFont systemFontOfSize:14.0f]

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.replyButton];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.imageCollectionView];
        
        [self.contentView addConstraint:[self.titleLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[self.titleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:0.0f]];
        [self.contentView addConstraint:[self.titleLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.replyButton withOffset:-10.0f]];
        [self.contentView addConstraint:[self.titleLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.replyButton withOffset:10.0f]];
        
        [self.contentView addConstraints:[self.replyButton autoSetDimensionsToSize:CGSizeMake(80.0f, 25.0f)]];
        [self.contentView addConstraint:[self.replyButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        [self.contentView addConstraint:[self.replyButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0f]];
        
        [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.titleLabel withOffset:5.0f]];
        [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.imageCollectionView withOffset:-5.0f]];
        
        self.imageCollectionViewHeightLayoutConstraint = [self.imageCollectionView autoSetDimension:ALDimensionHeight toSize:0.0f];
        [self.contentView addConstraint:self.imageCollectionViewHeightLayoutConstraint];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:0.0f]];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:0.0f]];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5.0f]];
    }
    return self;
}


#pragma mark - Property

- (UILabel *)titleLabel
{
    if (nil == _titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UIButton *)replyButton
{
    if (nil == _replyButton) {
        _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _replyButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        _replyButton.layer.cornerRadius = 3.0f;
        _replyButton.layer.masksToBounds = YES;
        _replyButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [_replyButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        [_replyButton setTitle:@"回复患者" forState:UIControlStateNormal];
        [_replyButton addTarget:self action:@selector(replyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyButton;
}

- (UILabel *)infoLabel
{
    if (nil == _infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

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

+ (CGFloat)cellHeightWithFollowUpItem:(FollowUpItem *)item
{
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 20.0f, MAXFLOAT);
    CGSize textSize = [item.symptomsDescription sizeWithFont:CellTextFont constrainedToSize:constraintSize];
    return 150.0f + textSize.height + [DFDFollowUpItemTableViewCell imageCollectionViewHeightFollowUpItem:item];
}

+ (CGFloat)imageCollectionViewHeightFollowUpItem:(FollowUpItem *)item
{
    NSInteger imagesCount = item.imagesURLStrings.count;
    if (imagesCount == 0) {
        return 0.0f;
    }
    
    if ((imagesCount * 64.0f + (imagesCount + 1) * 5.0f) > App_Frame_Width) {
        return 64.0f * 2 + 15.0f;
    }
    return 64.0 + 10.0f;
}

- (void)loadFollowUpItem:(FollowUpItem *)item
{
    self.followUpItem = item;
    
    NSDictionary *grayTextAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:CellTextFont, NSFontAttributeName,
                                           [SkinManager sharedInstance].defaultGrayColor, NSForegroundColorAttributeName, nil];
    NSDictionary *redTextAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:CellTextFont, NSFontAttributeName,
                                           [UIColor redColor], NSForegroundColorAttributeName, nil];
    NSDictionary *greenTextAttributesDic = [NSDictionary dictionaryWithObjectsAndKeys:CellTextFont, NSFontAttributeName,
                                           [SkinManager sharedInstance].defaultNavigationBarBackgroundColor, NSForegroundColorAttributeName, nil];
    
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *timeText = [NSString stringWithFormat:@"报告：%@", [dateFormatter stringFromDate:item.createTime]];
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:timeText attributes:grayTextAttributesDic];
    NSString *statusText = item.isReceived ? @"\n已经联系" : @"\n还没联系";
    
    [titleAttributedString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:statusText attributes:(item.isReceived ? grayTextAttributesDic : redTextAttributesDic)]];
    [self.titleLabel setAttributedText:titleAttributedString];
    
    NSString *medicationCompliance = item.isMedicationCompliance ? @"服药情况正常" : @"有漏服或服药时间不正常";
    NSMutableAttributedString *conditionAttributedString = [[NSMutableAttributedString alloc] initWithString:medicationCompliance attributes:grayTextAttributesDic];
    NSMutableAttributedString *symptomsAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n症状变化：%@", item.symptomsStatus] attributes:grayTextAttributesDic];
    [conditionAttributedString appendAttributedString:symptomsAttributedString];
    if (item.isSetBodyTemperature) {
        NSMutableAttributedString *bodyTemperatureAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"体温：%.02f", item.bodyTemperature] attributes:grayTextAttributesDic];
        [conditionAttributedString appendAttributedString:bodyTemperatureAttributedString];
    }
    if (item.isSetBloodGlucose) {
        NSMutableAttributedString *bloodGlucoseAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\t血糖：%.02f", item.bloodGlucose] attributes:grayTextAttributesDic];
        [conditionAttributedString appendAttributedString:bloodGlucoseAttributedString];
    }
    if (item.isSetLowBloodPressure) {
        NSMutableAttributedString *lowBloodPressureAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\t血压低值：%ld", (long)item.lowBloodPressure] attributes:grayTextAttributesDic];
        [conditionAttributedString appendAttributedString:lowBloodPressureAttributedString];
    }
    if (item.isSetHighBloodPressure) {
        NSMutableAttributedString *highBloodPressureAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\t血压高值：%ld", (long)item.highBloodPressure] attributes:grayTextAttributesDic];
        [conditionAttributedString appendAttributedString:highBloodPressureAttributedString];
    }
    NSMutableAttributedString *descriptionAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n描述：%@", item.symptomsDescription] attributes:grayTextAttributesDic];
    [conditionAttributedString appendAttributedString:descriptionAttributedString];
    
    NSMutableAttributedString *imagesCountAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n病历/处方图片%ld张", (long)item.imagesURLStrings.count] attributes:greenTextAttributesDic];
    [conditionAttributedString appendAttributedString:imagesCountAttributedString];
    [self.infoLabel setAttributedText:conditionAttributedString];
    self.imageCollectionViewHeightLayoutConstraint.constant = [DFDFollowUpItemTableViewCell imageCollectionViewHeightFollowUpItem:item];
    [self.imageCollectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.followUpItem.imagesURLStrings.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewReuseIdentifier forIndexPath:indexPath];
    NSString *imageURLString = [self.followUpItem.imagesURLStrings objectAtIndex:[indexPath row]];
    
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
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.followUpItem, kFollowUpItemKey, @(indexPath.row), kImageIndexKey, self, kFollowUpItemTableViewCellKey, nil];
    [self routerEventWithName:kFollowUpItemThumbnailImageClickedEvent userInfo:userInfoDic];
}


#pragma mark - Selector

- (void)replyButtonClicked:(id)sender
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.followUpItem, kFollowUpItemKey, self, kFollowUpItemTableViewCellKey, nil];
    [self routerEventWithName:kReplyButtonClickedEvent userInfo:userInfoDic];
}

@end
