//
//  SexCheckController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "SexCheckController.h"

@interface SexCheckController ()

@end

@implementation SexCheckController

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
    CheckMarkRowModel *man = [CheckMarkRowModel checkMarkRowModelWithTitle:@"男"];
    CheckMarkRowModel *women = [CheckMarkRowModel checkMarkRowModelWithTitle:@"女"];

    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[man, women]];
    [sectionModel.rowModels enumerateObjectsUsingBlock:^(CheckMarkRowModel *rowModel, NSUInteger idx, BOOL *stop) {

        [rowModel setRowSelectedBlock:^(NSIndexPath *indexPath) {
            
            [self checkMarkWithIndexPath:indexPath];
        }];
    }];
    [self.sectionModelArray addObject:sectionModel];
    
}

- (void)checkMarkWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tbv cellForRowAtIndexPath:indexPath];
    if (UITableViewCellAccessoryNone == cell.accessoryType)
    {
        InfoChangeRequest *request = [InfoChangeRequest request];
        request.sex = cell.textLabel.text;
        
        [self showMessage:@"修改中..."];
        [ChangeInfoManger changeInfoWithInfoChangeRequest:request accountId:kAccount.doctor_id success:^(Account *account) {
            
            [AccountManager saveAccount:account];
            [self hidMessage];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD showError:error.localizedDescription];
            [self hidMessage];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
