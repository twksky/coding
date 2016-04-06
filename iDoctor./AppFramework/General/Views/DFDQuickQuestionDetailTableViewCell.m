//
//  DFDQuickQuestionTableViewCell.m
//  AppFramework
//
//  Created by DebugLife on 2/13/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDQuickQuestionDetailTableViewCell.h"
#import "FollowUpReport.h"
#import "UIView+AutoLayout.h"
#import "MedicalRecordCollectionViewCell.h"
#import "AccountManager.h"
#import "ManagerUtil.h"
#import "SkinManager.h"
#import "UIImageView+WebCache.h"
#import "UIResponder+Router.h"
#import "QuickQuestion.h"

@interface DFDQuickQuestionDetailTableViewCell ()
<
UICollectionViewDataSource, UICollectionViewDelegate
>

@property (nonatomic, weak) QuickQuestion   *question;
@property (nonatomic, strong) UICollectionView  *imageCollectionView;
@property (nonatomic, strong) NSLayoutConstraint *imageCollectionViewHeightLayoutConstraint;
@property (nonatomic, strong) UIButton *spreadBtn;

+ (CGFloat)imageCollectionViewHeightWithQuickQuestion:(QuickQuestion *)question;

@end

@implementation DFDQuickQuestionDetailTableViewCell

static NSString *CollectionViewReuseIdentifier = @"1A819AFE-2298-451E-83D9-D933C8D4FF96";
#define CellTextFont    [UIFont systemFontOfSize:14.0f]

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.imageCollectionView];
        [self addSubview:self.spreadBtn];
        
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
//        [self.contentView addConstraint:[self.imageCollectionView autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5.0f]];
        
        [self addConstraint:[self.spreadBtn autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-20.0f]];
        [self addConstraint:[self.spreadBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.imageCollectionView withOffset:10.0f]];
        
//        self addConstraint:[]
//        [self addConstraint:[self.spreadBtn autoSetDimension:ALDimensionWidth toSize:App_Frame_Width - 20]];
    }
    return self;
}

+ (CGFloat)cellHeightWithQuickQuestion:(QuickQuestion *)question
{
    NSMutableString *infoText = [[NSMutableString alloc] init];
    NSString *department = (nil != question.department) ? question.department : @"";
    [infoText appendFormat:@"科室：%@", department];
    if (nil != question.lastTime && question.lastTime.length > 0) {
        [infoText appendFormat:@"\n到目前为止症状持续时间：%@", question.lastTime];
    }
    if (nil != question.conditionDescription && question.conditionDescription.length > 0) {
        [infoText appendFormat:@"\n病情与症状描述：%@", question.conditionDescription];
    }
    if (nil != question.incentives && question.incentives.length > 0) {
        [infoText appendFormat:@"\n突发诱因：%@", question.incentives];
    }
    if (nil != question.otherDisease && question.otherDisease.length > 0) {
        [infoText appendFormat:@"\n近三个月其他疾病与服药情况：%@", question.otherDisease];
    }
    if (nil != question.operationHistory && question.operationHistory.length > 0) {
        [infoText appendFormat:@"\n手术史：%@", question.operationHistory];
    }
    if (nil != question.geneticHistory && question.geneticHistory.length > 0) {
        [infoText appendFormat:@"\n遗传病史：%@", question.geneticHistory];
    }
    
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 20.0f, MAXFLOAT);
    CGSize textSize = [infoText sizeWithFont:CellTextFont constrainedToSize:constraintSize];
    return 110.0f + textSize.height + [DFDQuickQuestionDetailTableViewCell imageCollectionViewHeightWithQuickQuestion:question];
}

+ (CGFloat)imageCollectionViewHeightWithQuickQuestion:(QuickQuestion *)question
{
    if (question.imagesCount == 0) {
        return 0.0f;
    }
    
    if ((question.imagesCount * 64.0f + (question.imagesCount + 1) * 5.0f) > App_Frame_Width) {
        return 64.0f * 2 + 15.0f;
    }
    return 64.0 + 10.0f;
}

- (void)loadQuickQuestion:(QuickQuestion *)question
{
    self.question = question;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:question.patient.avatarURLString] placeholderImage:[SkinManager sharedInstance].defaultContactAvatarIcon];
    
    NSDictionary *nameAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, nil];
    NSMutableString *titleText = [[NSMutableString alloc] initWithString:[question.patient getDisplayName]];
    [titleText appendFormat:@"\t%ld岁", (long)question.patient.firstFamilyMember.age];
    [titleText appendFormat:@"\t%@\n", [ManagerUtil parseGender:question.patient.firstFamilyMember.gender]];
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:titleText attributes:nameAttributeDic];
    NSDictionary *timeAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f], NSFontAttributeName, [SkinManager sharedInstance].defaultGrayColor, NSForegroundColorAttributeName, nil];
    NSDateFormatter *dateFormatter  = [[NSDateFormatter alloc] init];
    //dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSMutableAttributedString *statusAttributedString = [[NSMutableAttributedString alloc] initWithString:[dateFormatter stringFromDate:question.createTime] attributes:timeAttributeDic];
    [titleAttributedString appendAttributedString:statusAttributedString];
    [self.titleLabel setAttributedText:titleAttributedString];
    
    NSDictionary *infoAttributeDic = [NSDictionary dictionaryWithObjectsAndKeys:CellTextFont, NSFontAttributeName, nil];
    NSMutableString *infoText = [[NSMutableString alloc] init];
    NSString *department = (nil != question.department) ? question.department : @"";
    [infoText appendFormat:@"科室：%@", department];
    if (nil != question.lastTime && question.lastTime.length > 0) {
        [infoText appendFormat:@"\n到目前为止症状持续时间：%@", question.lastTime];
    }
    if (nil != question.conditionDescription && question.conditionDescription.length > 0) {
        [infoText appendFormat:@"\n病情与症状描述：%@", question.conditionDescription];
    }
    if (nil != question.incentives && question.incentives.length > 0) {
        [infoText appendFormat:@"\n突发诱因：%@", question.incentives];
    }
    if (nil != question.otherDisease && question.otherDisease.length > 0) {
        [infoText appendFormat:@"\n近三个月其他疾病与服药情况：%@", question.otherDisease];
    }
    if (nil != question.operationHistory && question.operationHistory.length > 0) {
        [infoText appendFormat:@"\n手术史：%@", question.operationHistory];
    }
    if (nil != question.geneticHistory && question.geneticHistory.length > 0) {
        [infoText appendFormat:@"\n遗传病史：%@", question.geneticHistory];
    }
    NSMutableAttributedString *infoAttributedString = [[NSMutableAttributedString alloc] initWithString:infoText attributes:infoAttributeDic];
    [self.subtitleLabel setAttributedText:infoAttributedString];
    
    self.imageCollectionViewHeightLayoutConstraint.constant = [DFDQuickQuestionDetailTableViewCell imageCollectionViewHeightWithQuickQuestion:question];
    [self.imageCollectionView reloadData];
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

- (UIButton *)spreadBtn {
    
    if (nil == _spreadBtn) {
        
        _spreadBtn = [[UIButton alloc] init];
        [_spreadBtn setTitle:@"展开" forState:UIControlStateNormal];
        [_spreadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    return _spreadBtn;
}

#pragma mark - set spreadBtn action

- (void) addSpreadBtnAction:(SEL)action withTarget:(id)target {
    
    [self.spreadBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.question.imagesCount;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MedicalRecordCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewReuseIdentifier forIndexPath:indexPath];
    NSString *imageURLString = [self.question.imagesURLStrings objectAtIndex:[indexPath row]];
    
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
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.question, kQuickQuestionKey, @(indexPath.row), kImageIndexKey, self, kQuickQuestionTableViewCellKey, nil];
    [self routerEventWithName:kQuickQuestionThumbnailImageClickedEvent userInfo:userInfoDic];
}


#pragma mark - Selector

- (void)avatarImageViewTapGestureRecognizerFired:(UIGestureRecognizer *)gestureRecognizer
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithObjectsAndKeys:self.question, kQuickQuestionKey, self, kQuickQuestionTableViewCellKey, nil];
    [self routerEventWithName:kAvatarClickEvent userInfo:userInfoDic];
}

@end
