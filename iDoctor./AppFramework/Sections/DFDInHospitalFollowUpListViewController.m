//
//  DFDInHospitalFollowUpListViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDInHospitalFollowUpListViewController.h"
#import "DFDInHospitalFollowUpDetailViewController.h"

@interface DFDInHospitalFollowUpListViewController ()

@end

@implementation DFDInHospitalFollowUpListViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.followUpReportType = FollowUpType_PostDischarge;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"出院后随访报告";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectedFollowUpReport:(FollowUpReport *)followUpReport
{
    DFDInHospitalFollowUpDetailViewController *detailViewController = [[DFDInHospitalFollowUpDetailViewController alloc] init];
    detailViewController.followUpReport = followUpReport;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
