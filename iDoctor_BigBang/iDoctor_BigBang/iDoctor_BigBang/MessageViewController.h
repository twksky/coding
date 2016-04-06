//
//  MessageViewController.h
//  
//
//  Created by twksky on 15/9/14.
//
//

#import "BaseViewController.h"

@interface MessageViewController : BaseViewController

@property (nonatomic, assign) NSInteger systemUnreadMessageCount;
@property (nonatomic, assign) NSInteger recentlyUnreadMessageCount;

- (void)updateUnreadCount:(NSInteger)count withUserID:(NSString *)userID;
- (void)updateUnreadCountWithCmdMessage:(EMMessage *)cmdMessage;//有附件下载，暂时没有用

@end
