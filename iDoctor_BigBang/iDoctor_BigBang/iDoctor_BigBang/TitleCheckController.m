//
//  TitleCheckController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "TitleCheckController.h"

@interface TitleCheckController ()

@end

@implementation TitleCheckController

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
    CheckMarkRowModel *directDoctor = [CheckMarkRowModel checkMarkRowModelWithTitle:@"主任医师"];
    CheckMarkRowModel *subtopDoctor = [CheckMarkRowModel checkMarkRowModelWithTitle:@"副主任医师"];
    CheckMarkRowModel *chargeDoctor = [CheckMarkRowModel checkMarkRowModelWithTitle:@"主治医师"];
    CheckMarkRowModel *hospitaledDoctor = [CheckMarkRowModel checkMarkRowModelWithTitle:@"住院医师"];
    CheckMarkRowModel *normalDoctor = [CheckMarkRowModel checkMarkRowModelWithTitle:@"医师"];

    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[directDoctor, subtopDoctor, chargeDoctor, hospitaledDoctor, normalDoctor]];
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
    
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop)
    {
        
        if (self.xxxBlock) {
            self.xxxBlock(cell.textLabel.text);
        }
        
        if ([NSStringFromClass([vc class]) isEqualToString:@"RegistTwoBaseInfoViewController"])
        {
            *stop = YES;
            [self.navigationController popToViewController:self.navigationController.childViewControllers[idx] animated:YES];
            return ;
        }
        
        if ([NSStringFromClass([vc class]) isEqualToString:@"MyInfoController"])
        {
            if (UITableViewCellAccessoryNone == cell.accessoryType)
            {
                InfoChangeRequest *request = [InfoChangeRequest request];
                request.title = cell.textLabel.text;
                
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
        }
    }];
}
- (void)setXxxBlock:(XXXBlock)xxxBlock
{
    _xxxBlock = xxxBlock;
}

@end
