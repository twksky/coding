//
//  SendGiftViewController.m
//  AppFramework
//
//  Created by ABC on 8/24/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import "SendGiftViewController.h"
#import "SkinManager.h"
#import "UIView+AutoLayout.h"
#import "AccountManager.h"
#import "UserGiftRecordTableViewCell.h"

@interface SendGiftViewController ()
<
UITableViewDataSource, UITableViewDelegate
>

@property (nonatomic, strong) UITableView   *contentTableView;
@property (nonatomic, assign) NSInteger     userIDCopy;
@property (nonatomic, strong) NSMutableArray    *giftRecordArray;
@property (nonatomic, strong) UILabel           *summaryLabel;
@property (nonatomic, strong) UIView            *headerView;
@property (nonatomic, strong) UILabel *flowerNumberLabel;
@property (nonatomic, strong) UILabel *flowerValueLabel;

- (void)setupSubviews;
- (void)setupConstraints;

@end

@implementation SendGiftViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithUserID:(NSInteger)userID
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.userIDCopy = userID;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentTableView.tableHeaderView = self.headerView;
    self.contentTableView.backgroundColor = UIColorFromRGB(0xedf2f1);
    
    [self setNavigationBarWithTitle:@"送花记录" leftBarButtonItem:nil rightBarButtonItem:nil];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [SkinManager sharedInstance].defaultViewBackgroundColor;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self setupSubviews];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
//    [[SkinManager sharedInstance] navigationRootViewControllerSizeToFit:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[AccountManager sharedInstance] asyncGetUserGiftRecordWithUserID:self.userIDCopy withCompletionHandler:^(NSArray *recordArray) {
        self.giftRecordArray = [[NSMutableArray alloc] initWithArray:recordArray];
        [self.contentTableView reloadData];
        
        NSInteger sendedGiftCount = 0;  // 送花多少朵
        long sendedGiftValue = 0;  // 送花价值
        NSInteger acceptedGiftCount = 0;    // 接收多少朵
        long acceptedGiftValue = 0;   // 接收价值
        for (GiftItem *giftItem in recordArray) {
            sendedGiftCount += giftItem.number;
            sendedGiftValue += giftItem.money;
            if (giftItem.acceptState) {
                acceptedGiftCount += giftItem.number;
                acceptedGiftValue += giftItem.money;
            }
        }
        
        //sendedGiftCount 总送花数
        //sendedGiftValue 总送花价值
        //acceptedGiftCount 总接受花数
        //acceptedGiftValue 总接受花价值
        
        self.flowerNumberLabel.text = [NSString stringWithFormat:@"%ld朵花", sendedGiftCount];
        self.flowerValueLabel.text = [NSString stringWithFormat:@"(%.02f元)", sendedGiftValue / 100.0f];
        
        NSString *summaryText = [NSString stringWithFormat:@"患者共计送花%ld朵 价值%.02f元\n您接收他的花%ld朵 价值%.02f元",
                                 (long)sendedGiftCount, (sendedGiftValue / 100.0f), acceptedGiftCount, (acceptedGiftValue / 100.0f)];
        [self.summaryLabel setText:summaryText];
    } withErrorHandler:^(NSError *error) {
        
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Property

- (UITableView *)contentTableView
{
    if (!_contentTableView) {
        _contentTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _contentTableView.dataSource = self;
        _contentTableView.delegate = self;
    }
    return _contentTableView;
}

- (NSMutableArray *)giftRecordArray
{
    if (!_giftRecordArray) {
        _giftRecordArray = [[NSMutableArray alloc] init];
    }
    return _giftRecordArray;
}

- (UILabel *)summaryLabel
{
    if (!_summaryLabel) {
        _summaryLabel = [[UILabel alloc] init];
        _summaryLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
        _summaryLabel.font = [UIFont systemFontOfSize:17.0f];
        _summaryLabel.textColor = [SkinManager sharedInstance].defaultHighlightBackgroundColor;
        _summaryLabel.numberOfLines = 0;
        _summaryLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _summaryLabel;
}

- (UIView *)headerView {
    
    if (!_headerView) {
        
        _headerView = [[UIView alloc] init];
        
        _headerView.frame = CGRectMake(0, 0, App_Frame_Width, 65    );
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        titleLabel.textColor = UIColorFromRGB(0x8e8e91);
        [titleLabel setText:@"该患者送花给我"];
        
        [_headerView addSubview:titleLabel];
        [_headerView addSubview:self.flowerNumberLabel];
        [_headerView addSubview:self.flowerValueLabel];
        
        //AutoLayout
        {
            [_headerView addConstraint:[titleLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            [_headerView addConstraint:[titleLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
            
            [_headerView addConstraint:[self.flowerNumberLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:titleLabel withOffset:10.0f]];
            [_headerView addConstraint:[self.flowerNumberLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
//
            [_headerView addConstraint:[self.flowerValueLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.flowerNumberLabel withOffset:10.0f]];
            [_headerView addConstraint:[self.flowerValueLabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.flowerNumberLabel]];
        }
        
    }
        
    return _headerView;
}

- (UILabel *)flowerNumberLabel {
    
    if (!_flowerNumberLabel) {
        
        _flowerNumberLabel = [[UILabel alloc] init];
        _flowerNumberLabel.font = [UIFont boldSystemFontOfSize:19.0f];
        _flowerNumberLabel.textColor = UIColorFromRGB(0x00B48C);
    }
    
    return _flowerNumberLabel;
}

- (UILabel *)flowerValueLabel {
    
    if (!_flowerValueLabel) {
        
        _flowerValueLabel = [[UILabel alloc] init];
        _flowerValueLabel.font = [UIFont systemFontOfSize:14.0f];
        _flowerValueLabel.textColor = UIColorFromRGB(0x00B48c);
    }
    
    return _flowerValueLabel;
}

#pragma mark - Private Method

- (void)setupSubviews
{
    [self.view addSubview:self.contentTableView];
    
    [self setupConstraints];
}

- (void)setupConstraints
{
    [self.view addConstraints:[self.contentTableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
}


#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (0 == section) {
//        return 1;
//    } else if (1 == section) {
        return [self.giftRecordArray count];
//    }
//    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (0 == [indexPath section]) {
//        static NSString *reusableCellIdentifier = @"2C7FBD91-0D90-4B45-B329-3D788556BF84";
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
//        if (!cell) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reusableCellIdentifier];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [cell.contentView addSubview:self.summaryLabel];
//            [cell.contentView addConstraints:[self.summaryLabel autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 10.0f)]];
//        }
//        
//        return cell;
//    } else if (1 == [indexPath section]) {
        static NSString *reusableCellIdentifier = @"56FEA229-F52E-4D7B-9D3C-A84495E62B4A";
        UserGiftRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reusableCellIdentifier];
        if (!cell) {
            cell = [[UserGiftRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reusableCellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        GiftItem *giftItem = [self.giftRecordArray objectAtIndex:[indexPath row]];
        [cell setGiftRecord:giftItem];
        return cell;
//    }
//    return nil;
}


#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"   送患者送花记录";
    label.textColor = UIColorFromRGB(0x8e8d93);
    label.font = [UIFont systemFontOfSize:14.0f];
    
//    if (0 == section) {
//        
//        static NSString *HeaderFooterViewIdentifier = @"AF784243-52EE-4C03-99D8-DE88B897FCB0";
//        UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HeaderFooterViewIdentifier];
//        if (!headerView) {
//            headerView = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:HeaderFooterViewIdentifier];
//        }
//        UILabel *titleLabel = headerView.textLabel;
//        titleLabel.text = @"哈哈哈哈";
//        
//        return headerView;
//    }
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 25.0f;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (0 == section) {
        return 10.0f;
    } else if (1 == section) {
        return 0.1;
    }
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath section]) {
        return 64.0f;
    } else if (1 == [indexPath section]) {
        return 44.0f;
    }
    return 0.0f;
}

#pragma mark - Public Method

@end
