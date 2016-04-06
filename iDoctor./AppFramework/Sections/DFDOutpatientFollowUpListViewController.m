//
//  DFDOutpatientFollowUpListViewController.m
//  AppFramework
//
//  Created by DebugLife on 2/8/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDOutpatientFollowUpListViewController.h"
#import "DFDOutpatientFollowUpDetailViewController.h"

@interface DFDOutpatientFollowUpListViewController ()

@end

@implementation DFDOutpatientFollowUpListViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.followUpReportType = FollowUpType_Outpatient;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"门诊后随访报告";
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
    DFDOutpatientFollowUpDetailViewController *detailViewController = [[DFDOutpatientFollowUpDetailViewController alloc] init];
    detailViewController.followUpReport = followUpReport;
    detailViewController.delegate = self;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
