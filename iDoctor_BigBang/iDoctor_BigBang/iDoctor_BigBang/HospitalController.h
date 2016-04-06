//
//  HospitalController.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyBaseController.h"

typedef void(^XXBlock)(NSString *hospatalName, NSInteger ID);

@interface HospitalController : MyBaseController
@property(nonatomic, assign) NSInteger regionId;
@property (nonatomic, copy) XXBlock xxBlock;

- (void)setXxBlock:(XXBlock)xxBlock;


@end
