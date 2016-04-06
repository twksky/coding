//
//  BankCardController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/28/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "BankCardController.h"
#import "AddBankCardController.h"
#import "GlideManger.h"


@interface BankCardController ()

@property (nonatomic, strong) NSMutableArray *backArray;

@end

@implementation BankCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpRightItem];
}
- (void)setUpData
{
    [self setUpSection0];

}
- (void)setUpRightItem
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.bounds = CGRectMake(0, 0, 18, 18);
    btn.tintColor = [UIColor whiteColor];
    [btn addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)rightItemClick
{
    AddBankCardController *addBankCard = [[AddBankCardController alloc] init];
    addBankCard.title = @"添加银行卡";
    [self.navigationController pushViewController:addBankCard animated:YES];
}
- (void)setUpSection0
{
    NSMutableArray *tmpArrM = [NSMutableArray array];
    
    [GlideManger bankCardListWithAccountId:kAccount.doctor_id success:^(NSArray *bankCardList) {
        
        [self.backArray addObjectsFromArray:bankCardList];
        
        [bankCardList enumerateObjectsUsingBlock:^(BankCard *obj, NSUInteger idx, BOOL *stop) {
            
            BankCardListRowModel *bankCard = [BankCardListRowModel bankCardListRowModelWithBankCard:obj];
            [bankCard setRowSelectedBlock:^(NSIndexPath *indexPath) {
                
                [self checkMarkWithIndexPath:indexPath];
                
            }];
            
            [tmpArrM addObject:bankCard];
        }];
        
        SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
        [self.sectionModelArray addObject:sectionModel];
        [self.tbv reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
    }];

    
}

- (void)checkMarkWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tbv cellForRowAtIndexPath:indexPath];
//    GDLog(@"%@",cell.imageView.image);
    
    BankCard *model = self.backArray[indexPath.row];
    
    if (self.ttblock) {
        self.ttblock(cell.imageView.image, cell.textLabel.text, cell.detailTextLabel.text,model.bank_account);
    }
    if (UITableViewCellAccessoryNone == cell.accessoryType)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        //        GDAccountModel *accountModel = [GDAccountManger getAccountModel];
        //
        //        GDChangeInfoRequsetModel *request = [[GDChangeInfoRequsetModel alloc] init];
        //        request.sex = cell.textLabel.text;
        //
        //        UIView *view = self.view;
        //        [MBProgressHUD showMessage:@"正在修改中..." toView:view isDimBackground:NO];
        //
        //        [GDChangeInfoManger changeInfoWithAccountId:accountModel.account_id request:request success:^(GDAccountModel *accountModel) {
        //
        //            [GDAccountManger saveAccount:accountModel];
        //            [MBProgressHUD hideHUDForView:view];
        //
        //            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        //            [MBProgressHUD showSuccess:@"修改成功！"];
        //
        //            [self.navigationController popViewControllerAnimated:YES];
        //
        //        } failure:^(NSError *error) {
        //
        //            GDLog(@"%@",error);
        //            [MBProgressHUD hideHUDForView:view];
        //            [MBProgressHUD showError:@"修改失败！"];
        //            [self.navigationController popViewControllerAnimated:YES];
        //
        //        }];
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setTtblock:(TTBlock)ttblock
{
    _ttblock = ttblock;
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

- (NSMutableArray *)backArray
{
    if (_backArray == nil) {
        
        _backArray = [NSMutableArray array];
    }
    
    return _backArray;
}

@end
