//
//  IDSelectTimeViewController.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/10/12.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDSelectTimeViewController.h"

@interface IDSelectTimeViewController ()

// array
@property (nonatomic, strong) NSArray *timeArray;

// 创建一个数组 进行相应的日期得到
@property (nonatomic, strong) NSMutableArray *tempMutableArray;



@end

@implementation IDSelectTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"门诊时间";
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(saveTime:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    
    [self setupUI];
    
}

// 保存
- (void)saveTime:(UIButton *)button
{
    
    _block(self.tempMutableArray);
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

// 计算星期几 是上午还是下午
- (NSString *)weekAndAmOrPmWithButton:(UIButton *)button
{
    
    // 点击了相应的保存  进行相应的保存
    CGRect buttonFrame = button.frame;
    
    // 星期几
    float week = buttonFrame.origin.x / (App_Frame_Width / 7);
    
    if (week > 2.9) {
        
        week += 0.5;
    }
    
    int weeks = week;
    
    
    // 上午  还是下午
    int amOrPm = buttonFrame.origin.y / 100;
    
    NSString *amOrPmString = nil;
    
    if (amOrPm == 1) { // 证明是上午
        
        amOrPmString = @"am";
        
    } else if (amOrPm == 2) { // 证明是下午
        
        amOrPmString = @"pm";
    }
    
    NSString *string = [NSString stringWithFormat:@"%d-%@",weeks + 1, amOrPmString];
    return string;
    
}


// 为页面创建UI
- (void)setupUI
{
    
    for (int i = 0 ; i < 3; i++) { // 3列
        
        for (int j = 0; j < 7; j++) { // 7行
            
            float height = 100 * i;
            float width = (App_Frame_Width / 7) * j;
            
            // 选择数组中的第几个? row = i - 1 * 7 + j;
            
            int row = i * 7 + j;
            
            if (i == 0) { // 第一行的日期 不可点击
                
                UILabel *label = [[UILabel alloc] init];
                label.font = [UIFont systemFontOfSize:15.0f];
                label.textColor = UIColorFromRGB(0x353d3f);
                label.text = self.timeArray[row];
                label.textAlignment = NSTextAlignmentCenter;
                label.frame = CGRectMake(width, height, App_Frame_Width / 7, 100);
                label.numberOfLines = [self.timeArray[row] length];
                label.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
                label.layer.borderWidth = 0.5;
                [self.view addSubview:label];
                
                
            } else { // 可点击的每一行
 
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame = CGRectMake(width, height, App_Frame_Width/7, 100);
                [button setTitle:self.timeArray[row] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:15.0f];
                button.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
                button.layer.borderWidth = 0.5;
                button.titleLabel.numberOfLines = [self.timeArray[row] length];
                [button setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
                
                NSArray *selectArray = [self getTimeArray];
                for (NSNumber *number in selectArray) {
                
                    if ([number intValue] == row) {
                      
                        button.backgroundColor = UIColorFromRGB(0x66d2d3);

                        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        break;
                        
                    } else {
                    
                        button.backgroundColor = [UIColor whiteColor];
                        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    }
                    
                }
                

                [button addTarget:self action:@selector(selectTime:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:button];
                
                
            }
            
        }
        
    }
    
    
}

- (NSArray *)getTimeArray
{
    NSMutableArray *timeArray = [NSMutableArray array];
    
    for (NSString *time in self.tempMutableArray) {
            
        NSArray *array = [time componentsSeparatedByString:@"-"];
            
        int number = [array[0] intValue];
            
        int aOrP = 0;
            
        if ([array[1] isEqualToString:@"am"]) {
                
            aOrP = 1;
                
        } else if ([array[1] isEqualToString:@"pm"]) {
                
            aOrP = 2;
                
        }
        
        // row = i * 7 + j
        [timeArray addObject:@(aOrP * 7 + (number - 1))];
        
    }
    
    return timeArray;

}



- (void)selectTime:(UIButton *)button
{
    NSString *time = [self weekAndAmOrPmWithButton:button];
    
    if (self.tempMutableArray.count == 0) { // 第一次加入  不用进行相应的判断
        
        [self.tempMutableArray addObject:time];
        
        button.backgroundColor = UIColorFromRGB(0x66d2d3);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    } else { // 数组中 已经存在相应的button了
        
        for (NSString *selectedTime in self.tempMutableArray) {
            
            if ([selectedTime isEqualToString:time]) { // 前后选择了相同的button
                // 将数组中的button移除
                [self.tempMutableArray removeObject:selectedTime];
                button.backgroundColor = [UIColor whiteColor];
                
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                return;
            }
            
        }
 
        // 循环结束没有找到  将button 加到数组中  并点亮
        [self.tempMutableArray addObject:time];
        
        button.backgroundColor = UIColorFromRGB(0x66d2d3);
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    
}


- (NSArray *)timeArray
{
    if (_timeArray == nil) {
        
        _timeArray = @[@"星\n期\n一",@"星\n期\n二",@"星\n期\n三",@"星\n期\n四",@"星\n期\n五",@"星\n期\n六",@"星\n期\n日",@"上\n午",@"上\n午",@"上\n午",@"上\n午",@"上\n午",@"上\n午",@"上\n午",@"下\n午",@"下\n午",@"下\n午",@"下\n午",@"下\n午",@"下\n午",@"下\n午"];
        
    }
    
    return _timeArray;
}


- (NSMutableArray *)tempMutableArray
{
    if (_tempMutableArray == nil) {
        
        _tempMutableArray = [NSMutableArray arrayWithArray:_selectTimeArray];
        
    }
    
    return _tempMutableArray;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
