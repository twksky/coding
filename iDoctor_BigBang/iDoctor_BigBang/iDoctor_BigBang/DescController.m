//
//  DescController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "DescController.h"

@interface DescController ()
{
    NSString *_brief;
}
@end

@implementation DescController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    [self setUpData];
}
- (void)setUpData
{
    [self setUpSection0];
}

- (void)setUpSection0
{
    TextViewRowModel *desc = [TextViewRowModel
                                           textViewRowModelWithText:kAccount.brief];
    [desc setTextViewDidEndEditingBlock:^(NSString *text) {
        
        _brief = text;
        
    }];
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[desc]];
    
    [self.sectionModelArray addObject:sectionModel];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (void)leftItemClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick
{
    [self.view endEditing:YES];
    
    InfoChangeRequest *request = [InfoChangeRequest request];
    request.brief = _brief;
    
    [self showMessage:@"修改中..."];
    [ChangeInfoManger changeInfoWithInfoChangeRequest:request accountId:kAccount.doctor_id success:^(Account *account) {
        
        [AccountManager saveAccount:account];
        [self hidMessage];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } failure:^(NSError *error) {
        
        [self hidMessage];
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
        
        [self.view endEditing:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];

}
@end
