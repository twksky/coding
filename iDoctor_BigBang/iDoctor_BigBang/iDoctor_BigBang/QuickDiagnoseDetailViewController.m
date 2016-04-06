//
//  QuickDiagnoseDetailViewController.m
//  iDoctor_BigBang
//
//  Created by tianxiewuhua on 15/10/20.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import "QuickDiagnoseDetailViewController.h"
#import "QuickDiagnoseDetailCell.h"
#import "QuickDiagnoseCommentCell.h"
#import "QuickDiagnose.h"
#import "QuickDiagnoseManager.h"
#import "GDComposeView.h"
#import <Masonry.h>
#import <MWPhotoBrowser.h>

static const NSInteger SECTION_QUESTION_DETAIL = 0;
static const NSInteger SECTION_QEUSTION_COMMENTS = 1;

static NSString *const QuickDiagnoseCommentCellIdentifier = @"bd629d20-b294-4775-975c-811a415d88b8";
static NSString *const QuickDiagnoseDetailCellIdentifier = @"0d664541-99e4-4a18-a8af-5b44808f47ff";
static NSString *const QuickDiagnoseDetailFooterViewIdentifier = @"22162797-7f87-4454-b3f0-f5f37a99dda3";

@interface QuickDiagnoseDetailViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
MWPhotoBrowserDelegate
>

@property (nonatomic, strong) QuickDiagnose *quickDiagnose;
@property (nonatomic, strong) NSArray *comments;

@property (nonatomic, strong) UITableView *detailTableView;
@property (nonatomic, strong) UIView *replayView;
@property (nonatomic, strong) UIButton *replayButton;

// 图片查看器
@property (nonatomic, strong) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSString *image_URL;

@end

@implementation QuickDiagnoseDetailViewController

- (instancetype)initWithQuickDiagnose:(QuickDiagnose *)quickDiagnose {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        self.quickDiagnose = quickDiagnose;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    [self getComments];
}

#pragma mark -
- (void)setupView {
    
    self.view.backgroundColor = UIColorFromRGB(0xf8f8f8);
    self.detailTableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:self.detailTableView];
    [self.detailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.and.left.and.right.equalTo(self.view);
        make.bottom.equalTo(self.view).with.offset(-50.0f);
    }];
    
    [self.view addSubview:self.replayView];
    [self.replayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.and.right.and.bottom.equalTo(self.view);
        make.height.equalTo(50.0f);
    }];
    
    [self.replayView addSubview:self.replayButton];
    [self.replayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.replayView);
        make.height.equalTo(27.0f);
        make.left.equalTo(self.replayView).with.offset(15.0f);
        make.right.equalTo(self.replayView).with.offset(-15.0f);
    }];
}

#pragma mark -
- (void)getComments {
    
    [[QuickDiagnoseManager sharedInstance] getQuickDiagnoseCommentsWithQuickDiagnoseId:self.quickDiagnose.quickDiagnoseId withCompletionHandler:^(NSArray *comments) {
        
        self.comments = comments;
        [self.detailTableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [self handleError:error];
    }];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //TODO
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == SECTION_QUESTION_DETAIL) {
        
        return [QuickDiagnoseDetailCell cellHeightWithQuickDiagnose:self.quickDiagnose];
    } else if (indexPath.section == SECTION_QEUSTION_COMMENTS) {
        
        QuickDiagnoseComment *comment = self.comments[indexPath.row];
        return [QuickDiagnoseCommentCell cellHeight:comment];
    }
    
    return 0.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == SECTION_QUESTION_DETAIL) {
        
        return 60.0f;
    } else {
        
        return 0.1f;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == SECTION_QUESTION_DETAIL) {
        
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
        replayLabel.text = @"我的回复";
        
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == SECTION_QUESTION_DETAIL) {
        
        return 1;
    } else if (section == SECTION_QEUSTION_COMMENTS) {
        
        return [self.comments count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (indexPath.section == SECTION_QUESTION_DETAIL) {
        
        QuickDiagnoseDetailCell *detailCell = [tableView dequeueReusableCellWithIdentifier:QuickDiagnoseDetailCellIdentifier];
        if (!detailCell) {
            
            detailCell = [[QuickDiagnoseDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QuickDiagnoseDetailCellIdentifier];
        }
        
         
        [detailCell loadData:self.quickDiagnose imageBlock:^(NSString *image_url) {
            
            self.image_URL = image_url;
            [self.photoBrowser reloadData];
            UINavigationController *photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
            photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController presentViewController:photoNavigationController animated:YES completion:nil];
 
        }];
        

        cell = detailCell;
        
    } else if (indexPath.section == SECTION_QEUSTION_COMMENTS) {
        
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


#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    
    return 1;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    
    return [MWPhoto photoWithURL:[NSURL URLWithString:self.image_URL]];
}


#pragma mark - Selectors
- (void)replayButtonClicked:(id)sender {
    
    GDComposeView *composeView = [[GDComposeView alloc] init];
    [composeView setSendBtnClickBlock:^(NSString *text) {
        
        [self sendComment:text];
    }];
    
    [composeView show];
}

#pragma mark -
- (void)sendComment:(NSString *)commentContent {
    
    [self showLoading];
    [[QuickDiagnoseManager sharedInstance] replyQuickDiagnoseWithContent:commentContent withQuickDiagnoseId:self.quickDiagnose.quickDiagnoseId withCompletionHandler:^(QuickDiagnoseComment *comment) {
        
        [self hideLoading];
        NSMutableArray *mutableComments = [self.comments mutableCopy];
        [mutableComments insertObject:comment atIndex:0];
        
        self.comments = mutableComments;
        [self.detailTableView reloadData];
        
    } withErrorHandler:^(NSError *error) {
        
        [self hideLoading];
        [self handleError:error];
    }];
}


#pragma mark - Properties
- (UITableView *)detailTableView {
    
	if(_detailTableView == nil) {
        
		_detailTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _detailTableView.delegate = self;
        _detailTableView.dataSource = self;
	}
	return _detailTableView;
}

- (UIView *)replayView {
    
    if(_replayView == nil) {
        
        _replayView = [[UIView alloc] init];
        _replayView.backgroundColor = UIColorFromRGB(0xf9f9f9);
        _replayView.layer.borderColor = UIColorFromRGB(0xbebebe).CGColor;
        _replayView.layer.borderWidth = 0.7f;
    }
    return _replayView;
}

- (UIButton *)replayButton {
    
    if(_replayButton == nil) {
        
        _replayButton = [[UIButton alloc] init];
        [_replayButton setTitle:@" 我来回复" forState:UIControlStateNormal];
        _replayButton.backgroundColor = [UIColor whiteColor];
        [_replayButton setTitleColor:UIColorFromRGB(0xc8c8cd) forState:UIControlStateNormal];
        [_replayButton setImage:[UIImage imageNamed:@"replay_button_icon"] forState:UIControlStateNormal];
        _replayButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_replayButton addTarget:self action:@selector(replayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        ViewBorderRadius(_replayButton, 13.5f, 0.7f, UIColorFromRGB(0xbebebe));
    }
    return _replayButton;
}



- (NSArray *)comments {
    
    if(_comments == nil) {
        
        _comments = @[];
    }
    return _comments;
}


- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.wantsFullScreenLayout = YES;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
        [_photoBrowser setCurrentPhotoIndex:0];
    }
    
    return _photoBrowser;
}


@end





