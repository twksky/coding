//
//  QuickDiagnoseDetailCell.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/20.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseDetailCell.h"
#import "QuickDiagnose.h"

#define QuickDiagnoseDetailImageCollectionCellHeight (App_Frame_Width - 120.0f) / 5
static NSString *const QuickDiagnoseDetailImageCollectionCellIdentifier = @"3b7229b7-0660-46d0-ae8d-04629208c098";

@interface QuickDiagnoseDetailCell ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (nonatomic, strong) UIImageView *patientIcon;
@property (nonatomic, strong) UILabel *patientNameLabel;
@property (nonatomic, strong) UIImageView *patientSexIcon;
@property (nonatomic, strong) UILabel *patientAgeLabel;
@property (nonatomic, strong) UILabel *departmentLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) NSArray *quickDiagnoseImages;

@property (nonatomic, copy) imageClickBlock block;

@end

@implementation QuickDiagnoseDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setupView];
    }
    
    return self;
}

#pragma mark -
- (void)setupView {
    
    UIView *contentView = self;
    
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
    
    [contentView addSubview:self.imagesCollectionView];
//    self.imagesCollectionView.backgroundColor = [UIColor redColor];
    [self.imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(contentView);
        make.top.equalTo(self.contentLabel.bottom).with.offset(15.0f);
    }];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QuickDiagnoseDetailImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:QuickDiagnoseDetailImageCollectionCellIdentifier forIndexPath:indexPath];
    NSString *imageURL = [self.quickDiagnoseImages objectAtIndex:indexPath.row];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:nil];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.quickDiagnoseImages count];
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.block) {
        
        NSString *imageURL = [self.quickDiagnoseImages objectAtIndex:indexPath.row];
        
        self.block(imageURL);
        
    }
    
    
    
}

// 张丽修改
- (void)loadData:(QuickDiagnose *)quickDiagnose imageBlock:(imageClickBlock)block
{
    
    self.block = block;
    
    //TODO 默认头像
    [self.patientIcon sd_setImageWithURL:[NSURL URLWithString:quickDiagnose.user.avatar_url] placeholderImage:[UIImage imageNamed:@"default_user_avatar"]];
    self.patientNameLabel.text = quickDiagnose.user.realname;
    
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
    
    self.quickDiagnoseImages = quickDiagnose.images_url;
    [self.imagesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.equalTo(self);
        make.top.equalTo(self.contentLabel.bottom).with.offset(15.0f);
        make.height.equalTo([[self class] imageViewsHeightWithQuickDiagnose:quickDiagnose]);
    }];
    [self.imagesCollectionView reloadData];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//TODO
#pragma mark - cellHeight
+ (CGFloat)cellHeightWithQuickDiagnose:(QuickDiagnose *)quickDiagnose {
    
    return 110.0f + [[self class] textHeightWithContent:quickDiagnose.quickDiagnoseDescription] + [[self class] imageViewsHeightWithQuickDiagnose:quickDiagnose];
}


+ (CGFloat)textHeightWithContent:(NSString *)content {
    
    CGSize constraintSize = CGSizeMake(App_Frame_Width - 30.0f, MAXFLOAT);
    CGSize textSize = [content sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraintSize];
    
    return  textSize.height;
}

+ (CGFloat)imageViewsHeightWithQuickDiagnose:(QuickDiagnose *)quickDiagnose
{
    NSInteger imagesCount = quickDiagnose.images_url.count;
    
    CGFloat cellHeight = QuickDiagnoseDetailImageCollectionCellHeight;
    NSInteger imagesRowsCount = imagesCount / 5;
    if ((imagesCount % 5) != 0) {
        
        imagesRowsCount++;
    }
    
    //    return question.imagesCount * ((App_Frame_Width - 120.0f) * 0.6) + (question.imagesCount + 1) * 10.0f;
    
    return imagesRowsCount * (cellHeight + 10.0);
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
        _contentLabel.numberOfLines = 0;
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


- (UICollectionView *)imagesCollectionView {
    
	if(_imagesCollectionView == nil) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat cellHeight = QuickDiagnoseDetailImageCollectionCellHeight;
        [flowLayout setItemSize:CGSizeMake(cellHeight, cellHeight)]; //设置每个cell显示数据的宽和高必须
        //[flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal]; //水平滑动
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //控制滑动分页用
        flowLayout.sectionInset = UIEdgeInsetsMake(5.0f, 10.0f, 5.0f, 10.0f);
        flowLayout.minimumInteritemSpacing = 5.0f;
        
        _imagesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        //对Cell注册(必须否则程序会挂掉)
        [_imagesCollectionView registerClass:[QuickDiagnoseDetailImageCollectionCell class] forCellWithReuseIdentifier:QuickDiagnoseDetailImageCollectionCellIdentifier];
        //[_imageCollectionView setBackgroundColor:[RFQSkinManager sharedInstance].defaultBackgroundColor];
        [_imagesCollectionView setUserInteractionEnabled:YES];

        [_imagesCollectionView setDelegate:self]; //代理－视图
        [_imagesCollectionView setDataSource:self]; //代理－数据
        
        _imagesCollectionView.backgroundColor = self.backgroundColor;
        
	}
	return _imagesCollectionView;
}


- (NSArray *)quickDiagnoseImages {
    
    if(_quickDiagnoseImages == nil) {
        
        _quickDiagnoseImages = [[NSArray alloc] init];
    }
    return _quickDiagnoseImages;
}


@end

@implementation QuickDiagnoseDetailImageCollectionCell: UICollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
