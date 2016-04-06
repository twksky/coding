//
//  CityController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "CityController.h"
#import "DistrictController.h"
#import "RegionManger.h"
@interface CityController ()

@end

@implementation CityController

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
    [self.citiesModelArray enumerateObjectsUsingBlock:^(Cities *c, NSUInteger idx, BOOL *stop) {
        
        ArrowRowModel *arrow = [ArrowRowModel arrowRowWithTitle:c.name destVC:nil];
        
        [arrow setRowSelectedBlock:^(NSIndexPath *indexPath) {
            
            [self pushToDistrictWithIndexPath:indexPath];
        }];
        [tmpArrM addObject:arrow];
    }];
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
    [self.sectionModelArray addObject:sectionModel];
    
}
- (void)pushToDistrictWithIndexPath:(NSIndexPath *)indexPath
{
//    SectionModel *sectionModel = self.sectionModelArray[0];
//    ArrowRowModel *arrowRowModel = sectionModel.rowModels[indexPath.row];
//    
    Cities *c = self.citiesModelArray[indexPath.row];
//    GDLog(@"%@",c.counties);
    DistrictController *d = [[DistrictController alloc] init];
    [d setXxBlock:^(NSString *fullPath, NSInteger ID) {
        
        if (self.xxBlock) {
            self.xxBlock(fullPath, ID);
        }
    }];
    d.title = c.name;
    d.countiesModelArray = c.counties;
    d.fullPath = [NSString stringWithFormat:@"%@ %@", self.fullPath, c.name];
    [self.navigationController pushViewController:d animated:YES];

}
- (void)setXxBlock:(XXBlock)xxBlock
{
    _xxBlock = xxBlock;
}

@end
