//
//  TitleCheckController.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyBaseController.h"

typedef void(^XXXBlock)(NSString *title);

@interface TitleCheckController : MyBaseController
@property (nonatomic, copy) XXXBlock xxxBlock;

- (void)setXxxBlock:(XXXBlock)xxxBlock;
@end
