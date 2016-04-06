//
//  TemplateController.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseViewController.h"

@class TemplateModel;

@protocol MyTemplateControllerDelegate <NSObject>

@required
- (void)didSelectTemplate:(TemplateModel *)model;

@end

@interface MyTemplateController : BaseViewController

@property (nonatomic, weak) id<MyTemplateControllerDelegate> delegate;

@end
