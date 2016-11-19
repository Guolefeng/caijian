//
//  FZY_MessageViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_MessageViewController.h"
#import "FZY_MessageTableViewCell.h"
#import "FZY_ChatViewController.h"
#import "FZY_FriendsModel.h"
@interface FZY_MessageViewController ()

<
UITableViewDataSource,
UITableViewDelegate,
EMChatManagerDelegate,
FZYBaseViewControllerDelegate
>

{
    BMKLocationService *_locService;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *conversationArray;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, strong) NSArray *objectArray;

//@property (nonatomic, strong) FZY_User *user;

@end

@implementation FZY_MessageViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    //移除消息回调
    [[EMClient sharedClient].chatManager removeDelegate:self];
    
}

- (void)viewWillDisappear:(BOOL)animated {
     [super viewWillDisappear:animated];
    [[EMClient sharedClient].chatManager removeDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackToTabBarViewController" object:nil];
    self.navigationController.navigationBar.hidden = YES;
    
    self.objectArray = [[FZY_DataHandle shareDatahandle] select:nil];    
    // 载入所有会话
    [self loadAllConversations];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.objectArray = [NSMutableArray array];

    self.title = @"Messages";
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    [self creatTableView];
    [super create];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = (id)self;
    //启动LocationService
    [_locService startUserLocationService];
    
    FZYBaseViewController *base = [[FZYBaseViewController alloc] init];
    base.delegate = self;
}
- (void)refreshTableView {
    [self loadAllConversations];
    [_tableView reloadData];
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
//    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    self.latitude = userLocation.location.coordinate.latitude;
    self.longitude = userLocation.location.coordinate.longitude;
}

#pragma mark - 获取全部会话
- (void)loadAllConversations {
    
    [_conversationArray removeAllObjects];
    
    NSArray *conversationArray = [[EMClient sharedClient].chatManager getAllConversations];
        
    for (EMConversation *con in conversationArray) {
        
        FZY_FriendsModel *model = [[FZY_FriendsModel alloc] init];
        if (con.type == EMConversationTypeChat) {
            model.name = con.conversationId;
            
            model.isGroup = NO;
        } else{
            // 群聊
            model.groupID = con.conversationId;
            model.isGroup = YES;
        }
        
        // 最新一条信息
        EMMessage *latestMess = con.latestMessage;
        EMTextMessageBody *textBody = (EMTextMessageBody *)latestMess.body;
        NSString *txt = nil;
        
        switch (textBody.type) {
            case EMMessageBodyTypeImage:
                 txt = @"图片";
                break;
            case EMMessageBodyTypeText:
                txt = textBody.text;
                break;
            case EMMessageBodyTypeLocation:
                txt = nil;
                break;
            case EMMessageBodyTypeVoice:
                txt = @"声音";
                break;
            case EMMessageBodyTypeVideo:
                txt = @"视频";
                break;
            default:
                break;
        }
        
        // 最新消息
        model.latestMessage = txt;
        
        // 客户端发送/收到此消息的时间
        model.time = latestMess.localTime;
        
        // 会话未读消息总数
        model.unReadMessageNum = con.unreadMessagesCount;
        
        [_conversationArray addObject:model];
        [_tableView reloadData];
    }
}

#pragma mark - 创建 tableView
- (void)creatTableView {
    
    FZY_FriendsModel *model = [[FZY_FriendsModel alloc] init];
    self.conversationArray = [[NSMutableArray alloc] initWithObjects:model, nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 80;
    _tableView.separatorStyle = NO;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[FZY_MessageTableViewCell class] forCellReuseIdentifier:@"messageCell"];
    
}

#pragma mark - tableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _conversationArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_MessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    
    FZY_FriendsModel *model = _conversationArray[indexPath.row];
    
    for (FZY_User *user in _objectArray) {
        if (model.name == user.name) {
//            self.user = user;
            cell.urlImage = user.imageUrl;
        }
    }
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FZY_ChatViewController *chatVC = [[FZY_ChatViewController alloc] init];
    
    FZY_FriendsModel *model = _conversationArray[indexPath.row];
    
    if (model.isGroup) {
        chatVC.friendName = model.groupID;
        chatVC.isGroupChat = YES;
    } else {
        chatVC.friendName = model.name;
        chatVC.isGroupChat = NO;
    }
    // 设置消息为已读
    EMConversation *con = [[EMClient sharedClient].chatManager getConversation:model.name type:EMConversationTypeChat createIfNotExist:YES];
    if (con.unreadMessagesCount) {
        EMError *err = nil;
        [con markAllMessagesAsRead:&err];
        // UI 去掉红点
        FZY_MessageTableViewCell *cell = (FZY_MessageTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
        [cell displayNumberOfUnreadMessagesWith:NO];
    }
    
    
//    EMLocationMessageBody *body = [[EMLocationMessageBody alloc] initWithLatitude:_latitude longitude:_longitude address:@"地址"];
//    NSString *from = [[EMClient sharedClient] currentUsername];
//    
//    // 生成message
//    EMMessage *message = [[EMMessage alloc] initWithConversationID:model.name from:from to:[[EMClient sharedClient] currentUsername] body:body ext:nil];
//    message.chatType = EMChatTypeChat;// 设置为单聊消息
//    [[EMClient sharedClient].chatManager sendMessage:message progress:nil completion:^(EMMessage *message, EMError *error) {
//        if (!error) {
//            
//            NSLog(@"位置发送成功"); 
//        } else {
//            NSLog(@"发送失败: %@", error);
//        }
//    }];

    [self.navigationController pushViewController:chatVC animated:YES];
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
