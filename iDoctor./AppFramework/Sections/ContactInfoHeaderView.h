//
//  ContactInfoHeaderView.h
//  AppFramework
//
//  Created by 周世阳 on 15/5/19.
//  Copyright (c) 2015年 AppChina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;

@protocol ContactInfoHeaderViewDelegate <NSObject>

- (void)changeDisplayNameButtonClicked;

@end

@interface ContactInfoHeaderView : UIView

@property (nonatomic, weak) id<ContactInfoHeaderViewDelegate> delegate;

//- (void)setAvatarWithImage:(UIImage *)image;
//
//- (void)setName:(NSString *)name;
//
//- (void)setRecordID:(NSString *)recordID;

- (void)loadDataWithPatient:(Patient *)patient;

@end
