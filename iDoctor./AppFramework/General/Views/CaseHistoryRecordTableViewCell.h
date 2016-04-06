//
//  CaseHistoryRecordTableViewCell.h
//  AppFramework
//
//  Created by ABC on 8/14/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MedicalRecord;

@interface CaseHistoryRecordTableViewCell : UITableViewCell

+ (CGFloat)defaultCellHeight;

- (void)setMedicalRecord:(MedicalRecord *)medicalRecord;

@end
