//
//  IDMessageView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/22.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDMessageView.h"
#import "IDGetPatientInformation.h"

#import <MJExtension.h>


@interface IDMessageView()<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

// 底部的View
@property (nonatomic, strong) UITableView *messageTableView;

// 设置一个中间的button
@property (nonatomic, strong) UIButton *tempButton;

// 日期选择器
@property (nonatomic, strong) UIDatePicker *datePicker;

// 患者名字输入
@property (nonatomic, strong) UITextField *textField;

// 用一个string类型来得到相应的日期
@property (nonatomic, strong) NSDate *dateString;

// 显示出生日期
@property (nonatomic, strong) UILabel *defaultLabel;

// 用来显示完成的导航栏
@property (nonatomic, strong) UIView *garyView;

// 身高的输入框
@property (nonatomic, strong) UITextField *HeightTextFied;

// 体重
@property (nonatomic, strong) UITextField *weightTextField;


// 设置一个字典  装下所有的信息
@property (nonatomic, strong) NSMutableDictionary *messageDic;

// 判断是否填写相应的姓名信息
@property (nonatomic, assign) BOOL isHaveName;

// 模型数据
@property (nonatomic, strong) IDGetPatientInformation *informationModel;

@end

@implementation IDMessageView

- (instancetype)initWithModel:(IDGetPatientInformation *)model
{
    self = [super init];
    
    if (self) {
        
        _isHaveName = NO;
        self.backgroundColor = [UIColor whiteColor];

         [self.messageDic setObject:@"1990-01-01" forKey:@"birth"];
        
        [self seupUIWithModel:model];
        
    }

    return self;
}


- (void)seupUIWithModel:(IDGetPatientInformation *)model
{
    self.informationModel = model;

    [self addSubview:self.messageTableView];
    [self.messageTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).with.offset(0);
        make.top.equalTo(self).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width, App_Frame_Height - 66 - 50 - 15 - 10 - 50));
        
    }];
    
    if (self.informationModel != nil) {
        
        
        [self.messageDic setObject:model.birth forKey:@"birth"];
        [self.messageDic setObject:model.sex forKey:@"sex"];
        [self.messageDic setObject:model.loginname forKey:@"name"];
        [self.messageDic setObject:@(model.height) forKey:@"height"];
        [self.messageDic setObject:@(model.weight) forKey:@"weight"];
        
        [self.messageTableView reloadData];
    }
    
    // 下一步的按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"下一步" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    button.backgroundColor = UIColorFromRGB(0x36cacc);
    [button addTarget:self action:@selector(nextStepButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).with.offset(15);
        make.right.equalTo(self).with.offset(-15);
        make.bottom.equalTo(self).with.offset(-15);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 50));
        
    }];


}

- (void)nextStepButtonClicked:(UIButton *)button
{
    // 将相应的性别信息 写入
    [self.messageDic setObject:self.tempButton.titleLabel.text forKey:@"sex"];
    
    // 下一步 按钮 被点击
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];

    if (_isHaveName == NO) {
        
        alert.message = @"患者姓名没有填写，请补充完整";
        [alert show];
        return;
    } else if ([_HeightTextFied.text integerValue] == 0 || [_weightTextField.text integerValue] == 0) {// 首先查看一下 身高的参数对不对
        
        alert.message = @"身高或体重填写的参数不对，请检查一下，身高和体重必须为整数";
        [alert show];
        
    } else { // 信息已填写完整
    
        if ([self.delegate respondsToSelector:@selector(nextStepWithDic:)]) {
          
            [self.delegate nextStepWithDic:self.messageDic];
        }

    }
    
}


#pragma mark - 表的数据源 和 代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{ NSInteger row = indexPath.row;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];

    switch (row) {
        case 0:
        {
            // 姓名
            UILabel *label = [[UILabel alloc] init];
            label.text = @"姓       名";
            label.font = [UIFont systemFontOfSize:15.0f];
            label.textColor = UIColorFromRGB(0x353d3f);
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).with.offset(15);
                make.top.equalTo(cell.contentView).with.offset(23);
            }];
            
            // 请输入姓名 的 textField
            _textField = [[UITextField alloc] init];
            _textField.placeholder = @"请输入患者姓名";
            _textField.text = self.informationModel.loginname;
            _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _textField.tag = 10001;
            _textField.delegate = self;
            [cell.contentView addSubview:_textField];
            [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(label.right).with.offset(30);
                make.top.equalTo(cell.contentView).with.offset(23);
                make.width.equalTo(App_Frame_Width - 30 - 15 - 70);
            }];
            
        }; break;
            
        case 1:
        {
            // 性别
            UILabel *label = [[UILabel alloc] init];
            label.text = @"性       别";
            label.font = [UIFont systemFontOfSize:15.0f];
            label.textColor = UIColorFromRGB(0x353d3f);
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).with.offset(15);
                make.top.equalTo(cell.contentView).with.offset(23);
            }];
            
            // 实心的原点
            UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
            [button1 setImage:[UIImage imageNamed:@"myHavePatient_active"] forState:UIControlStateSelected];
            [button1 setImage:[UIImage imageNamed:@"myHavePatient_inactive"] forState:UIControlStateNormal];
            [button1 setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
            [button1 setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateSelected];
            button1.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [button1 setTitle:@"男" forState:UIControlStateNormal];
            [button1 setTitle:@"男" forState:UIControlStateSelected];
            button1.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:button1];
            [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(label.right).with.offset(32);
                make.top.equalTo(cell.contentView).with.offset(21);
                make.size.equalTo(CGSizeMake(41.0f, 22.0f));
                
            }];
            
            
            // 女
            // 实心的原点
            UIButton *fmaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [fmaleButton setImage:[UIImage imageNamed:@"myHavePatient_active"] forState:UIControlStateSelected];
            [fmaleButton setImage:[UIImage imageNamed:@"myHavePatient_inactive"] forState:UIControlStateNormal];
            [fmaleButton setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
            [fmaleButton setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateSelected];
            fmaleButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [fmaleButton setTitle:@"女" forState:UIControlStateNormal];
            [fmaleButton setTitle:@"女" forState:UIControlStateSelected];
            fmaleButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
            [fmaleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:fmaleButton];
            [fmaleButton mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(button1.right).with.offset(45);
                make.top.equalTo(cell.contentView).with.offset(21);
                make.size.equalTo(CGSizeMake(41.0f, 22.0f));
                
            }];
            
            
            if ([self.informationModel.sex isEqualToString:@"男"]) {
                
                button1.selected = YES;
                self.tempButton = button1;
            } else {
            
                fmaleButton.selected = YES;
                self.tempButton = fmaleButton;
            }
            
            
        };break;
            
        case 2:
        {
            // 出生日期
            UILabel *label = [[UILabel alloc] init];
            label.text = @"出生日期";
            label.font = [UIFont systemFontOfSize:15.0f];
            label.textColor = UIColorFromRGB(0x353d3f);
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).with.offset(15);
                make.top.equalTo(cell.contentView).with.offset(23);
            }];
            
            // 默认的出生日期
            _defaultLabel = [[UILabel alloc] init];
            
            if (self.informationModel != nil) {
                
               NSArray *array = [self.informationModel.birth componentsSeparatedByString:@"-"];
                
                NSString *date = [NSString stringWithFormat:@"%@年%@月%@日",array[0],array[1],array[2]];
                _defaultLabel.text = date;
                
            } else {
                
                _defaultLabel.text = @"1990年1月1日";
            
            }

            _defaultLabel.textColor = UIColorFromRGB(0x353d3f);
            _defaultLabel.font = [UIFont systemFontOfSize:15.0f];
            _defaultLabel.tag = 11;
            [cell.contentView addSubview:_defaultLabel];
            [_defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(label.right).with.offset(30);
                make.top.equalTo(cell.contentView).with.offset(23);
                
            }];
            
        }; break;
            
        case 3: {
            
            // 身高
            UILabel *label = [[UILabel alloc] init];
            label.text = @"身高(CM)";
            label.font = [UIFont systemFontOfSize:15.0f];
            label.textColor = UIColorFromRGB(0x353d3f);
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).with.offset(15);
                make.top.equalTo(cell.contentView).with.offset(23);
            }];
            
            // 请输入姓名 的 textField
            _HeightTextFied = [[UITextField alloc] init];
            _HeightTextFied.placeholder = @"如：180";
            if (self.informationModel == nil) {
                
                
            } else {
                _HeightTextFied.text = [NSString stringWithFormat:@"%.0f",self.informationModel.height];
            
            }
            
            _HeightTextFied.clearButtonMode = UITextFieldViewModeWhileEditing;
            _HeightTextFied.delegate = self;
            _HeightTextFied.tag = 10002;
            [cell.contentView addSubview:_HeightTextFied];
            [_HeightTextFied mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(label.right).with.offset(30);
                make.top.equalTo(cell.contentView).with.offset(23);
                make.width.equalTo(App_Frame_Width - 30 - 15 - 80);
            }];
            
        } break;
            
        case 4: {
            
            // 体重
            UILabel *label = [[UILabel alloc] init];
            label.text = @"体重(KG)";
            label.font = [UIFont systemFontOfSize:15.0f];
            label.textColor = UIColorFromRGB(0x353d3f);
            [cell.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(cell.contentView).with.offset(15);
                make.top.equalTo(cell.contentView).with.offset(23);
            }];
            
            // 请输入姓名 的 textField
            _weightTextField = [[UITextField alloc] init];
            _weightTextField.placeholder = @"如：50";
            
            if (self.informationModel == nil) {
                
                
            } else {
                 _weightTextField.text = [NSString stringWithFormat:@"%.0f",self.informationModel.weight];
                
            }
           
            _weightTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            _weightTextField.delegate = self;
            _weightTextField.tag = 10003;
            [cell.contentView addSubview:_weightTextField];
            [_weightTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(label.right).with.offset(30);
                make.top.equalTo(cell.contentView).with.offset(23);
                make.width.equalTo(App_Frame_Width - 30 - 15 - 80);
            }];
            
        } break;
            
        default:
            break;
    }
    
    
    UIView *segment = [self getSegment];
    [cell.contentView addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(cell.contentView).with.offset(15);
        make.bottom.equalTo(cell.contentView).with.offset(-1);
        make.right.equalTo(cell.contentView).with.offset(0);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 15, 1));
        
    }];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;

}

- (UIView *)getSegment
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xeaeaea);
    return view;
}

// 按钮的点击事件
- (void)buttonClicked:(UIButton *)button
{
    [_textField resignFirstResponder];
    [_HeightTextFied resignFirstResponder];
    [_weightTextField resignFirstResponder];
    
    if (self.tempButton == button) // 现在点击的是同一个按钮
        return;
    
    // 点击的不是同一个button的时候进行的相应的操作
    self.tempButton.selected = NO;
    button.selected = YES;
    self.tempButton = button;
    
    
    
}


// 已经停止编辑
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 10001) { // 姓名
        
        _isHaveName = YES;
        [self.messageDic setObject:textField.text forKey:@"name"];
        
    } else if (textField.tag == 10002) { // 身高
        
        ;
        
        NSNumber *height = [NSNumber numberWithFloat:[textField.text floatValue]];
        
        [self.messageDic setObject:height forKey:@"height"];
        
    } else { // 体重
        
        NSNumber *weight = [NSNumber numberWithFloat:[textField.text floatValue]];
        
        [self.messageDic setObject:weight forKey:@"weight"];
        
    }
    
}

// 按下return键
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    
    if (tableView.tag == 101) {
        
        if (row != 0) {
            
            [_textField resignFirstResponder];
        }
        
        if (row != 2) {
            
            [self.garyView removeFromSuperview];
            [self.datePicker removeFromSuperview];
            
        }
        
        if (row != 3) {
            
            [_HeightTextFied resignFirstResponder];
        }
        
        if (row != 4) {
            
            [self.weightTextField resignFirstResponder];
        }
        
        if (row == 2) { // 弹出相应的日期选择器
            
            // 完成按钮
            self.garyView = [[UIView alloc] init];
            self.garyView.backgroundColor = UIColorFromRGB(0xeeeeee);
            [self.superview addSubview:self.garyView];
            [self.garyView mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.superview).with.offset(0);
                make.top.equalTo(self.superview).with.offset(App_Frame_Height - 216 - 44);
                make.size.equalTo(CGSizeMake(App_Frame_Width, 44));
                
            }];
            
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setTitle:@"完成" forState:UIControlStateNormal];
            [button setTitleColor:UIColorFromRGB(0x36cacc) forState:UIControlStateNormal];
            [button addTarget:self action:@selector(finishChooseDate:) forControlEvents:UIControlEventTouchUpInside];
            [self.garyView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.right.equalTo(self.garyView).with.offset(-12);
                make.top.equalTo(self.garyView).with.offset(11);
                make.size.equalTo(CGSizeMake(36, 22));
                
            }];
            
            
            [self.superview addSubview:self.datePicker];
            [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(self.superview).with.offset(0);
                make.top.equalTo(self.superview).with.offset(App_Frame_Height - 216);
                
            }];
            
        }
        
        
    }
}


// 完成选择日期
- (void)finishChooseDate:(UIButton *)button
{
    [self.datePicker removeFromSuperview];
    [button.superview removeFromSuperview];
    
    
    if (self.dateString == nil) {
        
       

    } else {
        
        NSDateFormatter *pickerDateFormatter = [[NSDateFormatter alloc] init];
        [pickerDateFormatter setDateFormat:@"yyyy年MM月dd日"];
        NSString *date  = [pickerDateFormatter stringFromDate:self.dateString];
        
        _defaultLabel.text = date;
        
        
        NSString *string = [NSString stringWithFormat:@"%@", self.dateString];
        
        NSArray *array = [string componentsSeparatedByString:@" "];
        
        // 数组的第0个元素就是相应的数据 可取的yyyy - mm - dd
        
        [self.messageDic setObject:[NSString stringWithFormat:@"%@", array[0]] forKey:@"birth"];
        
    }
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = UIColorFromRGB(0xf8f8f8);
        bgView.frame = CGRectMake(0, 0, App_Frame_Width, 10);
    
    return bgView;
    
}


#pragma mark - 懒加载
// 基本信息
- (UITableView *)messageTableView
{
    if (_messageTableView == nil) {
        
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _messageTableView.dataSource = self;
        _messageTableView.delegate = self;
        _messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTableView.bounces = NO;
        _messageTableView.tag = 101;
        
    }
    
    return _messageTableView;
}

// 日期选择器的懒加载
- (UIDatePicker *)datePicker
{
    if (_datePicker == nil) {
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        self.dateString = _datePicker.date;
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        
    }
    
    return _datePicker;
    
}

// 日期选择器 相应的值改变实践
- (void)dateChanged:(UIDatePicker *)datePicker
{
    self.dateString = datePicker.date;
    
}


- (NSMutableDictionary *)messageDic
{
    if (_messageDic == nil) {
        
        _messageDic = [NSMutableDictionary dictionary];
    }
    
    return _messageDic;
}



@end
