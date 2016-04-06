//
//  AddTemplateViewController.m
//  AppFramework
//
//  Created by 周世阳 on 15/6/17.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "AddTemplateViewController.h"
#import "EXUITextField.h"
#import <PureLayout.h>
#import "SkinManager.h"
#import "AddTemplateDiyQuestionCell.h"
#import "TemplateModel.h"
#import "TemplateCategoryModel.h"
#import "AccountManager.h"
#import <UIAlertView+Blocks.h>
#import "TemplateCategoriesSelectTableViewAdapter.h"

#define AddTemplateDiyQuestionCellHeight 55.0f

@interface AddTemplateViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
TemplateCategoriesSelectTableViewAdapterDelegate,
AddTemplateDiyQuestionCellDelegate
>

@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) EXUITextField *templateNameField;
@property (nonatomic, strong) UILabel *templateCategoryTitle;
@property (nonatomic, strong) UIButton *templateCategoryButton;
@property (nonatomic, strong) UIImageView *templateCategoryListIconImageView;
@property (nonatomic, strong) UILabel *templateItemTitle;
@property (nonatomic, strong) UIView *templateItemsContainer;
@property (nonatomic, strong) UILabel *ageLabel;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *diseaseTimeLabel;
@property (nonatomic, strong) UILabel *symptomDescriptionLabel;
@property (nonatomic, strong) UIButton *updateButton;
@property (nonatomic, strong) UILabel *diyQuestionTitle;
@property (nonatomic, strong) EXUITextField *diyQuestionField;
@property (nonatomic, strong) UITableView *diyQuestionsTableView;
@property (nonatomic, strong) UIImageView *templateCategoryButtonIcon;

@property (nonatomic, strong) UITableView *templateCategoriesSelectTableView;
@property (nonatomic, strong) TemplateCategoriesSelectTableViewAdapter *templateCategoriesSelectTableViewAdapter;

@property (nonatomic, strong) NSMutableArray *diyQuestions;
@property (nonatomic, strong) NSLayoutConstraint *tableViewHeightConstraint;
//@property (nonatomic, strong) NSArray *templateCategories;

@property (nonatomic, strong) TemplateCategoryModel *selectedTemplateCategory;

@property (nonatomic, strong) TemplateModel *defaultTemplateModel;

@end

@implementation AddTemplateViewController

- (id)initWithDefaultTemplate:(TemplateModel *)templateModel {
    
    self = [super init];
    if (self) {
        
        _defaultTemplateModel = templateModel;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *saveButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveTemplate)];
    
    [self setNavigationBarWithTitle:@"新增问诊模板" leftBarButtonItem:[self makeLeftReturnBarButtonItem] rightBarButtonItem:saveButtonItem];
    
    [self setupViews];
    if (_defaultTemplateModel) {
        
        [self setupWithDefaultTemplateModel:_defaultTemplateModel];
    }
    
//    [self showLoading];
//    [[AccountManager sharedInstance] asyncGetTemplateCategoriesWithCompletionHandler:^(NSArray *templateCategories) {
//        [self dismissLoading];
//        
//        self.templateCategoriesSelectTableViewAdapter.templateCategories = templateCategories;
//        TemplateCategoryModel *categoryModel = [self.templateCategoriesSelectTableViewAdapter.templateCategories objectAtIndex:0];
//        [self.templateCategoriesSelectTableView reloadData];
//        if (!_defaultTemplateModel) {
//            
//            [self setSelectedTemplateCategory:categoryModel];
//        }
//        
//    } withErrorHandler:^(NSError *error) {
//        
//        [self dismissLoading];
//        NSString *localErrorMsg = [error localizedDescription];
//        
//        RIButtonItem *cancelButtonItem = [RIButtonItem itemWithLabel:@"确定" action:^{
//           
//            [self.navigationController popViewControllerAnimated:YES];
//        }];
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:localErrorMsg cancelButtonItem:cancelButtonItem otherButtonItems:nil, nil];
//        [alertView show];
//    }];
}

- (void)setupViews {
    
    UIView *contentView = self.contentScrollView;
    
    [self.view addSubview:self.contentScrollView];
    {
        [self.view addConstraints:[self.contentScrollView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero]];
    }
    
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    
    [contentView addSubview:self.templateNameField];
    {
        [contentView addConstraint:[self.templateNameField autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10.0f]];
        [contentView addConstraint:[self.templateNameField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraints:[self.templateNameField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 45.0f)]];
    }
    
    [contentView addSubview:self.templateCategoryTitle];
    {
        [contentView addConstraint:[self.templateCategoryTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.templateNameField withOffset:15.0f]];
        [contentView addConstraint:[self.templateCategoryTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    }
    
    [contentView addSubview:self.templateCategoryButton];
    {
        [contentView addConstraint:[self.templateCategoryButton autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateCategoryTitle]];
        [contentView addConstraint:[self.templateCategoryButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.templateCategoryTitle]];
        [contentView addConstraint:[self.templateCategoryButton autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.templateNameField]];
    }
    
    [self.templateCategoryButton addSubview:self.templateCategoryButtonIcon];
    {
        [self.templateCategoryButton addConstraints:[self.templateCategoryButtonIcon autoSetDimensionsToSize:CGSizeMake(20.0f, 20.0f)]];
        [self.templateCategoryButton addConstraint:[self.templateCategoryButtonIcon autoAlignAxisToSuperviewAxis:ALAxisHorizontal]];
        [self.templateCategoryButton addConstraint:[self.templateCategoryButtonIcon autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    }
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    [contentView addSubview:line];
    {
        [contentView addConstraints:[line autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 0.7f)]];
        [contentView addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraint:[line autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.templateNameField withOffset:15.0f]];
    }
    
    [contentView addSubview:self.templateItemTitle];
    {
        [contentView addConstraint:[self.templateItemTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.templateNameField withOffset:30.0f]];
        [contentView addConstraint:[self.templateItemTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraint:[self.templateNameField autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    }
    
    [contentView addSubview:self.templateItemsContainer];
    {
        [contentView addConstraint:[self.templateItemsContainer autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.templateItemTitle withOffset:15.0f]];
        [contentView addConstraint:[self.templateItemsContainer autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraints:[self.templateItemsContainer autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 45.0f)]];
    }
    
    [contentView addSubview:self.ageLabel];
    [contentView addSubview:self.sexLabel];
    [contentView addSubview:self.diseaseTimeLabel];
    [contentView addSubview:self.symptomDescriptionLabel];
    CGFloat templateItemWidthAtom = (App_Frame_Width - 20.0f) / 10.0f;
    {
        [contentView addConstraints:[self.ageLabel autoSetDimensionsToSize:CGSizeMake(templateItemWidthAtom * 2, 45.0f)]];
        [contentView addConstraint:[self.ageLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.templateItemsContainer]];
        [contentView addConstraint:[self.ageLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateItemsContainer]];
        
        [contentView addConstraints:[self.sexLabel autoSetDimensionsToSize:CGSizeMake(templateItemWidthAtom * 2, 45.0f)]];
        [contentView addConstraint:[self.sexLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.ageLabel]];
        [contentView addConstraint:[self.sexLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateItemsContainer]];
        
        [contentView addConstraints:[self.diseaseTimeLabel autoSetDimensionsToSize:CGSizeMake(templateItemWidthAtom * 3, 45.0f)]];
        [contentView addConstraint:[self.diseaseTimeLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.sexLabel]];
        [contentView addConstraint:[self.diseaseTimeLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateItemsContainer]];
        
        [contentView addConstraints:[self.symptomDescriptionLabel autoSetDimensionsToSize:CGSizeMake(templateItemWidthAtom * 3, 45.0f)]];
        [contentView addConstraint:[self.symptomDescriptionLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.diseaseTimeLabel]];
        [contentView addConstraint:[self.symptomDescriptionLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateItemsContainer]];
    }
    
//    UIImageView *line1 = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    UIImageView *line2 = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
    UIImageView *line3 = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
//    [contentView addSubview:line1];
    [contentView addSubview:line2];
    [contentView addSubview:line3];
    {
//        [contentView addConstraints:[line1 autoSetDimensionsToSize:CGSizeMake(0.7f, 45.0f)]];
//        [contentView addConstraint:[line1 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateItemsContainer]];
//        [contentView addConstraint:[line1 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.ageLabel]];
        
        [contentView addConstraints:[line2 autoSetDimensionsToSize:CGSizeMake(0.7f, 45.0f)]];
        [contentView addConstraint:[line2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateItemsContainer]];
        [contentView addConstraint:[line2 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.sexLabel]];
        
        [contentView addConstraints:[line3 autoSetDimensionsToSize:CGSizeMake(0.7f, 45.0f)]];
        [contentView addConstraint:[line3 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.templateItemsContainer]];
        [contentView addConstraint:[line3 autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.diseaseTimeLabel]];
    }
    
    [contentView addSubview:self.updateButton];
    {
        [contentView addConstraint:[self.updateButton autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.templateItemsContainer withOffset:15.0f]];
        [contentView addConstraint:[self.updateButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
    }
    
    [contentView addSubview:self.diyQuestionTitle];
    {
        [contentView addConstraint:[self.diyQuestionTitle autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.updateButton withOffset:20.0f]];
        [contentView addConstraint:[self.diyQuestionTitle autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraint:[self.diyQuestionTitle autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
    }
    
    [contentView addSubview:self.diyQuestionField];
    {
        [contentView addConstraint:[self.diyQuestionField autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.diyQuestionTitle withOffset:15.0f]];
        [contentView addConstraint:[self.diyQuestionField autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
        [contentView addConstraints:[self.diyQuestionField autoSetDimensionsToSize:CGSizeMake(App_Frame_Width - 20.0f, 45.0f)]];
    }
    
    [contentView addSubview:self.diyQuestionsTableView];
    {
        [contentView addConstraint:[self.diyQuestionsTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.diyQuestionField withOffset:20.0f]];
        [contentView addConstraint:[self.diyQuestionsTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [contentView addConstraint:[self.diyQuestionsTableView autoSetDimension:ALDimensionWidth toSize:App_Frame_Width]];
        self.tableViewHeightConstraint = [self.diyQuestionsTableView autoSetDimension:ALDimensionHeight toSize:self.diyQuestions.count * AddTemplateDiyQuestionCellHeight];
        [contentView addConstraint:self.tableViewHeightConstraint];
        [contentView addConstraint:[self.diyQuestionsTableView autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
    }
    
    [contentView addSubview:self.templateCategoriesSelectTableView];
    {
        [contentView addConstraint:[self.templateCategoriesSelectTableView autoPinEdgeToSuperviewEdge:ALEdgeLeft]];
        [contentView addConstraint:[self.templateCategoriesSelectTableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.templateCategoryTitle withOffset:15.7f]];
        
        CGFloat templateCategoriesSelectTableViewHeight = App_Frame_Height - self.templateCategoryTitle.frame.origin.y - self.templateCategoryTitle.frame.size.height - 15.7f;
        [contentView addConstraints:[self.templateCategoriesSelectTableView autoSetDimensionsToSize:CGSizeMake(App_Frame_Width, templateCategoriesSelectTableViewHeight)]];
    }
}

#pragma mark - private methods

- (void)setupWithDefaultTemplateModel:(TemplateModel *)templateModel {
    
    self.templateNameField.text = templateModel.name;
//    [self setSelectedTemplateCategory:templateModel.category];
    [self.updateButton setSelected:templateModel.images];
    self.diyQuestions = [[NSMutableArray alloc] initWithArray:templateModel.fields];
    [self reloadDiyQuestionTableView];
}

- (UILabel *)defaultTemplateItemLabelWithTitle:(NSString *)title {
    
    UILabel *label = [[UILabel alloc] init];
    label.textColor = UIColorFromRGB(0x767e7d);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    return label;
}

- (void)reloadDiyQuestionTableView {
    
    [self.diyQuestionsTableView reloadData];
    self.tableViewHeightConstraint.constant = self.diyQuestions.count * AddTemplateDiyQuestionCellHeight;
}

- (void)showTemplateCategoryTableView {
    
    [self.templateCategoriesSelectTableView setHidden:NO];
    [self.contentScrollView bringSubviewToFront:self.templateCategoriesSelectTableView];
    [self.templateCategoryButtonIcon setImage:[UIImage imageNamed:@"icon_hidden_list"]];
}

- (void)hideTemplateCategoryTableView {
    
    [self.templateCategoriesSelectTableView setHidden:YES];
    [self.templateCategoryButtonIcon setImage:[UIImage imageNamed:@"icon_show_list"]];
}

#pragma mark - TemplateCategoriesSelectTableViewAdapterDelegate Methods

- (void)templateCategorySelected:(TemplateCategoryModel *)templateCategoryModel {
    
    [self hideTemplateCategoryTableView];
    [self setSelectedTemplateCategory:templateCategoryModel];
}

#pragma mark - AddTemplateDiyQuestionCell Delegate

- (void)removeItemWith:(AddTemplateDiyQuestionCell *)cell {
    
    NSIndexPath *indexPath = [self.diyQuestionsTableView indexPathForCell:cell];
    [self.diyQuestions removeObjectAtIndex:indexPath.row];
    [self.diyQuestionsTableView reloadData];
}

#pragma mark - selector

- (void)saveTemplate {
    
    if (self.templateNameField.text.length == 0) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"模板名称不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    
    TemplateModel *templateModel = [[TemplateModel alloc] init];
    templateModel.name = self.templateNameField.text;
    templateModel.age = YES;
    templateModel.sex = YES;
    templateModel.last_time = YES;
    templateModel.symptomDescription = YES;
    
    templateModel.images = self.updateButton.isSelected;
    templateModel.fields = self.diyQuestions;
//    templateModel.category = self.selectedTemplateCategory;
    
    [self showLoading];
    
    [[AccountManager sharedInstance] asyncSaveTemplateWith:templateModel CompletionHandler:^(TemplateModel *templateModel) {
        [self dismissLoading];

        [self showHint:@"添加成功"];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSavedNewTemplate:)]) {
            
            [self.delegate didSavedNewTemplate:templateModel];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } withErrorHandler:^(NSError *error) {
        [self dismissLoading];
        
        [self showHint:[error localizedDescription]];
    }];
}

//- (void)addDiyQuestion:(id)sender {
//    
//    if (self.diyQuestionField.text.length == 0) { return; }
//    
//    [self.diyQuestions addObject:self.diyQuestionField.text];
//    [self.diyQuestionsTableView reloadData];
//}

- (void)updateButtonClicked:(id)sender {
    
    UIButton *btn = sender;
    btn.selected = !btn.selected;
}


- (void)showTemplateCategoryMenu:(id)sender {
    
    if (self.templateCategoriesSelectTableView.isHidden) {
        
        [self showTemplateCategoryTableView];
    }
    else {
        
        [self hideTemplateCategoryTableView];
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (self.diyQuestionField.text.length == 0) { return YES; }
    
    [self.diyQuestions addObject:self.diyQuestionField.text];
    self.diyQuestionField.text = @"";
    [self reloadDiyQuestionTableView];
    
    return YES;
}

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return AddTemplateDiyQuestionCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableView DataSource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.diyQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *AddTemplateDiyQuestionCellReusedIdentifier = @"5ddf52a8-e968-480f-9c4f-ae3e6bb37089";
    NSString *diyQuestion = [self.diyQuestions objectAtIndex:indexPath.row];
    
    AddTemplateDiyQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:AddTemplateDiyQuestionCellReusedIdentifier];
    if (!cell) {
        
        cell = [[AddTemplateDiyQuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AddTemplateDiyQuestionCellReusedIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    [cell loadDataWithDiyQuestion:diyQuestion];
    
    return cell;
}


#pragma mark - properties

- (UIScrollView *)contentScrollView {
    
    if (!_contentScrollView) {
        
        _contentScrollView = [[UIScrollView alloc] init];
    }
    
    return _contentScrollView;
}

- (EXUITextField *)templateNameField {
    
    if (!_templateNameField) {
        
        _templateNameField = [[EXUITextField alloc] init];
        _templateNameField.placeholder = @"模板名称";
        _templateNameField.layer.borderWidth = 0.7f;
        _templateNameField.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
        _templateNameField.layer.cornerRadius = 3.0f;
        _templateNameField.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _templateNameField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
    }
    
    return _templateNameField;
}

- (UILabel *)templateCategoryTitle {
    
    if (!_templateCategoryTitle) {
        
        _templateCategoryTitle = [[UILabel alloc] init];
        _templateCategoryTitle.text = @"模板类别";
        _templateCategoryTitle.textColor = UIColorFromRGB(0x152724);
        _templateCategoryTitle.font = [UIFont systemFontOfSize:20.0f];
        [_templateCategoryTitle setHidden:YES];
    }
    
    return _templateCategoryTitle;
}

- (UIButton *)templateCategoryButton {
    
    if (!_templateCategoryButton) {
        
        _templateCategoryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_templateCategoryButton setTitleColor:UIColorFromRGB(0x152724) forState:UIControlStateNormal];
        [_templateCategoryButton addTarget:self action:@selector(showTemplateCategoryMenu:) forControlEvents:UIControlEventTouchUpInside];
        [_templateCategoryButton setHidden:YES];
    }
    
    return _templateCategoryButton;
}

- (UIImageView *)templateCategoryListIconImageView {
    
    if (!_templateCategoryListIconImageView) {
        
        _templateCategoryListIconImageView = [[UIImageView alloc] init];
    }
    
    return _templateCategoryListIconImageView;
}


- (UILabel *)templateItemTitle {
    
    if (!_templateItemTitle) {
        
        _templateItemTitle = [[UILabel alloc] init];
        _templateItemTitle.text = @"问诊项目";
        _templateItemTitle.textColor = UIColorFromRGB(0x152724);
        _templateItemTitle.font = [UIFont systemFontOfSize:20.0f];
    }
    
    return _templateItemTitle;
}

- (UIView *)templateItemsContainer {
    
    if (!_templateItemsContainer) {
        
        _templateItemsContainer = [[UIView alloc] init];
        _templateItemsContainer.backgroundColor = UIColorFromRGB(0xedf1f2);
        _templateItemsContainer.layer.cornerRadius = 3.0f;
        _templateItemsContainer.layer.borderWidth = 0.7f;
        _templateItemsContainer.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
    }
    
    return _templateItemsContainer;
}

- (UILabel *)ageLabel {
    
    if (!_ageLabel) {
        
        _ageLabel = [self defaultTemplateItemLabelWithTitle:@"年龄"];
    }
    
    return _ageLabel;
}

- (UILabel *)sexLabel {
    
    if (!_sexLabel) {
        
        _sexLabel = [self defaultTemplateItemLabelWithTitle:@"性别"];
    }
    
    return _sexLabel;
}

- (UILabel *)diseaseTimeLabel {
    
    if (!_diseaseTimeLabel) {
        
        _diseaseTimeLabel = [self defaultTemplateItemLabelWithTitle:@"发病时间"];
    }
    
    return _diseaseTimeLabel;
}

- (UILabel *)symptomDescriptionLabel {
    
    if (!_symptomDescriptionLabel) {
        
        _symptomDescriptionLabel = [self defaultTemplateItemLabelWithTitle:@"症状描述"];
    }
    
    return _symptomDescriptionLabel;
}

- (UIButton *)updateButton {
    
    if (!_updateButton) {
        
        _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_updateButton setTitle:@"  是否上传图片" forState:UIControlStateNormal];
        _updateButton.titleLabel.font = [UIFont systemFontOfSize:18.0];
        [_updateButton setTitleColor:UIColorFromRGB(0x152724) forState:UIControlStateNormal];
        [_updateButton setImage:[UIImage imageNamed:@"icon_template_updatePic"] forState:UIControlStateSelected];
        [_updateButton setImage:[UIImage imageNamed:@"icon_template_updatePicSelected"] forState:UIControlStateNormal]; //拷图片的时候命名反了
        
        CGRect frame = _updateButton.imageView.frame;
        frame.size.width = 20.0f;
        frame.size.height = 20.0f;
        _updateButton.imageView.frame = frame;
        
        [_updateButton addTarget:self action:@selector(updateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_updateButton setSelected:YES];
    }
    
    return _updateButton;
}

- (UILabel *)diyQuestionTitle {
    
    if (!_diyQuestionTitle) {
        
        _diyQuestionTitle = [[UILabel alloc] init];
        _diyQuestionTitle.text = @"自定义问题";
        _diyQuestionTitle.textColor = UIColorFromRGB(0x152724);
        _diyQuestionTitle.font = [UIFont systemFontOfSize:20.0f];
    }
    
    return _diyQuestionTitle;
}

- (EXUITextField *)diyQuestionField {
    
    if (!_diyQuestionField) {
        
        _diyQuestionField = [[EXUITextField alloc] init];
        _diyQuestionField.placeholder = @"添加新的问诊问题";
        _diyQuestionField.layer.borderWidth = 0.7f;
        _diyQuestionField.layer.borderColor = [UIColorFromRGB(0xd4d4d4) CGColor];
        _diyQuestionField.layer.cornerRadius = 3.0f;
        _diyQuestionField.backgroundColor = UIColorFromRGB(0xf7f7f7);
        _diyQuestionField.textEdgeInsets = UIEdgeInsetsMake(0.0f, 10.0f, 0.0f, 0.0f);
        _diyQuestionField.delegate = self;
    }
    
    return _diyQuestionField;
}

- (UITableView *)diyQuestionsTableView {
    
    if (!_diyQuestionsTableView) {
        
        _diyQuestionsTableView = [[UITableView alloc] init];
        _diyQuestionsTableView.scrollEnabled = NO;
        _diyQuestionsTableView.delegate = self;
        _diyQuestionsTableView.dataSource = self;
    }
    
    return _diyQuestionsTableView;
}

- (NSMutableArray *)diyQuestions {
    
    if (!_diyQuestions) {
        
        _diyQuestions = [[NSMutableArray alloc] init];
    }
    
    return _diyQuestions;
}

- (UITableView *)templateCategoriesSelectTableView {
    
    if (!_templateCategoriesSelectTableView) {

        _templateCategoriesSelectTableView = [[UITableView alloc] init];
        [_templateCategoriesSelectTableView setHidden:YES];
        _templateCategoriesSelectTableView.delegate = self.templateCategoriesSelectTableViewAdapter;
        _templateCategoriesSelectTableView.dataSource = self.templateCategoriesSelectTableViewAdapter;
        _templateCategoriesSelectTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return _templateCategoriesSelectTableView;
}

- (TemplateCategoriesSelectTableViewAdapter *)templateCategoriesSelectTableViewAdapter {
    
    if (!_templateCategoriesSelectTableViewAdapter) {
        
        _templateCategoriesSelectTableViewAdapter = [[TemplateCategoriesSelectTableViewAdapter alloc] init];
        _templateCategoriesSelectTableViewAdapter.delegate = self;
    }
    
    return _templateCategoriesSelectTableViewAdapter;
}

- (UIImageView *)templateCategoryButtonIcon {
    
    if (!_templateCategoryButtonIcon) {
        
        _templateCategoryButtonIcon = [[UIImageView alloc] init];
        [_templateCategoryButtonIcon setImage:[UIImage imageNamed:@"icon_show_list"]];
    }
    
    return _templateCategoryButtonIcon;
}

- (void)setSelectedTemplateCategory:(TemplateCategoryModel *)selectedTemplateCategory {
    
//    _selectedTemplateCategory = selectedTemplateCategory;
//    [self.templateCategoryButton setTitle:selectedTemplateCategory.name forState:UIControlStateNormal];
}


@end

























