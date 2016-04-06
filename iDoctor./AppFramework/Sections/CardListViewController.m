//
//  CardListViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/5/14.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "CardListViewController.h"
#import "UIView+AutoLayout.h"
#import "CardListCardCell.h"
#import "CardListHeaderCell.h"
#import "CardAddViewController.h"
#import "AccountManager.h"
#import "Bankcard.h"

@interface CardListViewController ()
<
CardAddViewControllerDelegate
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *cardListHeaderCell;

@property (nonatomic, strong) NSArray *bankCardArray;

@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarWithTitle:@"选择银行" leftBarButtonItem:nil rightBarButtonItem:nil];
    
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = UIColorFromRGB(0xeef1f1);
    
    
    //Test TODO 隐藏分割线 在没有footerview和headerivew的情况下
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self.tableView setTableFooterView:view];
    [self.tableView setTableHeaderView:view];
    
    //AutoLayout
    {
        [self.view addConstraints:[self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(10, 0, 0, 0)]];
    }
    
    [self updateBankCardLst];
}


#pragma mark - private methods

- (void)updateBankCardLst {
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncGetBankcardListWithCompletionHandler:^(NSArray *bankcardArray) {
        [self dismissLoading];
        
        self.bankCardArray = bankcardArray;
        [self.tableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:[[error userInfo] objectForKey:NSLocalizedDescriptionKey] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    }];
}


#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (0 == section) {
        
        return 1;
    }
    
    if (1 == section) {
        
        return [self.bankCardArray count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CardListCardCellResuedIdentifier = @"e291d8b5-97af-43ed-a982-1ac93fa8f77d";
    
    UITableViewCell *cell;
    if (0 == indexPath.section) {
        
        CardListHeaderCell *headerCell = [[CardListHeaderCell alloc] init];
        cell = headerCell;
    }
    else {
        
        Bankcard *card = [self.bankCardArray objectAtIndex:indexPath.row];
        CardListCardCell *cardCell = [tableView dequeueReusableCellWithIdentifier:CardListCardCellResuedIdentifier];
        if (!cardCell) {
            
            cardCell = [[CardListCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CardListCardCellResuedIdentifier];
        }
        
//        cardCell.cardNumberLabel.text = card.cardID;
        cardCell.cardNumberLabel.text = card.cardName; //TODO 服务器数据不正确
        cardCell.bankNameLabel.text = card.cardID;
        
        cell = cardCell;
    }
    
    
    return cell;
}

#pragma mark - UITableView DelegateMethods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (0 == indexPath.section) {

        CardAddViewController *cav = [[CardAddViewController alloc] init];
        cav.delegate = self;
        [self.navigationController pushViewController:cav animated:YES];
    }
    else if (1 == indexPath.section) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedCard:)]) {
            
            Bankcard *card = [self.bankCardArray objectAtIndex:indexPath.row];
            [self.delegate didSelectedCard:card];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

#pragma mark - CardAddViewControllerDelegate Methods

- (void)didAddCard:(Bankcard *)card {
    
    NSMutableArray *mutableBankCardArray = [[NSMutableArray alloc] initWithArray:self.bankCardArray];
    [mutableBankCardArray addObject:card];
    
    self.bankCardArray = mutableBankCardArray;
    [self.tableView reloadData];
}


#pragma mark - properties

- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource =self;
    }
    
    return _tableView;
}

- (NSArray *)bankCardArray {
    
    if (!_bankCardArray) {
        
        _bankCardArray = [[NSArray alloc] init];
    }
    
    return _bankCardArray;
}

@end
