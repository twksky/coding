//
//  DFDUrgentCallCell.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/20.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DFDUrgentCallCell.h"
#import "UIView+AutoLayout.h"
#import "UIImageView+WebCache.h"
#import "UrgentCallInfo.h"
#import "Patient.h"
#import "SkinManager.h"
#import "FamilyMember.h"
#import "MedicalRecordCollectionViewCell.h"
#import "AccountManager.h"
#import "UIResponder+Router.h"

@interface DFDUrgentCallCell ()
<
UICollectionViewDataSource,
UICollectionViewDelegate
>

@property (nonatomic, strong) UIImageView *iconCallImageView;
@property (nonatomic, strong) UIImageView *iconUserImageView;
@property (nonatomic, strong) UILabel *nameUserLabel;
@property (nonatomic, strong) UILabel *sexUserLabel;
@property (nonatomic, strong) UILabel *ageUserLabel;

@property (nonatomic, strong) UILabel *callStateTitleLabel;
@property (nonatomic, strong) UILabel *callStateContetnLabel;

@property (nonatomic, strong) UIView *anotherLine;

@property (nonatomic, strong) UILabel *decriptionTitleLabel;
@property (nonatomic, strong) UILabel *decriptionLabel;
@property (nonatomic, strong) UIButton *extentBtn;

@property (nonatomic, strong) UICollectionView  *imageCollectionView;
@property (nonatomic, strong) NSLayoutConstraint *imageCollectionViewHeightLayoutConstraint;
@property (nonatomic, strong) NSArray *imgUrls;

@property (nonatomic, strong) UrgentCallInfo *callInfo;

@end

@implementation DFDUrgentCallCell

static NSString *CollectionViewReuseIdentifier = @"4cc5a2ed-5793-419d-9147-4bfbe6410c3f";

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    
    return self;
}

- (void)setupViews {

    UIView *redPoint = [[UIView alloc] init];
    UIView *line = [[UIView alloc] init];
    UIView *container = [[UIView alloc] init];
    UIView *titleView = [[UIView alloc] init];
//    UIView *contentView = [[UIView alloc] init];
    
    redPoint.backgroundColor = [UIColor redColor];
    redPoint.layer.cornerRadius = 2.5f;
    
    line.backgroundColor =  UIColorFromRGB(0xb0b0b0);
    
    container.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    container.layer.borderWidth = 0.5f;
    container.layer.cornerRadius = 6.0f;
    container.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    titleView.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    titleView.layer.borderWidth = 0.5f;
    titleView.layer.cornerRadius = 6.0f;
    titleView.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.iconCallImageView];
    [self addSubview:line];
    [self addSubview:redPoint];
    [self addSubview:container];
    
    [container addSubview:titleView];

//    UIImageView *extentIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_mainpage_extend"]];
    
    UIButton *extentBtn = self.extentBtn;
    
    [titleView addSubview:self.iconUserImageView];
    [titleView addSubview:self.nameUserLabel];
    [titleView addSubview:self.sexUserLabel];
    [titleView addSubview:self.ageUserLabel];
    [titleView addSubview:extentBtn];
    
    [container addSubview:self.callStateTitleLabel];
    [container addSubview:self.callStateContetnLabel];
    
    [container addSubview:self.anotherLine];
    
    [container addSubview:self.decriptionTitleLabel];
    [container addSubview:self.decriptionLabel];
    [container addSubview:self.imageCollectionView];
    
    ///AutoLayout
    {
        [self addConstraint:[self.iconCallImageView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0f]];
        [self addConstraint:[self.iconCallImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.0f]];
        [self addConstraints:[self.iconCallImageView autoSetDimensionsToSize:CGSizeMake(40.0f, 40.0f)]];
        
        [self addConstraint:[line autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconCallImageView withOffset:10.0f]];
        [self addConstraint:[line autoSetDimension:ALDimensionWidth toSize:1.0f]];
        [self addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f]];
        [self addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0.0f]];
        
        [self addConstraint:[redPoint autoAlignAxis:ALAxisVertical toSameAxisOfView:line]];
        [self addConstraints:[redPoint autoSetDimensionsToSize:CGSizeMake(5.0f, 5.0f)]];
        [self addConstraint:[redPoint autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.iconCallImageView]];
        
        [self addConstraint:[container autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:line withOffset:10.0f]];
        [self addConstraint:[container autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13.0f]];
        [self addConstraint:[container autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:13.0f]];
        [self addConstraint:[container autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10.0f]];
        
        {
            [container addConstraint:[titleView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0.0f]];
            [container addConstraint:[titleView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
            [container addConstraint:[titleView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
            [container addConstraint:[titleView autoSetDimension:ALDimensionHeight toSize:40.0f]];
            
            {
                [titleView addConstraint:[self.iconUserImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
                [titleView addConstraints:[self.iconUserImageView autoSetDimensionsToSize:CGSizeMake(30.0f, 30.0f) ]];
                [titleView addConstraint:[self.iconUserImageView autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
                
                [titleView addConstraint:[self.nameUserLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.iconUserImageView withOffset:15.0f]];
                [titleView addConstraint:[self.nameUserLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
                
                [titleView addConstraint:[self.sexUserLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.nameUserLabel withOffset:15.0f]];
                [titleView addConstraint:[self.sexUserLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
                
                [titleView addConstraint:[self.ageUserLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sexUserLabel withOffset:15.0f]];
                [titleView addConstraint:[self.ageUserLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
                
                [titleView addConstraint:[extentBtn autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
                [titleView addConstraint:[extentBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
                [titleView addConstraints:[extentBtn autoSetDimensionsToSize:CGSizeMake(20.0f, 20.0f)]];
            }
            
            [container addConstraint:[self.callStateTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.0f]];
            [container addConstraint:[self.callStateTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleView withOffset:5.0f]];
            
            [container addConstraint:[self.callStateContetnLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.callStateTitleLabel withOffset:10.0f]];
            [container addConstraint:[self.callStateContetnLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13.0f]];
            [container addConstraint:[self.callStateContetnLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleView withOffset:5.0f]];
            
            [container addConstraint:[self.anotherLine autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.callStateContetnLabel withOffset:5.0f]];
            [container addConstraint:[self.anotherLine autoSetDimension:ALDimensionHeight toSize:0.5f]];
            [container addConstraint:[self.anotherLine autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0.0f]];
            [container addConstraint:[self.anotherLine autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0.0f]];
            
            [container addConstraint:[self.decriptionTitleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.0f]];
            [container addConstraint:[self.decriptionTitleLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.anotherLine withOffset:5.0f]];
            
            [container addConstraint:[self.decriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:13.0f]];
            [container addConstraint:[self.decriptionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.decriptionTitleLabel withOffset:5.0f]];
            [container addConstraint:[self.decriptionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:13.0f]];
            
            [container addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.decriptionLabel withOffset:10.0f]];
            [container addConstraint:[self.imageCollectionView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            [container addConstraint:[self.imageCollectionView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
            self.imageCollectionViewHeightLayoutConstraint = [self.imageCollectionView autoSetDimension:ALDimensionHeight toSize:0.0f];
            [container addConstraint:self.imageCollectionViewHeightLayoutConstraint];
        }
        
    }
    
}

#pragma mark - actions

- (void)extentBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    [self.delegate changeExpandStateWithIndexPath:self.indexPath isExpanded:sender.selected];
//    [self.delegate reloadCellAtIndexPath:self.indexPath];
    
    if (sender.selected) {
        
        [self.imageCollectionView setHidden:NO];
        [self.anotherLine setHidden:NO];
        [self.decriptionTitleLabel setHidden:NO];
        [self.decriptionLabel setHidden:NO];
    }
    else {
        
        [self.imageCollectionView setHidden:YES];
        [self.anotherLine setHidden:YES];
        [self.decriptionTitleLabel setHidden:YES];
        [self.decriptionLabel setHidden:YES];
    }
    
    [self.delegate reloadCellAtIndexPath:self.indexPath];
}

- (void)callButtonClicked:(id)sender
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self, kUrgentCallCell, nil];
    [self routerEventWithName:kUgentCallBtnClickEvent userInfo:userInfoDic];
}

- (void)userIconImageViewTapGestureRecognizerFired:(UIGestureRecognizer *)gestureRecognizer
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self, kUrgentCallCell, nil];
    [self routerEventWithName:kUserIconClickEvent userInfo:userInfoDic];
}

#pragma mark - properties

- (UIImageView *)iconCallImageView {
    
    if (!_iconCallImageView) {
        
        _iconCallImageView = [[UIImageView alloc] init];
        _iconCallImageView.layer.cornerRadius = 6.0f;
        _iconCallImageView.layer.masksToBounds = YES;
        _iconCallImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(callButtonClicked:)];
        [_iconCallImageView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _iconCallImageView;
}

- (UIImageView *)iconUserImageView {
    
    if (!_iconUserImageView) {
        
        _iconUserImageView = [[UIImageView alloc] init];
        _iconUserImageView.layer.cornerRadius = 15.0f;
        _iconUserImageView.layer.masksToBounds = YES;
        _iconUserImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userIconImageViewTapGestureRecognizerFired:)];
        [_iconUserImageView addGestureRecognizer:tapGestureRecognizer];
    }
    
    return _iconUserImageView;
}

- (UILabel *)nameUserLabel {
    
    if (!_nameUserLabel) {
        
        _nameUserLabel = [[UILabel alloc] init];
        _nameUserLabel.textColor = [UIColor blackColor];
        _nameUserLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    
    return _nameUserLabel;
}

- (UILabel *)sexUserLabel {
    
    if (!_sexUserLabel) {
        
        _sexUserLabel = [[UILabel alloc] init];
        _sexUserLabel.textColor = UIColorFromRGB(0x8f8f92);
        _sexUserLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _sexUserLabel;
}

- (UILabel *)ageUserLabel {
    
    if (!_ageUserLabel) {
        
        _ageUserLabel = [[UILabel alloc] init];
        _ageUserLabel.textColor = UIColorFromRGB(0x8f8f92);
        _ageUserLabel.font = [UIFont systemFontOfSize:13.0f];
    }
    
    return _ageUserLabel;
}

- (UILabel *)callStateTitleLabel {
    
    if (!_callStateTitleLabel) {
        
        _callStateTitleLabel = [[UILabel alloc] init];
        _callStateTitleLabel.textColor = UIColorFromRGB(0xfe5f57);
        _callStateTitleLabel.font = [UIFont systemFontOfSize:10.0f];
    }
    
    return _callStateTitleLabel;
}

- (UILabel *)callStateContetnLabel {
    
    if (!_callStateContetnLabel) {
        
        _callStateContetnLabel = [[UILabel alloc] init];
        _callStateContetnLabel.textColor = UIColorFromRGB(0xfe5f57);
        _callStateContetnLabel.font = [UIFont systemFontOfSize:10.0f];
        _callStateContetnLabel.numberOfLines = 2;
    }
    
    return _callStateContetnLabel;
}


- (UILabel *)decriptionLabel {
    
    if (!_decriptionLabel) {
        
        _decriptionLabel = [[UILabel alloc] init];
        _decriptionLabel.textColor = UIColorFromRGB(0x8f8f92);
        _decriptionLabel.font = [UIFont systemFontOfSize:10.0f];
        _decriptionLabel.numberOfLines = 0;
    }
    
    return _decriptionLabel;
}

- (UIView *)anotherLine {
    
    if (!_anotherLine) {
        
        _anotherLine = [[UIView alloc] init];
        _anotherLine.backgroundColor = UIColorFromRGB(0xb0b0b0);
    }
    
    return _anotherLine;
}

- (UILabel *)decriptionTitleLabel {
    
    if (!_decriptionTitleLabel) {
        
        _decriptionTitleLabel = [[UILabel alloc] init];
        _decriptionTitleLabel.text = @"问题描述";
        _decriptionTitleLabel.textColor = [UIColor blackColor];
        _decriptionTitleLabel.textAlignment = NSTextAlignmentLeft;
        _decriptionTitleLabel.font = [UIFont systemFontOfSize:14.0f];
    }
    
    return _decriptionTitleLabel;
}

- (UIButton *)extentBtn {
    
    if (!_extentBtn) {
        
        _extentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_extentBtn setBackgroundImage:[UIImage imageNamed:@"icon_mainpage_unextend"] forState:UIControlStateNormal];
        [_extentBtn setBackgroundImage:[UIImage imageNamed:@"icon_mainpage_extend"] forState:UIControlStateSelected];
        [_extentBtn addTarget:self action:@selector(extentBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_extentBtn setSelected:NO]; // 默认改为 NO
    }
    
    return _extentBtn;
}

- (NSArray *)imgUrls {
    
    if (!_imgUrls) {
        
        _imgUrls = [[NSArray alloc] init];
    }
    
    return _imgUrls;
}

- (UICollectionView  *)imageCollectionView
{
    if (!_imageCollectionView) {
        //层声明实列化
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake((App_Frame_Width - 142.0f) / 4, (App_Frame_Width - 142.0f) / 4)]; //设置每个cell显示数据的宽和高必须
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

#pragma mark - load data

- (void)loadUrgentCallInfo:(UrgentCallInfo *)info {
    
    self.callInfo = info;
    
    [self.iconUserImageView sd_setImageWithURL:[NSURL URLWithString:info.patient.avatarURLString] placeholderImage:[SkinManager sharedInstance].defaultContactAvatarIcon];
    self.nameUserLabel.text = [info.patient getDisplayName];
    
    NSString *sex = [info.patient.firstFamilyMember.gender isEqualToString:@"male"]?@"男": @"女";
    self.sexUserLabel.text = sex;
    self.ageUserLabel.text = [NSString stringWithFormat:@"%ld岁", info.patient.firstFamilyMember.age];
    
    if (info.isReceive) {
        
        NSString *callStateTitle = @"已经联系过";
        NSString *callStateContent = [NSString stringWithFormat:@"已经接受咨询费%ld元\n", (long)(info.money / 100)];
        
        self.callStateTitleLabel.textColor = UIColorFromRGB(0x8f8f92);
        self.callStateTitleLabel.text = callStateTitle;
        
        self.callStateContetnLabel.textColor = UIColorFromRGB(0x8f8f92);
        self.callStateContetnLabel.text = callStateContent;
        self.decriptionLabel.text = info.infoDescription;
        
        [self.iconCallImageView setImage:[UIImage imageNamed:@"icon_avaliable_call_black"]];
        
    } else {
        NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
        NSString *delayTimeString = [dateFormatter stringFromDate:info.expireDate];
        
        NSString *callStateTitle = @"未联系";
        NSString *callStateContent = [NSString stringWithFormat:@"请于%@前呼叫回复患者, 逾期将会退还咨询费%ld元", delayTimeString, (long)(info.money / 100)];
        
        self.callStateTitleLabel.textColor = UIColorFromRGB(0xfe5f57);
        self.callStateTitleLabel.text = callStateTitle;
        
        self.callStateContetnLabel.textColor = UIColorFromRGB(0xfe5f57);
        self.callStateContetnLabel.text = callStateContent;
        self.decriptionLabel.text = info.infoDescription;
        
        [self.iconCallImageView setImage:[UIImage imageNamed:@"icon_avaliable_call"]];
    }
    
    self.imgUrls = info.imagesURLStrings;
    if (self.imgUrls && self.imgUrls.count != 0) {
        
        self.imageCollectionViewHeightLayoutConstraint.constant = self.imgUrls.count > 4 ? (((App_Frame_Width - 142.0f) / 4) * 2 + 20.0f) : (((App_Frame_Width - 142.0f) / 4) + 10.0f);
    }
    [self.imageCollectionView reloadData]; // TODO 为什么放在这里就没有残影了？？？跟tableview的reload机制有关
    
    if (info.isExpanded) {
        
        [self.extentBtn setSelected:YES];
        
        [self.imageCollectionView setHidden:NO];
        [self.anotherLine setHidden:NO];
        [self.decriptionTitleLabel setHidden:NO];
        [self.decriptionLabel setHidden:NO];
    }
    else {
        
        [self.extentBtn setSelected:NO];
        
        [self.imageCollectionView setHidden:YES];
        [self.anotherLine setHidden:YES];
        [self.decriptionTitleLabel setHidden:YES];
        [self.decriptionLabel setHidden:YES];
    }
}

#pragma mark - cell Heigth Method

+ (CGFloat)cellHeightWithUrgentCallInfo:(UrgentCallInfo *)info
{
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 112.0f, MAXFLOAT);
    CGSize textSize = [info.infoDescription sizeWithFont:[UIFont systemFontOfSize:10.0f] constrainedToSize:constraintSize];
    
    if (info.isExpanded) {
        
        CGFloat height = 0.0f;
        if (info.imagesCount > 0) {
            
            height = info.imagesCount > 4 ? (((App_Frame_Width - 142.0f) / 4) * 2 + 25.0f) : (((App_Frame_Width - 142.0f) / 4) + 15.0f);
        }
        
        return 135.0f + textSize.height + height;
    }
    
    return 98.0f;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imgUrls.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewReuseIdentifier forIndexPath:indexPath];
    NSString *imageURLString = [self.imgUrls objectAtIndex:[indexPath row]];
    
    // 下载缩略图
    [[AccountManager sharedInstance] asyncDownThumbnailImageWithURLString:imageURLString withCompletionHandler:^(UIImage *image) {
        [cell.imageView setImage:image];
    } withErrorHandler:^(NSError *error) {
        
        //TODO
    }];
    
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.callInfo, kUrgentCallCellInfoKey, @(indexPath.row), kUrgentCallCellImageIndexKey, self, kUrgentCallCell, nil];
    [self routerEventWithName:kUrgentCallCellDetailImageClickEvent userInfo:userInfoDic];
}



@end
