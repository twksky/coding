//
//  ContactsViewController.m
//  
//
//  Created by 周世阳 on 15/9/14.
//
//

#import "ContactsViewController.h"
#import "ContactManager.h"
#import "IDHaveTableViewCell.h"
#import "IDGetDoctorPatient.h"
#import "MessageViewController.h"
#import "ChatViewController.h"
#import "SearchDisplayController.h"
#import "IDPatientMessageViewController.h"

@interface ContactsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,IDHaveTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tabelView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) SearchDisplayController* searchBarDisplayController;

@end

@implementation ContactsViewController

//-(instancetype)init{
//    self = [super init];
//    if (self) {
////        self.title = @"我的患者";
////        [self layoutTableView];
//        [self getData];
//    }
//    return self;
//}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabelView reloadData];
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"我的患者";
    self.title = @"通讯录";
    [self layoutTableView];
//    [self getData];
}

#pragma mark - UITableViewDelegate 
//组头高
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return 0.0f;
    }
    return 20.0f;
}
//尾高
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}
//每组个数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return [[ContactManager sharedInstance] getContactCountWithSection:section];
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%lu",(unsigned long)[[[ContactManager sharedInstance] getIndexKeys] count]);
    return [[[ContactManager sharedInstance] getIndexKeys] count];
}
//行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *key = [[ContactManager sharedInstance] getIndexKeyWithSection:section];
//    if ([key isEqualToString:kDoctorAssistantKey]) {
//        key = @"医生助手";
//    } else if ([key isEqualToString:kStarContactKey]) {
//        key = @"星级用户";
//    } else if ([key isEqualToString:kBlockContactKey]) {
//        key = @"黑名单";
//    }
    
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    headerView.frame = CGRectMake(0, 0, App_Frame_Width, 20);

    
    UILabel *keyLabel = [[UILabel alloc] init];
//    keyLabel.backgroundColor = [SkinManager sharedInstance].defaultClearColor;
    keyLabel.frame = CGRectMake(10, 5, headerView.frame.size.width, 10);
    keyLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    keyLabel.textColor = [UIColor blackColor];
    [headerView addSubview:keyLabel];
    [keyLabel setText:key];
    
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
     // 不用环信的好友列表
     EMBuddy *buddy = [self.contactArray objectAtIndex:[indexPath row]];
     [cell.textLabel setText:buddy.username];
     */
    IDGetDoctorPatient *patient = [[ContactManager sharedInstance] getContactWithSection:[indexPath section] withRow:[indexPath row]];
    
    NSArray *array = [[ContactManager sharedInstance] getContactArrayWithSection:indexPath.section];
    BOOL ishiden = NO;
    
    if (array.count == indexPath.row + 1) { // 证明是最后一个
        
        ishiden = YES;
    }
    
    
    IDHaveTableViewCell *cell = [self getMoreCellWithDic:patient WithIndexPath:indexPath tableView:tableView isHiden:ishiden];
    cell.layer.borderColor = UIColorFromRGB(0xeaeaea).CGColor;
    cell.layer.borderWidth = 0.5;
    
    //医生助手额外隐藏一些属性
    if (indexPath.section == 0) {
        cell.sexImage.hidden = YES;
        cell.ageLabel.hidden = YES;
    }else{
        cell.sexImage.hidden = NO;
        cell.ageLabel.hidden = NO;
    }
    
    return cell;
}

//cell加载布局
- (IDHaveTableViewCell *)getMoreCellWithDic:(IDGetDoctorPatient *)model WithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView isHiden:(BOOL)isHiden
{
    static NSString *ident = @"IDHaveTableViewCell";
    IDHaveTableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (moreCell == nil) {
        
        moreCell = [[IDHaveTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    moreCell.delegate = self;
    moreCell.intoDetailsDelegate = self;
    
    //数据的填写
    // [moreCell getDataWithName:model indexPath:indexPath];
    [moreCell getDataWithName:model indexPath:indexPath isHideSegment:isHiden];
    
    moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    moreCell.addButton.hidden = YES;//隐藏加号
    

    
    return moreCell;
    
}

////索引//SB设计还不要这个索引的东西
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    NSArray *content = [[ContactManager sharedInstance] getIndexKeys];
//    NSMutableArray *newSectionIndexTitles = [[NSMutableArray alloc] init];
//    for (NSString *title in content) {
//        [newSectionIndexTitles addObject:[NSString stringWithFormat:@"  %@  ", title]];
//    }
//    return newSectionIndexTitles;
//}

//点击头像进入详情页
-(void)intoIDPatientMessageVC:(UIButton *)btn{
    
    
    //跳到联系人详情界面
    IDPatientMessageViewController *infoViewController = [[IDPatientMessageViewController alloc] init];
    if (btn.tag != [kDoctorAssistantID intValue]) {
        infoViewController.patient_id = btn.tag;
        [self.navigationController pushViewController:infoViewController animated:YES];
    }
    
}

-(void)layoutTableView{
    
    [self.view addSubview:self.tabelView];
    //Masonry布局！！！！！！！！！！！！
    [self.tabelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0.0f));
        make.bottom.equalTo(@(0.0f));
        make.right.equalTo(@(0.0f));
        make.top.equalTo(@(0.0f));
    }];
}

//重新刷新列表，暂时没有什么卵用
- (void)reloadContacts
{
    /*
     // 不用环信的好友列表
     [self.contactArray removeAllObjects];
     NSArray *array = [[EaseMob sharedInstance].chatManager buddyList];
     
     for (EMBuddy *buddy in array) {
     if (buddy.isPendingApproval) {
     [self.contactArray addObject:buddy];
     }
     }
     [_totalFansCountLabel setText:[NSString stringWithFormat:@"共%d名患者关注了您", [self.contactArray count]]];
     [self.contactTableView reloadData];
     */
    
    [[ContactManager sharedInstance] getPatientsInformationWithDoctorID:KContactViewRefresh/*其实不用传，都怪张丽瞎写!!!*/ withCompletionHandelr:^(BOOL bSuccess, NSInteger contactCount) {
        
    } withErrorHandler:^(NSError *error) {
        
    }];
    
}

//跳转进入聊天页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    IDGetDoctorPatient *patient = [[ContactManager sharedInstance] getContactWithSection:[indexPath section] withRow:[indexPath row]];
    IDHaveTableViewCell *cell = (IDHaveTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *chatter = patient.patient_id;
//    UIImage *image = cell.iconImageBtn.imageView.image;
    ChatViewController *messageController = [[ChatViewController alloc] initWithChatter:chatter withChatterAvatar:cell.iconImageBtn.imageView.image withMyAvatarURL:[AccountManager sharedInstance].account.avatar_url];
    messageController.title = [patient getDisplayName];
    [self.navigationController pushViewController:messageController animated:YES];
}


- (UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tabelView.tableHeaderView = self.searchBar;
        _tabelView.sectionIndexColor = [UIColor blackColor];
        _tabelView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        self.searchBarDisplayController = [[SearchDisplayController alloc]initWithSearchBar:self.searchBar contentsController:self withDataArr:[ContactManager sharedInstance].searchArr];
        _tabelView.backgroundColor = UIColorFromRGB(0xf8f8f8);
    }
    return _tabelView;
}

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        _searchBar.delegate = self;
        [_searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
//        [_searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
        _searchBar.placeholder = @"搜索";
//        _searchBar.barTintColor = UIColorFromRGB(0xe7e7e9);
//        _searchBar.backgroundColor = UIColorFromRGB(0xe7e7e9);
    }
    return _searchBar;
}

@end
