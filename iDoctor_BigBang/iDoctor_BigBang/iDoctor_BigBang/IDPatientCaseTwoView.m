//
//  IDPatientCaseTwoView.m
//  iDoctor_BigBang
//
//  Created by 张丽 on 15/9/24.
//  Copyright (c) 2015年 YDHL. All rights reserved.
//

#import "IDPatientCaseTwoView.h"

#import "IDGetPatientMedicalModel.h"
#import "IDPatientMedical.h"
#import "IDGetPatientCaseProcesses.h"
#import "IDMedicaledModel.h"
@interface IDPatientCaseTwoView()

// 病种名字
@property (nonatomic, strong) UILabel *nameLabel;


// 病种的情况 标签
@property (nonatomic, strong) UILabel *tagLabel;


// 病症主诉
@property (nonatomic, strong) UIView *mainView;

// 检查报告
@property (nonatomic, strong) UIView *reportView;

// 其他信息
@property (nonatomic, strong) UIView *otherMsgView;

// 保存病例
@property (nonatomic, strong) UIButton *saveCaseButton;



@property (nonatomic, strong) IDGetPatientMedicalModel *model;


@end


@implementation IDPatientCaseTwoView

- (instancetype)init
{
    if ([super init]) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}


- (void)setupUIWithModel:(IDGetPatientMedicalModel *)model
{
    self.model = model;
    
    // 病种名字
    [self addSubview:self.nameLabel];
    self.nameLabel.text = model.medical.name;
    CGSize nameSize = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).with.offset(25);
        make.top.equalTo(self).with.offset(25);
        
        if (nameSize.width > (App_Frame_Width - 50 - 40 - 5)) {
            
            make.width.equalTo(App_Frame_Width - 50);
            
        } else {
            
            make.width.equalTo(nameSize.width);
        }
        
    }];
    
    [self.nameLabel sizeToFit];
    
    // 病种程度的标签
    [self addSubview:self.tagLabel]; // 1 轻 2 一般  3 危重
    if (model.medical.rank == 1) { // 轻
        self.tagLabel.text = @"轻";
        self.tagLabel.backgroundColor = UIColorFromRGB(0x73cff5);
    } else if (model.medical.rank == 2) { // 一般
        self.tagLabel.text = @"一般";
        self.tagLabel.backgroundColor = UIColorFromRGB(0xfc9c71);
    } else {
        self.tagLabel.text = @"危重";
        self.tagLabel.backgroundColor = UIColorFromRGB(0xff682c);
    }
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        // 得到显示了几行
        CGFloat number = nameSize.width /  (App_Frame_Width - 50);
        
        CGFloat numbers = (App_Frame_Width - 50 - 40 - 5) / (App_Frame_Width - 50);
        
        int queue = number;
        
        CGFloat compare = number - queue;
        
        int num = 0;
        
        if (compare > numbers) { // 超出了能显示下的范围
            
            num = number + 0.5;
            
        } else {
            
            num = queue;
            
        }
        
        // 计算剩下的宽度
        float width = nameSize.width - (App_Frame_Width - 50) * num;
        
        if (width <= 0) {
            
            width = 0;
        }
        
        
        if (nameSize.width <= (App_Frame_Width - 50 - 40 - 5)) { // 名字需要显示一行 标签转行显示
            
            make.left.equalTo(self.nameLabel.right).with.offset(5);
            make.top.equalTo(self).with.offset(25);
            
        } else if (((nameSize.width > App_Frame_Width - 50 - 40 - 5) && (nameSize.width <= App_Frame_Width - 50)) || width == 0 ){ // 正好能显示一行，但是无法显示那个lable 转行显示
            
            make.left.equalTo(self).with.offset(25);
            make.top.equalTo(self).with.offset(25 + nameSize.height * num);
            
        } else { // 大于一行了
            
            make.left.equalTo(25 + width + 5 * (num + 3));
            
            make.top.equalTo(self).with.offset(25 + nameSize.height * num);
        }
        
        make.size.equalTo(CGSizeMake(40, 17));
        
    }];
    
    
    // 病状主诉
    [self addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).with.offset((App_Frame_Width - 3 * 75) / 4);
        make.top.equalTo(self.nameLabel.bottom).with.offset(25);
        make.size.equalTo(CGSizeMake(75, 108 + 7 + 15 - 5));
        
        
    }];
    
    
    // 检查报告
    [self addSubview:self.reportView];
    [self.reportView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.mainView.right).with.offset((App_Frame_Width - 3 * 75) / 4);
        make.top.equalTo(self.nameLabel.bottom).with.offset(25);
        make.size.equalTo(CGSizeMake(75, 108 + 7 + 15 - 5));
        
    }];
    
    
    // 其他信息
    [self addSubview:self.otherMsgView];
    [self.otherMsgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.reportView.right).with.offset((App_Frame_Width - 3 * 75) / 4);
        make.top.equalTo(self.nameLabel.bottom).with.offset(25);
        make.size.equalTo(CGSizeMake(75, 108 + 7 + 15 - 5));
    }];
    
    
    // 保存病例
    [self addSubview:self.saveCaseButton];
    [self.saveCaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self).with.offset(15);
        make.bottom.equalTo(self).with.offset(-15);
        make.size.equalTo(CGSizeMake(App_Frame_Width - 30, 50));
        
        
    }];
    
    
}


#pragma mark - 懒加载
// 病种名字
- (UILabel *)nameLabel
{
    if (_nameLabel == nil) {
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = UIColorFromRGB(0x353d3f);
        _nameLabel.numberOfLines = 0;
    }
    
    return _nameLabel;
}


// 病种程度的标签
- (UILabel *)tagLabel
{
    if (_tagLabel == nil) {
        
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.font = [UIFont systemFontOfSize:12];
        _tagLabel.textColor = [UIColor whiteColor];
        _tagLabel.layer.masksToBounds = YES;
        _tagLabel.layer.cornerRadius = 9;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return _tagLabel;
}


// 症状主诉
- (UIView *)mainView
{
    if (_mainView == nil) {
        
        NSArray *array = self.model.processes;
        
        IDGetPatientCaseProcesses *model = array[0];
        
        _mainView = [self creatProcessViewWithImage:[UIImage imageNamed:@"myHavePatient_mian"] title:@"病状主诉" fill:model.fill buttonTag:10001];
        
    }
    
    return _mainView;
}

// 检查报告
- (UIView *)reportView
{
    if (_reportView == nil) {
        
        NSArray *array = self.model.processes;
        IDGetPatientCaseProcesses *model = array[1];
        _reportView = [self creatProcessViewWithImage:[UIImage imageNamed:@"myHavePatient_report"] title:@"检查报告" fill:model.fill buttonTag:10002];
    }
    
    return _reportView;
}

// 其他病史
- (UIView *)otherMsgView
{
    if (_otherMsgView == nil) {
        
        NSArray *array = self.model.processes;
        IDGetPatientCaseProcesses *model = array[2];
        _otherMsgView = [self creatProcessViewWithImage:[UIImage imageNamed:@"myHavePatient_otherMsg"] title:@"其他信息" fill:model.fill buttonTag:10003];
    }
    
    return _otherMsgView;
}




/**
 *  创建一个View的对象
 *
 *  @param image  图片
 *  @param title  标题
 *  @param ifFill 是否已经填写过
 *
 *  @return 返回一个完整的View
 */
- (UIView *)creatProcessViewWithImage:(UIImage *)image title:(NSString *)title fill:(BOOL)isFill buttonTag:(NSInteger)buttonTag
{
    UIView *view = [[UIView alloc] init];
    
    // 创建一个button
    UIButton *button = [self creatButtonWithImage:image title:title];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = buttonTag;
    [view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(view).with.offset(0);
        make.top.equalTo(view).with.offset(0);
        make.size.equalTo(CGSizeMake(80, 108));
        
    }];
    
    UIView *fillView = [[UIView alloc] init];
    
    if (isFill == YES) { // 标示已经填完了
        // 钩
        UIImageView *iconImage = [[UIImageView alloc] init];
        iconImage.image = [UIImage imageNamed:@"myHavePatient_ture"];
        [fillView addSubview:iconImage];
        [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(fillView).with.offset(5);
            make.top.equalTo(fillView).with.offset(5);
            make.size.equalTo(CGSizeMake(12, 12));
        }];
        
        // 已填的字体
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:12];
        nameLabel.textColor = UIColorFromRGB(0x36cacc);
        nameLabel.text = @"已填";
        [fillView addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(iconImage.right).with.offset(5);
            make.top.equalTo(fillView).with.offset(5);
            
        }];
        
        
    } else { // 还未填写
        
        // 未填的字样
        UILabel *lable = [[UILabel alloc] init];
        lable.font = [UIFont systemFontOfSize:12];
        lable.textColor = UIColorFromRGB(0xa8a8a8);
        lable.text = @"(未填)";
        lable.textAlignment = NSTextAlignmentCenter;
        [fillView addSubview:lable];
        [lable mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(fillView).with.offset(0);
            make.top.equalTo(fillView).with.offset(5);
            
        }];
    }
    
    
    [view addSubview:fillView];
    [fillView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(view).with.offset(19);
        make.top.equalTo(button.bottom).with.offset(7);
        make.width.equalTo(42);
        
        
    }];
    
    return view;
    
}




// 按钮的点击事件
- (void)buttonClicked:(UIButton *)button
{
    NSArray *array = self.model.processes;
    if (button.tag == 10001) { // 病状主诉
        
        if ([self.delegate respondsToSelector:@selector(mainButtonClicked:model:)]) {
            
            [self.delegate mainButtonClicked:button model:array[0]];
        }
        
    } else if (button.tag == 10002) { // 检查报告
        
        if ([self.delegate respondsToSelector:@selector(reportButtonClicked:model:)]) {
            
            [self.delegate reportButtonClicked:button model:array[1]];
        }
        
        
    } else if (button.tag == 10003) { // 其他信息
        
        if ([self.delegate respondsToSelector:@selector(relatedButtonClicked:model:)]) {
            
            [self.delegate relatedButtonClicked:button model:array[2]];
        }
        
    }
    
    
}

// 保存病例
- (UIButton *)saveCaseButton
{
    if (_saveCaseButton == nil) {
        
        _saveCaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveCaseButton.backgroundColor = UIColorFromRGB(0x36cacc);
        [_saveCaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveCaseButton setTitle:@"保存病例" forState:UIControlStateNormal];
        [_saveCaseButton addTarget:self action:@selector(saveCaseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _saveCaseButton;
}

- (void)saveCaseButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(saveCaseButtonClicked:)]) {
        [self.delegate saveCaseButtonClicked:button];
    }
}


// 通过字 和 图片 创建一个按钮
- (UIButton *)creatButtonWithImage:(UIImage *)image title:(NSString *)title
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x353d3f) forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
    button.titleEdgeInsets = UIEdgeInsetsMake(0, -77, - 75 - 30, 0);
    
    return button;
}

@end
