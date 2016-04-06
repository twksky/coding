//
//  MyInfoController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyInfoController.h"
#import "GDPhotoChooseView.h"
#import "SexCheckController.h"
#import "ProvinceController.h"
#import "DepartmentController.h"
#import "TitleCheckController.h"
#import "DescController.h"
#import "AddrController.h"
#import "HospitalController.h"
#import "PhoneController.h"

#import "IDMyCardViewController.h"
#import "IDselectSymptomViewController.h"

#import "IDDoctorIsGoodAtDiseaseModel.h"

@interface MyInfoController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSInteger _region_id;
    NSString *_fullPath;
    NSString *_hospital;
}
@end

@implementation MyInfoController

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
    AvatarRowModel *test = [AvatarRowModel avatarRowWithTitle:@"头像" avatarImageURLStr:kAccount.avatar_url];
    [test setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        [self alertPhotoChooseView];
    }];
    
    ArrowRowModel *sex = [ArrowRowModel arrowRowModelWithTitle:@"性别" subtitle:kAccount.sex destVC:[SexCheckController class]];
    BaseRowModel *realname = [BaseRowModel baseRowModelWithTitle:@"真实姓名" subtitle:kAccount.realname];
    QrCodeRowModel *qrCode = [QrCodeRowModel qrCodelModelWithTitle:@"我的二维码" qrCodeImage:[UIImage imageNamed:@"qrCode"] destVC:[IDMyCardViewController class]];
    ArrowRowModel *consiAddr = [ArrowRowModel arrowRowWithTitle:@"收货地址" destVC:nil];
    [consiAddr setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        AddrController *addr = [[AddrController alloc] init];
        addr.title = @"收货地址";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addr];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[test, sex, realname, qrCode, consiAddr]];
    [self.sectionModelArray addObject:sectionModel];
    
}
- (void)setUpSection1
{
    
    ArrowRowModel *region = [ArrowRowModel arrowRowModelWithTitle:@"地区" subtitle:(_fullPath)?_fullPath:kAccount.full_region_path destVC:nil];
    [region setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请联系医生助手修改您所在的地区和医院" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
        
        
        ProvinceController *p = [[ProvinceController alloc] init];
        p.title = @"选择地区";
        [p setXxBlock:^(NSString *fullPath, NSInteger ID) {
    
            _hospital = @"请选择...";
            _fullPath = fullPath;
            _region_id = ID;
            
        }];
        
        [self.navigationController pushViewController:p animated:YES];
        
    }];
    
    
    ArrowRowModel *hospital = [ArrowRowModel arrowRowModelWithTitle:@"医院" subtitle:(_hospital)?_hospital:kAccount.hospital destVC:nil];
    [hospital setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请联系医生助手修改您所在的地区和医院" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return ;
        
        
        HospitalController *hospital = [[HospitalController alloc] init];
        hospital.title = @"选择医院";
        hospital.regionId = (_region_id)?_region_id:kAccount.region_id;
        [hospital setXxBlock:^(NSString *hospatalName, NSInteger ID) {
            
            GDLog(@"%@---%ld",hospatalName, ID);
        }];
        [self.navigationController pushViewController:hospital animated:YES];
    }];
    ArrowRowModel *department = [ArrowRowModel arrowRowModelWithTitle:@"科室" subtitle:kAccount.department destVC:[DepartmentController class]];
    ArrowRowModel *pTitle = [ArrowRowModel arrowRowModelWithTitle:@"职称" subtitle:kAccount.title destVC:[TitleCheckController class]];
    
    
    ArrowRowModel *tags = [ArrowRowModel arrowRowModelWithTitle:@"标签" subtitle:@"已填" destVC:nil];
    
    [tags setRowSelectedBlock:^(NSIndexPath *indexPath) {
       
        IDselectSymptomViewController *selectedSymptom = [[IDselectSymptomViewController alloc] init];
    
        NSArray *array = kAccount.skills;
        
        NSMutableDictionary *diction = [NSMutableDictionary dictionary];
        [array enumerateObjectsUsingBlock:^(IDDoctorIsGoodAtDiseaseModel *model, NSUInteger idx, BOOL *stop) {
            
            // 疾病
            if (model.type == 1) { // 疾病
                
                NSMutableArray *array = [NSMutableArray array];
                
                [array addObjectsFromArray:diction[@"disease"]];
                
                [array addObject:model];
                
                [diction setObject:array forKey:@"disease"];
                
            } else if (model.type == 2) {
                
                NSMutableArray *array = [NSMutableArray array];
                
                [array addObjectsFromArray:diction[@"symptom"]];
                
                [array addObject:model];
                
                [diction setObject:array forKey:@"symptom"];
                
            }
            
        }];
        
        selectedSymptom.diction = diction;
        
        selectedSymptom.block = ^(NSArray *array, NSDictionary *diction) {
            
            
            InfoChangeRequest *request = [InfoChangeRequest request];
            request.good_disease_list = array;
            
            [MBProgressHUD showMessage:@"正在修改..." toView:self.view isDimBackground:NO];
            [ChangeInfoManger changeInfoWithInfoChangeRequest:request accountId:kAccount.doctor_id success:^(Account *account) {
                
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showSuccess:@"修改成功"];
                [AccountManager saveAccount:account];
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideHUDForView:self.view];
                [MBProgressHUD showError:error.localizedDescription];
                
                
            }];
 
        };
        
        [self.navigationController pushViewController:selectedSymptom animated:YES];
        
        
    }];
    
    ArrowRowModel *phone = [ArrowRowModel arrowRowModelWithTitle:@"办公室电话" subtitle:kAccount.office_phone destVC:nil];
    [phone setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        PhoneController *phone = [[PhoneController alloc] init];
        phone.title = @"修改办公室电话";        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:phone];
        [self presentViewController:nav animated:YES completion:nil];

    }];
    
    
    NSString *brief = nil;
    if (kAccount.brief != nil && kAccount.brief.length != 0) {
       
        brief = @"已填";
    } else {
    
        brief = @"未填";
    
    }
    
    ArrowRowModel *desc = [ArrowRowModel arrowRowModelWithTitle:@"简介" subtitle:brief destVC:nil];
    [desc setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        DescController *desc = [[DescController alloc] init];
        desc.title = @"简介";
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:desc];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[region, hospital, department, pTitle, tags, phone, desc]];
    [self.sectionModelArray addObject:sectionModel];

}
- (void)alertPhotoChooseView
{
    GDPhotoChooseView *chooseView = [[GDPhotoChooseView alloc] init];
    [chooseView setPhotoChooseFromBlock:^(GDPhotoChooseFrom from) {
        
        [self choosePhotoWithPhotoChooseFrom:from];
    }];
    [chooseView show];
}

- (void)choosePhotoWithPhotoChooseFrom:(GDPhotoChooseFrom)from
{
    switch (from) {
        case GDPhotoChooseFromCamera:
            [self openCamera];
            break;
        case GDPhotoChooseFromAlbum:
            [self openPhotoAlbum];
            break;
            
        default:
            break;
    }
}
/**
 *  打开相机
 */
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
}

/**
 *  打开相册
 */
- (void)openPhotoAlbum
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    ipc.delegate = self;
    ipc.allowsEditing = YES;
    [self presentViewController:ipc animated:YES completion:nil];
    
}

#pragma mark - 图片选择控制器的代理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 1.销毁picker控制器
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 2.取的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    
    NSData *data = UIImageJPEGRepresentation(image, 0.2);
    
    
    NSString *str = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [self showMessage:@"上传中..."];
    [ChangeInfoManger uploadAvatarWithBase64String:str accountId:kAccount.doctor_id success:^(NSString *avatarURLString) {
        
        Account *accout = [AccountManager sharedInstance].account;
        accout.avatar_url = avatarURLString;
        [AccountManager saveAccount:accout];
        
        [self hidMessage];
        [self updateData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD showError:error.localizedDescription];
        
        [self hidMessage];
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.section ==0 && indexPath.row == 0) ? 95 : 60;
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
