//
//  AppDelegate.m
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "AppDelegate.h"
#import "FZYTabBarViewController.h"

#import "FZY_LoginAndRegisterViewController.h"
#import "ChatDemoHelper.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()
<
EMClientDelegate
>
@property (nonatomic, strong) EMError *error;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"sc1mRQSAtnTTYMWmRQMLdZd7MKEvZrvG"  generalDelegate:nil];
    if (!ret) {
//        NSLog(@"manager start failed!");
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    EMOptions *options = [EMOptions optionsWithAppkey:@"1137161019178010#fzycolorletter"];
    options.apnsCertName = @"ColorLetter";
    // 自动添加成员进群
    options.isAutoAcceptGroupInvitation = YES;
    self.error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    if (!_error) {
        NSLog(@"初始化成功");
    }
    
    
    //------- 注册 APNS --------
    if ([[UIDevice currentDevice] systemVersion].floatValue < 8.0f) {
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    }else if (([[UIDevice currentDevice] systemVersion].floatValue >= 8.0f) && ([[UIDevice currentDevice] systemVersion].floatValue < 10.0f)) {
        // 注册通知设置
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil]];
        // 注册远程通知 (请求token)
        [application registerForRemoteNotifications];
    }else {
        UNUserNotificationCenter *notificationCenter = [UNUserNotificationCenter currentNotificationCenter];
        [notificationCenter requestAuthorizationWithOptions:UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // 授权成功
            if (granted) {
                NSLog(@"成功");
                [notificationCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                    NSLog(@"setting : %@", settings);
                }];
            }else {
                NSLog(@"Authorization error : %@",error);
            }
        }];
        [application registerForRemoteNotifications];
        
    }

    // ------------------------
    
    BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
    if (isAutoLogin) {
        // 推送昵称
        NSString *str = [EMClient sharedClient].currentUsername;
        [[EMClient sharedClient] setApnsNickname:str];
        self.window.rootViewController = [[FZYTabBarViewController alloc] init];
    } else {
        self.window.rootViewController = [[FZY_LoginAndRegisterViewController alloc] init];
    }
    
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    
    // EaseUI 的初始化
    [[EaseSDKHelper shareHelper] hyphenateApplication:application didFinishLaunchingWithOptions:launchOptions appkey:@"1137161019178010#fzycolorletter" apnsCertName:@"ColorLetter" otherConfig:@{kSDKConfigEnableConsoleLogger:[NSNumber numberWithBool:YES]}];
    
    // LeanCloud 的初始化
    [AVOSCloud setApplicationId:@"TqOSFbfozHvy7bvJsvRb5iUo-gzGzoHsz" clientKey:@"BVsKxayJdjhnXBz1fXjE4FOp"];
    
    [ChatDemoHelper shareHelper];
    
    AVQuery *userPhoto = [AVQuery queryWithClassName:@"userAvatar"];
    [userPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [[FZY_DataHandle shareDatahandle] open];
            [[FZY_DataHandle shareDatahandle] deleteAll];
            for (AVObject *userPhoto in objects) {
                AVObject *user = [userPhoto objectForKey:@"userName"];
                FZY_User *use = [[FZY_User alloc] init];
                AVFile *file = [userPhoto objectForKey:@"image"];
                use.name = [NSString stringWithFormat:@"%@", user];
                use.imageUrl = file.url;
                use.userId = userPhoto.objectId;
                [[FZY_DataHandle shareDatahandle] insert:use];
            }
        }
    }];
    
    return YES;

}

// 获取token
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"token : %@", deviceToken);
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
    // 将token提供给推送服务器
}

// 注册通知失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"register error :%@", error);
}

// 接收(触发)通知的方法 iOS 10.0之前
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"userInfo : %@", userInfo);
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
}

/*
 *  自动登录返回结果
 *
 *  @param aError 错误信息
 */
- (void)didAutoLoginWithError:(EMError *)aError {
    [TSMessage showNotificationWithTitle:@"Automatic Login Success" subtitle:@"自动登录成功" type:TSMessageNotificationTypeSuccess];
    AVQuery *userPhoto = [AVQuery queryWithClassName:@"userAvatar"];
    [userPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [[FZY_DataHandle shareDatahandle] open];
            [[FZY_DataHandle shareDatahandle] deleteAll];
            for (AVObject *userPhoto in objects) {
                AVObject *user = [userPhoto objectForKey:@"userName"];
                FZY_User *use = [[FZY_User alloc] init];
                AVFile *file = [userPhoto objectForKey:@"image"];
                use.name = [NSString stringWithFormat:@"%@", user];
                use.imageUrl = file.url;
                use.userId = userPhoto.objectId;
                [[FZY_DataHandle shareDatahandle] insert:use];
            }
        }
    }];

}

/*
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice {

    self.window.rootViewController = [[FZY_LoginAndRegisterViewController alloc] init];
    [TSMessage showNotificationWithTitle:@"Warning" subtitle:@"该账号已在其他设备登录" type:TSMessageNotificationTypeWarning];
}

/*
 *  当前登录账号已经被从服务器端删除时会收到该回调
 */
- (void)didRemovedFromServer {
//    NSLog(@"sddasff");
    self.window.rootViewController = [[FZY_LoginAndRegisterViewController alloc] init];
    [TSMessage showNotificationWithTitle:@"Warning" subtitle:@"该账号已被从服务器端删除" type:TSMessageNotificationTypeWarning];

}



/*!
 *  SDK连接服务器的状态变化时会接收到该回调
 *
 *  有以下几种情况，会引起该方法的调用：
 *  1. 登录成功后，手机无法上网时，会调用该回调
 *  2. 登录成功后，网络状态变化时，会调用该回调
 *
 *  @param aConnectionState 当前状态
 */
- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState {
    [TSMessage showNotificationWithTitle:@"正在重连..." subtitle:nil type:TSMessageNotificationTypeWarning];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// app 进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[EMClient sharedClient] applicationDidEnterBackground:application];
}

// app 将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
