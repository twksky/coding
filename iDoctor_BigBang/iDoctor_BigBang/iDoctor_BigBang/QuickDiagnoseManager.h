//
//  QuickDiagnoseManager.h
//  iDoctor_BigBang
//
//  Created by 周世阳 on 15/10/16.
//  Copyright © 2015年 YDHL. All rights reserved.
//

@class QuickDiagnoseComment;

@interface QuickDiagnoseManager : NSObject

+ (instancetype)sharedInstance;

- (void)getQuickDiagnoseListWithDepartment:(NSString *)department withRegion:(NSInteger)regionId withPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *quickDiagnoseList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)getQuickDiagnoseCommentsWithQuickDiagnoseId:(NSInteger)quickDiagnoseId withCompletionHandler:(void (^)(NSArray *comments))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)getQuickDiagnoseAllCommentsWithQuickDiagnoseId:(NSInteger)quickDiagnoseId withCompletionHandler:(void (^)(NSArray *comments))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)replyQuickDiagnoseWithContent:(NSString *)content withQuickDiagnoseId:(NSInteger)quickDiagnoseId withCompletionHandler:(void (^)(QuickDiagnoseComment *comment))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)getRepliedQuickDiagnosesWithPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *quickDiagnoseList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

- (void)getMasterDiagnosesWithPage:(NSInteger)page withSize:(NSInteger)size withCompletionHandler:(void (^)(NSArray *masterDiagnoseList))completionHandler withErrorHandler:(void (^)(NSError *error))errorHandler;

@end
