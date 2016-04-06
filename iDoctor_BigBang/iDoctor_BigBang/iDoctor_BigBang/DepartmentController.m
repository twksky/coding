//
//  DepartmentController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/18/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "DepartmentController.h"

@interface DepartmentController ()
@property(nonatomic, strong) NSArray *dpArray;
@end

@implementation DepartmentController

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
    NSMutableArray *tmpArrM = [NSMutableArray array];
    
    [self.dpArray enumerateObjectsUsingBlock:^(NSString *dpNmae, NSUInteger idx, BOOL *stop) {
        
        CheckMarkRowModel *check = [CheckMarkRowModel checkMarkRowModelWithTitle:dpNmae];
        [check setRowSelectedBlock:^(NSIndexPath *indexPath) {
            
            [self checkMarkWithIndexPath:indexPath];
        }];
        [tmpArrM addObject:check];
    }];
    
    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:tmpArrM];
  
    [self.sectionModelArray addObject:sectionModel];
    
}


- (void)checkMarkWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tbv cellForRowAtIndexPath:indexPath];
    
    [self.navigationController.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop)
     {
         
         if (self.xxxxBlock) {
             self.xxxxBlock(self.dpArray[indexPath.row]);
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
                 request.department = cell.textLabel.text;
                 
                 [self showMessage:@"修改中..."];
                 [ChangeInfoManger changeInfoWithInfoChangeRequest:request accountId:kAccount.doctor_id success:^(Account *account) {
                     
                     [AccountManager saveAccount:account];
                     [self hidMessage];
                     cell.accessoryType = UITableViewCellAccessoryCheckmark;
                     
                     [self.navigationController popViewControllerAnimated:YES];
                     
                 } failure:^(NSError *error) {
                     
                     [MBProgressHUD showError:error.localizedDescription toView:self.view];
                     [self hidMessage];
                     [self.navigationController popViewControllerAnimated:YES];
                 }];
             }
         }
     }];
}

- (void)setXxxxBlock:(XXXXBlock)xxxxBlock
{
    _xxxxBlock = xxxxBlock;
}
- (NSArray *)dpArray
{
    if (_dpArray == nil) {
        _dpArray = @[  @"ICU",
                       @"变态反应",
                       @"病理科"	,
                       @"超声科"	,
                       @"传染科"	,
                       @"儿科",
                       @"耳鼻咽喉科",
                       @"放疗科"	,
                       @"放射科"	,
                       @"风湿免疫科",
                       @"妇产科"	,
                       @"肛肠科"	,
                       @"公共卫生",
                       @"功能检查科",
                       @"骨外科"	,
                       @"核医学"	,
                       @"呼吸内科",
                       @"护理科"	,
                       @"基础学科",
                       @"急诊科"	,
                       @"检验科"	,
                       @"精神科"	,
                       @"康复科"	,
                       @"科教科",
                       @"口腔科"	,
                       @"老年病科",
                       @"流行病科",
                       @"麻醉科"	,
                       @"泌尿外科",
                       @"内分泌科",
                       @"内科",
                       @"皮肤性病科",
                       @"普通外科",
                       @"其它科室",
                       @"器官移植",
                       @"全科",
                       @"烧伤外科",
                       @"神经内科",
                       @"神经外科",
                       @"肾脏内科",
                       @"生殖中心",
                       @"输血相关科室",
                       @"体检中心",
                       @"外科",
                       @"消化内科",
                       @"心胸外科",
                       @"心血管内科",
                       @"血管外科",
                       @"血液科"	,
                       @"眼科",
                       @"药学相关科室",
                       @"营养科"	,
                       @"影像医学其他",
                       @"预防医学",
                       @"整形外科",
                       @"职业病科",
                       @"中西医结合科",
                       @"中医科"	,
                       @"肿瘤科"
                       ];
    }
    return _dpArray;
}
@end
