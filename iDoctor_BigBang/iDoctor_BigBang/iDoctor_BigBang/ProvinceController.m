//
//  ProvinceController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ProvinceController.h"
#import "CityController.h"
#import "RegionManger.h"
@interface ProvinceController ()
@property (nonatomic, strong) RegionsModel *regionsModel;
@end

@implementation ProvinceController

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
    [self showMessage:nil];
    [RegionManger getRegionsIfSuccess:^(RegionsModel *regions) {
        
        self.regionsModel = regions;
        
        NSMutableArray *tmpArrM = [NSMutableArray array];
        [regions.provinces enumerateObjectsUsingBlock:^(Provinces *p, NSUInteger idx, BOOL *stop) {
            
            ArrowRowModel *arrow = [ArrowRowModel arrowRowWithTitle:p.name destVC:nil];
            [arrow setRowSelectedBlock:^(NSIndexPath *indexPath) {
                
                [self pushToCityWithIndexPath:indexPath];
            }];

            [tmpArrM addObject:arrow];
        }];
        
        SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
       [self.sectionModelArray addObject:sectionModel];
        [self.tbv reloadData];
        [self hidMessage];

    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
        [self hidMessage];
    }];
}

- (void)pushToCityWithIndexPath:(NSIndexPath *)indexPath
{
    Provinces *p = self.regionsModel.provinces[indexPath.row];
    
    
    CityController *city = [[CityController alloc] init];
    city.title = p.name;
    city.citiesModelArray = p.cities;
    city.fullPath = p.name;
    
    [city setXxBlock:^(NSString *fullPath, NSInteger ID) {
        
        if (self.xxBlock) {
            self.xxBlock(fullPath, ID);
        }
    }];
    [self.navigationController pushViewController:city animated:YES];
}
- (void)setXxBlock:(XXBlock)xxBlock
{
    _xxBlock = xxBlock;
}
@end
