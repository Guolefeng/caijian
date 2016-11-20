//
//  FZY_ChatViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ChatViewController.h"
#import "FZY_ChatTableViewCell.h"
#import "FZY_ChatModel.h"
#import "FZY_KeyboardCollectionViewCell.h"
#import "Mp3Recorder.h"
#import "UUProgressHUD.h"
#import "FZY_ChatterInfoViewController.h"

@interface FZY_ChatViewController ()

<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate,
EMChatManagerDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
Mp3RecorderDelegate,
BMKMapViewDelegate
>

{
    BOOL isbeginVoiceRecord;
    Mp3Recorder *MP3;
    NSInteger playTime;
    NSTimer *playTimer;
//    BMKMapView* _mapView;
    BMKLocationService *_locService;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *downView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) EMConversation *conversation;
@property (nonatomic, assign) CGFloat keyboard_H;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) UICollectionView *optionsCollectionView;;
@property (nonatomic, strong) NSArray *optionsArray;
@property (nonatomic, assign) BOOL isShow;

@property (nonatomic, retain) UIButton *btnVoiceRecord;
@property (nonatomic, strong) UIButton *sendMessageButton;
@property (nonatomic, strong) UIButton *optionVioceButton;
@property (nonatomic, strong) UITextView *importTextField;
@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKUserLocation *userLocation;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) NSArray *objectArray;

@property (nonatomic, copy) NSString *userImage;

@property (nonatomic, copy) NSString *friendImage;
@property (nonatomic, assign) BOOL isMapClose;

@end

@implementation FZY_ChatViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _importTextField.delegate = nil;
    _mapView.delegate = nil;
    MP3.delegate = nil;
    _optionsCollectionView.delegate = nil;
    _optionsCollectionView.dataSource = nil;
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)displayGeographicInformationLAT:(double)latitude LON:(double)longitude {
    BMKPointAnnotation *pointAnnotation = [[BMKPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    [_mapView addAnnotation:pointAnnotation];
    [self mapView:_mapView viewForAnnotation:(id)self];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        BMKPinAnnotationView*annotationView = (BMKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        annotationView.pinColor = BMKPinAnnotationColorPurple;
        return annotationView;
    }
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
     self.objectArray = [[FZY_DataHandle shareDatahandle] select:nil];
    for (FZY_User *user in _objectArray) {
        if (user.name == [[EMClient sharedClient] currentUsername]) {
            _userImage = user.imageUrl;
        }else if (_friendName == user.name) {
            _friendImage = user.imageUrl;
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createRightItem];
    
    self.title = _friendName;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor grayColor];
    
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    //启动LocationService
    [_locService startUserLocationService];
    
    self.isMapClose = YES;
    
    self.mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _mapView.mapType = BMKMapTypeStandard;
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    _mapView.showsUserLocation = YES;//显示定位图层
    self.view = _mapView;
    
    [self loadConversationHistory];
    
    [self creatChatTableViewAndTextField];

    // 接收消息
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    // 添加 键盘弹出 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
 
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    // 移除聊天消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

#pragma mark - 好友详情
- (void)createRightItem {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tab-home"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)rightBarAction {
    FZY_ChatterInfoViewController *chatterInfoVC = [[FZY_ChatterInfoViewController alloc] init];
    chatterInfoVC.friendImage  =_friendImage;
    chatterInfoVC.friendName = _friendName;
    [self.navigationController pushViewController:chatterInfoVC animated:YES];
    
}
//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [_mapView updateLocationData:userLocation];
    _latitude = userLocation.location.coordinate.latitude;
    _longitude = userLocation.location.coordinate.longitude;



}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView updateLocationData:userLocation];
    _latitude = userLocation.location.coordinate.latitude;
    _longitude = userLocation.location.coordinate.longitude;

}

#pragma mark - 获取与好友的聊天历史记录
- (void)loadConversationHistory {
    [_dataSourceArray removeAllObjects];
    
    if (_isGroupChat) {
        self.conversation = [[EMClient sharedClient].chatManager getConversation:_friendName type:EMConversationTypeGroupChat createIfNotExist:YES];
    } else {
        self.conversation = [[EMClient sharedClient].chatManager getConversation:_friendName type:EMConversationTypeChat createIfNotExist:YES];
    }
    
    // 获取当前用户名
    NSString *userName = [[EMClient sharedClient] currentUsername];
    //  从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息取
    [_conversation loadMessagesStartFromId:nil count:20 searchDirection:EMMessageSearchDirectionUp completion:^(NSArray *aMessages, EMError *aError) {
        
        if (!aError) {
//            NSLog(@"载入历史消息成功");
            
            if (aMessages.count) {
                
                for (EMMessage *mes in aMessages) {
                    
                    EMMessageBody *msgBody = mes.body;
                    FZY_ChatModel * model = [[FZY_ChatModel alloc] init];
                    
                    switch (msgBody.type) {
                        case EMMessageBodyTypeText:
                        {
//                            NSLog(@"文字");
                            EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                            
                            NSString *txt = textBody.text;
                            
                            if ([mes.from isEqualToString:userName]) {
                                model.isSelf = YES;
                            } else{
                                model.isSelf = NO;
                            }
                            
                            model.fromUser = mes.from;
                            
                            model.time = mes.localTime;
                            model.context = txt;
                            model.isPhoto = NO;
                            model.isVoice = NO;
                            [self.dataSourceArray addObject:model];
                            
                            if (_dataSourceArray.count > 0) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                                [self insertMessageIntoTableViewWith:indexPath];
                            }
                        }
                            break;
                        case EMMessageBodyTypeImage:
                        {
//                            NSLog(@"图片");
                            EMImageMessageBody *imageBody = (EMImageMessageBody *)msgBody;
                            model.photoName = imageBody.remotePath;
                            if ([mes.from isEqualToString:userName]) {
                                model.isSelf = YES;
                            } else{
                                model.isSelf = NO;
                            }
                            model.width = imageBody.size.width;
                            model.height = imageBody.size.height;
                            model.fromUser = mes.from;
                            model.time = mes.localTime;
                            model.isPhoto = YES;
                            model.isVoice = NO;
                            [_dataSourceArray addObject:model];
                            if (_dataSourceArray.count > 0) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                                [self insertMessageIntoTableViewWith:indexPath];
                            }
                            
                        }
                            break;
                        case EMMessageBodyTypeVoice:
                        {
//                            NSLog(@"语音");
                            EMVoiceMessageBody *body = ((EMVoiceMessageBody *)msgBody);
                            
                            model.fromUser = mes.from;
                            model.remoteVoicePath = body.remotePath;
                            model.localVoicePath = body.localPath;
                            if ([mes.from isEqualToString:userName]) {
                                model.isSelf = YES;
                 
                            } else{
                                model.isSelf = NO;
                            }
                            model.isPhoto= NO;
                            model.isVoice = YES;
                            model.voiceDuration = body.duration;
                            model.time = mes.localTime;
                            [_dataSourceArray addObject:model];
                            // 将消息插入 UI
                            if (_dataSourceArray.count > 0) {
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                                [self insertMessageIntoTableViewWith:indexPath];
                            }
                        }
                            break;
                        case EMMessageBodyTypeLocation: {
                            EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                            if (![mes.from isEqualToString:userName]) {
                                [self displayGeographicInformationLAT:body.latitude LON:body.longitude];
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
            }
            
        } else {
//            NSLog(@"载入历史消息失败 : %@", aError);
        }
        
    }];
    
}

/*!
 @method
 @brief 接收到一条及以上cmd消息
 */
- (void)didReceiveCmdMessages:(NSArray *)aCmdMessages {
    
    for (EMMessage *mes in aCmdMessages) {
        
        // cmd消息中的扩展属性
        NSDictionary *ext = mes.ext;
        if ([@"对方正在输入..." isEqualToString:ext[@"name"]]) {
            self.title = @"对方正在输入...";
        }
        else if ([@"end" isEqualToString:ext[@"name"]]) {
            self.title = _friendName;
        }
    }
}

/*!
 @method
 @brief 接收到一条及以上非cmd消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages {
    
        for (EMMessage *message in aMessages) {
            EMMessageBody *msgBody = message.body;
            FZY_ChatModel *model = [[FZY_ChatModel alloc] init];
            
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    // 收到文字消息
                    EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                    NSString *txt = textBody.text;
                    
                    model.fromUser = message.to;
                    model.isSelf = NO;
                    model.isPhoto = NO;
                    model.context = txt;
                    model.time = message.localTime;
                    [_dataSourceArray addObject:model];
                    
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    // 图片消息
                    EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                    
                    model.photoName = body.remotePath;
                    model.width = body.size.width;
                    model.height = body.size.height;
                    model.isSelf = NO;
                    model.isPhoto = YES;
                    model.fromUser = message.to;
                    model.time = message.localTime;
                    [_dataSourceArray addObject:model];
                    // 将消息插入 UI
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                case EMMessageBodyTypeLocation: {
                    EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                    [self displayGeographicInformationLAT:body.latitude LON:body.longitude];
                }
                    break;
                case EMMessageBodyTypeVoice: {
                    // 语音
                    EMVoiceMessageBody *body = ((EMVoiceMessageBody *)msgBody);
                    model.fromUser = message.from;
                    model.remoteVoicePath = body.remotePath;
                    model.localVoicePath = body.localPath;
                    model.isSelf = NO;
                    model.isPhoto= NO;
                    model.isVoice = YES;
                    model.time = message.localTime;
                    model.voiceDuration = body.duration;
                    [_dataSourceArray addObject:model];
                    // 将消息插入 UI
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                default:
                    break;
            }
        }

}

#pragma mark - 发送消息
- (void)sendMessageWithEMMessage:(EMMessage *)message {
    // 发送消息
    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
        if (!error) {
            
            FZY_ChatModel *model = [[FZY_ChatModel alloc] init];
            EMMessageBody *msgBody = message.body;
            
            switch (msgBody.type) {
                case EMMessageBodyTypeText:
                {
                    model.fromUser = message.from;
                    model.context = _importTextField.text;
                    model.isSelf = YES;
                    model.isPhoto = NO;
                    model.time = message.localTime;
                    [_dataSourceArray addObject:model];
                    // 将消息插入 UI
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                case EMMessageBodyTypeImage:
                {
                    EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                    model.fromUser = message.from;
                    model.photoName = body.remotePath;
                    model.isSelf = YES;
                    model.isPhoto= YES;
                    model.time = message.localTime;
                    [_dataSourceArray addObject:model];
                    // 将消息插入 UI
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                case EMMessageBodyTypeVoice:
                {
//                    NSLog(@"发送语音消息");
                    EMVoiceMessageBody *body = ((EMVoiceMessageBody *)msgBody);
                    model.fromUser = message.from;
                    model.remoteVoicePath = body.remotePath;
                    model.localVoicePath = body.localPath;
                    model.isSelf = YES;
                    model.isPhoto= NO;
                    model.isVoice = YES;
                    model.time = message.localTime;
                    model.voiceDuration = body.duration;
                    [_dataSourceArray addObject:model];
                    // 将消息插入 UI
                    if (_dataSourceArray.count > 0) {
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
                        [self insertMessageIntoTableViewWith:indexPath];
                    }
                    
                }
                    break;
                case EMMessageBodyTypeCmd:
                {
//                    NSLog(@"发送 cmd 消息");
                    
                }
                    break;
                default:
                    break;
            }
            
        } else {
//            NSLog(@"发送失败: %@", error.errorDescription);
        }
        
        [_importTextField setText:nil];
        
    }];

}

#pragma mark - 创建聊天 UI
- (void)creatChatTableViewAndTextField {
    self.dataSourceArray = [NSMutableArray array];
    
    // 创建 tableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 120) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellAccessoryNone;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[FZY_ChatTableViewCell class] forCellReuseIdentifier:@"chatCell"];
    
    // 创建下面的输入框
    self.downView = [[UIView alloc] initWithFrame:CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50)];
    _downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_downView];
    
    MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
    
    // 语音按钮
    self.optionVioceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_optionVioceButton setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
    isbeginVoiceRecord = NO;
    [_optionVioceButton addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
    [_downView addSubview:_optionVioceButton];
    [_optionVioceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downView).offset(10);
        make.centerY.equalTo(_downView.mas_centerY).offset(0);
        make.height.width.equalTo(@40);
    }];

    

    // 切换发送消息类型
    self.sendMessageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendMessageButton setBackgroundImage:[UIImage imageNamed:@"optionAdd"] forState:UIControlStateNormal];
    self.isAbleToSendTextMessage = NO;
    _sendMessageButton.frame = CGRectMake(WIDTH - 100, 5, 80, 40);
    _sendMessageButton.layer.cornerRadius = 10;
    _sendMessageButton.clipsToBounds = YES;
    [_sendMessageButton addTarget:self action:@selector(AddOrSend:) forControlEvents:UIControlEventTouchUpInside];

    [_downView addSubview:_sendMessageButton];
    [_sendMessageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_downView).offset(-10);
            make.centerY.equalTo(_downView.mas_centerY).offset(0);
            make.height.width.equalTo(@40);
    }];
    
    // 输入框
    self.importTextField = [[UITextView alloc] initWithFrame:CGRectMake(80, 5, WIDTH / 2, 40)];
    _importTextField.layer.cornerRadius = 4;
    _importTextField.font = [UIFont systemFontOfSize:20];
    _importTextField.layer.masksToBounds = YES;
    _importTextField.delegate = self;
    _importTextField.layer.borderWidth = 1;
    _importTextField.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    _importTextField.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1.0];
    [_downView addSubview:_importTextField];
    
    [_importTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_optionVioceButton.mas_right).offset(10);
        make.right.equalTo(_sendMessageButton.mas_left).offset(-10);
        make.centerY.equalTo(_downView.mas_centerY).offset(0);
        make.height.equalTo(@40);
    }];
    
    //改变状态（语音、文字）
    self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
    _btnVoiceRecord.hidden = YES;
    [_btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
    [_btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [_btnVoiceRecord setTitle:@"Hold to Talk" forState:UIControlStateNormal];
    [_btnVoiceRecord setTitle:@"Release to Send" forState:UIControlStateHighlighted];
    [_btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
    [_btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
    [_btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [_btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [_btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self.view addSubview:self.btnVoiceRecord];
//    [self.view addSubview:_btnVoiceRecord];
    [_btnVoiceRecord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_optionVioceButton.mas_right).offset(10);
        make.right.equalTo(_sendMessageButton.mas_left).offset(-10);
        make.centerY.equalTo(_downView.mas_centerY).offset(0);
        make.height.equalTo(@40);
    }];
    
    // 添加手势收起键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(screenTap:)];
    [_tableView addGestureRecognizer:tap];
    
    [self createOptionsCollectionView];
    
}

- (void)AddOrSend:(UIButton *)button {
    if (self.isAbleToSendTextMessage) {
        if (_importTextField.text.length > 0) {
            EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:_importTextField.text];
            NSString *userName = [[EMClient sharedClient] currentUsername];
            // 生成 Message
            EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:userName to:_friendName body:body ext:nil];
            if (_isGroupChat) {
                message.chatType = EMChatTypeGroupChat; // 设置为群聊聊信息
            } else {
                message.chatType = EMChatTypeChat; // 设置为单聊信息
            }
            
            [self sendMessageWithEMMessage:message];
            self.isAbleToSendTextMessage = NO;
        }else {
            [TSMessage showNotificationWithTitle:@"Warning" subtitle:@"发送消息不能为空" type:TSMessageNotificationTypeWarning];
        }
    }
    else{
        [self.importTextField resignFirstResponder];
        [self optionsCollectionViewFrameChange];
    }
    UIImage *image = [UIImage imageNamed:_isAbleToSendTextMessage?@"send":@"optionAdd"];
    [self.sendMessageButton setBackgroundImage:image forState:UIControlStateNormal];
}

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
//    [self.delegate UUInputFunctionView:self sendVoice:voiceData time:playTime+1];
    
    
    [UUProgressHUD dismissWithSuccess:@"Success"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)beginConvert {
    Mp3Recorder *mp3 = [[Mp3Recorder alloc] init];
    NSString *mp3Path = [mp3 mp3Path];
//    NSLog(@"结束录音 ======= %@", mp3Path);
    [self sendVoice:mp3Path];

}

- (void)failRecord {
    
    [UUProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.importTextField.hidden  = !self.importTextField.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.optionVioceButton setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [self.importTextField resignFirstResponder];
        [self keyboardWillHide];


    }else{
        [self.optionVioceButton setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
//        [self.importTextField becomeFirstResponder];
        [self.importTextField resignFirstResponder];

    }
}

#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button {
    [MP3 startRecord];
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
}

#pragma mark - 构造语音信息
- (void)endRecordVoice:(UIButton *)button {
    if (playTimer) {
        [MP3 stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)sendVoice:(NSString *)mp3Path {
    
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:mp3Path displayName:@"mp3"];
    
    body.duration = (int)playTime;
    
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    // 生成 语音message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:from to:_friendName body:body ext:nil];
    if (_isGroupChat) {
       message.chatType = EMChatTypeGroupChat;
    } else {
       message.chatType = EMChatTypeChat;
    }
    
    [self sendMessageWithEMMessage:message];

}

- (void)cancelRecordVoice:(UIButton *)button {
    if (playTimer) {
        [MP3 cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [UUProgressHUD dismissWithError:@"Cancel"];
}

- (void)RemindDragExit:(UIButton *)button {
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button {
    [UUProgressHUD changeSubTitle:@"Slide up to cancel"];
}

- (void)countVoiceTime {
    playTime ++;
    if (playTime>=60) {
        [self endRecordVoice:nil];
    }
}

#pragma mark - 创建 键盘 选择发送消息的类型
- (void)createOptionsCollectionView {
    
    self.optionsArray = @[@"optionPhoto", @"optionCamera", @"optionPostion", @"optionVideo"];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((WIDTH - 15 * 5) / 5 , 50);
    layout.minimumInteritemSpacing = 15;
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    self.optionsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, HEIGHT, WIDTH, 0) collectionViewLayout:layout];
    _optionsCollectionView.backgroundColor = [UIColor whiteColor];
    _optionsCollectionView.delegate = self;
    _optionsCollectionView.dataSource = self;
    [self.view addSubview:_optionsCollectionView];
    [_optionsCollectionView registerClass:[FZY_KeyboardCollectionViewCell class] forCellWithReuseIdentifier:@"optionCell"];
}

#pragma mark - collectionView 协议
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _optionsArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FZY_KeyboardCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"optionCell" forIndexPath:indexPath];
    NSString *imgName = _optionsArray[indexPath.item];
    cell.backImageView.image = [UIImage imageNamed:imgName];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.item) {
        case 0:
        {
            if (_isMapClose) {
//                NSLog(@"图片");
                UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
                PickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                //自代理
                PickerImage.delegate = self;
                PickerImage.allowsEditing = YES;
                //页面跳转
                [self presentViewController:PickerImage animated:YES completion:nil];
            } else {
                [UIView showMessage:@"地图打开中, 无法发送图片"];
            }
            
            
        }
            break;
        case 1:
        {
            if (_isMapClose) {
//                NSLog(@"相机");
                UIImagePickerController *PickerImage = [[UIImagePickerController alloc]init];
                //获取方式:通过相机
                PickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
                PickerImage.allowsEditing = YES;
                PickerImage.delegate = self;
                [self presentViewController:PickerImage animated:YES completion:nil];
            } else {
                [UIView showMessage:@"地图打开中, 无法使用相机"];
            }
            
        }
            break;
        case 2:
        {
            self.isMapClose = !_isMapClose;
          
            _tableView.hidden = !_tableView.hidden;
            _downView.hidden = !_downView.hidden;
            
                EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithLatitude:_latitude longitude:_longitude address:@"地址"];
                NSString *from = [[EMClient sharedClient] currentUsername];
            
                // 生成message
                EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:from to:_friendName body:body ext:nil];
            if (_isGroupChat) {
                message.chatType = EMChatTypeGroupChat;
            } else {
                message.chatType = EMChatTypeChat;// 设置为单聊消息
            }
            
                [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
                    if (!error) {
            
//                        NSLog(@"位置发送成功");
                    } else {
//                        NSLog(@"发送失败: %@", error);
                    }
                }];
        }
            break;
        case 3:
        {
            if (_isMapClose) {
//                NSLog(@"视频");
                if ([self canOpenCamera]) {
                    if (_isGroupChat) {
                        [TSMessage showNotificationWithTitle:@"视屏通话失败" subtitle:@"群聊时无法视屏通话" type:TSMessageNotificationTypeError];
                    } else {
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_CALL object:@{@"chatter":self.conversation.conversationId, @"type":[NSNumber numberWithInt:1]}];
                    }
                    
                } else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有相机权限" message:@"请去设置-隐私-相机中进行授权" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alertController addAction:okAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                }
            } else {
                [UIView showMessage:@"地图打开中, 无法视屏通话"];
            }
           
            
        }
            break;
        default:
            break;
    }
}

- (BOOL)canOpenCamera {
    // 获取相机授权状态
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    // 对象机授权状态的判断
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return NO;
    } else {
        return YES;
    }
}

//PickerImage完成后的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //定义一个newPhoto，用来存放我们选择的图片
    UIImage *libraryPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // 可以在上传时使用当前系统时间作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    // 将图片转为 data 数据
    NSData *imageData = UIImageJPEGRepresentation(libraryPhoto, 0.5);
    // 构造图片信息
    EMImageMessageBody *body = [[EMImageMessageBody alloc] initWithData:imageData displayName:str];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:from to:_friendName body:body ext:nil];
    if (_isGroupChat) {
       message.chatType = EMChatTypeGroupChat;
    } else {
       message.chatType = EMChatTypeChat;
    }
    
    //关闭当前界面，即回到主界面去
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 发送消息
    [self sendMessageWithEMMessage:message];
    
    // 添加 键盘弹出 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    
}

#pragma mark -  自定义 消息动态插入 tableView
- (void)insertMessageIntoTableViewWith:(NSIndexPath *)indexPath {
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
}

#pragma mark - tableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCell"];
    if (_dataSourceArray.count <= 0) {
        return cell;
    }
    // 取数据
    FZY_ChatModel *model = _dataSourceArray[indexPath.row];
    cell.leftImage = _friendImage;
    cell.rightImage = _userImage;
    cell.model = model;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //取数据
    FZY_ChatModel * model = _dataSourceArray[indexPath.row];
    if (model.isPhoto) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.photoName]]];
        CGSize size = image.size;
        CGFloat scale = 220 / image.size.width;
        CGFloat height = size.height *scale;
        return height + 20;
        
    } else {
        if (model.isVoice) {
            return 60;
        }else {
            
            //根据文字确定显示大小
            CGSize size = [model.context boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
            return size.height + 50;
        }
    }
    
}

#pragma mark - TextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    // 构造透传消息
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"对方正在输入..."];
    NSString *from = [[EMClient sharedClient] currentUsername];
    NSDictionary *dic = @{@"name" : @"对方正在输入..."};
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:from to:_friendName body:body ext:dic];
    if (_isGroupChat) {
        message.chatType = EMChatTypeGroupChat;
    } else {
        message.chatType = EMChatTypeChat;
    }
    [self sendMessageWithEMMessage:message];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
//    NSLog(@"end");
    // 构造透传消息
    EMCmdMessageBody *body = [[EMCmdMessageBody alloc] initWithAction:@"end"];
    NSDictionary *dic = @{@"name" : @"end"};
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_friendName from:from to:_friendName body:body ext:dic];
    if (_isGroupChat) {
        message.chatType = EMChatTypeGroupChat;
    } else {
        message.chatType = EMChatTypeChat;
    }
    [self sendMessageWithEMMessage:message];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    
   
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    self.isAbleToSendTextMessage = !isPhoto;
    UIImage *image = [UIImage imageNamed:isPhoto?@"optionAdd":@"send"];
    [self.sendMessageButton setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - 轻拍手势方法
- (void)screenTap:(UIGestureRecognizer *)tap {
    // 取消当前屏幕所有第一响应
    [self.view endEditing:YES];
    
    if (_isShow) {
        [self keyboardWillHide];
        _downView.frame = CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50);
    }
    if (_optionsCollectionView.frame.size.height > 0) {
        [self optionsCollectionViewFrameChange];
    }
}

#pragma mark - 获取键盘弹出隐藏的动态高度
- (void)keyboardWillShow:(NSNotification *)notification {
    
    self.isShow = YES;
    // 获取通知的信息字典
    NSDictionary *userInfo = [notification userInfo];
    // 获取键盘弹出后的rect
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGFloat h = keyboardRect.size.height;
    
    // 获取键盘弹出动画时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    self.keyboard_H = h;
    self.animationDuration = animationDuration;
    
    [UIView animateWithDuration:animationDuration animations:^{
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, HEIGHT - 120 - h);
        [_downView setFrame:CGRectMake(_downView.frame.origin.x, HEIGHT - 50 - h - 64, _downView.frame.size.width, _downView.frame.size.height)];
    }];
    
}
- (void)keyboardWillHide {
    
    self.isShow = NO;
    [UIView animateWithDuration:_animationDuration animations:^{
        
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, HEIGHT - 120);
        _optionsCollectionView.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
        [_downView setFrame:CGRectMake(_downView.frame.origin.x, HEIGHT - 50 - 64, _downView.frame.size.width, _downView.frame.size.height)];
    }];
    
}

- (void)tableViewScrollToBottom {
    if (_dataSourceArray.count == 0) {
        return;
    }
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSourceArray.count - 1 inSection:0];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)optionsCollectionViewFrameChange {
    if (_optionsCollectionView.frame.size.height > 0) {
        _downView.frame = CGRectMake(0, HEIGHT - 50 - 64, WIDTH, 50);
        _optionsCollectionView.frame = CGRectMake(0, HEIGHT, WIDTH, 0);
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, HEIGHT - 120);
        
    }
    else if (_isShow) {
        [_importTextField resignFirstResponder];
        _optionsCollectionView.frame = CGRectMake(0, HEIGHT - 80 - 64, WIDTH, 80);
        _downView.frame = CGRectMake(0, HEIGHT - 80 - 50 - 64, WIDTH, 50);
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, HEIGHT - 120 - _optionsCollectionView.frame.size.height);
    }
    else if (_optionsCollectionView.frame.size.height == 0) {
        [_importTextField resignFirstResponder];
        _optionsCollectionView.frame = CGRectMake(0, HEIGHT - 80 - 64, WIDTH, 80);
        _downView.frame = CGRectMake(0, HEIGHT - 80 - 50 - 64, WIDTH, 50);
        _tableView.frame = CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y, _tableView.frame.size.width, HEIGHT - 120 - _optionsCollectionView.frame.size.height);
    }
    [self tableViewScrollToBottom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
