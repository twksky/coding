//
//  CaseHistoryInfoTableViewCell.h
//  AppFramework
//
//  Created by ABC on 8/14/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MedicalRecord;
@class CaseHistoryInfoTableViewCell;

@protocol CaseHistoryInfoTableViewCellDelegate <NSObject>

- (void)caseHistoryInfoTableViewCell:(CaseHistoryInfoTableViewCell *)cell didSelectMedicalRecordImageIndex:(NSInteger)index withImageView:(UIImageView *)imageView withMedicalRecord:(MedicalRecord *)medicalRecord;

@end

@interface CaseHistoryInfoTableViewCell : UITableViewCell

+ (CGFloat)defaultCellHeight;
+ (CGFloat)defaultCellHeightWithMedicalRecord:(MedicalRecord *)medicalRecord;

@property (nonatomic, weak) id<CaseHistoryInfoTableViewCellDelegate> delegate;

- (void)setMedicalRecord:(MedicalRecord *)medicalRecord;

@end
