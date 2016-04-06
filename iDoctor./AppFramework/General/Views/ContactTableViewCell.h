//
//  ContactTableViewCell.h
//  AppFramework
//
//  Created by ABC on 8/14/14.
//  Copyright (c) 2014 iHaoyisheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Patient;
@class ContactTableViewCell;

@protocol ContactTableViewCellDelegate <NSObject>

- (void)contactTableViewCellDidClickedAvatarImage:(ContactTableViewCell *)cell;

@end

@interface ContactTableViewCell : UITableViewCell

@property (nonatomic, weak)   id<ContactTableViewCellDelegate> delegate;

@property (nonatomic, strong) UIImageView   *avatarImageView;
@property (nonatomic, strong) UILabel       *nicknameLabel;
@property (nonatomic, strong) UILabel       *infoLabel;

- (void)setContact:(Patient *)patient;

@end
