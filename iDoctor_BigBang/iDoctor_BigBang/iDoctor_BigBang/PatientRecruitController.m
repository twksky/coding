//
//  PatientRecruitController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/17/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "PatientRecruitController.h"
#import "IWantRecruitController.h"
#import "RecruitRatioController.h"

#import "IWantPatientDataManger.h"

@interface PatientRecruitController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@end

@implementation PatientRecruitController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (void)setUpData
{
    [self setUpSection0];
    [self setUpSection1];
}
- (void)setUpSection0
{
    ArrowRowModel *recruit = [ArrowRowModel arrowRowWithIcon:[UIImage imageNamed:@"recruit"] title:@"我要招募" destVC:[IWantRecruitController class]];

    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[recruit]];
    [self.sectionModelArray addObject:sectionModel];
}
- (void)setUpSection1
{
    NSMutableArray *tmpArrM = [NSMutableArray array];
    
    [IWantPatientDataManger getRecruitListWithAccountId:kAccount.doctor_id success:^(NSArray *recruitList) {

        [recruitList enumerateObjectsUsingBlock:^(RecruitList *rl, NSUInteger idx, BOOL *stop) {
            
            RecruitRatioRowModel *rr = [RecruitRatioRowModel recruitRatioRowModelWithRecruitList:rl];
            
            [rr setRowSelectedBlock:^(NSIndexPath *indexPath) {
                
                SectionModel *sec = self.sectionModelArray[indexPath.section];
                
                RecruitRatioRowModel *rr = sec.rowModels[indexPath.row];

                RecruitRatioController *rrc = [[RecruitRatioController alloc] init];
                rrc.title = @"招募详情";
                rrc.recId = rr.recruitList.ID;
                [self.navigationController pushViewController:rrc animated:YES];
            }];
            
            [tmpArrM addObject:rr];
        }];
        
        SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
        [self.sectionModelArray addObject:sectionModel];
        [self.tbv reloadData];
        
    } failure:^(NSError *error) {

        [MBProgressHUD showError:error.localizedDescription];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 10 : 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateData];
}
- (void)updateData
{
    [self.sectionModelArray removeAllObjects];
    [self setUpData];
    [self.tbv reloadData];
}

@end
