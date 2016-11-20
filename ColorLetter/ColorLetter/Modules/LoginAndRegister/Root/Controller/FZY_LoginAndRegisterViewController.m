//
//  FZY_LoginAndRegisterViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_LoginAndRegisterViewController.h"
#import "FZY_LoginOrRegisterViewController.h"

@interface FZY_LoginAndRegisterViewController ()

@end

@implementation FZY_LoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self creatHomepage];
    
}

- (void)creatHomepage {    
    // app 代表图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT * 0.55)];
    imageView.image = [UIImage imageNamed:@"bg-mob"];
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
    
    // app 名字 
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH * 0, 10, WIDTH / 3, 45)];
    headImage.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:headImage];
    [self.view sendSubviewToBack:headImage];

    // app 介绍
    UILabel *bottomLabel = [[UILabel alloc] init];
   // bottomLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    bottomLabel.text = @"欲寄彩笺兼尺素";
    
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel];
    [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(20);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
       make.height.equalTo(@(HEIGHT * 0.5 * 0.2));
     
    }];
    
    UILabel *bottomLabel2 = [[UILabel alloc] init];
  // bottomLabel2.font = [UIFont fontWithName:@"Helvetica" size:15];
    bottomLabel2.text = @"山长水阔知何处";
    bottomLabel2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:bottomLabel2];
    [bottomLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(40);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
       make.height.equalTo(@(HEIGHT * 0.5 * 0.2));
    }];
    
    // 注册button
    UIButton *registerButton = [[UIButton alloc]init];
    registerButton.layer.cornerRadius = 15;
    registerButton.backgroundColor = [UIColor colorWithRed:0.26f green:0.55f blue:0.82f alpha:1.00f];
    registerButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    __weak typeof(self) weakself = self;
    [registerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        FZY_LoginOrRegisterViewController *registerVC = [[FZY_LoginOrRegisterViewController alloc] init];
        registerVC.position = WIDTH / 4;
        registerVC.scrollPosition = 0;
        registerVC.VC = weakself;
        [self presentViewController:registerVC animated:YES completion:nil];
    }];
    
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLabel.mas_bottom).offset(50);
        make.right.equalTo(self.view.mas_centerX).offset(-40);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    
    // 登录button
    UIButton *loginButton = [[UIButton alloc]init];
     loginButton.layer.cornerRadius = 15;
    loginButton.backgroundColor = [UIColor colorWithRed:0.32 green:0.78 blue:0.48 alpha:1.0];
    loginButton.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:22];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal]; 
    
    [loginButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        FZY_LoginOrRegisterViewController *LoginVC = [[FZY_LoginOrRegisterViewController alloc] init];
        LoginVC.VC = weakself;
        LoginVC.position = WIDTH / 4 * 3;
        LoginVC.scrollPosition = WIDTH;

        [self presentViewController:LoginVC animated:YES completion:nil];
    }];
    
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomLabel.mas_bottom).offset(50);
        make.left.equalTo(self.view.mas_centerX).offset(40);
        make.width.equalTo(@80);
        make.height.equalTo(@50);
    }];
    
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
