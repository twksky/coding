//
//  MyBaseController.m
//  iDoctor_BigBang
//
//  Created by hexy on 7/20/1937 Saka.
//  Copyright © 1937 Saka YDHL. All rights reserved.
//

#import "MyBaseController.h"

@interface MyBaseController ()

@end

@implementation MyBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTableView];
}
- (void)setUpNav
{
    UIBarButtonItem *letfItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(leftItemClick)];
    letfItem.tintColor = [UIColor whiteColor];
    [letfItem setTitleTextAttributes:@{NSFontAttributeName : GDFont(15)} forState:UIControlStateNormal];
    
    self.navigationItem.leftBarButtonItem  = letfItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"保存"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(rightItemClick)];
    rightItem.tintColor = [UIColor whiteColor];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName : GDFont(15)} forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem  = rightItem;
}
- (void)leftItemClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)rightItemClick
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addTableView
{
    [self.view addSubview:self.tbv];
    [self.tbv makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.sectionModelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    SectionModel *sectionModel = self.sectionModelArray[section];
    return sectionModel.rowModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    SectionModel *sectionModel = self.sectionModelArray[indexPath.section];
    BaseRowModel *rowModel = sectionModel.rowModels[indexPath.row];
    
    UITableViewCell *cell = [CellManger cellWithTableView:tableView rowModel:rowModel];
    
    
    
    cell.textLabel.textColor = UIColorFromRGB(0x353d3f);
    
    // 设置cell选中时的背景颜色
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = UIColorFromRGB(0xf3f3f4);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取消选中这行
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // 2.模型数据
    SectionModel *sectionModel = self.sectionModelArray[indexPath.section];
    BaseRowModel *rowModel = sectionModel.rowModels[indexPath.row];
    
    if (rowModel.rowSelectedBlock)
    {
        rowModel.rowSelectedBlock(indexPath);
    }
    else if ([rowModel isKindOfClass:[ArrowRowModel class]])
    {
        ArrowRowModel *arrowRowModel = (ArrowRowModel *)rowModel;
        
        if (arrowRowModel.destVC == nil) return;
        
        UIViewController *vc = [[arrowRowModel.destVC alloc] init];
        vc.title = arrowRowModel.title;
        [self.navigationController pushViewController:vc  animated:YES];
    }
    
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0.1 : 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [HeaderManger scrollViewDidScroll:scrollView];
}

- (void)viewDidLayoutSubviews
{
    [HeaderManger resizeView];
}
- (NSMutableArray *)sectionModelArray
{
    if (!_sectionModelArray) {
        _sectionModelArray = [NSMutableArray array];
    }
    return _sectionModelArray;
}

- (UITableView *)tbv
{
    if (_tbv == nil) {
        
        _tbv = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tbv.backgroundColor = UIColorFromRGB(0xf8f8f8);
        _tbv.separatorColor = UIColorFromRGB(0xeaeaea);
        _tbv.dataSource = self;
        _tbv.delegate = self;
    }
    return _tbv;
}

@end
