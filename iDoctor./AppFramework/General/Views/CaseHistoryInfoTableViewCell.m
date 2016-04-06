//
//  CaseHistoryInfoTableViewCell.m
//  AppFramework
//
//  Created by ABC on 8/14/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "CaseHistoryInfoTableViewCell.h"
#import "UIView+Autolayout.h"
#import "MedicalRecord.h"
#import "AccountManager.h"
#import "MedicalRecordCollectionViewCell.h"
#import "SkinManager.h"

@interface CaseHistoryInfoTableViewCell ()
<
UICollectionViewDataSource, UICollectionViewDelegate
>

@property (nonatomic, strong) UIView    *lineView;
@property (nonatomic, strong) UIView    *pointView;
@property (nonatomic, strong) UILabel   *doctorLabel;
@property (nonatomic, strong) UILabel   *timeLabel;
@property (nonatomic, strong) UILabel   *patientLabel;
@property (nonatomic, strong) UILabel   *illnessLabel;
@property (nonatomic, strong) UILabel   *pictureCountLabel;
@property (nonatomic, strong) UICollectionView  *imageCollectionView;

@property (nonatomic, strong) MedicalRecord *medicalRecordCopy;

- (void)setupSubviews;
- (void)setupConstraints;

- (void)imageTapGestureRecognizerFired:(UIGestureRecognizer *)gestureRecognizer;

@end

@implementation CaseHistoryInfoTableViewCell

static NSInteger RecordImageTagBase = 10;
static NSString *CollectionViewReuseIdentifier = @"5AFE522A-74C6-43B0-95CC-0631E049A92B";

+ (CGFloat)defaultCellHeight
{
    return 160.0f;
}

+ (CGFloat)defaultCellHeightWithMedicalRecord:(MedicalRecord *)medicalRecord
{
    CGFloat viewHeight = 70.0f;
    NSMutableString *illnessText = [[NSMutableString alloc] initWithString:@"基本病情："];
    if (medicalRecord.recordDescription) {
        [illnessText appendString:medicalRecord.recordDescription];
        [illnessText appendString:@" "];
    }
    
    NSDictionary *attributesDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f], NSFontAttributeName, nil];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:illnessText attributes:attributesDic];
    CGRect textRect = [attributedText boundingRectWithSize:CGSizeMake(App_Frame_Width - 30.0, MAXFLOAT) options:NSStringDrawingUsesFontLeading context:nil];
    
    CGFloat imageViewHeight = 0.0f;
    if ([medicalRecord.imagesURLs count] > 0) {
        imageViewHeight = 95.0f;
    }
    imageViewHeight += ([medicalRecord.imagesURLs count] / 4) * 95.0f;
    return textRect.size.height + viewHeight + imageViewHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupSubviews];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Property

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor grayColor];
    }
    return _lineView;
}

- (UIView *)pointView
{
    if (!_pointView) {
        _pointView = [[UIView alloc] init];
        _pointView.layer.cornerRadius = 5.0f;
        _pointView.layer.masksToBounds = YES;
        _pointView.layer.backgroundColor = [[UIColor orangeColor] CGColor];
    }
    return _pointView;
}

- (UILabel *)doctorLabel
{
    if (!_doctorLabel) {
        _doctorLabel = [[UILabel alloc] init];
        _doctorLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _doctorLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _doctorLabel;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _timeLabel;
}

- (UILabel *)patientLabel
{
    if (!_patientLabel) {
        _patientLabel = [[UILabel alloc] init];
        _patientLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _patientLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _patientLabel;
}

- (UILabel *)illnessLabel
{
    if (!_illnessLabel) {
        _illnessLabel = [[UILabel alloc] init];
        _illnessLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _illnessLabel.font = [UIFont systemFontOfSize:14.0f];
        _illnessLabel.numberOfLines = 0;
        _illnessLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _illnessLabel;
}

- (UILabel *)pictureCountLabel
{
    if (!_pictureCountLabel) {
        _pictureCountLabel = [[UILabel alloc] init];
        _pictureCountLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _pictureCountLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    return _pictureCountLabel;
}

- (UICollectionView  *)imageCollectionView
{
    if (!_imageCollectionView) {
        //层声明实列化
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(64.0f, 64.0f)]; //设置每个cell显示数据的宽和高必须
        //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
        flowLayout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 0, 10.0f);
        
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

#pragma mark - Private Method

- (void)setupSubviews
{
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.pointView];
    [self.contentView addSubview:self.doctorLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.patientLabel];
    [self.contentView addSubview:self.illnessLabel];
    [self.contentView addSubview:self.pictureCountLabel];
    [self.contentView addSubview:self.imageCollectionView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.contentView addConstraint:[self.lineView autoSetDimension:ALDimensionWidth toSize:1.0f]];
    [self.contentView addConstraint:[self.lineView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:0.0f]];
    [self.contentView addConstraint:[self.lineView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f]];
    [self.contentView addConstraint:[self.lineView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0.0f]];
    
    //[self.contentView addConstraint:[self.pointView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.lineView]];
    [self.contentView addConstraints:[self.pointView autoSetDimensionsToSize:CGSizeMake(10.0f, 10.0f)]];
    [self.contentView addConstraint:[self.pointView autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:5.0f]];
    [self.contentView addConstraint:[self.pointView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
    
    [self.contentView addConstraint:[self.doctorLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.doctorLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
    [self.contentView addConstraint:[self.doctorLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:self.timeLabel withOffset:0.0f]];
    
    [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f]];
    [self.contentView addConstraint:[self.timeLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
    
    [self.contentView addConstraint:[self.patientLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.patientLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.doctorLabel withOffset:5.0f]];
    [self.contentView addConstraint:[self.patientLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
    
    [self.contentView addConstraint:[self.illnessLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.illnessLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.patientLabel withOffset:0.0f]];
    [self.contentView addConstraint:[self.illnessLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
    
    [self.contentView addConstraint:[self.pictureCountLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:10.0f]];
    [self.contentView addConstraint:[self.pictureCountLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.illnessLabel withOffset:0.0f]];
    [self.contentView addConstraint:[self.pictureCountLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-10.0f]];
    
    [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.lineView withOffset:0.0f]];
    [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.pictureCountLabel withOffset:0.0f]];
    [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:0.0f]];
    [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:0.0f]];
}


#pragma mark - Public Method

- (void)setMedicalRecord:(MedicalRecord *)medicalRecord
{
    self.medicalRecordCopy = medicalRecord;
    /*
     [_doctorLabel setText:@"医生：小三医生 天坛医院"];
     [_timeLabel setText:@"2014-08-17"];
     [_patientLabel setText:@"xiaojiahuo 男 30岁 海鲜牛奶过敏"];
     [_illnessLabel setText:@"基本病情：肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼肚子疼"];
     [_pictureCountLabel setText:@"图片：0张"];
     */
    NSMutableString *doctorText = [[NSMutableString alloc] initWithString:@"医生："];
    if (medicalRecord.doctorName) {
        [doctorText appendString:medicalRecord.doctorName];
        [doctorText appendString:@" "];
    }
    if (medicalRecord.hospitial) {
        [doctorText appendString:medicalRecord.hospitial];
    }
    [self.doctorLabel setText:doctorText];
    
    if (medicalRecord.dateISO) {
        [self.timeLabel setText:[NSString stringWithFormat:@"就诊时间：%@", medicalRecord.dateISO]];
    }
    
    NSMutableString *patientText = [[NSMutableString alloc] init];
    if (medicalRecord.name) {
        [patientText appendString:medicalRecord.name];
        [patientText appendString:@" "];
    }
    if (medicalRecord.gender) {
        if ([medicalRecord.gender isEqualToString:@"male"]) {
            [patientText appendString:@"男"];
        } else if ([medicalRecord.gender isEqualToString:@"female"]) {
            [patientText appendString:@"女"];
        }
        [patientText appendString:@" "];
    }
    [patientText appendString:[NSString stringWithFormat:@"%ld岁 ", medicalRecord.age]];
    if (medicalRecord.allergies && ![medicalRecord.allergies isEqual:[NSNull null]]) {
        [patientText appendString:medicalRecord.allergies];
    }
    [self.patientLabel setText:patientText];
    
    NSMutableString *illnessText = [[NSMutableString alloc] initWithString:@"基本病情："];
    if (medicalRecord.recordDescription) {
        [illnessText appendString:medicalRecord.recordDescription];
        [illnessText appendString:@" "];
    }
    [self.illnessLabel setText:illnessText];
    
    [self.pictureCountLabel setText:[NSString stringWithFormat:@"图片：%ld张", medicalRecord.imagesCount]];
}


#pragma mark - Selector

- (void)imageTapGestureRecognizerFired:(UIGestureRecognizer *)gestureRecognizer
{
    UIImageView *imageView = (UIImageView *)gestureRecognizer.view;
    NSInteger index = gestureRecognizer.view.tag - RecordImageTagBase;
    if ([self.delegate respondsToSelector:@selector(caseHistoryInfoTableViewCell:didSelectMedicalRecordImageIndex:withImageView:withMedicalRecord:)]) {
        [self.delegate caseHistoryInfoTableViewCell:self didSelectMedicalRecordImageIndex:index withImageView:imageView withMedicalRecord:self.medicalRecordCopy];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.medicalRecordCopy.imagesURLs count];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewReuseIdentifier forIndexPath:indexPath];
    NSString *imageURLString = [self.medicalRecordCopy.imagesURLs objectAtIndex:[indexPath row]];
    
    // 下载缩略图
    [[AccountManager sharedInstance] asyncDownThumbnailImageWithURLString:imageURLString withCompletionHandler:^(UIImage *image) {
        [cell.imageView setImage:image];
    } withErrorHandler:^(NSError *error) {
    }];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordCollectionViewCell *cell = (MedicalRecordCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    // 通知ViewController打开看大图
    if ([self.delegate respondsToSelector:@selector(caseHistoryInfoTableViewCell:didSelectMedicalRecordImageIndex:withImageView:withMedicalRecord:)]) {
        [self.delegate caseHistoryInfoTableViewCell:self didSelectMedicalRecordImageIndex:[indexPath row] withImageView:cell.imageView withMedicalRecord:self.medicalRecordCopy];
    }
}

@end
