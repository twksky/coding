//
//  TemplateSettingTemplateLibsCollectionViewAdapter.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "TemplateSettingTemplateLibsCollectionViewAdapter.h"
#import "TemplateCategoryCollectionViewCell.h"
#import "TemplateSettingViewController.h"
#import "templateCategoryModel.h"

@interface TemplateSettingTemplateLibsCollectionViewAdapter ()

@property (nonatomic, strong) NSString *reuseIdentifier;

@end

@implementation TemplateSettingTemplateLibsCollectionViewAdapter

- (instancetype)initWithReusedIdentifer:(NSString *)reusedIdentifer {
    
    self = [super init];
    if (self) {
        
        self.reuseIdentifier = reusedIdentifer;
    }
    
    return self;
}


#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTemplateCategory:)]) {
        
        TemplateCategoryModel *category = [self.templateLibs objectAtIndex:indexPath.row];
        [self.delegate didSelectedTemplateCategory:category];
    }
}

#pragma mark - UICollectionView DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.templateLibs count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TemplateCategoryCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    TemplateCategoryModel *templateCategoryModel = [self.templateLibs objectAtIndex:indexPath.row];
    [cell loadDataWithTemplateModel:templateCategoryModel];
    
    return cell;
}
#pragma mark - properties

-(NSArray *)templateLibs {
    
    if (!_templateLibs) {
        
        _templateLibs = [[NSArray alloc] init];
    }
    
    return _templateLibs;
}

@end
