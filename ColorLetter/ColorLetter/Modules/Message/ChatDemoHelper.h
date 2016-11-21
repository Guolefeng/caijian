/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import <Foundation/Foundation.h>
@class FZYTabBarViewController;
@class FZY_MessageViewController;

@protocol ChatDemoHelperDelegate <NSObject>

- (void)pushCallVC:(EMCallSession *)session isCaller:(BOOL)isCaller status:(NSString *)status;

@end

#if DEMO_CALL == 1

#import "CallViewController.h"

@interface ChatDemoHelper : NSObject
<
EMClientDelegate,
EMChatManagerDelegate,
EMContactManagerDelegate,
EMGroupManagerDelegate,
EMChatroomManagerDelegate,
EMCallManagerDelegate
>

@property (nonatomic, assign) id<ChatDemoHelperDelegate>delegate;

@property (nonatomic, strong) UIViewController *viewController;

#endif

#if DEMO_CALL == 1

@property (strong, nonatomic) NSObject *callLock;
@property (strong, nonatomic) EMCallSession *callSession;
@property (strong, nonatomic) CallViewController *callController;

#endif

+ (instancetype)shareHelper;

#if DEMO_CALL == 1

+ (void)updateCallOptions;

- (void)makeCallWithUsername:(NSString *)aUsername
                        type:(EMCallType)aType;

- (void)hangupCallWithReason:(EMCallEndReason)aReason;

- (void)answerCall:(NSString *)aCallId;

- (void)dismissCurrentCallController;

#endif

@end
