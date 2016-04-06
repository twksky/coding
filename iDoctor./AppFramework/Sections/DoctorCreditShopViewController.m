//
//  DoctorCreditShopViewController.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/24.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "DoctorCreditShopViewController.h"
#import "EXUITextField.h"
#import <PureLayout.h>
#import "AccountManager.h"
#import "DoctorCreditShopCell.h"
#import "IDChooseScoreButton.h"

@interface DoctorCreditShopViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
DoctorCreditShopCellDelegate,
UITableViewDataSource
>

/**
 * 可兑换积分Label
 */
@property (nonatomic, strong) UILabel *availabelCreditLabel;
/**
 *  兑换现金标题
 */
@property (nonatomic, strong) UILabel *exchangeCreditTitle;
/**
 *  想要兑换积分输入框
 */
@property (nonatomic, strong) EXUITextField *exchangeCreditValueField;
/**
 *  兑换button
 */
@property (nonatomic, strong) UIButton *exchangeButton;
/**
 *  兑换比例提示Label
 */
@property (nonatomic, strong) UILabel *tipLabel;
/**
 *  商品展示table
 */
@property (nonatomic, strong) UITableView *goodsTableView;
/**
 *  商品数据源
 */
@property (nonatomic, strong) NSArray *goodsArray;

// ============
/**
 *  可选的积分展示tableView
 */
@property (nonatomic, strong) UITableView *scoreTableView;
/**
 *  可选的积分项数据源
 */
@property (nonatomic, strong) NSArray *score;
/**
 *  可选的积分对应的钱
 */
@property (nonatomic, strong) NSArray *scoreToRmb;
/**
 *  自定义的button，点击之后可选择积分
 */
@property (nonatomic, strong) IDChooseScoreButton *chooseBtn;

/**
 *  人民币符号
 */
@property (nonatomic, strong) UILabel *rmbSymbolLabel;
/**
 *  可兑换的人民币
 */
@property (nonatomic, strong) UILabel *rmbLabel;

// =============
@property (nonatomic, assign) CGFloat chooseBtnX;
@property (nonatomic, assign) CGFloat chooseBtnY;
@property (nonatomic, assign) CGFloat chooseBtnW;
@property (nonatomic, assign) CGFloat chooseBtnH;
/** 标识符 */
@property (nonatomic, assign) int btnTag;
@property (nonatomic, assign) int flag;
// ==============


@end

@implementation DoctorCreditShopViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavigationBarWithTitle:@"积分兑换" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:nil];
    
    [self setupViews];
    
    [self setCreditValue:[AccountManager sharedInstance].account.score];
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncGetGoodsListWithCompletionHandler:^(NSArray *goodModels) {
        [self dismissLoading];
        
        self.goodsArray = goodModels;
        [self.goodsTableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        [self showHint:[error localizedDescription]];
    }];
    
}

#pragma mark - 设置可选择的分数
- (NSArray *)score
{
    if (!_score) {
        _score = @[@"10积分",@"100积分",@"200积分",@"500积分",@"1000积分"];
        _scoreToRmb = @[@"1",@"10",@"21",@"60",@"150"];
    }
    return _score;
}




#pragma mark - private methods

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    UIView *contentView = self.view;
    
    // 添加可用积分Label
    [contentView addSubview:self.availabelCreditLabel];
    {
        
        [contentView addConstraint:[self.availabelCreditLabel autoAlignAxisToSuperviewAxis:ALAxisVertical]];
        [contentView addConstraint:[self.availabelCreditLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20.0f]];
     
    }
    
    // 添加兑换现金标题
    [contentView addSubview:self.chooseBtn];
    {
        // 自己的上面距离可用积分Label下面20；
        [contentView addConstraint:[self.chooseBtn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.availabelCreditLabel withOffset:20.0f]];
        
        // 距离父控件左边20
        [contentView addConstraint:[self.chooseBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        
        //固定 100 x 35
        [contentView addConstraints:[self.chooseBtn autoSetDimensionsToSize:CGSizeMake(120.0f, 35.0f)]];

    }
    
    // 添加人民币符号
    [contentView addSubview:self.rmbSymbolLabel];
    {
        [contentView addConstraint:[self.rmbSymbolLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:150.0f]];
        [contentView addConstraint:[self.rmbSymbolLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.chooseBtn]];
        [contentView addConstraints:[self.rmbSymbolLabel autoSetDimensionsToSize:CGSizeMake(20.0f, 35.0f)]];
    }
    
    // 添加可以兑换人民币
    [contentView addSubview:self.rmbLabel];
    {
        // 左边接着选择button的右边
        [contentView addConstraint:[self.rmbLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.rmbSymbolLabel]];
        // 与选择图标水平对齐
        [contentView addConstraint:[self.rmbLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.rmbSymbolLabel]];
        [contentView addConstraint:[self.rmbLabel autoSetDimension:ALDimensionHeight toSize:35.0f]];
    }
    
    // 兑换按钮
    [contentView addSubview:self.exchangeButton];
    {
        //固定 宽70 高35
        [contentView addConstraints:[self.exchangeButton autoSetDimensionsToSize:CGSizeMake(70.0f, 35.0f)]];
        [contentView addConstraint:[self.exchangeButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
        [contentView addConstraint:[self.exchangeButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.rmbLabel]];
    }
    
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    
    [contentView addSubview:line];
    {
        [contentView addConstraints:[line autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, 0.7f)]];
        [contentView addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [contentView addConstraint:[line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.chooseBtn withOffset:25.0f]];
    }
    
    [contentView addSubview:self.goodsTableView];
    {
        [contentView addConstraint:[self.goodsTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line withOffset:20.0f]];
        [contentView addConstraint:[self.goodsTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        [contentView addConstraint:[self.goodsTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [contentView addConstraint:[self.goodsTableView autoPinEdgeToSuperviewEdge:ALEdgeRight]];
    }
    
}

- (void)setCreditValue:(NSInteger)value {
    
    self.availabelCreditLabel.text = [NSString stringWithFormat:@"可用积分: %ld", (long)value];
}

- (void)exchangeIt:(GoodsModel *)it {
    
    [self showLoading];
    [[AccountManager sharedInstance] asyncExchangeGoodsWithGoodsId:it.goodsId withCompletionHandler:^(NSInteger remainScore) {
        [self dismissLoading];
        
        [AccountManager sharedInstance].account.score = remainScore;
        [self setCreditValue:remainScore];
        
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }];
}

- (void)exchangeMoney:(NSInteger)money {
  
    [self showLoading];
    [[AccountManager sharedInstance] asyncExchangeMoney:money withCompletionHandler:^(Account *account) {
        [self dismissLoading];
        
        [self setCreditValue:account.score];
        [self showSimpleAlertWithTitle:@"提示" msg:@"兑换成功"];
        [self.chooseBtn setTitle:@"使用积分" forState:UIControlStateNormal];
        [self.chooseBtn setTitleColor:UIColorFromRGB(0xa3a3a3) forState:UIControlStateNormal];
        self.rmbLabel.text = @"0";
        
        
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        [self showSimpleAlertWithTitle:@"错误" msg:[error localizedDescription]];
    }];
}

#pragma mark - selector

- (void)exchangeButtonClicked:(id)sender {

    NSString *moneyStr = self.chooseBtn.currentTitle;
  
    if (!moneyStr || [moneyStr length] == 0) {
        
        [self showSimpleAlertWithTitle:@"提示" msg:@"兑换现金不能为空"];
        return;
    }
    
    NSInteger money = [moneyStr integerValue];
    
    if (money == 0) {
        
        [self showSimpleAlertWithTitle:@"提示" msg:@"亲，你还没有选择要兑换的积分数哦！"];
        return;
    }
    
    [self exchangeMoney:money];
}

#pragma mark - UITextFieldDelegate Methods

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:kNumbers] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    BOOL basic = [string isEqualToString:filtered];
    
    return basic;
}


#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.scoreTableView) {
        return self.score.count;
    }
    return [self.goodsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.scoreTableView) {
       
        static NSString *ID = @"scoreCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        }
        cell.textLabel.text = self.score[indexPath.row];

        cell.textLabel.textColor = UIColorFromRGB(0x54d0b8);
        return cell;
    }
    else
    {
        static NSString *DoctorCreditShopCellReusedIdentifier = @"67d65670-5cb3-4f36-9ee6-c9d593150ef2";
        DoctorCreditShopCell *cell = [tableView dequeueReusableCellWithIdentifier:DoctorCreditShopCellReusedIdentifier];
        GoodsModel *goodsModel = [self.goodsArray objectAtIndex:indexPath.row];
        
        if (!cell) {
            
            cell = [[DoctorCreditShopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DoctorCreditShopCellReusedIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        }
        
        [cell loadDataWithGoods:goodsModel];
        
        return cell;
    }
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.scoreTableView) {
        // 1.切换button的内容
        [self.chooseBtn setTitle:self.score[indexPath.row] forState:UIControlStateNormal];
        [self.chooseBtn setTitleColor:UIColorFromRGB(0x54d0b8) forState:UIControlStateNormal];
        
        // 2.显示能兑换多少钱
        self.rmbLabel.text = [NSString stringWithFormat:@"%@",self.scoreToRmb[indexPath.row]];
        
        // 3.隐藏下拉表格
        [self hidDropMenuWithDuration:0.25];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.scoreTableView) {
        return 44;
    }
    return 80.0f;
}

#pragma mark - DoctorCreditShopCellDelegate Methods

- (void)exchangedWithGoods:(GoodsModel *)goods {
    
    [self exchangeIt:goods];
}


#pragma mark - properties

- (UILabel *)availabelCreditLabel {
    
    if (!_availabelCreditLabel) {
        
        _availabelCreditLabel = [[UILabel alloc] init];
        _availabelCreditLabel.textColor = UIColorFromRGB(0x54d0b8);
    }
    
    return _availabelCreditLabel;
}


- (UIButton *)exchangeButton {
    
    if (!_exchangeButton) {
        
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_exchangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
        _exchangeButton.backgroundColor = UIColorFromRGB(0x54d0b8);
        _exchangeButton.layer.cornerRadius = 3.0f;
        [_exchangeButton addTarget:self action:@selector(exchangeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _exchangeButton;
}

- (UITableView *)goodsTableView {
    
    if (!_goodsTableView) {
        
        _goodsTableView = [[UITableView alloc] init];
        _goodsTableView.delegate = self;
        _goodsTableView.dataSource = self;
        _goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _goodsTableView;
}

- (NSArray *)goodsArray {
    
    if (!_goodsArray) {
        
        _goodsArray = [[NSArray alloc] init];
    }
    
    return _goodsArray;
}

- (IDChooseScoreButton *)chooseBtn
{
    if (!_chooseBtn) {
        _chooseBtn = [[IDChooseScoreButton alloc] init];
        [_chooseBtn setTitleColor:UIColorFromRGB(0x54d0b8) forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"DropDown"] forState:UIControlStateNormal];
        _chooseBtn.layer.borderWidth = 1.0;
        _chooseBtn.layer.borderColor = [UIColorFromRGB(0xe4e9e8) CGColor];
        [_chooseBtn setTitle:@"使用积分" forState:UIControlStateNormal];
        [_chooseBtn setTitleColor:UIColorFromRGB(0xa3a3a3) forState:UIControlStateNormal];
        [_chooseBtn addTarget:self action:@selector(chooseBtnClick:) forControlEvents:UIControlEventTouchDown];
    }
    return _chooseBtn;
}

- (UITableView *)scoreTableView
{
    if (!_scoreTableView) {
        _scoreTableView = [[UITableView alloc] init];
        _scoreTableView.backgroundColor = UIColorFromRGB(0xe4e9e8);
        _scoreTableView.scrollEnabled = NO;
        _scoreTableView.layer.borderWidth = 1.0;
        _scoreTableView.separatorColor = UIColorFromRGB(0xe4e9e8);
        
        _scoreTableView.layer.borderColor = [UIColorFromRGB(0xe4e9e8) CGColor];
        _scoreTableView.dataSource = self;
        _scoreTableView.delegate   = self;
        
    }
    return _scoreTableView;
}

- (UILabel *)rmbSymbolLabel
{
    if (!_rmbSymbolLabel) {
        _rmbSymbolLabel = [[UILabel alloc] init];
        _rmbSymbolLabel.text = @"￥";
        _rmbSymbolLabel.textColor = UIColorFromRGB(0xf1465a);
    }
    return _rmbSymbolLabel;
}

- (UILabel *)rmbLabel
{
    if (!_rmbLabel) {
        _rmbLabel = [[UILabel alloc] init];
        _rmbLabel.text = @"0";
        _rmbLabel.textColor = UIColorFromRGB(0xf1465a);
        _rmbLabel.font = [UIFont systemFontOfSize:28.0];
    }
    return _rmbLabel;
}

- (void)chooseBtnClick:(UIButton *)btn
{
    
    if (!_flag) {
        [self.view addSubview:self.scoreTableView];
        _chooseBtnX = self.chooseBtn.frame.origin.x;
        _chooseBtnY = self.chooseBtn.frame.origin.y;
        _chooseBtnW = self.chooseBtn.frame.size.width;
        _chooseBtnH = self.chooseBtn.frame.size.height;
        self.scoreTableView.frame = CGRectMake(_chooseBtnX, _chooseBtnY + _chooseBtnH, _chooseBtnW, 0.0);
        _flag = 1;
    }

    if (!_btnTag) {
        
        [self showDropMenuWithDuration:0.25];
    }
    else
    {
        [self hidDropMenuWithDuration:0.25];
    }

}
/**
 *  显示下拉菜单
 *
 *  @param duration 动画时间
 */
- (void)showDropMenuWithDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.scoreTableView.frame = CGRectMake(_chooseBtnX, _chooseBtnY + _chooseBtnH, _chooseBtnW, 44 * self.score.count);
    }];
    _btnTag = 1;
}
/**
 *  隐藏下拉菜单
 *
 *  @param duration 动画时间
 */
- (void)hidDropMenuWithDuration:(CGFloat)duration
{
    [UIView animateWithDuration:duration animations:^{
        self.scoreTableView.frame = CGRectMake(_chooseBtnX, _chooseBtnY + _chooseBtnH, _chooseBtnW, 0.0);
    }];
    _btnTag = 0;
}
@end
