//
//  IDHavePatientViewController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/21.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^saveMedicalBlock)(void);

@interface IDHavePatientViewController : BaseViewController

// 患者的id
@property (nonatomic, assign) NSInteger patient_id;

@property (nonatomic, copy) saveMedicalBlock block;

@end
