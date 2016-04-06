//
//  TemplateSettingMyTemplateCollectionViewDataSource.m
//  AppFramework
//
//  Created by tianxiewuhua on 15/6/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import "TemplateSettingTemplateCollectionViewAdapter.h"
#import "TemplateCollectionViewCell.h"
#import "TemplateSettingViewController.h"

@interface TemplateSettingTemplateCollectionViewAdapter ()

@property (nonatomic, strong) NSString *reuseIdentifier;

@end

@implementation TemplateSettingTemplateCollectionViewAdapter

- (instancetype)initWithReusedIdentifer:(NSString *)reusedIdentifer {
    
    self = [super init];
    if (self) {
        
        self.reuseIdentifier = reusedIdentifer;
    }
    
    return self;
}



#pragma mark - UICollectionView Delegate Methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < [self.templates count]) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedTemplate:)]) {
            
            TemplateModel *templateModel = [self.templates objectAtIndex:indexPath.row];
            [self.delegate didSelectedTemplate:templateModel];
        }
    }
    else {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(addNewTemplate)]) {
            
            [self.delegate addNewTemplate];
        }
    }
}

#pragma mark - UICollectionView DataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.templates count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
        
    TemplateCollectionViewCell *templateCollectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
    if (indexPath.row < [self.templates count]) {
        
        TemplateModel *template = [self.templates objectAtIndex:indexPath.row];
        [templateCollectionViewCell loadDataWithTemplateModel:template];
    }
    else {
        
        [templateCollectionViewCell setAsAddTemplateCellStyle];
    }
    
    return templateCollectionViewCell;
}
#pragma mark - properties

-(NSArray *)templates {
    
    if (!_templates) {
        
        _templates = [[NSArray alloc] init];
    }
    
    return _templates;
}

@end
