//
//  QuickDiagnoseDetailCell.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/20.
//  Copyright © 2015年 YDHL. All rights reserved.
//

@class QuickDiagnose;


typedef void(^imageClickBlock)(NSString *image_url);
@interface QuickDiagnoseDetailCell : UITableViewCell

@property (nonatomic, strong) UICollectionView *imagesCollectionView;

// 张丽修改过
- (void)loadData:(QuickDiagnose *)quickDiagnose imageBlock:(imageClickBlock)block;



+ (CGFloat)cellHeightWithQuickDiagnose:(QuickDiagnose *)quickDiagnose;
+ (CGFloat)textHeightWithContent:(NSString *)content;
- (void)setupView;

@end

@interface QuickDiagnoseDetailImageCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end
