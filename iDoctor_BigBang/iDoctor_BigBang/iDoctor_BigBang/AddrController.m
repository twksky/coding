//
//  AddrController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "AddrController.h"
#import "AddrModel.h"
#import "ProvinceController.h"
@interface AddrController ()
@property(nonatomic, strong) AddrModel *addrModel;
@property(nonatomic, assign) BOOL isAdd;
@end

@implementation AddrController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNav];
    // 设置数据
    [self setUpData];
    [self fetchData];
}

- (void)setUpData
{
    [self setUpSection0];
    
}

- (void)setUpSection0
{
    AddrRowModel *consignee = [AddrRowModel addrRowModelWithTitle:@"收货人"
                                                                            value:self.addrModel.name
                                                                     keyboardType:UIKeyboardTypeDefault];
    
    [consignee setTextFieldDidEndEditingBlock:^(NSString *text) {
        
        self.addrModel.name = text;
    }];
    
    AddrRowModel *mobile = [AddrRowModel addrRowModelWithTitle:@"手机号码"
                                                                         value:self.addrModel.phone
                                                                  keyboardType:UIKeyboardTypeNumberPad];
    [mobile setTextFieldDidEndEditingBlock:^(NSString *text) {
        
        self.addrModel.phone = text;
    }];
    
    AddrRowModel *region = [AddrRowModel addrRowModelWithTitle:@"地区"
                                                                         value:self.addrModel.full_path
                                                                  keyboardType:(UIKeyboardType)(-1)];
    [region setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        [self pushToProvinceVC];
    }];
    
    AddrRowModel *detailAddr = [AddrRowModel addrRowModelWithTitle:@"详细地址"
                                                                             value:self.addrModel.address
                                                                      keyboardType:UIKeyboardTypeDefault];
    [detailAddr setTextFieldDidEndEditingBlock:^(NSString *text) {
        
        self.addrModel.address = text;
    }];
    
    AddrRowModel *zipCode = [AddrRowModel addrRowModelWithTitle:@"邮政编码"
                                                                          value:self.addrModel.zip_code
                                                                   keyboardType:UIKeyboardTypeNumberPad];
    [zipCode setTextFieldDidEndEditingBlock:^(NSString *text) {
        
        self.addrModel.zip_code = text;
    }];
    
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[consignee, mobile, region, detailAddr, zipCode]];

    [self.sectionModelArray addObject:sectionModel];
    
}
- (void)pushToProvinceVC
{
    ProvinceController *p = [[ProvinceController alloc] init];
    p.title = @"选择地区";
    [p setXxBlock:^(NSString *fullPath, NSInteger ID) {
        
        GDLog(@"%@-----%ld",fullPath, ID);
        self.addrModel.full_path = fullPath;
        self.addrModel.region_id = @(ID);
    }];
    [self.navigationController pushViewController:p animated:YES];
}

- (void)leftItemClick
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick
{
    [self saveAddr];
}
- (void)fetchData
{
    [MBProgressHUD showMessage:nil toView:self.view isDimBackground:NO];
    [ChangeInfoManger getAddrIfSuccess:^(AddrModel *addrModel) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        self.addrModel = addrModel;
        [self updateData];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.navigationItem.title = @"修改地址";
        });
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if ([error.userInfo[@"NSLocalizedDescription"] isEqualToString:@"收货地址不存在"]) {
            
            self.isAdd = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self.navigationItem.title = @"增加地址";
            });
        } else {
            
            [MBProgressHUD showError:error.userInfo[@"NSLocalizedDescription"] toView:self.view];
        }
        
    }];
}
- (void)saveAddr
{
    [self.view endEditing:YES];
    
    if (!self.addrModel.region_id) {
        
        [MBProgressHUD showError:@"请选择地区" toView:self.view];
        return;
    }

    if ([self.addrModel.name isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"收货人不能为空" toView:self.view];
        return;
    }

    NSRegularExpression *regexPhone = [NSRegularExpression regularExpressionWithPattern:@"^1[3|4|5|7|8][0-9]\\d{8}$" options:0 error:NULL];
    NSTextCheckingResult *rsPhone = [regexPhone firstMatchInString:self.addrModel.phone
                                                           options:0
                                                             range:NSMakeRange(0, self.addrModel.phone.length)];
    if (!rsPhone) {
        
        [MBProgressHUD showError:@"手机号不正确" toView:self.view];
        return;
    }

    if ([self.addrModel.address isEqualToString:@""]) {
        
        [MBProgressHUD showError:@"详细地址不能为空不能为空" toView:self.view];
        return;
    }
    NSRegularExpression *regexZipCode = [NSRegularExpression regularExpressionWithPattern:@"[1-9]\\d{5}(?!\\d)" options:0 error:NULL];
    NSTextCheckingResult *rsZipCode = [regexZipCode firstMatchInString:self.addrModel.zip_code
                                                               options:0
                                                                 range:NSMakeRange(0, self.addrModel.zip_code.length)];
    if (!rsZipCode) {
        
        [MBProgressHUD showError:@"邮政编码不正确" toView:self.view];
        return;
    }
    
    [MBProgressHUD showMessage:@"修改中..." toView:self.view isDimBackground:NO];
    if (self.isAdd) {
        
        [ChangeInfoManger addAddrWithRequest:self.addrModel success:^(NSString *success) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:success];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
        }];
        
    } else {
        
        [ChangeInfoManger changeAddrWithRequest:self.addrModel success:^(NSString *success) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showSuccess:success];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
        }];
    }
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
- (AddrModel *)addrModel
{
    if (_addrModel == nil) {
        _addrModel = [[AddrModel alloc] init];
    }
    return _addrModel;
}
@end
