//
//  DistrictController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "DistrictController.h"
#import "RegionManger.h"

@interface DistrictController ()

@end

@implementation DistrictController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置数据
    [self setUpData];
}

- (void)setUpData
{
    [self setUpSection0];
    
}

- (void)setUpSection0
{
    NSMutableArray *tmpArrM = [NSMutableArray array];
    [self.countiesModelArray enumerateObjectsUsingBlock:^(Counties *c, NSUInteger idx, BOOL *stop) {
        
        BaseRowModel *base = [BaseRowModel baseRowModelWithTitle:c.name];
        
        [base setRowSelectedBlock:^(NSIndexPath *indexPath) {
            
            [self popSelfWithIndexPath:indexPath];
        }];
        [tmpArrM addObject:base];
    }];
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
    [self.sectionModelArray addObject:sectionModel];

}
- (void)popSelfWithIndexPath:(NSIndexPath *)indexPath
{
    
    Counties *c = self.countiesModelArray[indexPath.row];
    NSString *fullPath = [NSString stringWithFormat:@"%@ %@", self.fullPath, c.name];
    
    if (self.xxBlock) {
        self.xxBlock(fullPath, c.ID);
    }

    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        
        if ([NSStringFromClass([vc class]) isEqualToString:@"MyInfoController"])
        {
//            Account *account = [AccountManager getAccount];
//            account.full_region_path = fullPath;
//            account.region_id = c.ID;
//            [AccountManager saveAccount:account];

            *stop = YES;
            [self.navigationController popToViewController:self.navigationController.childViewControllers[idx] animated:YES];
        }
        if ([NSStringFromClass([vc class]) isEqualToString:@"AddrController"])
        {
            *stop = YES;
            [self.navigationController popToViewController:self.navigationController.childViewControllers[idx] animated:YES];
            
        }
        if ([NSStringFromClass([vc class]) isEqualToString:@"RegistTwoBaseInfoViewController"])
        {
            *stop = YES;
            [self.navigationController popToViewController:self.navigationController.childViewControllers[idx] animated:YES];
        }
    }];
}
- (void)setXxBlock:(XXBlock)xxBlock
{
    _xxBlock = xxBlock;
}

@end
