//
//  QuickDiagnoseMenuView.m
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/11/2.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseMenuView.h"
#import "MenuButton.h"
#import "RegionManger.h"
#import "MenuCell.h"
#import "QuickDiagnoseManager.h"

@interface QuickDiagnoseMenuView ()
<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) MenuButton *leftButton;
@property (nonatomic, strong) MenuButton *rightButton;
@property (nonatomic, strong) UITableView *locationLTableView;
@property (nonatomic, strong) UITableView *locationRTableView;
@property (nonatomic, strong) UIView *locationContainerView;
@property (nonatomic, strong) UIButton *currentLocationBtn;
@property (nonatomic, strong) UITableView *departmentTableView;

@property (nonatomic, strong) NSArray *departments;
@property (nonatomic, strong) RegionsModel *regionsModel;
@property (nonatomic, strong) Provinces *selectedProvince;

@end

@implementation QuickDiagnoseMenuView

-(void)layoutIfNeeded{

}

- (void)layoutSubviews {
    
    [self setupViews];
    [super layoutSubviews];
}

- (void)setupViews {
    
    [self addSubview:self.leftButton];
    [self.leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.equalTo(self);
        make.width.equalTo(App_Frame_Width / 2.0f);
        make.height.equalTo(50.0f);
    }];
    
    [self addSubview:self.rightButton];
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.right.equalTo(self);
        make.width.equalTo(App_Frame_Width / 2.0f + 1.0f);
        make.height.equalTo(50.0f);
    }];
    
    [self addSubview:self.locationContainerView];
    [self.locationContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.leftButton.bottom);
        make.left.and.right.and.bottom.equalTo(self);
    }];
    
    [self.locationContainerView addSubview:self.currentLocationBtn];
    [self.currentLocationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.and.right.equalTo(self.locationContainerView);
        make.height.equalTo(35.0f);
    }];
    
    [self.locationContainerView addSubview:self.locationLTableView];
    [self.locationLTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currentLocationBtn.bottom);
        make.left.and.bottom.equalTo(self.locationContainerView);
        make.width.equalTo(App_Frame_Width / 2.0f);
    }];
    
    [self.locationContainerView addSubview:self.locationRTableView];
    [self.locationRTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.currentLocationBtn.bottom);
        make.right.and.bottom.equalTo(self.locationContainerView);
        make.width.equalTo(App_Frame_Width / 2.0f);
    }];
    
    [self addSubview:self.departmentTableView];
    [self.departmentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.rightButton.bottom);
        make.right.and.bottom.equalTo(self);
        make.width.equalTo(App_Frame_Width / 2.0f);
    }];
}

#pragma mark - privete Methods
- (void)getLocations {
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [RegionManger getRegionsIfSuccess:^(RegionsModel *regions) {
        
        _regionsModel = regions;
        [self.locationLTableView reloadData];
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self animated:YES];
        [MBProgressHUD showError:[error localizedDescription] toView:self];
    }];
}

#pragma mark - Selectors
- (void)leftButtonClicked:(id)sender {
    
//    self.rightButton.selected = NO;
    self.departmentTableView.hidden = YES;
    
//    self.leftButton.selected = !self.leftButton.isSelected;
//    self.locationContainerView.hidden = !self.leftButton.isSelected;
//    if (self.leftButton.selected) {
//        
//        if (!_regionsModel) {
//            
//            [self getLocations];
//        }
//    }
//    
//    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowMenuView)] && [self.delegate respondsToSelector:@selector(didHideMenuView)]) {
//        
//        if (self.leftButton.selected) {
//            
//            [self.delegate didShowMenuView];
//        } else {
//            
//            [self.delegate didHideMenuView];
//        }
//    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"尚未开通地区选择功能" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)rightButtonClicked:(id)sender {
    
    self.leftButton.selected = NO;
    self.locationContainerView.hidden = YES;
    
    self.rightButton.selected = !self.rightButton.isSelected;
    self.departmentTableView.hidden = !self.rightButton.isSelected;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didShowMenuView)] && [self.delegate respondsToSelector:@selector(didHideMenuView)]) {
        
        if (self.rightButton.selected) {
            
            [self.delegate didShowMenuView];
        } else {
            
            [self.delegate didHideMenuView];
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.departmentTableView) {
        
        return [self.departments count];
    } else if (tableView == self.locationLTableView) {
        
        if (!_regionsModel) {
            
            return 0;
        } else {
            
            return _regionsModel.provinces.count;
        }
    } else if (tableView == self.locationRTableView) {
        
        if (!_selectedProvince) {
            
            return 0;
        } else {
            
            return _selectedProvince.cities.count;
        }
    } else {
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MenuCell *cell = [MenuCell cellWithTableView:tableView];
    
    if (tableView == self.departmentTableView) {
        
        cell.textLabel.text = self.departments[indexPath.row];
    } else if (tableView == self.locationLTableView) {
        
        Provinces *p = self.regionsModel.provinces[indexPath.row];
        cell.textLabel.text = p.name;
    } else if (tableView == self.locationRTableView) {
        
        Cities *c = _selectedProvince.cities[indexPath.row];
        cell.textLabel.text = c.name;
        
        cell.backgroundColor = UIColorFromRGB(0xf4f4f5);
    }

    return cell;

}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.departmentTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self departmentChanged:self.departments[indexPath.row]];
    } else if (tableView == self.locationLTableView) {
        
        _selectedProvince = self.regionsModel.provinces[indexPath.row];
        [self.locationRTableView reloadData];
    } else if (tableView == self.locationRTableView) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        Cities *city = _selectedProvince.cities[indexPath.row];
        [self locationChanged:city.ID];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60.0f;
}

#pragma mark - NotifyDelegate
- (void)departmentChanged:(NSString *)deparment {
    
    self.rightButton.selected = NO;
    self.departmentTableView.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didHideMenuView)]) {
        
        [self.delegate didHideMenuView];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectDepartment:)]) {
        
        [self.delegate didSelectDepartment:deparment];
    }
}

- (void)locationChanged:(NSInteger)regionId {
    
    self.leftButton.selected = NO;
    self.locationContainerView.hidden = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didHideMenuView)]) {
        
        [self.delegate didHideMenuView];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectLocation:)]) {
        
        [self.delegate didSelectLocation:regionId];
    }
}

#pragma mark -
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
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
    return btn;
}


#pragma mark - Properties
- (MenuButton *)leftButton {
	if(_leftButton == nil) {
        
        _leftButton = [self createBtnWithTitle:@"按地区"
                                     normalImg:[UIImage imageNamed:@"indicator_normal"]
                                   selectedImg:[UIImage imageNamed:@"indicator_selected"]];
        [_leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _leftButton;
}

- (MenuButton *)rightButton {
	if(_rightButton == nil) {
        
        _rightButton = [self createBtnWithTitle:@"按科室"
                                     normalImg:[UIImage imageNamed:@"indicator_normal"]
                                   selectedImg:[UIImage imageNamed:@"indicator_selected"]];
        [_rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _rightButton;
}

- (UITableView *)locationLTableView {
    
	if(_locationLTableView == nil) {
        
		_locationLTableView = [[UITableView alloc] init];
        _locationLTableView.delegate = self;
        _locationLTableView.dataSource = self;
        _locationLTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _locationLTableView;
}

- (UITableView *)locationRTableView {
    
	if(_locationRTableView == nil) {
        
		_locationRTableView = [[UITableView alloc] init];
        _locationRTableView.delegate = self;
        _locationRTableView.dataSource = self;
        _locationRTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _locationRTableView;
}

- (UITableView *)departmentTableView {
    
	if(_departmentTableView == nil) {
        
		_departmentTableView = [[UITableView alloc] init];
        _departmentTableView.delegate = self;
        _departmentTableView.dataSource = self;
        _departmentTableView.hidden = YES;
        _departmentTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	}
	return _departmentTableView;
}

- (NSArray *)departments {
    
	if(_departments == nil) {
        
		_departments = @[@"全部", @"内科", @"外科", @"妇科", @"儿科", @"其他科室"];
	}
	return _departments;
}

- (UIView *)locationContainerView {
    
	if(_locationContainerView == nil) {
        
		_locationContainerView = [[UIView alloc] init];
        _locationContainerView.hidden = YES;
	}
	return _locationContainerView;
}

- (UIButton *)currentLocationBtn {
    
	if(_currentLocationBtn == nil) {
        
		_currentLocationBtn = [[UIButton alloc] init];
        _currentLocationBtn.backgroundColor = UIColorFromRGB(0xeaeaea);
        [_currentLocationBtn setTitle:@"当前城市: 保定" forState:UIControlStateNormal];//TOOD
        _currentLocationBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _currentLocationBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _currentLocationBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
        [_currentLocationBtn setTitleColor:UIColorFromRGB(0x9b9b9e) forState:UIControlStateNormal];
	}
	return _currentLocationBtn;
}

@end
