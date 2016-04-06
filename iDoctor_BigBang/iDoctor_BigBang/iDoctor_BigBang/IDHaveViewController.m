//
//  IDHaveViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/16.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDHaveViewController.h"
#import "IDMyCardViewController.h"
#import "IDHavePatientViewController.h"
#import "IDPatientCaseDetailViewController.h"
#import "IDNoFinishController.h"

#import "IDHaveTableViewCell.h"
#import "IDpatientCaseTableViewCell.h"
#import "IWantPatientCell.h"

#import "IDIHavePatientManager.h"
#import "IDGetDoctorPatient.h"

#import "IDMedicaledModel.h"
#import "IWantPatientViewController.h"

#import "IDPatientMessageViewController.h"

#import "AccountManager.h"
#import "Account.h"

#import "ContactManager.h"


@interface IDHaveViewController ()<UITableViewDelegate, UITableViewDataSource,IDHaveTableViewCellDelegate>

{
    UIView * bgView;
}

// 设置头部的选择条
@property (nonatomic, strong) UIView *topView;

// 分段选择器
@property (nonatomic, strong) UISegmentedControl *segment;


// 底部的列表显示(新增患者病例)
@property (nonatomic, strong) UITableView *patientTableView;

// 底部的列表显示(患者病例记录)
@property (nonatomic, strong) UITableView *patientCaseTableView;


// 用一个数组来装未完成的病例
@property (nonatomic, strong) NSMutableArray *noFinishArray;

// 已完成数组
@property (nonatomic, strong) NSMutableArray *finishArray;

// 用作提示的小灰字
@property (nonatomic, strong) UILabel *tipLabel;




// 字典 -- 用来存储相对应的数组
@property (nonatomic, strong) NSMutableDictionary *datasDic;

// 用来存储当前的数组
@property (nonatomic, strong) NSMutableArray *modelDatas;

// 放置一个数组 用来保存除A~Z外的其他排序
@property (nonatomic, strong) NSMutableArray *unsteadyArray;

// 用一个数组来储存有序的字母
@property (nonatomic, strong) NSMutableArray *upperArray;
@property(nonatomic, strong) IWantPatientViewController *wantP;


@property (nonatomic, assign) NSInteger row;



@end

@implementation IDHaveViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.row = 0;
    self.title = @"我有患者";
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.view).with.offset(0);
        make.height.equalTo(@49);
    }];
    
    
    [self.view addSubview:self.patientTableView];
    [self.patientTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.topView.bottom).with.offset(0);
        make.height.equalTo(App_Frame_Height - 49 - 44);
    }];
    
    // 得到一组数据
     [self getFlaseData];
    
    // [self.navigationController popToRootViewControllerAnimated:YES];
}

// 得到数据
- (NSArray *)getFlaseData
{
    [self removeView];
    
    NSMutableArray *array = [NSMutableArray array];

//    
//    [MBProgressHUD showMessage:@"加载中..." toView:self.view isDimBackground:NO];
//    
//    [[IDIHavePatientManager sharedInstance] getPatientsInformationWithDoctorID:kUser withCompletionHandelr:^(NSArray *arr) {
//        
//        [MBProgressHUD hideHUDForView:self.view];
//        // 得到数据
        [array addObjectsFromArray:[ContactManager sharedInstance].iHavePatientArr];
//
        // 将数据根据名字 进行排序
        [self setDatasWithArray:array];
//
        [self.patientTableView reloadData];
        [self newAlertView];
//
//    } withErrorHandler:^(NSError *error) {
//        
//        self.row = 0;
//        
//        [self errorView];
//        
//        [MBProgressHUD hideHUDForView:self.view];
//        [MBProgressHUD showError:error.localizedDescription toView:self.view];
//        
//        
//    }];
    
    return array;
    
    
}

//点击头像进入详情页
-(void)intoIDPatientMessageVC:(UIButton *)btn{
    
    //跳到联系人详情界面
    IDPatientMessageViewController *infoViewController = [[IDPatientMessageViewController alloc] init];
    if (btn.tag != [kDoctorAssistantID intValue]) {
        infoViewController.patient_id = btn.tag;
        [self.navigationController pushViewController:infoViewController animated:YES];
    }
    
}


- (void)removeView
{
    for (UIView *view in self.view.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
            
            break;
        }
        
    }
}


- (void)errorView
{
    IDErrorView *errorView = [[IDErrorView alloc] init];
    errorView.block = ^(){
        
        if (self.row == 0) {
            
           [self getFlaseData];
            
        } else if (self.row == 1) {
        
            [self getMedicalDatas];
        
        }
        
        
    };
    
    [self.view addSubview:errorView];
    [errorView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(0);
        make.top.equalTo(self.view).offset(50);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 50));
        
    }];
}


#pragma mark - 得到相应的数组  这个地方有点乱

// 得到相应的字典  进行相应的转化
- (void)setDatasWithArray:(NSArray *)array
{
    
    // 得到数据 进行相应的排序
    [array enumerateObjectsUsingBlock:^(IDGetDoctorPatient *model, NSUInteger idx, BOOL *stop) {
        
        NSString *name = model.realname;
        
        // 返回相应的第一个元素
        NSString *first = [self returnFirstElement:name];
        
        // 将第一个元素  转成UTF8格式
        const char *firstElement = [first cStringUsingEncoding:NSUTF8StringEncoding];
        
        
        char element = firstElement[0];
        
        if (element > 'Z' || element < 'A') { // 其他特殊的字符
            
            [self judgeFromKey:@"#" model:model];
            
            
        } else { // ‘A’ ~ 'Z' 之间的字符
            
            
            [self judgeFromKey:first model:model];
            
            
        }
        
    }];
    
    
    
    // 由于排序中第一项是“#” 需要把“#”的放在最后一项 如果字典中第一项是“#”再进行相应的执行
    
    [self.datasDic.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        
        if ([key isEqualToString:@"#"]) {
            
            // 1 取出第一项的元素
            self.unsteadyArray = [self.datasDic objectForKey:@"#"];
            
            // 2 删除数组中的第一项元素
            [self.datasDic removeObjectForKey:@"#"];
            
            return ;
            
        } // 相反的 就不需要做相应的操作
        
        
    }];
    
    // 将得到的数组进行相应的排序
    [self upperArrayWithDic];
}


// 对数组进行相应的排序
- (void)upperArrayWithDic
{
    
    NSArray *array = [self.datasDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        
        NSComparisonResult result = [obj1 compare:obj2];
        
        return result;
    }];
    
    [self.upperArray addObjectsFromArray:array];
    
}



// 采用相应的方法进行判定
- (void)judgeFromKey:(NSString *)key model:(IDGetDoctorPatient *)model
{
    __block int i = 0;
    
    // 逻辑原理, 如果这个字母已经存在于字典中，则证明已经有一个元素了，若不存在字典中，则创建一个数组 将数组的元素塞进去
    if (self.datasDic.count == 0) { // 证明是首次启用 并加入相应的元素  所以不需要进行相应的判断
        
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:model];
        [self.datasDic setObject:array forKey:key];
        
    } else { // 之前已经往数组中添加了相应的元素了 所以需要进行相应的循环
        
        // 通过相应的key值进行相应的循环  若存在相应的key 则之前添加过相应的元素  若循环完成都没有找到相应的key 则创建相应的键值对
        [self.datasDic.allKeys enumerateObjectsUsingBlock:^(NSString *oldKey, NSUInteger idx, BOOL *stop) {
            
            if ([oldKey isEqualToString:key]) { // 存在了相应的key 值
                
                // 取出相应的数组
                NSMutableArray *array = [self.datasDic objectForKey:key];
                
                // 向数组中添加相应的元素
                [array addObject:model];
                
                // 用新的数组替换旧的数组
                [self.datasDic setObject:array forKey:key];
                
                i = 1;
                
                return ;
            }
            
        }];
        
        if (i == 0) {
            
            // 在字典中没有找到相应的数组
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:model];
            // 为字典增加新的字段
            [self.datasDic setObject:array forKey:key];
            
        }
        
    }
}

// 获取字符串首个字母的元素
- (NSString *)returnFirstElement:(NSString *)name
{
    
    NSString *first = nil;
    
    if (name.length == 0) {
        
        first = @" ";
        
        return first;
    }
    
    if (name) {
        
        NSMutableString *ms = [[NSMutableString alloc] initWithString:name];
        
        // 将汉字转成有音调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)ms , 0, kCFStringTransformMandarinLatin, NO)) {
            
        }
        
        // 将拼音的音调去掉
        if (CFStringTransform((__bridge CFMutableStringRef)ms , 0, kCFStringTransformStripDiacritics, NO)) {
            
            NSString *upperMs = ms.uppercaseString;
            
            first = [upperMs substringToIndex:1];
            
        }
        
    } 
    
    return first;
    
}


#pragma mark - 表的数据源和代理
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger section = 0;
    if (101 == tableView.tag) {
        
        section = [self numberOfPatient];
        
    } else if (102 == tableView.tag) {
        
        section = 2;
    }
    
    return section;
}

- (NSInteger)numberOfPatient
{
    if (self.unsteadyArray.count != 0) { // 证明有“#” “我的名片” 单成一个组
        
        return self.datasDic.count + 2;
        
    } else {
        
        return self.datasDic.count + 1;
        
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger row = 0;
    
    if (tableView.tag == 101) {
        
        row = [self numberofPatientSection:section];
        
    } else if (tableView.tag == 102) {
        
        if (section == 0) { // 未完成
            
            row = self.noFinishArray.count;
            
        } else { // 已完成
            
            row = self.finishArray.count;
        }
    }
    
    return row;
    
}

- (NSInteger)numberofPatientSection:(NSInteger)section
{
    if (section == 0) {
        
        return 1;
        
    } else if (self.unsteadyArray.count != 0) { // 证明有“#”
        
        if (section == self.datasDic.count + 1) {
            
            return self.unsteadyArray.count;
            
        } else {
            
            
            NSString *key = self.upperArray[section - 1];
            
            return [[self.datasDic objectForKey:key] count];
            
        }
        
    } else {
        
        NSString *key = self.upperArray[section - 1];
        
        return [[self.datasDic objectForKey:key] count];
        
    }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 分开处理
    UITableViewCell *cell = nil;
    
    // 取得对应的行和列
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (tableView.tag == 101) {
        
        if (self.unsteadyArray.count != 0) { // 证明有“#”
            
            if (section == 0) {
                
                UITableViewCell *zeroCell = [self getZeroCellWithIndexPath:indexPath tableView:tableView];
                
                cell = zeroCell;
                
            } else if (section == self.datasDic.count + 1) { // 最后一行
                
                
                IDGetDoctorPatient *model = self.unsteadyArray[row];
                
                IDHaveTableViewCell *moreCell = [self getMoreCellWithDic:model WithIndexPath:indexPath tableView:tableView];
                cell = moreCell;
                
            } else {
                
                
                NSString *key = self.upperArray[section - 1];
                
                IDGetDoctorPatient *model = [self.datasDic objectForKey:key][row];
                
                IDHaveTableViewCell *moreCell = [self getMoreCellWithDic:model WithIndexPath:indexPath tableView:tableView];
                
                cell = moreCell;
            }
            
        } else {
            
            
            if (section == 0) {
                
                UITableViewCell *zeroCell = [self getZeroCellWithIndexPath:indexPath tableView:tableView];
                
                cell = zeroCell;
                
            } else {
                
                NSString *key = self.upperArray[section - 1];
                
                IDGetDoctorPatient *model = [self.datasDic objectForKey:key][row];
                
                IDHaveTableViewCell *moreCell = [self getMoreCellWithDic:model WithIndexPath:indexPath tableView:tableView];
                cell = moreCell;
            }
            
        }
        
    } else if (tableView.tag == 102) {
        
        cell = [self getPatientCaseWithTableView:tableView indexPath:indexPath];
        
        
    }
    
    return cell;
}




// 患者病例记录的cell
- (IWantPatientCell *)getPatientCaseWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    
    IWantPatientCell *cell = [IWantPatientCell cellWithTableView:tableView];
    
    cell.avatarClickBlock = ^(PatientModel *patientModel, IDMedicaledModel *medicalModel){
        
        // 进入 患者 个人信息界面
        IDPatientMessageViewController *patientMsg = [[IDPatientMessageViewController alloc] init];
        patientMsg.medicalModel = medicalModel;
        
        [self.navigationController pushViewController:patientMsg animated:YES];
        
    };
    
    if (indexPath.section == 0) { // 未完成
        
        
        [cell setDataWithMedicaledModel:self.noFinishArray[indexPath.row]];
        
        
    } else { // 已完成
        
        [cell setDataWithMedicaledModel:self.finishArray[indexPath.row]];
        
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
    
    
}

// 得到第O组的cell
- (UITableViewCell *)getZeroCellWithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    static NSString *ident = @"patientTableViewZero";
    UITableViewCell *zeroCell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (zeroCell == nil) {
        
        zeroCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    // 图片
    zeroCell.imageView.layer.masksToBounds = YES;
    zeroCell.imageView.layer.cornerRadius = 16.0f;
    zeroCell.imageView.image = [UIImage imageNamed:@"myHavePatient_myCard"];
    
    //  正标题
    zeroCell.textLabel.font = [UIFont systemFontOfSize:15];
    zeroCell.textLabel.textColor = UIColorFromRGB(0x353d3f);
    zeroCell.textLabel.text = @"我的名片";
    
    // 副标题
    zeroCell.detailTextLabel.font = [UIFont systemFontOfSize:13];
    zeroCell.detailTextLabel.textColor = UIColorFromRGB(0xa8a8a8);
    zeroCell.detailTextLabel.text = @"新患者扫码添加";
    
    zeroCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return zeroCell;
    
}

// 得到其他组的cell
- (IDHaveTableViewCell *)getMoreCellWithDic:(IDGetDoctorPatient *)model WithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    static NSString *ident = @"IDHaveTableViewCell";
    IDHaveTableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (moreCell == nil) {
        
        moreCell = [[IDHaveTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    moreCell.delegate = self;
    
    
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    BOOL isHiden = NO;
    
    if (self.unsteadyArray.count != 0) { // 证明有“#”
        
        if (section == self.datasDic.count + 1) { // 最后一行
            
            if (self.unsteadyArray.count == (row + 1)) {
                
                isHiden = YES;
            }
            
        } else {
            
            
            NSString *key = self.upperArray[section - 1];
            
            if ([[self.datasDic objectForKey:key] count] == (row + 1)) {
                
                isHiden = YES;
            }
            
        }
        
    } else {
        
        
        NSString *key = self.upperArray[section - 1];
        
        if ([[self.datasDic objectForKey:key] count] == (row + 1)) {
            
            isHiden = YES;
            
        }
        
    }
    
    [moreCell getDataWithName:model indexPath:indexPath isHideSegment:isHiden];
    
    moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return moreCell;
    
}

// 增加患者按钮的点击事件
- (void)addPatientButtonClick:(UIButton *)button index:(NSIndexPath *)indexPath
{
    IDHavePatientViewController *havePatient = [[IDHavePatientViewController alloc] init];
    havePatient.block = ^(){
      
        self.segment.selectedSegmentIndex = 1;
        
         [self patientMedicalCase];
        
        
    };
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    IDGetDoctorPatient *model = nil;
    
    
    if (self.unsteadyArray.count != 0) { // 证明有“#”
        if (section == self.datasDic.count + 1) { // 最后一行
            
            model = self.unsteadyArray[row];
            
            
        } else {
            
            
            NSString *key = self.upperArray[section - 1];
            
            model = [self.datasDic objectForKey:key][row];
            
        }
        
    } else {
        
        NSString *key = self.upperArray[section - 1];
        
        model = [self.datasDic objectForKey:key][row];
        
    }
    
    havePatient.patient_id = [model.patient_id integerValue];
    
    [self.navigationController pushViewController:havePatient animated:YES];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    CGFloat height = 0;
    if (tableView.tag == 101) {
        
        if (section == 0) {
            
            height =  0.1;
            
        } else {
            
            height =  20;
        }
        
    } else if (tableView.tag == 102) {
        
        NSInteger noCount = self.noFinishArray.count;
        NSInteger count = self.finishArray.count;
        
        if (noCount == 0 && count != 0) {
            
            if (section == 0) {
                
                height = 0.1f;
                
            } else if (section == 1){
                
                height = 30.0f;
            }
            
        } else if (noCount !=0 && count == 0) {
            
            if (section == 0) {
                
                height = 30.0f;
                
            } else if(section == 1){
                
                height = 0.1f;
            }
            
        } else if (noCount == 0 && count == 0) {
            
            
            height = 0.1f;
            
        } else {
            
            height = 30.0f;
        }
        
    }
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) {
        
        return 75.0f;
        
    } else if (tableView.tag == 102) {
        
        
        return [IWantPatientCell height];
        
    }
    
    return 75.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    
    
    if (tableView.tag == 101) {
        
        headerView = [self viewWithPatientSection:section];
        
    } else  if (tableView.tag == 102) {
        
        if (self.noFinishArray.count != 0 && section == 0) {
            
            headerView = [self viewForHeaderInSection:section name:@"未完成"];
            
        } else if (self.finishArray.count != 0 && section == 1) {
            
            headerView = [self viewForHeaderInSection:section name:@"已完成"];
            
        }
        
    }
    
    return headerView;
    
}

// 根据名字创建一个相应的头部View
- (UIView *)viewForHeaderInSection:(NSInteger)section name:(NSString *)name
{
    UIView *hdView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 30)];
    hdView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    
    // 横线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xeaeaea);
    
    [hdView addSubview:line];
    [line makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(hdView);
        make.height.equalTo(1);
        make.left.right.equalTo(hdView);
    }];
    
    // 标题
    UILabel *tlb = [[UILabel alloc] init];
    tlb.backgroundColor = UIColorFromRGB(0xf8f8f8);
    tlb.text = name;
    tlb.textColor = UIColorFromRGB(0xa8a8aa);
    tlb.font = GDFont(12);
    
    [hdView addSubview:tlb];
    [tlb mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(hdView);
    }];
    
    return hdView;
    
}


- (UIView *)viewWithPatientSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    bgView.frame = CGRectMake(0, 0, App_Frame_Width, 20);
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 5, bgView.frame.size.width, 10);
    label.font = [UIFont systemFontOfSize:12];
    
    if (section == 0) {
        
    } else {
        
        if (self.unsteadyArray.count != 0) { // 证明有“#”
            
            if (section == self.datasDic.count + 1) {
                
                label.text = @"#";
                
            } else {
                
                NSString *key = self.upperArray[section - 1];
                
                label.text = key;
                
            }
            
        } else {
            
            
            NSString *key = self.upperArray[section - 1];
            
            label.text = key;
            
        }
        [bgView addSubview:label];
        
    }
    
    
    
    return bgView;
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 101) { // 新增患者病例
        
        [self patientTableViewSelectedWithTableView:tableView indexPath:indexPath];
        
    } else if (tableView.tag == 102){ // 患者病例记录
        
        
        
        if (indexPath.section == 0) { // 未完成
            
            IDNoFinishController *nofinishViewController = [[IDNoFinishController alloc] init];
            
            nofinishViewController.model = self.noFinishArray[indexPath.row];
            
            nofinishViewController.block = ^(){
            
                
                [self patientMedicalCase];
                
            
            };
            [self.navigationController pushViewController:nofinishViewController animated:YES];
            
        } else { // 已完成
            
            IDPatientCaseDetailViewController *patientCaseDetail = [[IDPatientCaseDetailViewController alloc] init];
            patientCaseDetail.isChat = YES;
            patientCaseDetail.model = self.finishArray[indexPath.row];
            [self.navigationController pushViewController:patientCaseDetail animated:YES];
            
        }

    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// 新增患者病例被点击
- (void)patientTableViewSelectedWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    
    if (section == 0) { // 扫码界面
        
        IDMyCardViewController *myCard = [[IDMyCardViewController alloc] init];
        [self.navigationController pushViewController:myCard animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
}


#pragma mark - 懒加载
- (UIView *)topView
{
    if (_topView == nil) {
        
        _topView = [[UIView alloc] init];
        _topView.layer.borderWidth = 0.5;
        _topView.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
        _topView.backgroundColor = UIColorFromRGB(0xffffff);
        
        
        NSArray *items = @[@"新增患者病历",@"患者病历记录"];
        // 初始化UISegmetsController
        self.segment = [[UISegmentedControl alloc] initWithItems:items];
        
        self.segment.selectedSegmentIndex = 0;
        self.segment.tintColor = UIColorFromRGB(0x36cacc);
        self.segment.momentary = NO;
        [self.segment addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventValueChanged];
        [_topView addSubview:self.segment];
        [self.segment mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_topView).with.offset(15);
            make.top.equalTo(_topView).with.offset(11);
            make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 27));
            
        }];
        
    }
    
    return _topView;
}


// 分段选择器的点击事件
- (void)segmentClicked:(UISegmentedControl *)segment
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (segment.selectedSegmentIndex == 0) {
        
        [self.tipLabel removeFromSuperview];
        [self.patientCaseTableView removeFromSuperview];
        [self.view addSubview:self.patientTableView];
        [self.patientTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.view).with.offset(0);
            make.right.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.topView.bottom).with.offset(0);
            make.height.equalTo(App_Frame_Height - 49 - 44);
        }];
        
        [self.patientTableView reloadData];
        
    } else {
        
        [self patientMedicalCase];
        
    }
    
    
}


// 患者病例记录
- (void)patientMedicalCase
{
    // 进行相应的网络请求
    [self.patientTableView removeFromSuperview];
    
    [self.view addSubview:self.patientCaseTableView];
    [self.patientCaseTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.top.equalTo(self.topView.bottom).with.offset(0);
        make.height.equalTo(App_Frame_Height - 49 - 44);
    }];
    
    [self getMedicalDatas];

}



// 患者病历记录
- (void)getMedicalDatas
{
    [self.finishArray removeAllObjects];
    [self.noFinishArray removeAllObjects];
    [self removeView];
    
    [MBProgressHUD showMessage:@"加载中..." toView:self.view isDimBackground:NO];
    
    [[IDIHavePatientManager sharedInstance] getPatientMedicalCaseWithDoctorID:(int)[AccountManager sharedInstance].account.doctor_id withCompletionHandelr:^(NSArray *arr) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        if (arr.count == 0) { // 没有
            
//            self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
//            [self.patientCaseTableView removeFromSuperview];
//            [self.view addSubview:self.tipLabel];
//            self.tipLabel.text = @"您暂时没有患者病例记录";
//            [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                
//                make.left.equalTo(self.view).with.offset(0);
//                make.center.equalTo(self.view);
//                make.width.equalTo(App_Frame_Width);
//            }];
//
            
            UIView *view = [self tipViewWithName:@"您暂时没有患者病例记录"];
            [self.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.left.equalTo(self.view).offset(0);
                make.top.equalTo(self.topView.bottom).offset(0);
                make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 49));
                
            }];
            
            
        } else {
            
            [arr enumerateObjectsUsingBlock:^(IDMedicaledModel *model, NSUInteger idx, BOOL *stop) {
                
                // 分成 未完成  和 已完成
                
                if (model.finish == YES) { // 已完成
                    
                    [self.finishArray addObject:model];
                    
                } else { // 未完成
                    
                    [self.noFinishArray addObject:model];
                }
                
                
                
            }];
            
            [self.patientCaseTableView reloadData];
            
        }
        
        
        
        
    } withErrorHandler:^(NSError *error) {
        
        self.row = 1;
        [self errorView];
        
        [MBProgressHUD hideHUDForView:self.view];
        [MBProgressHUD showError:error.localizedDescription toView:self.view];
    }];

}


- (UITableView *)patientTableView
{
    if (_patientTableView == nil) {
        
        
        _patientTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _patientTableView.delegate = self;
        _patientTableView.dataSource = self;
        _patientTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _patientTableView.tag = 101;
    }
    
    return _patientTableView;
    
    
    
}

- (NSMutableDictionary *)datasDic
{
    if (_datasDic == nil) {
        
        _datasDic = [NSMutableDictionary dictionary];
        
    }
    return _datasDic;
}


- (NSMutableArray *)unsteadyArray
{
    if (_unsteadyArray == nil) {
        
        _unsteadyArray = [NSMutableArray array];
    }
    return _unsteadyArray;
}

- (NSMutableArray *)upperArray
{
    if (_upperArray == nil) {
        
        _upperArray = [NSMutableArray array];
    }
    
    return _upperArray;
    
}

- (UITableView *)patientCaseTableView
{
    if (_patientCaseTableView == nil) {
        
        _patientCaseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _patientCaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _patientCaseTableView.delegate = self;
        _patientCaseTableView.dataSource = self;
        _patientCaseTableView.tag = 102;
        _patientCaseTableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    
    return _patientCaseTableView;
    
}

// 未完成
- (NSMutableArray *)noFinishArray
{
    if (_noFinishArray == nil) {
        
        _noFinishArray = [NSMutableArray array];
    }
    
    return _noFinishArray;
}

// 已完成
- (NSMutableArray *)finishArray
{
    if (_finishArray == nil) {
        
        _finishArray = [NSMutableArray array];
    }
    
    return _finishArray;
}

- (UILabel *)tipLabel
{
    if (_tipLabel == nil) {
        
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.font = [UIFont systemFontOfSize:13.0f];
        _tipLabel.textColor = UIColorFromRGB(0xa8a8a8);
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _tipLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 自定义提示框

-(void)newAlertView {
    NSUserDefaults * uds = [NSUserDefaults standardUserDefaults];
    NSString * alerts = [uds objectForKey:@"ihavePatient_alerts"];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if ([alerts isEqualToString:@"agrees"]) {
        
    }else{
        bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(keyWindow.frame), CGRectGetHeight(keyWindow.frame))];
        [keyWindow addSubview:bgView];
        
        UIView * blackView = [[UIView alloc]initWithFrame:bgView.frame];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.5;
        [bgView addSubview:blackView];
        
        UIImageView * myAlertImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ihavePatient_alert"]];
        myAlertImageView.frame = CGRectMake(50, CGRectGetHeight(self.view.frame)/2 - (CGRectGetWidth(self.view.frame)-80)/3 - 50, CGRectGetWidth(self.view.frame)-80, (CGRectGetWidth(self.view.frame)-80)/1.5);
        [bgView addSubview:myAlertImageView];
        
        UIButton * myBtn1 = [[UIButton alloc]initWithFrame:CGRectMake(50, CGRectGetHeight(self.view.frame)/2 + (CGRectGetWidth(self.view.frame)-80)/3 - 30, (CGRectGetWidth(self.view.frame)-80)/2-30, ((CGRectGetWidth(self.view.frame)-80)/2-30)/2.67)];
        myBtn1.tag = 1;
        [myBtn1 setBackgroundImage:[UIImage imageNamed:@"ihavePatient_sayyes"] forState:0];
        [myBtn1 addTarget:self action:@selector(alertBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * myBtn2 = [[UIButton alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-80)/2+50, CGRectGetHeight(self.view.frame)/2 + (CGRectGetWidth(self.view.frame)-80)/3 - 30,(CGRectGetWidth(self.view.frame)-80)/2-30, ((CGRectGetWidth(self.view.frame)-80)/2-30)/2.67)];
        myBtn2.tag = 2;
        [myBtn2 setBackgroundImage:[UIImage imageNamed:@"ihavePatient_notips"] forState:0];
        [myBtn2 addTarget:self action:@selector(alertBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        
        [bgView addSubview:myBtn1];
        [bgView addSubview:myBtn2];
    }
}

-(void)alertBtn:(UIButton *)sender {
    NSUserDefaults * uds = [NSUserDefaults standardUserDefaults];
    if (sender.tag == 1) {
        
        
    }else {
        [uds setObject:@"agrees" forKey:@"ihavePatient_alerts"];
        [uds synchronize];
    }
    
    bgView.hidden = YES;
}

@end
