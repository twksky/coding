//
//  TWKSearchDisplayController.m
//  iDoctor_BigBang
//
//  Created by twksky on 15/11/2.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "SearchDisplayController.h"
#import "IDHaveTableViewCell.h"
#import "ContactManager.h"
#import "IDGetDoctorPatient.h"
#import "ChatViewController.h"

@interface SearchDisplayController ()<UITableViewDelegate,UITableViewDataSource,IDHaveTableViewCellDelegate>

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSArray *searchResultsArr;

@property (nonatomic, strong) UIViewController *vc;

//@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation SearchDisplayController

-(instancetype)initWithSearchBar:(UISearchBar *)searchBar contentsController:(UIViewController*)contentsController withDataArr:(NSArray *)dataArr {
    
    self = [super initWithSearchBar:searchBar contentsController:contentsController];
    
    if (self) {
        
        self.delegate = self;
        
        self.searchResultsDelegate = self;
        
        self.searchResultsDataSource = self;
        
        self.dataArr = dataArr;
        
        self.vc = contentsController;
        
        self.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
    
}

#pragma mark search
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (IDGetDoctorPatient *patient in self.dataArr) {
        [arr addObject:patient.realname];
    }
    
    self.searchResultsArr = [arr filteredArrayUsingPredicate:resultPredicate];
}

#pragma mark - UISearchDisplayController delegate methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString  scope:[[self.searchBar scopeButtonTitles]  objectAtIndex:[self.searchBar                                                      selectedScopeButtonIndex]]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchBar text] scope:[[self.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.searchResultsArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    IDGetDoctorPatient *patient = [[ContactManager sharedInstance] getSearchArrWithRealName:self.searchResultsArr[indexPath.row]];
    
    IDHaveTableViewCell *cell = [self getMoreCellWithDic:patient WithIndexPath:indexPath tableView:tableView];
    
    //医生助手额外隐藏一些属性
    if ([patient.patient_id isEqualToString:kDoctorAssistantID]) {
        cell.sexImage.hidden = YES;
        cell.ageLabel.hidden = YES;
    }else{
        cell.sexImage.hidden = NO;
        cell.ageLabel.hidden = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    IDGetDoctorPatient *patient = [[ContactManager sharedInstance] getSearchArrWithRealName:self.searchResultsArr[indexPath.row]];
    IDHaveTableViewCell *cell = (IDHaveTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *chatter = patient.patient_id;
    ChatViewController *messageController = [[ChatViewController alloc] initWithChatter:chatter withChatterAvatar:cell.iconImageBtn.imageView.image withMyAvatarURL:[AccountManager sharedInstance].account.avatar_url];
    messageController.title = [patient getDisplayName];
    [self.vc.navigationController pushViewController:messageController animated:YES];
}

- (IDHaveTableViewCell *)getMoreCellWithDic:(IDGetDoctorPatient *)model WithIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    static NSString *ident = @"IDHaveTableViewCell";
    IDHaveTableViewCell *moreCell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (moreCell == nil) {
        
        moreCell = [[IDHaveTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    moreCell.delegate = self;
    
    //数据的填写
    // [moreCell getDataWithName:model indexPath:indexPath];
    [moreCell getDataWithName:model indexPath:indexPath isHideSegment:NO];
    
    moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    moreCell.addButton.hidden = YES;//隐藏加号
    
    return moreCell;
    
}




@end
