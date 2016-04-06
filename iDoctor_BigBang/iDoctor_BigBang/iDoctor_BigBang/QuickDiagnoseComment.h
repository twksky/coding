//
//  QuickDiagnoseComment.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/21.
//  Copyright © 2015年 YDHL. All rights reserved.
//
@class Doctor;

@interface QuickDiagnoseComment : NSObject

@property (nonatomic, assign) NSInteger commentId;

@property (nonatomic, copy) NSString *ctime_iso;

@property (nonatomic, copy) NSString *commentContent;

@property (nonatomic, strong) Doctor *doctor;

@end

