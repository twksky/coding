//
//  MenuView.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/2/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MenuView.h"
#import "MenuButton.h"
#import "MenuCell.h"
#import "RegionManger.h"
#import "IDErrorView.h"
#import "IDLocationManager.h"

@interface MenuView ()<UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UIView *leftContainerView;
@property(nonatomic, strong) UIView *rightContainerView;
@property(nonatomic, strong) MenuButton *leftBtn;
@property(nonatomic, strong) MenuButton *rightBtn;

@property(nonatomic, strong) UIButton *currentRegionBtn;

@property(nonatomic, strong) UITableView *llTableView;

@property(nonatomic, strong) UITableView *lrghtTableView;

@property(nonatomic, strong) UITableView *rlTableView;

@property(nonatomic, strong) UITableView *rrghtTableView;


@property(nonatomic, strong) RegionsModel *regionsModel;

@property(nonatomic, strong) NSArray *illnessArray;
@property(nonatomic, strong) NSArray *illnessLevelArray;

@property(nonatomic, strong) NSDictionary *dict;
@end



@implementation MenuView

- (void)setCategoryFilterBlock:(CategoryFilterBlock)categoryFilterBlock
{
    _categoryFilterBlock = categoryFilterBlock;
}
- (void)setRegionFilterBlock:(RegionFilterBlock)regionFilterBlock
{
    _regionFilterBlock = regionFilterBlock;
}

- (void)hideMenu
{
    _leftBtn.selected = NO;
    _rightBtn.selected = NO;
    if (_leftContainerView && _rightContainerView) {
        _leftContainerView.hidden = YES;
        _rightContainerView.hidden = YES;
    }
}
- (instancetype)init
{
    if (self = [super init]) {
        [self setAllViews];
    }
    self.backgroundColor = UIColorFromRGB(0xeaeaea);
    return self;
}

- (void)setAllViews
{
    self.leftBtn = [self createBtnWithTitle:@"疾病分类"
                                  normalImg:[UIImage imageNamed:@"indicator_normal"]
                                selectedImg:[UIImage imageNamed:@"indicator_selected"]];
    [self addSubview:_leftBtn];
    [_leftBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self);
        make.bottom.equalTo(self).offset(-1);
    }];
    
    self.rightBtn = [self createBtnWithTitle:@"按地区"
                                  normalImg:[UIImage imageNamed:@"indicator_normal"]
                                selectedImg:[UIImage imageNamed:@"indicator_selected"]];
    [self addSubview:_rightBtn];
    [_rightBtn makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.equalTo(self);
        make.left.equalTo(_leftBtn.right).offset(1);
        make.bottom.equalTo(self).offset(-1);
        make.width.equalTo(_leftBtn);
    }];

}

- (MenuButton *)createBtnWithTitle:(NSString *)title
                       normalImg:(UIImage *)normalImg
                     selectedImg:(UIImage *)selectedImg
{
    MenuButton *btn = [[MenuButton alloc] init];
    btn.backgroundColor = [UIColor whiteColor];
    btn.titleLabel.font = GDFont(15);
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:kDefaultFontColor forState:UIControlStateNormal];
    [btn setImage:normalImg forState:UIControlStateNormal];
    [btn setImage:selectedImg forState:UIControlStateSelected];
    [btn setTitleColor:kNavBarColor forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

- (void)menuBtnClick:(MenuButton *)btn
{


    for (UIView *view in self.superview.subviews) {
        
        if (([view isKindOfClass:[UIView class]] && (view.subviews.count == 2) && [view.subviews[0] isKindOfClass:[UIImageView class]] && [view.subviews[1] isKindOfClass:[UILabel class]]) || [view isKindOfClass:[IDErrorView class]]) {
            
            [view removeFromSuperview];
            
            break;
        }
        
    
    }
    
    
    if (!_leftContainerView)
    {
        [self.superview addSubview:self.leftContainerView];
        _leftContainerView.hidden = YES;
    }
    
    if (!_rightContainerView)
    {
        [self.superview addSubview:self.rightContainerView];
        _rightContainerView.hidden = YES;
    }

    if (btn == self.leftBtn)
    {
        self.rightBtn.selected = NO;
        self.rightContainerView.hidden = YES;
    }
    
    if (btn == self.rightBtn)
    {
        if (_regionFilterBlock) {
            
            _regionFilterBlock(@(0));
        }
        
        
        // self.leftBtn.selected = NO;
        // self.leftContainerView.hidden = YES;
        // self.rightContainerView.hidden = YES;
        
        return;
        
    }
    
    btn.selected = !btn.selected;

    if (btn.selected && btn == self.leftBtn)
    {
        self.leftContainerView.hidden = NO;
        NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.llTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    else
    {
        self.leftContainerView.hidden = YES;
    }
    
    if (btn == self.rightBtn) {
        
        self.rightBtn.selected = YES;
    }
    
    if (btn.selected && btn == self.rightBtn)
    {
        // self.rightBtn.selected = NO;
       // self.rightContainerView.hidden = YES;
//        [MBProgressHUD showMessage:@"加载中..." toView:self.superview isDimBackground:NO];
//        [RegionManger getRegionsIfSuccess:^(RegionsModel *regions) {
//            
//            self.regionsModel = regions;
//            [self.rlTableView reloadData];
//            [MBProgressHUD hideHUDForView:self.superview];
//            NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.rlTableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionTop];
//            [self.rrghtTableView reloadData];
//        } failure:^(NSError *error) {
//            
//            [MBProgressHUD showError:@"加载失败"];
//            [MBProgressHUD hideHUDForView:self.superview];
//
//        }];
    }
    else
    {
       // self.rightContainerView.hidden = YES;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.rlTableView)
    {
        
        return self.regionsModel.provinces.count;
    }
    
    if (tableView == self.rrghtTableView)
    {
        NSUInteger selectRow = [self.rlTableView indexPathForSelectedRow].row;
        Provinces *p = self.regionsModel.provinces[selectRow];
        return p.cities.count;
    }
    
    if (tableView == self.llTableView)
    {
        
        return self.illnessArray.count;
    }
    
    if (tableView == self.lrghtTableView)
    {
        return self.illnessLevelArray.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell = [MenuCell cellWithTableView:tableView];

    
    if (tableView == self.llTableView)
    {
        
        cell.textLabel.text = self.illnessArray[indexPath.row];
    }
    if (tableView == self.rlTableView)
    {
        
        Provinces *p = self.regionsModel.provinces[indexPath.row];
        cell.textLabel.text = p.name;
    }
    if (tableView == self.lrghtTableView)
    {
        
        cell.textLabel.text = self.illnessLevelArray[indexPath.row];
        cell.backgroundColor = UIColorFromRGB(0xf4f4f5);
    }
    if (tableView == self.rrghtTableView)
    {
        NSUInteger selectRow = [self.rlTableView indexPathForSelectedRow].row;
        Provinces *p = self.regionsModel.provinces[selectRow];
        Cities *c = p.cities[indexPath.row];
        cell.textLabel.text = c.name;

        cell.backgroundColor = UIColorFromRGB(0xf4f4f5);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.lrghtTableView)
    {
        NSUInteger selectRow = [self.llTableView indexPathForSelectedRow].row;
        GDLog(@"%@ -- %@",self.illnessArray[selectRow], self.illnessLevelArray[indexPath.row]);
        
     
        if (self.categoryFilterBlock) {
            self.categoryFilterBlock(self.illnessArray[selectRow],self.dict[self.illnessLevelArray[indexPath.row]]);
        }
        
        [self hideMenu];
    
    }
    if (tableView == self.rlTableView)
    {
        [self.rrghtTableView reloadData];
    }
    
    if (tableView == self.rrghtTableView)
    {
        NSUInteger selectRow = [self.rlTableView indexPathForSelectedRow].row;
        Provinces *p = self.regionsModel.provinces[selectRow];
        Cities *c = p.cities[indexPath.row];
        GDLog(@"%@",c.name);
        if (self.regionFilterBlock) {
            self.regionFilterBlock(@(c.ID));
        }
        [self hideMenu];
    }
    
}
- (UIView *)leftContainerView
{
    if (_leftContainerView == nil) {
        _leftContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, App_Frame_Width, App_Frame_Height-60)];
        _leftContainerView.backgroundColor = GDRandomColor;
       
        self.llTableView = [self createTableView];
        [_leftContainerView addSubview:self.llTableView];
        [_llTableView makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.bottom.equalTo(_leftContainerView);
            make.width.equalTo(App_Frame_Width * 0.5);
        }];
        
        self.lrghtTableView = [self createTableView];
        _lrghtTableView.backgroundColor = UIColorFromRGB(0xf4f4f5);
        [_leftContainerView addSubview:self.lrghtTableView];
        [_lrghtTableView makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.right.bottom.equalTo(_leftContainerView);
            make.width.equalTo(App_Frame_Width * 0.5);
        }];
    }
    return _leftContainerView;
}
- (UIView *)rightContainerView
{
    if (_rightContainerView == nil) {
        _rightContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, App_Frame_Width, App_Frame_Height-60)];
        
        self.currentRegionBtn = [[UIButton alloc] init];
        _currentRegionBtn.titleLabel.font = GDFont(12);
        _currentRegionBtn.backgroundColor = UIColorFromRGB(0xeaeaea);
        _currentRegionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _currentRegionBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        
        IDLocationManager *locations = [IDLocationManager sharedInstance];
        NSString *locationStr = nil;
        
        if (locations.location == nil) {
            
            locationStr = @"当前所在城市:保定市";
            
        } else {
        
            locationStr = [NSString stringWithFormat:@"当前所在城市:%@",locations.location];
        
        }
        
        [_currentRegionBtn setTitle:locationStr forState:UIControlStateNormal];
        [_currentRegionBtn setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
        
        [_rightContainerView addSubview:_currentRegionBtn];
        [_currentRegionBtn makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.left.right.equalTo(_rightContainerView);
            make.height.equalTo(35);
        }];
        
        self.rlTableView = [self createTableView];
        [_rightContainerView addSubview:self.rlTableView];
        [_rlTableView makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_currentRegionBtn.bottom);
            make.left.bottom.equalTo(_rightContainerView);
            make.width.equalTo(App_Frame_Width * 0.43);
        }];
        
        self.rrghtTableView = [self createTableView];
        _rrghtTableView.backgroundColor = UIColorFromRGB(0xf4f4f5);
        [_rightContainerView addSubview:self.rrghtTableView];
        [_rrghtTableView makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(_currentRegionBtn.bottom);
            make.right.bottom.equalTo(_rightContainerView);
            make.width.equalTo(App_Frame_Width * 0.57);
        }];
    }
    return _rightContainerView;
}

- (UITableView *)createTableView
{
    UITableView *tb = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tb.rowHeight = 60;
    tb.separatorStyle = UITableViewCellSeparatorStyleNone;
    tb.dataSource = self;
    tb.delegate = self;
    tb.backgroundColor = UIColorFromRGB(0xf4f4f5);
    tb.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    return tb;
}
- (NSArray *)illnessArray
{
    if (_illnessArray == nil) {
        
        _illnessArray = @[ @"传染和寄生虫",
                           @"肿瘤",
                           @"血液和免疫疾病",
                           @"内分泌和代谢",
                           @"精神行为障碍",
                           @"神经系统疾病",
                           @"眼及附器疾病",
                           @"循环系统疾病",
                           @"呼吸系统疾病",
                           @"消化系统疾病",
                           @"耳和乳突疾病",
                           @"骨胳肌肉疾病",
                           @"泌尿生殖疾病",
                           @"皮肤系统疾病",
                           @"妊娠分娩",
                           @"围生期疾病",
                           @"遗传疾病",
                           @"损伤和中毒",
                           @"其他健康状况"
                          ];
    }
    return _illnessArray;
}
- (NSArray *)illnessLevelArray
{
    if (_illnessLevelArray == nil) {
        
        _illnessLevelArray = @[@"轻", @"一般", @"危重", @"全部"];
    }
    return _illnessLevelArray;
}

- (NSDictionary *)dict
{
    if (_dict == nil) {
        _dict = @{
                  @"轻" :@(1),
                  @"一般" :@(2),
                  @"危重" :@(3),
                  @"全部" :@(0),
                  };
    }
    return _dict;
}
@end
