//
//  IWantPatientCell.h
//  iDoctor_BigBang
//
//  Created by hexy on 6/26/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import <UIKit/UIKit.h>
#define IWantPatientCellMargin 10
#define IWantPatientCellSelectedColor UIColorFromRGB(0xf8f8f8)

@class PatientModel,IDMedicaledModel;

typedef void(^AvatarClickBlock)(PatientModel *patientModel, IDMedicaledModel *medicaledModel);

@interface IWantPatientCell : UITableViewCell

@property(nonatomic, copy) AvatarClickBlock avatarClickBlock;
/**
 *  创建Cell
 *
 *  @param tableView
 *
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView;


- (void)setDataWithPatientModel:(PatientModel *)patientModel;

- (void)setDataWithMedicaledModel:(IDMedicaledModel *)medicaledModel;

- (void)setAvatarClickBlock:(AvatarClickBlock)avatarClickBlock;

+ (CGFloat)height;
@end
