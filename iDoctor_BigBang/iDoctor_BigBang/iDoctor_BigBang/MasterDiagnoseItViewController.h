//
//  MasterDiagnoseItViewController.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/28.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

@protocol MasterDiagnoseItViewControllerDelegate <NSObject>

- (void)diagnoseMasterComment:(NSString *)diagnoseComment;

@end

@interface MasterDiagnoseItViewController : BaseViewController

@property (nonatomic, weak) id<MasterDiagnoseItViewControllerDelegate> delegate;

@end
