//
//  NativeQuestionDetailQuestionCellTableViewCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/1.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "NativeQuestionDetailQuestionCell.h"
#import <PureLayout.h>
#import "UIImageView+WebCache.h"
#import "QuickQuestion.h"
#import "Patient.h"
#import "SkinManager.h"
#import "FamilyMember.h"
#import "UIResponder+Router.h"
#import "MedicalRecordCollectionViewCell.h"

#define NativeQuestionDetailCollectionViewReuseIdentifier @"7ad8f694-cbc3-4fb7-93c1-ae42dd50d85c"

@interface NativeQuestionDetailQuestionCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic ,strong) UIView *cellView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sexAndAgeLabel;
@property (nonatomic ,strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *docOfficeLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, strong) UICollectionView *imagesCollectionView;
@property (nonatomic, strong) NSLayoutConstraint *collectionViewHeightConstraint;

+ (CGFloat)imageViewsHeightWithNativeQuestion:(QuickQuestion *)question;

@property (nonatomic, strong) QuickQuestion *nativeQuestion;

@end

@implementation NativeQuestionDetailQuestionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {
    
    self.contentView.backgroundColor = UIColorFromRGB(0xedf2f1);
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIView *cellView = self.cellView;
    
    [self.contentView addSubview:cellView];
    [cellView addSubview:self.avatarImageView];
    [cellView addSubview:self.nameLabel];
    [cellView addSubview:self.sexAndAgeLabel];
    [cellView addSubview:self.dateLabel];
    [cellView addSubview:self.docOfficeLabel];
    [cellView addSubview:self.contentLabel];
    [cellView addSubview:self.imagesCollectionView];
    
    {
        [self.contentView addConstraints:[cellView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0, 10.0f)]];
        
        [cellView addConstraint:[self.avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [cellView addConstraint:[self.avatarImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
        [cellView addConstraint:[self.avatarImageView autoSetDimension:ALDimensionHeight toSize:50.0f]];
        [cellView addConstraint:[self.avatarImageView autoSetDimension:ALDimensionWidth toSize:50.0f]];
        
        [cellView addConstraint:[self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:11.0f]];
        [cellView addConstraint:[self.nameLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:10.0f]];
        [cellView addConstraint:[self.nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:160.0f]];
        
        
        [cellView addConstraint:[self.sexAndAgeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameLabel]];
        [cellView addConstraint:[self.sexAndAgeLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.nameLabel]];
        
        [cellView addConstraint:[self.dateLabel autoPinEdgeToSuperviewEdge:ALEdgeRight]];
        [cellView addConstraint:[self.dateLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.sexAndAgeLabel]];
        
        [cellView addConstraint:[self.docOfficeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.nameLabel withOffset:10.0f]];
        [cellView addConstraint:[self.docOfficeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.avatarImageView withOffset:10.0f]];
        
        [cellView addConstraint:[self.contentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.avatarImageView withOffset:10.0f]];
        [cellView addConstraint:[self.contentLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [cellView addConstraint:[self.contentLabel autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 40.0f]];
        [cellView addConstraint:[self.contentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        
        [cellView addConstraint:[self.imagesCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentLabel withOffset:10.0f]];
        [cellView addConstraint:[self.imagesCollectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [cellView addConstraint:[self.imagesCollectionView autoPinEdgeToSuperviewEdge:ALEdgeRight]];
        self.collectionViewHeightConstraint = [self.imagesCollectionView autoSetDimension:ALDimensionHeight toSize:0.0f];
        [cellView addConstraint:self.collectionViewHeightConstraint];
    }
}

- (void) setupImageViewsWithQuestion:(QuickQuestion *)question {
    
    if (!self.imageUrls || self.imageUrls.count == 0)
        return;
    
    self.collectionViewHeightConstraint.constant = [[self class] imageViewsHeightWithNativeQuestion:question];
    
    
//    UIImageView *lastImageView;
//    
//    for (int i = 0; i < self.imageUrls.count; i++) {
//        
//        NSString *url = [self.imageUrls objectAtIndex:i];
//        
//        UIImageView *imageView = [[UIImageView alloc] init];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
//        
//        [self.cellView addSubview:imageView];
//        {
//            [self.cellView addConstraint:[imageView autoAlignAxisToSuperviewAxis:ALAxisVertical]];
//            [self.cellView addConstraints:[imageView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 120.0f, (App_Frame_Width - 120.0f) * 0.6)]];
//            if (i == 0) {
//                
//                [self.cellView addConstraint:[imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.contentLabel withOffset:10.0f]];
//            }
//            else {
//                
//                [self.cellView addConstraint:[imageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:lastImageView withOffset:10.0f]];
//            }
//        }
//        
//        lastImageView = imageView;
//    }
    
}

- (void)loadQuickQuestion:(QuickQuestion *)question {
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:question.patient.avatarURLString] placeholderImage:[SkinManager sharedInstance].defaultUserInfoIcon];
    
    self.nameLabel.text = [question.patient getDisplayName];
    
    NSString *sex;
    if (question.sex) {
        
        sex = question.sex;
    }
    else {
        
        sex = @"未知";
    }
    
    self.sexAndAgeLabel.text = [NSString stringWithFormat:@"   %@  %ld岁", sex, question.age];
    
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:@"MM-dd  HH:mm:ss  "];
    
    self.dateLabel.text = [dateFormatter stringFromDate:question.createTime];
    self.docOfficeLabel.text = question.department;
    self.contentLabel.text = question.conditionDescription;
    
    self.imageUrls = question.imagesURLStrings;
    
    [self setupImageViewsWithQuestion:question];
}

#pragma mark - UICollectionDelegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    kImageIndexKey
//    kQuickQuestionThumbnailImageClickedEvent
    
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self, kNativeQuestionDetailQuestionCell,
        @(indexPath.row),
        kDetailImageCollectionViewIndexKey,
        nil];
    
    [self routerEventWithName:kQuickQuestionDetailImageClickedEvent userInfo:userInfoDic];
}

#pragma mark - UICollectionDataSource Methods

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MedicalRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NativeQuestionDetailCollectionViewReuseIdentifier forIndexPath:indexPath];
    NSString *imageURLString = [self.imageUrls objectAtIndex:[indexPath row]];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[SkinManager sharedInstance].defaultUserInfoIcon];
    
    return cell;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.imageUrls count];
}

#pragma mark - selector

- (void)avatarImageClicked {
    
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self, kNativeQuestionDetailQuestionCell, nil];
    
    [self routerEventWithName:kNativeQuestionDetailAvatarClickEvent userInfo:userInfoDic];
}


#pragma mark - properties

- (UIView *)cellView {
    
    if (!_cellView) {
        
        _cellView = [[UIView alloc] init];
        _cellView.backgroundColor = [UIColor whiteColor];
        _cellView.layer.cornerRadius = 6.0f;
    }
    
    return _cellView;
}

- (UIImageView *)avatarImageView {
    
    if (!_avatarImageView) {
        
        _avatarImageView = [[UIImageView alloc] init];
        _avatarImageView.layer.cornerRadius = 6.0f;
        _avatarImageView.layer.masksToBounds = YES;
        _avatarImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarImageClicked)];
        [_avatarImageView addGestureRecognizer:tap];
    }
    
    return _avatarImageView;
}

- (UILabel *)nameLabel {
    
    if (!_nameLabel) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = UIColorFromRGB(0x33d2b4);
        _nameLabel.font = [UIFont systemFontOfSize:17.0f];
    }
    
    return _nameLabel;
}

- (UILabel *)sexAndAgeLabel {
    
    if (!_sexAndAgeLabel) {
        
        _sexAndAgeLabel = [[UILabel alloc] init];
        _sexAndAgeLabel.textColor = UIColorFromRGB(0x33d2b4);
        _sexAndAgeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _sexAndAgeLabel;
}

- (UILabel *)dateLabel {
    
    if (!_dateLabel) {
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = UIColorFromRGB(0x8e8e94);
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _dateLabel;
}

- (UILabel *)docOfficeLabel {
    
    if (!_docOfficeLabel) {
        
        _docOfficeLabel = [[UILabel alloc] init];
        _docOfficeLabel.textColor = UIColorFromRGB(0x797979);
        _docOfficeLabel.font = [UIFont systemFontOfSize:12.0f];
    }
    
    return _docOfficeLabel;
}

- (UILabel *)contentLabel {
    
    if (!_contentLabel) {
        
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0x8f8f92);
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.numberOfLines = 0;
    }
    
    return _contentLabel;
}

- (UICollectionView *)imagesCollectionView {
    
    if (!_imagesCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat cellHeight = (App_Frame_Width - 100.0f) / 4;
        [flowLayout setItemSize:CGSizeMake(cellHeight, cellHeight)]; //设置每个cell显示数据的宽和高必须
        //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
        flowLayout.sectionInset = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        flowLayout.minimumInteritemSpacing = 5.0f;
        
        _imagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //对Cell注册(必须否则程序会挂掉)
        [_imagesCollectionView registerClass:[MedicalRecordCollectionViewCell class] forCellWithReuseIdentifier:NativeQuestionDetailCollectionViewReuseIdentifier];
        //[_imageCollectionView setBackgroundColor:[RFQSkinManager sharedInstance].defaultBackgroundColor];
        [_imagesCollectionView setUserInteractionEnabled:YES];
        
        [_imagesCollectionView setDelegate:self]; //代理－视图
        [_imagesCollectionView setDataSource:self]; //代理－数据
        
        _imagesCollectionView.backgroundColor = self.backgroundColor;
    }
    
    return _imagesCollectionView;
}

#pragma mark - height For cell method

+ (CGFloat)cellHeightWithQuickQuestion:(QuickQuestion *)question
{
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 20.0f, MAXFLOAT);
    CGSize textSize = [question.conditionDescription sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraintSize];
    return 90.0f + textSize.height + [NativeQuestionDetailQuestionCell imageViewsHeightWithNativeQuestion:question];
}

+ (CGFloat)imageViewsHeightWithNativeQuestion:(QuickQuestion *)question
{
    if (question.imagesCount == 0) {
        return 0.0f;
    }
    
    CGFloat cellHeight = (App_Frame_Width - 100.0f) / 4;
    NSInteger imagesRowsCount = question.imagesCount / 4;
    if ((question.imagesCount % 4) != 0) {
        
        imagesRowsCount++;
    }
    
//    return question.imagesCount * ((App_Frame_Width - 120.0f) * 0.6) + (question.imagesCount + 1) * 10.0f;
    
    return imagesRowsCount * (cellHeight + 10.0);
}

@end
