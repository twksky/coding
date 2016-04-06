//
//  IDHaveTableViewCell.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IDGetDoctorPatient;

@protocol IDHaveTableViewCellDelegate <NSObject>

- (void)addPatientButtonClick:(UIButton *)button index:(NSIndexPath *)indexPath;

- (void)intoIDPatientMessageVC:(UIButton *)btn;

@end



//typedef void(^ToContactDetailsBlock)(NSString *patient_id);

@interface IDHaveTableViewCell : UITableViewCell

//@property(nonatomic, copy) ToContactDetailsBlock tcdblock;

// 性别标示
@property (nonatomic, strong) UIImageView *sexImage;

// 年龄
@property (nonatomic, strong) UILabel *ageLabel;

// 加号
@property (nonatomic, strong) UIButton *addButton;

// 患者头像
@property (nonatomic, strong) UIButton *iconImageBtn;

@property (nonatomic, weak)id<IDHaveTableViewCellDelegate> delegate;

@property (nonatomic, weak)id intoDetailsDelegate;

- (void)getDataWithName:(IDGetDoctorPatient *)model  indexPath:(NSIndexPath *)indexPath isHideSegment:(BOOL)isHide;

//-(void)setTtblock:(ToContactDetailsBlock)ttblock;

@end
