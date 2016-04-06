//
//  MasterDiagnoseDetailViewController.m
//  iDoctor_BigBang
//
//  Created by tianxiewuhua on 15/10/28.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "MasterDiagnoseDetailViewController.h"
#import "MasterDiagnoseDetailCell.h"
#import "QuickDiagnoseCommentCell.h"
#import "MasterDiagnose.h"
#import "QuickDiagnoseManager.h"
#import "MasterDiagnoseItViewController.h"
#import "MasterDiagnoseCommentCell.h"

static NSString *const MasterDiagnoseDetailCellIdentifier = @"ede78efc-8d7e-4283-9362-4576465e0647";
static NSString *const QuickDiagnoseCommentCellIdentifier = @"3b9c7255-7097-4fce-9c4d-e9aa5d52c4d2";
static NSString *const MasterDiagnoseCommentCellIdentifier = @"d1918f06-f00e-428d-ae7e-e84b6f760e09";

static const NSInteger SECTION_MASTER_DIAGNOSE_DETAIL = 0;
static const NSInteger SECTION_MASTER_DIAGNOSE_DIAGNOSECOMMENT = 1;
static const NSInteger SECTION_MASTER_DIAGNOSE_COMMENTS = 2;

@interface MasterDiagnoseDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
MasterDiagnoseItViewControllerDelegate
>

@property (nonatomic, strong) UITableView *masterDiagnoseDetailTableView;
@property (nonatomic, strong) UIButton *diagnoseButton;

@property (nonatomic, strong) MasterDiagnose *masterDiagnose;

@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *diagnoseComment;

@end

@implementation MasterDiagnoseDetailViewController

- (instancetype)initWithMasterDiagnose:(MasterDiagnose *)masterDiagnose {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        self.masterDiagnose = masterDiagnose;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self getMasterDIagnoseComments];
}

#pragma mark -
- (void)setupView {
    
    [self.view addSubview:self.masterDiagnoseDetailTableView];
    [self.masterDiagnoseDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-75.0f);
    }];
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.equalTo(75.0f);
    }];
    
    [view addSubview:self.diagnoseButton];
    [self.diagnoseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(view);
        make.right.and.bottom.equalTo(view).with.offset(-15.0f);
        make.left.equalTo(view).with.equalTo(15.0f);
        make.top.equalTo(view).with.equalTo(10.0f);
    }];
}

#pragma mark - 
- (void)getMasterDIagnoseComments {
    
    [self showLoading];
    [[QuickDiagnoseManager sharedInstance] getQuickDiagnoseAllCommentsWithQuickDiagnoseId:self.masterDiagnose.quickDiagnoseId withCompletionHandler:^(NSArray *comments) {
        
        self.comments = comments;
        [self.masterDiagnoseDetailTableView reloadData];
        [self hideLoading];
        
    } withErrorHandler:^(NSError *error) {
        
        [self hideLoading];
        [self handleError:error];
    }];
}

#pragma mark - MasterDiagnoseItViewControllerDelegate
- (void)diagnoseMasterComment:(NSString *)diagnoseComment {
    
    [self showLoading];
    [[QuickDiagnoseManager sharedInstance] replyQuickDiagnoseWithContent:diagnoseComment withQuickDiagnoseId:self.masterDiagnose.quickDiagnoseId withCompletionHandler:^(QuickDiagnoseComment *comment) {
        
        [self.diagnoseComment removeAllObjects];
        [self.diagnoseComment addObject:comment];
        [self.masterDiagnoseDetailTableView reloadData];
        [self hideLoading];
        
    } withErrorHandler:^(NSError *error) {
        
        [self hideLoading];
        [self handleError:error];
    }];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SECTION_MASTER_DIAGNOSE_DETAIL) {
        
        return [MasterDiagnoseDetailCell cellHeightWithMasterDiagnose:self.masterDiagnose];
    } else if (indexPath.section == SECTION_MASTER_DIAGNOSE_DIAGNOSECOMMENT) {
        
        QuickDiagnoseComment *comment = self.diagnoseComment[indexPath.row];
        return [MasterDiagnoseCommentCell cellHeightWithQuickDiagnoseComment:comment];
    }
    
    else if (indexPath.section == SECTION_MASTER_DIAGNOSE_COMMENTS){
        
        QuickDiagnoseComment *comment = self.comments[indexPath.row];
        return [QuickDiagnoseCommentCell cellHeight:comment];
    }
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == SECTION_MASTER_DIAGNOSE_DETAIL) {
        
        return 0.1f;
    } else if (section == SECTION_MASTER_DIAGNOSE_DIAGNOSECOMMENT) {
        
        return 10.0f;
    } else if (section == SECTION_MASTER_DIAGNOSE_COMMENTS) {
        
        return 60.0f;
    }
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == SECTION_MASTER_DIAGNOSE_COMMENTS) {
        
        UIView *view = [[UIView alloc] init];
        
        view.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = UIColorFromRGB(0xeaeaea);
        
        [view addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(view);
            make.height.equalTo(0.7f);
            make.top.equalTo(view).with.offset(10.0f);
        }];
        
        UIView *labelContentView = [[UIView alloc] init];
        labelContentView.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:labelContentView];
        [labelContentView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(line.bottom);
            make.left.and.right.and.bottom.equalTo(view);
        }];
        
        UILabel *replayLabel = [[UILabel alloc] init];
        replayLabel.backgroundColor = [UIColor whiteColor];
        replayLabel.textColor = UIColorFromRGB(0x353d3f);
        replayLabel.text = @"医生的回复";
        
        UILabel *commentsNumLabel = [[UILabel alloc] init];
        commentsNumLabel.backgroundColor = [UIColor whiteColor];
        commentsNumLabel.textColor = UIColorFromRGB(0xbfbfbf);
        commentsNumLabel.text = [NSString stringWithFormat:@"共%ld条", self.comments.count];
        
        [labelContentView addSubview:replayLabel];
        [replayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(labelContentView);
            make.left.equalTo(labelContentView).with.offset(15.0f);
        }];
        
        [labelContentView addSubview:commentsNumLabel];
        [commentsNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(labelContentView);
            make.right.equalTo(labelContentView).with.offset(-15.0f);
        }];
        
        return view;
    }
    
    return nil;

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == SECTION_MASTER_DIAGNOSE_DETAIL) {
        
        return 1;
    } else if (section == SECTION_MASTER_DIAGNOSE_DIAGNOSECOMMENT) {
        
        return self.diagnoseComment.count;
    } else {
        
        return self.comments.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;//TODO
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == SECTION_MASTER_DIAGNOSE_DETAIL) {
        
        MasterDiagnoseDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:MasterDiagnoseDetailCellIdentifier];
        if (!detailCell) {
            
            detailCell = [[MasterDiagnoseDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MasterDiagnoseDetailCellIdentifier];
            detailCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [detailCell loadDataWithMasterDiagnose:self.masterDiagnose];
        
        cell = detailCell;
        
    } else if (indexPath.section == SECTION_MASTER_DIAGNOSE_DIAGNOSECOMMENT) {
        
        MasterDiagnoseCommentCell *masterCommentCell = [tableView dequeueReusableCellWithIdentifier:MasterDiagnoseCommentCellIdentifier];
        if (!masterCommentCell) {
            
            masterCommentCell = [[MasterDiagnoseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MasterDiagnoseCommentCellIdentifier];
        }
        
        QuickDiagnoseComment *comment = self.diagnoseComment[indexPath.row];
        [masterCommentCell loadDataComment:comment];
        cell = masterCommentCell;
        
    } else if (indexPath.section == SECTION_MASTER_DIAGNOSE_COMMENTS) {
        
        QuickDiagnoseCommentCell *commentCell = [tableView dequeueReusableCellWithIdentifier:QuickDiagnoseCommentCellIdentifier];
        if (!commentCell) {
            
            commentCell = [[QuickDiagnoseCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuickDiagnoseCommentCellIdentifier];
        }
        
        QuickDiagnoseComment *comment = self.comments[indexPath.row];
        [commentCell loadDataComment:comment];
        
        cell = commentCell;
    }
    
    return cell;
}

#pragma mark - Selectors
- (void)replyDiagnose {
    
    if (self.diagnoseComment.count == 0) {
        
        MasterDiagnoseItViewController *masterDiagnoseItVC = [[MasterDiagnoseItViewController alloc] init];
        masterDiagnoseItVC.delegate = self;
        [self.navigationController pushViewController:masterDiagnoseItVC animated:YES];
    } else {
        
        [self showWarningAlertWithTitle:@"提示" withMessage:@"已经提交过小结"];
    }
}


#pragma mark - Properties
- (UITableView *)masterDiagnoseDetailTableView {
    
	if(_masterDiagnoseDetailTableView == nil) {
        
		_masterDiagnoseDetailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _masterDiagnoseDetailTableView.delegate = self;
        _masterDiagnoseDetailTableView.dataSource = self;
        _masterDiagnoseDetailTableView.backgroundColor = UIColorFromRGB(0xf8f8f8);
	}
	return _masterDiagnoseDetailTableView;
}

- (NSArray *)comments {
    
	if(_comments == nil) {
        
		_comments = [[NSArray alloc] init];
	}
	return _comments;
}

- (NSArray *)diagnoseComment {
    
	if(_diagnoseComment == nil) {
        
		_diagnoseComment = [[NSMutableArray alloc] initWithCapacity:1];
	}
	return _diagnoseComment;
}

- (UIButton *)diagnoseButton {
    
	if(_diagnoseButton == nil) {
        
		_diagnoseButton = [[UIButton alloc] init];
        _diagnoseButton.backgroundColor = UIColorFromRGB(0x36cacc);
        [_diagnoseButton setTitle:@"我来小结" forState:UIControlStateNormal];
        [_diagnoseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _diagnoseButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        [_diagnoseButton addTarget:self action:@selector(replyDiagnose) forControlEvents:UIControlEventTouchUpInside];
	}
	return _diagnoseButton;
}

@end
