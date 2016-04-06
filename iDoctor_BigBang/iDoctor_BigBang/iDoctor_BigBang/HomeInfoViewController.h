//
//  HomeInfoViewController.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/24.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "BaseViewController.h"
@class HomeInfoModel;

@interface HomeInfoViewController : BaseViewController

@property (nonatomic, strong) HomeInfoModel *blogItem;

-(instancetype)initWithUrlString:(HomeInfoModel *)model;

@end
