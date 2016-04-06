//
//  ContactDetailInfoViewController.h
//  AppFramework
//
//  Created by ABC on 8/23/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MedicalRecord;

@interface ContactDetailInfoViewController : UIViewController

- (id)initWithMedicalRecord:(MedicalRecord *)medicalRecordData;
- (id)initWithMedicalRecordID:(NSInteger)medicalRecordID;

@end
