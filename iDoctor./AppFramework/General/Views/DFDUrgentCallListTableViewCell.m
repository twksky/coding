//
//  DFDUrgentCallListTableViewCell.m
//  AppFramework
//
//  Created by DebugLife on 2/10/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDUrgentCallListTableViewCell.h"
#import "UIView+AutoLayout.h"
#import "SkinManager.h"
#import "UIResponder+Router.h"
#import "Patient.h"
#import "FamilyMember.h"
#import "UrgentCallInfo.h"
#import "MedicalRecordCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "ManagerUtil.h"
#import "AccountManager.h"

@interface DFDUrgentCallListTableViewCell ()
<
UICollectionViewDataSource, UICollectionViewDelegate
>
@property (nonatomic, strong) UrgentCallInfo    *urgentCallInfo;
@property (nonatomic, strong) UICollectionView  *imageCollectionView;
@property (nonatomic, strong) NSLayoutConstraint *imageCollectionViewHeightLayoutConstraint;

+ (CGFloat)imageCollectionViewHeightWithUrgentCallInfo:(UrgentCallInfo *)info;

@end

@implementation DFDUrgentCallListTableViewCell

static NSString *CollectionViewReuseIdentifier = @"616D2674-3547-4050-8EC8-DF80D03A1E97";
#define CellTextFont [UIFont systemFontOfSize:14.0f]

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.infoLabel];
        [self.contentView addSubview:self.callButton];
        [self.contentView addSubview:self.detailInfoLabel];
        [self.contentView addSubview:self.imageCollectionView];
        
        // Autolayout
        [self.contentView addConstraints:[self.avatarImageView autoSetDimensionsToSize:CGSizeMake(45.0f, 45.0f)]];
        [self.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
        [self.contentView addConstraint:[self.avatarImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:10.0f]];
        
        [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:10.0f]];
        [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.avatarImageView withOffset:0.0f]];
        [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.callButton withOffset:-10.0f]];
        [self.contentView addConstraint:[self.infoLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.avatarImageView withOffset:0.0f]];
        
        [self.contentView addConstraints:[self.callButton autoSetDimensionsToSize:CGSizeMake(60.0f, 25.0f)]];
        [self.contentView addConstraint:[self.callButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.infoLabel withOffset:0.0f]];
        [self.contentView addConstraint:[self.callButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
        
        [self.contentView addConstraint:[self.detailInfoLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.avatarImageView withOffset:0.0f]];
        [self.contentView addConstraint:[self.detailInfoLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarImageView withOffset:10.0f]];
        [self.contentView addConstraint:[self.detailInfoLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.callButton withOffset:0.0f]];
        [self.contentView addConstraint:[self.detailInfoLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.imageCollectionView withOffset:-10.0f]];
    
        self.imageCollectionViewHeightLayoutConstraint = [self.imageCollectionView autoSetDimension:ALDimensionHeight toSize:0.0f];
        [self.contentView addConstraint:self.imageCollectionViewHeightLayoutConstraint];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:0.0f]];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:0.0f]];
        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5.0f]];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Property

- (UIImageView *)avatarImageView
{
    if (nil == _avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 3.0f;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageViewTapGestureRecognizerFired:)];
        [_avatarImageView addGestureRecognizer:tapGestureRecognizer];
    }
    return _avatarImageView;
}

- (UILabel *)infoLabel
{
    if (nil == _infoLabel) {
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.numberOfLines = 0;
    }
    return _infoLabel;
}

- (UIButton *)callButton
{
    if (nil == _callButton) {
        _callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _callButton.backgroundColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        [_callButton setTitleColor:[SkinManager sharedInstance].defaultWhiteColor forState:UIControlStateNormal];
        _callButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _callButton.layer.cornerRadius = 3.0f;
        _callButton.layer.masksToBounds = YES;
        [_callButton addTarget:self action:@selector(callButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _callButton;
}

- (UILabel *)detailInfoLabel
{
    if (nil == _detailInfoLabel) {
        _detailInfoLabel = [[UILabel alloc] init];
        _detailInfoLabel.numberOfLines = 0;
    }
    return _detailInfoLabel;
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

+ (CGFloat)cellHeightWithUrgentCallInfo:(UrgentCallInfo *)info
{
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 20.0f, MAXFLOAT);
    CGSize textSize = [info.infoDescription sizeWithFont:CellTextFont constrainedToSize:constraintSize];
    return 120 + textSize.height + [DFDUrgentCallListTableViewCell imageCollectionViewHeightWithUrgentCallInfo:info];
}

+ (CGFloat)imageCollectionViewHeightWithUrgentCallInfo:(UrgentCallInfo *)info
{
    if (info.imagesCount == 0) {
        return 0.0f;
    }
    
    if ((info.imagesCount * 64.0f + (info.imagesCount + 1) * 5.0f) > App_Frame_Width) {
        return 64.0f * 2 + 15.0f;
    }
    return 64.0 + 10.0f;
}

- (void)loadUrgentCallInfo:(UrgentCallInfo *)info
{
    self.urgentCallInfo = info;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:info.patient.avatarURLString] placeholderImage:[UIImage imageNamed:@"icon_chat_default_avatar"]];
    
    NSDictionary *nameAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, nil];
    NSMutableString *infoText = [[NSMutableString alloc] initWithString:info.patient.realName];
    [infoText appendFormat:@"\t%ld岁", (long)info.patient.firstFamilyMember.age];
    [infoText appendFormat:@"\t%@\n", [ManagerUtil parseGender:info.patient.firstFamilyMember.gender]];
    NSMutableAttributedString *infoAttributedString = [[NSMutableAttributedString alloc] initWithString:infoText attributes:nameAttributeDic];
    NSDictionary *redTextAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [UIColor redColor], NSForegroundColorAttributeName, nil];
    NSDictionary *grayTextAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *statusAttributedString = nil;
    if (info.isReceive) {
        statusAttributedString = [[NSMutableAttributedString alloc] initWithString:@"已经联系" attributes:grayTextAttributeDic];
    } else {
        statusAttributedString = [[NSMutableAttributedString alloc] initWithString:@"还没联系" attributes:redTextAttributeDic];
    }
    [infoAttributedString appendAttributedString:statusAttributedString];
    [self.infoLabel setAttributedText:infoAttributedString];
    
    [self.callButton setTitle:@"呼叫患者" forState:UIControlStateNormal];
    
    NSDictionary *imageCountAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [SkinManager sharedInstance].defaultNavigationBarBackgroundColor, NSForegroundColorAttributeName, nil];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *delayTimeString = [dateFormatter stringFromDate:info.expireDate];
    NSMutableAttributedString *detailAttributedString = nil;
    if (info.isReceive) {
        detailAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已经接受咨询费%ld元\n", (long)(info.money / 100)] attributes:grayTextAttributeDic];
    } else {
        detailAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"最迟回复时间：%@，若逾期未呼叫回复患者，将会退回咨询费%ld元\n", delayTimeString, (long)(info.money / 100)] attributes:redTextAttributeDic];
    }
    
    NSAttributedString *desAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"病情与描述：%@\n", info.infoDescription] attributes:nameAttributeDic];
    NSAttributedString *imageCountAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有图%ld张", (long)info.imagesCount] attributes:imageCountAttributeDic];
    [detailAttributedString appendAttributedString:desAttributedString];
    [detailAttributedString appendAttributedString:imageCountAttributedString];
    [self.detailInfoLabel setAttributedText:detailAttributedString];
    
    self.imageCollectionViewHeightLayoutConstraint.constant = [DFDUrgentCallListTableViewCell imageCollectionViewHeightWithUrgentCallInfo:info];
    [self.imageCollectionView reloadData];
}


#pragma mark - Selector

- (void)callButtonClicked:(id)sender
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self, kTableViewCell, nil];
    [self routerEventWithName:kCallButtonClickEvent userInfo:userInfoDic];
}

- (void)avatarImageViewTapGestureRecognizerFired:(UIGestureRecognizer *)gestureRecognizer
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self, kTableViewCell, nil];
    [self routerEventWithName:kAvatarClickEvent userInfo:userInfoDic];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.urgentCallInfo.imagesCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewReuseIdentifier forIndexPath:indexPath];
    NSString *imageURLString = [self.urgentCallInfo.imagesURLStrings objectAtIndex:[indexPath row]];
    
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
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.urgentCallInfo, kUrgentCallInfoKey, @(indexPath.row), kImageIndexKey, self, kTableViewCell, nil];
    [self routerEventWithName:kUrgentCallInfoThumbnailImageClickedEvent userInfo:userInfoDic];
}

@end
