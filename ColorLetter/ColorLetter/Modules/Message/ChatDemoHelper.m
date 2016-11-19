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

#import "ChatDemoHelper.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <EMCallSession.h>
#import <EMOptions.h>


#ifdef REDPACKET_AVALABLE
#import "RedpacketOpenConst.h"
#import "RedPacketUserConfig.h"
#endif

#import "EaseSDKHelper.h"

#if DEMO_CALL == 1

#import <UserNotifications/UserNotifications.h>

#import "CallViewController.h"

@interface ChatDemoHelper()<EMCallManagerDelegate>
{
    NSTimer *_callTimer;
}

@end

#endif

static ChatDemoHelper *helper = nil;

@implementation ChatDemoHelper

+ (instancetype)shareHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[ChatDemoHelper alloc] init];
    });
    return helper;
}

- (void)dealloc
{
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
#if DEMO_CALL == 1
    [[EMClient sharedClient].callManager removeDelegate:self];
#endif
}

- (id)init
{
    self = [super init];
    if (self) {
        [self initHelper];
    }
    return self;
}

#pragma mark - init

- (void)initHelper
{

    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
#if DEMO_CALL == 1
    self.callLock = [[NSObject alloc] init];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeCall:) name:KNOTIFICATION_CALL object:nil];
#endif
}


#pragma mark - EMCallManagerDelegate

#if DEMO_CALL == 1

- (void)callDidReceive:(EMCallSession *)aSession
{
    if ([EaseSDKHelper shareHelper].isShowingimagePicker) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideImagePicker" object:nil];
    }
    
    NSString *callId = @"";
    if (aSession && aSession.sessionId) {
        callId = [aSession sessionId];
    }
    
    if(self.callSession && self.callSession.status != EMCallSessionStatusDisconnected){
        [[EMClient sharedClient].callManager endCall:aSession.sessionId reason:EMCallEndReasonBusy];
        return;
    }
    self.callSession = aSession;
    if(self.callSession){
        [self _startCallTimer];
        
        @synchronized (_callLock) {
            self.callController = [[CallViewController alloc] initWithSession:self.callSession isCaller:NO status:NSLocalizedString(@"call.connecting", "Incoimg call")];
            
            self.callController.modalPresentationStyle = UIModalPresentationOverFullScreen;

            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.callController) {

                    [self.delegate pushCallVC:self.callSession isCaller:NO status:NSLocalizedString(@"call.connecting", "Incoimg call")];

                }
            });
        }
    }
}

- (void)callDidConnect:(EMCallSession *)aSession
{
    if ([aSession.sessionId isEqualToString:self.callSession.sessionId]) {
        NSString *callId = @"";
        if (aSession && aSession.sessionId) {
            callId = [aSession sessionId];
        }
        [self.callController stateToConnected];
    }
}

- (void)callDidAccept:(EMCallSession *)aSession
{
    if ([aSession.sessionId isEqualToString:self.callSession.sessionId]) {
        NSString *callId = @"";
        if (aSession && aSession.sessionId) {
            callId = [aSession sessionId];
        }
        
        [self _stopCallTimer];
        [self.callController stateToAnswered];
    }
}

- (void)callDidEnd:(EMCallSession *)aSession
            reason:(EMCallEndReason)aReason
             error:(EMError *)aError
{
    NSString *callId = @"";
    if (aSession && aSession.sessionId) {
        callId = [aSession sessionId];
    }
    
    if ([aSession.sessionId isEqualToString:_callSession.sessionId]) {
        
        [self _stopCallTimer];
        
        @synchronized (_callLock) {
            self.callSession = nil;
            [self dismissCurrentCallController];
        }
        
        if (aReason != EMCallEndReasonHangup) {
            NSString *reasonStr = @"";
            switch (aReason) {
                case EMCallEndReasonNoResponse:
                {
                    reasonStr = NSLocalizedString(@"call.noResponse", @"NO response");
                }
                    break;
                case EMCallEndReasonDecline:
                {
                    reasonStr = NSLocalizedString(@"call.rejected", @"Reject the call");
                }
                    break;
                case EMCallEndReasonBusy:
                {
                    reasonStr = NSLocalizedString(@"call.in", @"In the call...");
                }
                    break;
                case EMCallEndReasonFailed:
                {
                    reasonStr = NSLocalizedString(@"call.connectFailed", @"Connect failed");
                }
                    break;
//                case EMCallEndReasonUnsupported:
//                {
//                    reasonStr = NSLocalizedString(@"call.connectUnsupported", @"Unsupported");
//                }
//                    break;
//                case EMCallEndReasonRemoteOffline:
//                {
//                    reasonStr = NSLocalizedString(@"call.offline", @"Remote offline");
//                }
//                    break;
                default:
                    break;
            }
            
            if (aError) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:aError.errorDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                [alertView show];
            }
            else{
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:reasonStr delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                [alertView show];
            }
        }
    }
}

- (void)didReceiveCallNetworkChanged:(EMCallSession *)aSession status:(EMCallNetworkStatus)aStatus
{
    if ([aSession.sessionId isEqualToString:self.callSession.sessionId]) {
        [self.callController setNetwork:aStatus];
    }
}

#endif

#pragma mark - public 

#if DEMO_CALL == 1

- (void)makeCall:(NSNotification*)notify
{
    if (notify.object) {
        EMCallType type = (EMCallType)[[notify.object objectForKey:@"type"] integerValue];
        [self makeCallWithUsername:[notify.object valueForKey:@"chatter"] type:type];
    }
}

- (void)_startCallTimer
{
    _callTimer = [NSTimer scheduledTimerWithTimeInterval:50 target:self selector:@selector(_cancelCall) userInfo:nil repeats:NO];
}

- (void)_stopCallTimer
{
    if (_callTimer == nil) {
        return;
    }
    
    [_callTimer invalidate];
    _callTimer = nil;
}

- (void)_cancelCall {
    [self hangupCallWithReason:EMCallEndReasonNoResponse];
}


- (void)makeCallWithUsername:(NSString *)aUsername
                        type:(EMCallType)aType {
    if ([aUsername length] == 0) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    void (^completionBlock)(EMCallSession *, EMError *) = ^(EMCallSession *aCallSession, EMError *aError){
        ChatDemoHelper *strongSelf = weakSelf;
        if (strongSelf) {
            if (aError || aCallSession == nil) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"call.initFailed", @"Establish call failure") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                [alertView show];
                return;
            }
            
            @synchronized (self.callLock) {
                self.callSession = aCallSession;
                self.callController = [[CallViewController alloc] initWithSession:self.callSession isCaller:YES status:NSLocalizedString(@"call.connecting", @"Connecting...")];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.callController) {
                        
                        [self.delegate pushCallVC:self.callSession isCaller:YES status:NSLocalizedString(@"call.connecting", @"Connecting...")];
                    }
                });
            }
            
            [self _startCallTimer];
        }
        else {
            [[EMClient sharedClient].callManager endCall:aCallSession.sessionId reason:EMCallEndReasonNoResponse];
        }
    };
    
    if (aType == EMCallTypeVideo) {
        [[EMClient sharedClient].callManager startVideoCall:aUsername completion:^(EMCallSession *aCallSession, EMError *aError) {
            completionBlock(aCallSession, aError);
        }];
    }
    else {
        [[EMClient sharedClient].callManager startVoiceCall:aUsername completion:^(EMCallSession *aCallSession, EMError *aError) {
            completionBlock(aCallSession, aError);
        }];
    }
}

- (void)hangupCallWithReason:(EMCallEndReason)aReason
{
    [self _stopCallTimer];
    
    EMCallSession *tmpSession = self.callSession;
    if (tmpSession) {
        [[EMClient sharedClient].callManager endCall:tmpSession.sessionId reason:aReason];
    }
    
    @synchronized (_callLock) {
        self.callSession = nil;
        
        [self dismissCurrentCallController];
    }
}

- (void)answerCall:(NSString *)aCallId
{
    if (_callSession && [_callSession.sessionId isEqualToString:aCallId]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            EMError *error = [[EMClient sharedClient].callManager answerIncomingCall:self.callSession.sessionId];
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error.code == EMErrorNetworkUnavailable) {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"network.disconnection", @"Network disconnection") delegate:nil cancelButtonTitle:NSLocalizedString(@"ok", @"OK") otherButtonTitles:nil, nil];
//                        [alertView show];
                    }
                    else{
                        [self hangupCallWithReason:EMCallEndReasonFailed];
                    }
                });
            }
        });
    }
}

- (void)dismissCurrentCallController
{
    self.callController.isDismissing = YES;
    CallViewController *tmpController = self.callController;
    self.callController = nil;
    if (tmpController) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_viewController dismissViewControllerAnimated:YES completion:nil];
        });
        
        [tmpController clear];
        tmpController = nil;
    }
}

#endif

#pragma mark - private
- (BOOL)_needShowNotification:(NSString *)fromChatter
{
    BOOL ret = YES;
    NSArray *igGroupIds = [[EMClient sharedClient].groupManager getGroupsWithoutPushNotification:nil];
    for (NSString *str in igGroupIds) {
        if ([str isEqualToString:fromChatter]) {
            ret = NO;
            break;
        }
    }
    return ret;
}

- (void)_clearHelper {
    [[EMClient sharedClient] logout:NO];
    
#if DEMO_CALL == 1
    [self hangupCallWithReason:EMCallEndReasonFailed];
#endif
}

@end
