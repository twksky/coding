//
//  MedicalRecord.h
//  AppFramework
//
//  Created by ABC on 7/20/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MedicalRecord : NSObject

@property (nonatomic, assign) NSInteger recordID;
@property (nonatomic, strong) NSString  *dateISO;
@property (nonatomic, assign) NSInteger personID;
@property (nonatomic, strong) NSString  *doctorName;
@property (nonatomic, strong) NSString  *hospitial;
@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) NSString  *gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, strong) NSString  *allergies;
@property (nonatomic, strong) NSString  *recordDescription;
@property (nonatomic, assign) NSInteger imagesCount;
@property (nonatomic, strong) NSArray   *imagesURLs;

@end
