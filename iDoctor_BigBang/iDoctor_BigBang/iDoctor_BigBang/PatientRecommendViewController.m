//
//  PatientRecommendViewController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/1/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "PatientRecommendViewController.h"
#import "IWantPatientViewController.h"
#import "PatientRecruitController.h"

@interface PatientRecommendViewController ()

@property(nonatomic, strong) UIView *segmentView;

@property(nonatomic, strong) UISegmentedControl *segment;
@property(nonatomic, strong) IWantPatientViewController *wantP;
@property(nonatomic, strong) PatientRecruitController *pRec;
@end

@implementation PatientRecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpAllViews];
    
    
}

- (void)setUpAllViews
{
    [self setUpSegment];
    _segment.selectedSegmentIndex = 0;
    [self segmentValueChanged:_segment];
}

- (void)setUpSegment
{
    UIView *rootView = self.view;
    
    self.segmentView = [[UIView alloc] init];
    _segmentView.backgroundColor = [UIColor whiteColor];
    [rootView addSubview:_segmentView];
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.right.equalTo(rootView);
        make.height.equalTo(50);
    }];
    
    // contentView
    UIView *contentView = [[UIView alloc] init];
    
    [_segmentView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
    
    // segment
    [contentView addSubview:self.segment];
    [_segment mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.bottom.right.equalTo(contentView);
    }];
    
    // 横线
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB(0xeaeaea);
    [_segmentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(_segmentView);
        make.height.equalTo(1);
    }];
}

- (void)segmentValueChanged:(UISegmentedControl *)segment
{
    if (segment.selectedSegmentIndex == 0) {
        self.pRec.view.hidden = YES;
        self.wantP.view.hidden = NO;
    }
    if (segment.selectedSegmentIndex == 1)
    {
        self.wantP.view.hidden = YES;
        self.pRec.view.hidden = NO;
//        [self.pRec.tableView reloadData];
    }
}

#pragma mark - 成员变量初始化
- (UISegmentedControl *)segment
{
    if (!_segment) {
        
        NSArray *arr = @[@"患者推荐", @"患者招募"];
        _segment = [[UISegmentedControl alloc] initWithItems:arr];
        _segment.tintColor = UIColorFromRGB(0x36cacc);
        UIFont *font = [UIFont systemFontOfSize:14];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        
        [_segment setTitleTextAttributes: dict forState:UIControlStateNormal];
        [_segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _segment;
}

- (IWantPatientViewController *)wantP
{
    if (_wantP == nil) {
        _wantP = [[IWantPatientViewController alloc] init];
        _wantP.isRecomment = YES;
        [self addChildViewController:_wantP];
        [self.view insertSubview:_wantP.view belowSubview:_segmentView];
        [_wantP.view makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.segmentView.bottom).offset(-50);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    return _wantP;
}
- (PatientRecruitController *)pRec
{
    if (_pRec == nil) {
        _pRec = [[PatientRecruitController alloc] init];
        [self addChildViewController:_pRec];
        [self.view addSubview:_pRec.view];
        [_pRec.view makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.segmentView.bottom);
            make.left.bottom.right.equalTo(self.view);
        }];
    }
    return _pRec;
}
@end
