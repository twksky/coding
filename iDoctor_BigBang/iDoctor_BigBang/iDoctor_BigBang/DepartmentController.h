//
//  DepartmentController.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyBaseController.h"

typedef void(^XXXXBlock)(NSString *dpName);

@interface DepartmentController : MyBaseController
@property (nonatomic, copy) XXXXBlock xxxxBlock;

- (void)setXxxxBlock:(XXXXBlock)xxxxBlock;
@end
