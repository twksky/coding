//
//  DFDQuickQuestionTableViewCell.h
//  AppFramework
//
//  Created by DebugLife on 2/13/15.
//  Copyright (c) 2015 AppChina. All rights reserved.
//

#import "DFDSubtitleTableViewCell.h"

@class QuickQuestion;

#define kQuickQuestionThumbnailImageClickedEvent    @"8EF95AE9-D6E4-4D6B-8CC2-A468755F95E1"
#define kQuickQuestionKey   @"quickQuestion"
#define kImageIndexKey      @"imageIndex"
#define kQuickQuestionTableViewCellKey @"quickQuestionTableViewCell"

@interface DFDQuickQuestionDetailTableViewCell : DFDSubtitleTableViewCell

+ (CGFloat)cellHeightWithQuickQuestion:(QuickQuestion *)question;

- (void)loadQuickQuestion:(QuickQuestion *)question;

- (void) addSpreadBtnAction:(SEL)action withTarget:(id)target;

@end
