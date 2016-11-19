//
//  FZYTabBarViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYTabBarViewController.h"
#import "FZY_MessageViewController.h"
#import "TheContactViewController.h"
#import "FZY_SettingViewController.h"

@interface FZYTabBarViewController ()

@property (nonatomic,strong) UIView * BackgroundView;


@end

@implementation FZYTabBarViewController


- (void)dealloc {
    // 代理的置空操作
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
   FZY_MessageViewController *message = [[FZY_MessageViewController alloc] init];
   
    UIImage *imageMessage = [UIImage imageNamed:@"tab-messages"];
    UIImage *selectedImageMessage = [UIImage imageNamed:@"tab-messages-on"];
    // 保持原图不被渲染
    imageMessage = [imageMessage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImageMessage = [selectedImageMessage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    message.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Messages" image:imageMessage selectedImage:selectedImageMessage];
    UINavigationController *messageNav = [[UINavigationController alloc] initWithRootViewController:message];
    [messageNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    TheContactViewController *theContact = [[TheContactViewController alloc] init];
    theContact.title = @"The contact";
    UIImage *imageContact = [UIImage imageNamed:@"tab-home"];
    UIImage *selectedImageContact = [UIImage imageNamed:@"tab-home-on"];
    // 保持原图不被渲染
    imageContact = [imageContact imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImageContact = [selectedImageContact imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    theContact.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"The contact" image:imageContact selectedImage:selectedImageContact];
    UINavigationController *theContactNav = [[UINavigationController alloc] initWithRootViewController:theContact];
    [theContactNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    FZY_SettingViewController *add = [[FZY_SettingViewController alloc] init];
    add.title = @"Setting";
    UIImage *imageAdd = [UIImage imageNamed:@"setting1"];
    UIImage *selectedImageAdd = [UIImage imageNamed:@"setting2"];
    // 保持原图不被渲染
    imageAdd = [imageAdd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImageAdd = [selectedImageAdd imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    add.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Setting" image:imageAdd selectedImage:selectedImageAdd];
    UINavigationController *addNav = [[UINavigationController alloc] initWithRootViewController:add];
    [addNav.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.viewControllers = @[messageNav, theContactNav, addNav];
    self.tabBar.tintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    
    // 添加观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenTabBarAction:) name:@"WhenPushPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTabBarAction:) name:@"BackToTabBarViewController" object:nil];
}

- (void)showTabBarAction:(NSNotification *)notification {
    self.tabBar.hidden = NO;
}

- (void)hiddenTabBarAction:(NSNotification *)notification {
    self.tabBar.hidden = YES;
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
