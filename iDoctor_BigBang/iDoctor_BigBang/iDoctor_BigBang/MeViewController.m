//
//  MeViewController.m
//  
//
//  Created by 周世阳 on 15/9/14.
//
//

#import "MeViewController.h"
#import "MyInfoController.h"
#import "IntegralRuleController.h"
#import "TimeController.h"
#import "TemplateController.h"
#import "PriceController.h"
#import "Account.h"
#import "AccountManager.h"
#import "TagView.h"
#import "MyIntegralController.h"
#import "MyBalacneController.h"
#import "IDSelectTimeViewController.h"
#import "SettingController.h"
#import "LoginViewController.h"
#import "IDAppManager.h"
#import "LoginManager.h"

#import "ChangeInfoManger.h"

@interface MeViewController ()

@property (nonatomic, strong) ArrowRowModel *time;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setUpData
{
    [self setUpSection0];
    [self setUpSection1];
//    [self setUpSection2];
}
- (void)setUpSection0
{
    BriefIntroRowModel *briefItro = [BriefIntroRowModel briefIntroRowWithAccountModel:kAccount];
    
    [briefItro setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        MyInfoController *myInfo = [[MyInfoController alloc] init];
        myInfo.title = @"我的资料";
        [self.navigationController pushViewController:myInfo animated:YES];
    }];
    
    [briefItro setIntegralBtnClickBlock:^{
        
        MyBalacneController *myBalance = [[MyBalacneController alloc] init];
        myBalance.title = @"我的余额";
        [self.navigationController pushViewController:myBalance animated:YES];

    }];
    
    [briefItro setBalacneBtnClickBlock:^{
        
        MyIntegralController *myInte = [[MyIntegralController alloc] init];
        myInte.title = @"我的积分";
        [self.navigationController pushViewController:myInte animated:YES];
        
        
    }];
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[briefItro]];
    [self.sectionModelArray addObject:sectionModel];
}
- (void)setUpSection1
{
    ArrowRowModel *integral = [ArrowRowModel arrowRowWithIcon:[UIImage imageNamed:@"integral"]
                                                        title:@"积分规则"
                                                       destVC:[IntegralRuleController class]];
    
    NSArray *array = kAccount.work_time_list;
    
    NSString *string = nil;
    if (array.count == 0) {
        
        string = @"未选";
    } else {
    
        string = @"已选";
    
    }
    
    _time = [ArrowRowModel arrowRowModelWithIcon:[UIImage imageNamed:@"time"]
                                                         title:@"门诊时间"
                                                      subtitle:string
                                                        destVC:nil];

    __weak ArrowRowModel *timeModel = self.time;
    __weak UITableView *tbv = self.tbv;
    __weak UINavigationController *nav = self.navigationController;
    
    __weak UIViewController *twSelf = self;
    [self.time setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        IDSelectTimeViewController *iDSelectTimeViewController = [[IDSelectTimeViewController alloc] init];
        NSLog(@"%@", kAccount.work_time_list);
        
        iDSelectTimeViewController.selectTimeArray = kAccount.work_time_list;
        
        iDSelectTimeViewController.block = ^(NSArray *timeArray){
            
            NSLog(@"%@", timeArray);

            InfoChangeRequest *que = [[InfoChangeRequest alloc] init];
            que.work_time_list = timeArray;
            
            [MBProgressHUD showMessage:@"正在保存..." toView:twSelf.view isDimBackground:NO];
            [ChangeInfoManger changeInfoWithInfoChangeRequest:que accountId:kAccount.doctor_id success:^(Account *account) {
                
                [MBProgressHUD hideHUDForView:twSelf.view];
                 [MBProgressHUD showSuccess:@"修改成功" toView:twSelf.view];
                if (!kAccount.work_time_list || kAccount.work_time_list.count == 0) {
                    
                    timeModel.subtitle = @"未选";
                    
                } else {
                    
                    timeModel.subtitle = @"已选";
                }
                
                [tbv reloadData];
                
               
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD hideHUDForView:twSelf.view];
                [MBProgressHUD showError:error.localizedDescription toView:twSelf.view];
                
                
            }];
            

            
            //TODO 同步网络状态
        };
        
        [nav pushViewController:iDSelectTimeViewController animated:YES];
    }];
    
    ArrowRowModel *template = [ArrowRowModel arrowRowWithIcon:[UIImage imageNamed:@"template"]
                                                        title:@"问诊模板设置"
                                                       destVC:[TemplateController class]];
    
    ArrowRowModel *setting = [ArrowRowModel arrowRowWithIcon:[UIImage imageNamed:@"setting"]
                                                        title:@"设置"
                                                       destVC:[SettingController class]];

    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[integral, self.time, template, setting]];
    
    [self.sectionModelArray addObject:sectionModel];
}
- (void)setUpSection2
{
    LogoutModel *test = [LogoutModel logoutModelWithIcon:[UIImage imageNamed:@"logout"] title:@"安全退出"];
    [test setRowSelectedBlock:^(NSIndexPath *indexPath) {
        
        [MBProgressHUD showMessage:@"正在退出..." toView:self.view isDimBackground:NO];
        
       [[AccountManager sharedInstance] resignLoginWithCompletionHandler:^() {
           
           [MBProgressHUD hideHUDForView:self.view];
           [MBProgressHUD showSuccess:nil toView:self.view];
           // 清除缓存
           NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
           
//           [userDefault removeObjectForKey:@"loginName"];
           [userDefault removeObjectForKey:@"password"];
           
           // 将界面转到相应的登陆界面
           [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
           
          //  [IDAppManager chooseRootController];
           [LoginManager sharedInstance].loginStatus = LOGINSTATUS_NONE;
           
       
       } withErrorHandler:^(NSError *error) {
           
           [MBProgressHUD hideHUDForView:self.view];
           
           if ([error.localizedDescription isEqualToString:@"你的账号已在其他地方登录，请重新登录"]) {
              
               // 清除缓存
               NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
               
//               [userDefault removeObjectForKey:@"loginName"];
               [userDefault removeObjectForKey:@"password"];
               
               [IDAppManager chooseRootController];
               
               // 将界面转到相应的登陆界面
            UIWindow *windown = [UIApplication sharedApplication].keyWindow;
               
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
               windown.rootViewController = nav;
               
           }

       }];
 
    }];
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[test]];
    [self.sectionModelArray addObject:sectionModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return (indexPath.section == 0) ? 215 : 60;
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
