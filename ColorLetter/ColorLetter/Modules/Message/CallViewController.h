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

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@class EMCallSession;
@interface CallViewController : UIViewController
{
    NSTimer *_timeTimer;
    AVAudioPlayer *_ringPlayer;
    
    UIView *_topView;
    UILabel *_nameLabel;    
    //操作按钮显示
    UIView *_actionView;
    UIButton *_silenceButton;
    UIButton *_rejectButton;
    UIButton *_answerButton;
    UIButton *_cancelButton;
    UIButton *_videoButton;
    UIButton *_voiceButton;
    UIButton *_switchCameraButton;
}


@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UIButton *rejectButton;

@property (strong, nonatomic) UIButton *answerButton;

@property (strong, nonatomic) UIButton *cancelButton;

@property (nonatomic) BOOL isDismissing;

- (instancetype)initWithSession:(EMCallSession *)session
                       isCaller:(BOOL)isCaller
                         status:(NSString *)statusString;

+ (BOOL)canVideo;

- (void)stateToConnected;

- (void)stateToAnswered;

- (void)setNetwork:(EMCallNetworkStatus)status;

- (void)clear;

@end
