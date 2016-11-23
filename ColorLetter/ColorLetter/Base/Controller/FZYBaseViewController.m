//
//  FZYBaseViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseViewController.h"
#import "DrawerViewController.h"
#import "FZY_FriendRequestViewController.h"
#import "ChatDemoHelper.h"


@interface FZYBaseViewController ()
<
EMCallManagerDelegate,
ChatDemoHelperDelegate,
EMChatManagerDelegate,
EMContactManagerDelegate,
EMGroupManagerDelegate
>
@end

@implementation FZYBaseViewController


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
   
//     背景图片
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-736"]];
    self.view.userInteractionEnabled = YES;
    
    // 注册实时通话回调
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    // 注册群组回调
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    
}

- (void)create {
    self.titleLabel = [[UILabel alloc] init];
    [_titleLabel sizeToFit];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.height.equalTo(@25);
    }];
    
    self.drawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawerButton setImage:[UIImage imageNamed:@"btn-profile"] forState:UIControlStateNormal];
    [_drawerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"WhenPushPage" object:nil];
        DrawerViewController *drawerVC = [[DrawerViewController alloc] init];
        drawerVC.myImage = [UIImage captureImageFromView: self.view];
        CATransition * animation = [CATransition animation];
        animation.duration = 0.1;
        animation.type = kCATransitionPush;
        drawerVC.viewController = self;
        drawerVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.view.window.layer addAnimation:animation forKey:nil];
        [self presentViewController:drawerVC animated:YES completion:nil];
        
    }];
    [self.view addSubview:_drawerButton];
    [_drawerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    self.searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_searchButton setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [_searchButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        FZY_FriendRequestViewController *friend = [[FZY_FriendRequestViewController alloc] init];
        [self presentViewController:friend animated:YES completion:nil];
    }];
    [self.view addSubview:_searchButton];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [ChatDemoHelper shareHelper].delegate = self;
    [ChatDemoHelper shareHelper].viewController = self;
    

}

- (void)pushCallVC:(EMCallSession *)session isCaller:(BOOL)isCaller status:(NSString *)status {
    CallViewController *callVC = [[CallViewController alloc] initWithSession:session isCaller:isCaller status:status];
    [self presentViewController:callVC animated:YES completion:nil];
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
