//
//  ExchangeController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/27/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "ExchangeController.h"
#import "IDExchangeIntergerView.h"
#import "IDExchangeSuccessView.h"
#import "Account.h"
#import <CoreText/CoreText.h>
#import "GlideManger.h"

#import "CardViewController.h"

@interface ExchangeController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *detailArray;

@property (nonatomic, strong) IDExchangeIntergerView *exchangeIntergerView;


@end

@implementation ExchangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *string = [NSString stringWithFormat:@"%ld分",kAccount.score];
    
    [self.detailArray addObjectsFromArray:@[string, @"10积分",@"1元"]];
    
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.edges.equalTo(self.view);
        
    }];
 
    [self setupFooterView];
   
}
- (void)setupFooterView
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, App_Frame_Width, 80)];
    
    UIButton *exchangeBtn = [[UIButton alloc] init];
    
    exchangeBtn.layer.cornerRadius = 3;
    exchangeBtn.clipsToBounds = YES;
    [exchangeBtn setTitle:@"确认兑换" forState:UIControlStateNormal];
    [exchangeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exchangeBtn setBackgroundImage:[UIImage createImageWithColor:kNavBarColor] forState:UIControlStateNormal];
    [exchangeBtn addTarget:self action:@selector(exchangeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:exchangeBtn];
    [exchangeBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(20, 15, 20, 15));
    }];
    
    
    self.tableView.tableFooterView = footerView;
}


// 确认兑换按钮被点击了
- (void)exchangeBtnClicked:(UIButton *)button
{
   // 将需要兑换的积分取出来
    NSString *string = self.detailArray[1];
    NSArray *array = [string componentsSeparatedByString:@"积分"];
    
    NSString *needScore = array[0];
    
    if ([needScore integerValue] > kAccount.score) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"积分不足" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"确定兑换%@积分?",needScore] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1) { // 确定按钮被点击了
        
        NSString *string = self.detailArray[1];
        NSArray *array = [string componentsSeparatedByString:@"积分"];
        
        NSString *needScore = array[0];
        
        [MBProgressHUD showMessage:@"正在兑换..." toView:self.view isDimBackground:NO];
        [GlideManger exchangeMoneyWithScore:[needScore intValue] success:^(ExchangeMoney *money) {
            
            [MBProgressHUD hideHUDForView:self.view];
            // UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
   
            IDExchangeSuccessView *successView = [[IDExchangeSuccessView alloc] initWithImageName:@"exchange_success"];
            
            // 用了名片的毛玻璃
            CardViewController *cardVC = [[CardViewController alloc] initForView:successView];
            successView.delegate = cardVC;
            successView.delegateVC = self;
            cardVC.cancelBtn.hidden = YES;
            [cardVC showInViewController:self center:CGPointMake(self.view.bounds.size.width/2.f, self.view.bounds.size.height*2/3.f)];

           // successView.frame = keyWindow.bounds;

           //  [keyWindow addSubview:successView];

            kAccount.score -= [needScore integerValue];
            NSArray *banace = [self.detailArray[2] componentsSeparatedByString:@"元"];
            
            kAccount.balance += [banace[0] integerValue];
            
            NSArray *array = [self.detailArray[2] componentsSeparatedByString:@"元"];
            
            NSInteger banaces = [array[0] integerValue];
            
            
            kAccount.balance  += banaces * 100;
            
            NSLog(@"%ld", kAccount.balance);
            
            
            [[AccountManager sharedInstance] cacheAccount];
            
            [self.detailArray replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%ld分",kAccount.score]];
            
      
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view];
            [MBProgressHUD showError:error.localizedDescription toView:self.view];
            
            
        }];
        
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.detailArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
   static NSString *ident = @"ExchangeControllerCell";
    
    NSInteger row = indexPath.row;
    
    NSArray *array = @[@"积分余额",@"本次兑换",@"可获得   "];
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    for (UIView *view in cell.contentView.subviews) {
        
        if ([view isKindOfClass:[UILabel class]] || [view isKindOfClass:[UIView class]]) {
            
            [view removeFromSuperview];
        }
        
    }
    
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
    }
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.text = array[row];
    label1.font = [UIFont systemFontOfSize:15.0f];
    label1.textColor = UIColorFromRGB(0x353d3f);
    [cell.contentView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(cell.contentView).offset(15);
        make.centerY.equalTo(cell.contentView);
        
    }];

    UILabel *label2 = [[UILabel alloc] init];
    label2.text = self.detailArray[row];
    label2.textColor = UIColorFromRGB(0x36cacc);
    label2.font = [UIFont systemFontOfSize:15.0f];
    [cell.contentView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(label1.right).offset(26);
        make.centerY.equalTo(cell.contentView);
        
    }];

    if (row == 1) { // 本次兑换
        
        label2.textColor = UIColorFromRGB(0xcbcbcb);
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setImage:[UIImage imageNamed:@"down_arrows"] forState:UIControlStateNormal];
        [cell.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView).offset(-15);
            make.size.equalTo(CGSizeMake(12, 7));
            
        }];
        
    }
    
    
    UIView *segment = [[UIView alloc] init];
    segment.backgroundColor = UIColorFromRGB(0xeaeaea);
    [cell.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(cell.contentView).offset(0);
        make.bottom.equalTo(cell.contentView).offset(-1);
        make.size.equalTo(CGSizeMake(App_Frame_Width, 1));
        
    }];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) { // 本次兑换
    
        [self.view addSubview:self.exchangeIntergerView];

        __weak typeof(self.exchangeIntergerView) exchangeView = self.exchangeIntergerView;
        __weak typeof(self.detailArray) detailData = self.detailArray;
        __weak typeof(self.tableView) table = self.tableView;
        
        self.exchangeIntergerView.block = ^(NSString *text){
        
            [exchangeView removeFromSuperview];
            
            [detailData replaceObjectAtIndex:1 withObject:text];
            
            if ([text isEqualToString:@"10积分"]) {
                
                [detailData replaceObjectAtIndex:2 withObject:@"1元"];
                
            } else if ([text isEqualToString:@"100积分"]) {
                [detailData replaceObjectAtIndex:2 withObject:@"10元"];
            
            } else if ([text isEqualToString:@"200积分"]) {
                [detailData replaceObjectAtIndex:2 withObject:@"20元"];
            
            } else if ([text isEqualToString:@"500积分"]) {
                [detailData replaceObjectAtIndex:2 withObject:@"60元"];
                
            } else if ([text isEqualToString:@"1000积分"]) {
            
                [detailData replaceObjectAtIndex:2 withObject:@"150元"];
            }
        
            [table reloadData];
        
        };
        
        [self.exchangeIntergerView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.equalTo(self.view).offset(0);
            make.top.equalTo(self.view).offset(120);
            make.size.equalTo(CGSizeMake(App_Frame_Width, 300));

        }];
        
    }
    
}


- (NSMutableArray *)detailArray
{
    if (_detailArray == nil) {
        
        _detailArray = [NSMutableArray array];

    }
    
    return _detailArray;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _tableView;
}

- (IDExchangeIntergerView *)exchangeIntergerView
{
    if (_exchangeIntergerView == nil) {
        
        _exchangeIntergerView = [[IDExchangeIntergerView alloc] init];
    }
    
    return _exchangeIntergerView;
}




//- (void)setUpSection0
//{
//    NSString *scoreStr = [NSString stringWithFormat:@"积分余额   %ld分",kAccount.score];
//    NSMutableAttributedString *score = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"积分余额   %ld分",kAccount.score]];
//    [score addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0,2)];
//    
//    BaseRowModel *jfye = [BaseRowModel baseRowModelWithTitle:scoreStr];
//    
//    RecruitTitleRowModel *bcdh = [RecruitTitleRowModel recruitTitleRowModelWithTitle:@"本次兑换" placeholder:@"请输入积分" keyboardType:UIKeyboardTypeNumberPad];
//    RecruitTitleRowModel *khd = [RecruitTitleRowModel recruitTitleRowModelWithTitle:@"可获得" placeholder:@"0元" keyboardType:(UIKeyboardType)(-1)];
//
//    SectionModel *sectionModel = [SectionModel sectionModelWithRowModelArray:@[jfye,bcdh, khd]];
//    [self.sectionModelArray addObject:sectionModel];
//}



@end
