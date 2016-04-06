//
//  HomeInfoModel.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/9/23.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeInfoModel : NSObject

/*
 'id': fields.Integer,
 'title': fields.String,
 'username': fields.String,
 'banner_url': fields.String,
 'short_desc': fields.String,
 'info_url': fields.String,
 'comments_count': fields.Integer,
 'share_num': fields.Integer,
 */

@property (nonatomic, assign) NSInteger h_id;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *banner_url;
@property (nonatomic, strong) NSString *short_desc;
@property (nonatomic, strong) NSString *info_url;
@property (nonatomic, assign) NSInteger comments_count;
@property (nonatomic, assign) NSInteger share_num;

@end
