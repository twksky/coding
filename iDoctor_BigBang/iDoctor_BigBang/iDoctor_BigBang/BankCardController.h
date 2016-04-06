//
//  BankCardController.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyBaseController.h"

typedef void(^TTBlock)(UIImage *icon, NSString *title, NSString *subtitle, NSString *back_account);
@interface BankCardController : MyBaseController
@property(nonatomic, copy) TTBlock ttblock;
-(void)setTtblock:(TTBlock)ttblock;

@end
