//
//  DistrictController.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyBaseController.h"
typedef void(^XXBlock)(NSString *fullPath, NSInteger ID);

@interface DistrictController : MyBaseController
@property(nonatomic, strong) NSArray *countiesModelArray;

@property(nonatomic, copy) NSString *fullPath;

@property (nonatomic, copy) XXBlock xxBlock;

- (void)setXxBlock:(XXBlock)xxBlock;

@end