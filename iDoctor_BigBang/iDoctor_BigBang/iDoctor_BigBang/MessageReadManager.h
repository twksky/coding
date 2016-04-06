//
//  MessageReadManager.h
//  iDoctor_BigBang
//
//  Created by twksky on 15/10/16.
//  Copyright © 2015年 YDHL. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MWPhotoBrowser.h>//三方库，一个图片查看的三方库，查看照片
#import "MessageModel.h"

typedef void (^FinishBlock)(BOOL success);
typedef void (^PlayBlock)(BOOL playing, MessageModel *messageModel);

@class EMChatFireBubbleView;
@interface MessageReadManager : NSObject<MWPhotoBrowserDelegate>

@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (strong, nonatomic) FinishBlock finishBlock;

//@property (strong, nonatomic) MessageModel *audioMessageModel;

+ (id)defaultManager;

//default
- (void)showBrowserWithImages:(NSArray *)imageArray;

/**
 *  准备播放语音文件
 *
 *  @param messageModel     要播放的语音文件
 *  @param updateCompletion 需要更新model所在的Cell
 *
 *  @return 若返回NO，则不需要调用播放方法
 *
 */
//- (BOOL)prepareMessageAudioModel:(MessageModel *)messageModel
//            updateViewCompletion:(void (^)(MessageModel *prevAudioModel, MessageModel *currentAudioModel))updateCompletion;
//
//- (MessageModel *)stopMessageAudioModel;

@end

