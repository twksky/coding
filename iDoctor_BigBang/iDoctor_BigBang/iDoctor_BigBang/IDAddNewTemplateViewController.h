//
//  IDAddNewTemplateViewController.h
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/23.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"

@class TemplateModel;

typedef void(^updateBlock)(void);
@interface IDAddNewTemplateViewController : BaseViewController

@property (nonatomic, strong) TemplateModel *model;

- initWithTitle:(NSString *)title;

@property (nonatomic, copy) updateBlock block;

@end
