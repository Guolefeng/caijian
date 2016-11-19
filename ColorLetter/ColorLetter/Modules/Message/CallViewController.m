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

#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import "CallViewController.h"

#import "ChatDemoHelper.h"

@interface CallViewController ()
{
    BOOL _isCaller;
    NSString *_status;
    int _timeLength;
    NSTimer *_propertyTimer;

}

@property (nonatomic, weak) EMCallSession *callSession;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation CallViewController

- (instancetype)initWithSession:(EMCallSession *)session
                       isCaller:(BOOL)isCaller
                         status:(NSString *)statusString
{
    self = [super init];
    if (self) {
        _callSession = session;
        _isCaller = isCaller;
        _timeLabel.text = @"";
        _timeLength = 0;
        _status = statusString;
        _isDismissing = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    if (_isDismissing) {
        return;
    }
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"phonepad_bg_1"]];
    _imageView.frame = [UIScreen mainScreen].bounds;
    [self.view addSubview:_imageView];
    [self.view sendSubviewToBack:_imageView];

    [self.view addGestureRecognizer:self.tapRecognizer];
    [self _setupSubviews];
    
    _nameLabel.text = _callSession.remoteUsername;
    if (_isCaller) {
        self.rejectButton.hidden = YES;
        self.answerButton.hidden = YES;
        self.cancelButton.hidden = NO;
    }
    else{
        self.cancelButton.hidden = YES;
        self.rejectButton.hidden = NO;
        self.answerButton.hidden = NO;
    }
    
    [self _setupRemoteView];
    
    if (_callSession.type == EMCallTypeVideo) {
        [self _initializeVideoView];
        
        [self.view bringSubviewToFront:_topView];
        [self.view bringSubviewToFront:_actionView];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (_isDismissing) {
        return;
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (_isDismissing) {
        return;
    }
    
    [super viewDidAppear:animated];
}

#pragma mark - getter

- (BOOL)isShowCallInfo
{
    id object = [[NSUserDefaults standardUserDefaults] objectForKey:@"showCallInfo"];
    if (object == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"showCallInfo"];
        return YES;
    }
    return [object boolValue];
}

#pragma makr - property

- (UITapGestureRecognizer *)tapRecognizer
{
    if (_tapRecognizer == nil) {
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction:)];
    }
    
    return _tapRecognizer;
}

#pragma mark - subviews

- (void)_setupSubviews
{
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    _topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_topView];
    
    _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((WIDTH - 50) / 2,  40, 50, 50)];
    _headerImageView.backgroundColor = [UIColor redColor];
    _headerImageView.image = [UIImage imageNamed:@"user"];
    [_topView addSubview:_headerImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90 + 5, WIDTH, 20)];
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    [_topView addSubview:_nameLabel];
    
    
    if (_callSession.type == EMCallTypeVideo) {
        _switchCameraButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 40, 60, 30)];
        _switchCameraButton.layer.cornerRadius = 15;
        [_switchCameraButton setBackgroundColor:[UIColor grayColor]];
        [_switchCameraButton setTitle:@"切换摄像头" forState:UIControlStateNormal];
        [_switchCameraButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [_switchCameraButton addTarget:self action:@selector(switchCameraAction) forControlEvents:UIControlEventTouchUpInside];
        _switchCameraButton.userInteractionEnabled = YES;
        [_topView addSubview:_switchCameraButton];
    }
    
    _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT * 0.6, WIDTH, HEIGHT * 0.4)];
    _actionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_actionView];
    
    _rejectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rejectButton setImage:[UIImage imageNamed:@"icon_voip_reject"] forState:UIControlStateNormal];
    [_rejectButton addTarget:self action:@selector(rejectAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_rejectButton];
    [_rejectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_actionView.mas_left).offset(WIDTH / 3);
        make.centerY.equalTo(_actionView.mas_centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    _answerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_answerButton setImage:[UIImage imageNamed:@"icon_voip_free_call"] forState:UIControlStateNormal];
    [_answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
    [_actionView addSubview:_answerButton];
    [_answerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_actionView.mas_right).offset( - WIDTH / 3);
        make.centerY.equalTo(_actionView.mas_centerY);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitle:@"挂断" forState:UIControlStateNormal];
    _cancelButton.layer.cornerRadius = 20;
    [_cancelButton addTarget:self action:@selector(hangupAction) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.backgroundColor = [UIColor redColor];
    [_actionView addSubview:_cancelButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_actionView.mas_centerX);
        make.centerY.equalTo(_actionView.mas_centerY);
        make.width.equalTo(@(WIDTH * 0.6));
        make.height.equalTo(@40);
    }];
}

- (void)_setupRemoteView
{
    //1.对方窗口
    if (_callSession.type == EMCallTypeVideo && _callSession.remoteVideoView == nil) {
        _callSession.remoteVideoView = [[EMCallRemoteView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
//        _callSession.videoBitrate = 1000;
        _callSession.remoteVideoView.hidden = YES;
        _callSession.remoteVideoView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_callSession.remoteVideoView];
        [self.view sendSubviewToBack:_callSession.remoteVideoView];
        [self.view sendSubviewToBack:_imageView];
        
        __weak CallViewController *weakSelf = self;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            weakSelf.callSession.remoteVideoView.hidden = NO;
        });
        
    }
}

- (void)_initializeVideoView
{
    //自己窗口
    CGFloat width = 80;
    CGFloat height = self.view.frame.size.height / self.view.frame.size.width * width;
    _callSession.localVideoView = [[EMCallLocalView alloc] initWithFrame:CGRectMake(WIDTH - 90, 20, 80, height) withSessionPreset:AVCaptureSessionPreset640x480];
    [self.view addSubview:_callSession.localVideoView];
    
}

#pragma mark - private

- (void)_reloadPropertyData
{
    if (_callSession) {
        NSString *connectStr = @"None";
        if (_callSession.connectType == EMCallConnectTypeRelay) {
            connectStr = @"Relay";
        } else if (_callSession.connectType == EMCallConnectTypeDirect) {
            connectStr = @"Direct";
        }
    }
}

- (void)_beginRing
{
    [_ringPlayer stop];
    
    NSString *musicPath = [[NSBundle mainBundle] pathForResource:@"callRing" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:musicPath];
    
    _ringPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_ringPlayer setVolume:1];
    _ringPlayer.numberOfLoops = -1; //设置音乐播放次数  -1为一直循环
    if([_ringPlayer prepareToPlay])
    {
        [_ringPlayer play]; //播放
    }
}

- (void)_stopRing
{
    [_ringPlayer stop];
}

- (void)timeTimerAction:(id)sender
{
    _timeLength += 1;
    int hour = _timeLength / 3600;
    int m = (_timeLength - hour * 3600) / 60;
    int s = _timeLength - hour * 3600 - m * 60;
    
    if (hour > 0) {
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i:%i", hour, m, s];
    }
    else if(m > 0){
        _timeLabel.text = [NSString stringWithFormat:@"%i:%i", m, s];
    }
    else{
        _timeLabel.text = [NSString stringWithFormat:@"00:%i", s];
    }
}

#pragma mark - UITapGestureRecognizer

- (void)viewTapAction:(UITapGestureRecognizer *)tap
{
    _topView.hidden = !_topView.hidden;
    _actionView.hidden = !_actionView.hidden;
}

#pragma mark - action

- (void)switchCameraAction
{
    [_callSession switchCameraPosition:_switchCameraButton.selected];
    _switchCameraButton.selected = !_switchCameraButton.selected;
}


- (void)speakerOutAction
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:YES error:nil];
}

- (void)answerAction
{
#if DEMO_CALL == 1
    [self _stopRing];
    self.answerButton.enabled = NO;
    [[ChatDemoHelper shareHelper] answerCall:_callSession.sessionId];
#endif
}

- (void)hangupAction
{
#if DEMO_CALL == 1
    [_timeTimer invalidate];
    [self _stopRing];
    
    [[ChatDemoHelper shareHelper] hangupCallWithReason:EMCallEndReasonHangup];
#endif
}

- (void)rejectAction
{
#if DEMO_CALL == 1
    [_timeTimer invalidate];
    [self _stopRing];
    
    [[ChatDemoHelper shareHelper] hangupCallWithReason:EMCallEndReasonDecline];
#endif
}

#pragma mark - public

+ (BOOL)canVideo
{
    if([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending){
        if(!([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized)){\
            return NO;
        }
    }
    
    return YES;
}

- (void)startTimeTimer
{
    _timeLength = 0;
    _timeTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeTimerAction:) userInfo:nil repeats:YES];
}

- (void)startShowInfo
{
    if ([self isShowCallInfo] || _callSession.type == EMCallTypeVoice) {
        [self _reloadPropertyData];
        _propertyTimer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(_reloadPropertyData) userInfo:nil repeats:YES];
    }
}

- (void)setNetwork:(EMCallNetworkStatus)status
{
    switch (status) {
        case EMCallNetworkStatusNormal:
        {
        
        }
            break;
        case EMCallNetworkStatusUnstable:
        {
            [TSMessage showNotificationWithTitle:@"" subtitle:@"当前网络不稳定" type:TSMessageNotificationTypeWarning];
        }
            break;
        case EMCallNetworkStatusNoData:
        {
            [TSMessage showNotificationWithTitle:@"" subtitle:@"没有通话数据" type:TSMessageNotificationTypeWarning];
        }
            break;
        default:
            break;
    }
}

- (void)stateToConnected {
//    self.statusLabel.text = NSLocalizedString(@"call.finished", "Establish call finished");
}

- (void)stateToAnswered
{
    NSString *connectStr = @"None";
    if (_callSession.connectType == EMCallConnectTypeRelay) {
        connectStr = @"Relay";
    } else if (_callSession.connectType == EMCallConnectTypeDirect) {
        connectStr = @"Direct";
    }
    
//    self.statusLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"call.speak", @"Can speak..."), connectStr];
    self.timeLabel.hidden = NO;
    [self startTimeTimer];
    [self startShowInfo];
    self.cancelButton.hidden = NO;
    self.rejectButton.hidden = YES;
    self.answerButton.hidden = YES;
    
    [self _setupRemoteView];
}

- (void)clear
{
    _callSession.remoteVideoView.hidden = YES;
    _callSession = nil;
    
    if (_timeTimer) {
        [_timeTimer invalidate];
        _timeTimer = nil;
    }
    
    if (_propertyTimer) {
        [_propertyTimer invalidate];
        _propertyTimer = nil;
    }
}

@end
