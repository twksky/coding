//
//  TemplateCategoriesSelectTableViewDataSource.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/22.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "TemplateCategoriesSelectTableViewAdapter.h"
#import "TemplateCategoryModel.h"
#import "SkinManager.h"
#import <PureLayout.h>

@implementation TemplateCategoriesSelectTableViewAdapter


#pragma mark - UITableView DataSource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TemplateCategoriesSelectTableViewDataSourceReusedCellIdentifier = @"5bb7ad17-34de-468c-a644-d4a542d125f3";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TemplateCategoriesSelectTableViewDataSourceReusedCellIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TemplateCategoriesSelectTableViewDataSourceReusedCellIdentifier];
        
        UIImageView *line = [[UIImageView alloc] initWithImage:[SkinManager sharedInstance].defaultLineImage];
        
        [cell addSubview:line];
        {
            [cell addConstraint:[line autoSetDimension:ALDimensionHeight toSize:0.7f]];
            [cell addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10.0f]];
            [cell addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:10.0f]];
            [cell addConstraint:[line autoPinEdgeToSuperviewEdge:ALEdgeBottom]];
        }
    }
    
    TemplateCategoryModel *categoryModel = [self.templateCategories objectAtIndex:indexPath.row];
    cell.textLabel.text = categoryModel.name;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.templateCategories count];
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(templateCategorySelected:)]) {
        
        TemplateCategoryModel *categoryModel = [self.templateCategories objectAtIndex:indexPath.row];
        [self.delegate templateCategorySelected:categoryModel];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - properties 

- (NSArray *)templateCategories {
    
    if (!_templateCategories) {
        
        _templateCategories = [[NSArray alloc] init];
    }
    
    return _templateCategories;
}

@end
