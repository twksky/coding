//
//  HospitalController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "HospitalController.h"
#import "RegionManger.h"
@interface HospitalController ()

@end

@implementation HospitalController

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
    
    [RegionManger getHospitalWithRegionId:self.regionId success:^(NSArray *hospitalArray) {
        
        [hospitalArray enumerateObjectsUsingBlock:^(Hospital *hos, NSUInteger idx, BOOL *stop) {
            
            CheckMarkRowModel *check = [CheckMarkRowModel checkMarkRowModelWithTitle:hos.name];
            
            [check setRowSelectedBlock:^(NSIndexPath *indexPath) {
                
                [self popSelfWithIndexPath:indexPath hospatalArray:hospitalArray];
            }];

            [tmpArrM addObject:check];
        }];
        SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
        
        [self.sectionModelArray addObject:sectionModel];
        [self.tbv reloadData];
        
    } failure:^(NSError *error) {
        
        
    }];
    
}
- (void)popSelfWithIndexPath:(NSIndexPath *)indexPath hospatalArray:(NSArray *)hospatalArray
{
    Hospital *hos = hospatalArray[indexPath.row];
    
    if (self.xxBlock) {
        self.xxBlock([NSString stringWithFormat:@"%@", hos.name], hos.ID);
    }
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        
        if ([NSStringFromClass([vc class]) isEqualToString:@"RegistTwoBaseInfoViewController"] ||
            [NSStringFromClass([vc class]) isEqualToString:@"MyInfoController"])
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
