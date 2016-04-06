//
//  MyBaseController.h
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BaseViewController.h"
#import "HeaderManger.h"
#import "ChangeInfoManger.h"
#import "GlideManger.h"
@interface MyBaseController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tbv;

/**
 *  section模型数组
 */
@property(nonatomic, strong) NSMutableArray *sectionModelArray;
- (void)setUpNav;
- (void)leftItemClick;
- (void)rightItemClick;
@end
