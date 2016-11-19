//
//  FZY_LoginOrRegisterViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/20.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_LoginOrRegisterViewController.h"
#import "FZY_MessageViewController.h"
#import "FZYTabBarViewController.h"
#import "DrawerViewController.h"
#import "FZY_ServeViewController.h"
@interface FZY_LoginOrRegisterViewController ()
<
UIScrollViewDelegate,
UITextFieldDelegate
>

@property (nonatomic, retain) UIView *upView;
@property (nonatomic, retain) UIScrollView *downScrollView;
@property (nonatomic, retain) UIImageView *triangleImageView;
@property (nonatomic, retain) UITextField *accountTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UITextField *loginAccountTextField;
@property (nonatomic, retain) UITextField *loginPasswordTextField;
@property (nonatomic, retain) UITextField *confirmPasswordTextField;

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) EMError *error;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, assign) BOOL agree;

@end

@implementation FZY_LoginOrRegisterViewController

- (void)dealloc {
    _downScrollView.delegate = nil;
    _accountTextField.delegate = nil;
    _passwordTextField.delegate = nil;
    _loginAccountTextField.delegate = nil;
    _loginPasswordTextField.delegate = nil;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:YES];
//    [self.delegate dismissViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.agree = YES;
    
    [self creatLoginOrRegisterButton];
    [self creatDownScrollView];
    [self creatLoginView];
    self.triangleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.position, 50, 20, 20)];
    _triangleImageView.image = [UIImage imageNamed:@"zhengsanjiao.png"];
    [self.view bringSubviewToFront:_triangleImageView];
    [self.view addSubview:_triangleImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:tap];
    
}
- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}

#pragma mark - 创建 downScrollView 注册
- (void)creatDownScrollView {
    self.downScrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _upView.frame.size.height, WIDTH, HEIGHT - _upView.frame.size.height)];
    _downScrollView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.21 alpha:1];
    _downScrollView.contentSize = CGSizeMake(WIDTH * 2, 0);
    _downScrollView.contentOffset = CGPointMake(_scrollPosition, 0);
    _downScrollView.pagingEnabled = YES;
    _downScrollView.delegate = self;
    _downScrollView.bounces = NO;
    _downScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_downScrollView];
    
    self.leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_header"]];
    _leftImageView.userInteractionEnabled = YES;
    [_downScrollView addSubview:_leftImageView];
    [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downScrollView.mas_left);
        make.top.equalTo(_downScrollView.mas_top);
        make.height.equalTo(@110);
        make.width.equalTo(@(WIDTH));
    }];

    self.accountTextField = [[UITextField alloc]init];
    _accountTextField.textColor = [UIColor whiteColor];
    _accountTextField.placeholder = @"Your New Username";
    [_accountTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.000] forKeyPath:@"placeholderLabel.textColor"];
    _accountTextField.clearButtonMode = UITextFieldViewModeAlways;
    [_downScrollView addSubview:_accountTextField];
    [_accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downScrollView.mas_left).offset(60);
        make.top.equalTo(_downScrollView.mas_top).offset(140);
        make.height.equalTo(@30);
        make.width.equalTo(@(WIDTH - 120));
        
    }];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    accountImageView.image = [UIImage imageNamed:@"field-email"];
    [leftView addSubview:accountImageView];
    _accountTextField.leftViewMode = UITextFieldViewModeAlways;
    _accountTextField.leftView = leftView;
    
    UIView *accountLineView = [[UIView alloc]init];
    accountLineView.backgroundColor = [UIColor blackColor];
    [_accountTextField addSubview:accountLineView];
    [accountLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_accountTextField).offset(0);
        make.right.equalTo(_accountTextField).offset(0);
        make.top.equalTo(_accountTextField).offset(32);
        make.height.equalTo(@1);
    }];
    
    self.passwordTextField = [[UITextField alloc]init];
    _passwordTextField.delegate = self;
    _passwordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.textColor = [UIColor whiteColor];
    _passwordTextField.placeholder = @"New Password";
    [_passwordTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.000] forKeyPath:@"placeholderLabel.textColor"];
    [_downScrollView addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downScrollView.mas_left).offset(60);
        make.top.equalTo(_accountTextField.mas_bottom).offset(30);
        make.height.equalTo(@30);
        make.width.equalTo(@(WIDTH - 120));
    }];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    passwordImageView.image = [UIImage imageNamed:@"field-lock"];
    [rightView addSubview:passwordImageView];
    _passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    _passwordTextField.leftView = rightView;
    
    UIView *passwordLineView = [[UIView alloc]init];
    passwordLineView.backgroundColor = [UIColor blackColor];
    [_passwordTextField addSubview:passwordLineView];
    [passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_passwordTextField).offset(0);
        make.right.equalTo(_passwordTextField).offset(0);
        make.top.equalTo(_passwordTextField).offset(32);
        make.height.equalTo(@1);
    }];
    
    self.confirmPasswordTextField = [[UITextField alloc]init];
    _confirmPasswordTextField.delegate = self;
    _confirmPasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _confirmPasswordTextField.secureTextEntry = YES;
    _confirmPasswordTextField.textColor = [UIColor whiteColor];
    _confirmPasswordTextField.placeholder = @"New password again";
    [_confirmPasswordTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.000] forKeyPath:@"placeholderLabel.textColor"];
    [_downScrollView addSubview:_confirmPasswordTextField];
    [_confirmPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downScrollView.mas_left).offset(60);
        make.top.equalTo(_passwordTextField.mas_bottom).offset(30);
        make.height.equalTo(@30);
        make.width.equalTo(@(WIDTH - 120));
    }];
    
    UIView *conPasswordView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *conPasswordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    conPasswordImageView.image = [UIImage imageNamed:@"field-lock"];
    [conPasswordView addSubview:conPasswordImageView];
    _confirmPasswordTextField.leftViewMode = UITextFieldViewModeAlways;
    _confirmPasswordTextField.leftView = conPasswordView;

    UIView *conPasswordLineView = [[UIView alloc]init];
    conPasswordLineView.backgroundColor = [UIColor blackColor];
    [_passwordTextField addSubview:conPasswordLineView];
    [conPasswordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_confirmPasswordTextField).offset(0);
        make.right.equalTo(_confirmPasswordTextField).offset(0);
        make.top.equalTo(_confirmPasswordTextField.mas_bottom).offset(0);
        make.height.equalTo(@1);
    }];
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signUpButton setTitle:@"register" forState:UIControlStateNormal];
    [_signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _signUpButton.backgroundColor = [UIColor colorWithRed:0.30 green:0.79 blue:0.50 alpha:1.0];
    _signUpButton.layer.cornerRadius = 10;
    _signUpButton.clipsToBounds = YES;
    _signUpButton.layer.borderWidth = 1;
    _signUpButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.downScrollView addSubview:_signUpButton];
    [_signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_confirmPasswordTextField).offset(-20);
        make.right.equalTo(_confirmPasswordTextField).offset(20);
        make.top.equalTo(_confirmPasswordTextField.mas_bottom).offset(25);
        make.height.equalTo(@50);
    }];
    [_signUpButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        if (([_accountTextField.text isEqualToString:@""] | [_passwordTextField.text isEqualToString:@""] | [_confirmPasswordTextField.text isEqualToString:@""])) {
            [UIView showMessage:@"Please fill in your registration information"];
        } else {
            
            if (_agree) {
                
                [self register];
                
            } else {
                [UIView showMessage:@"Please agree to the service agreement"];
            }
        }
    }];
    
    UIButton *roundImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    roundImageButton.layer.borderColor = [UIColor blackColor].CGColor;
    roundImageButton.layer.borderWidth = 1;
    roundImageButton.backgroundColor = [UIColor colorWithRed:0.30 green:0.79 blue:0.50 alpha:1.0];
    [roundImageButton setBackgroundImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
    [self.downScrollView addSubview:roundImageButton];
    [roundImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_confirmPasswordTextField).offset(-20);
        make.top.equalTo(_signUpButton.mas_bottom).offset(20);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    roundImageButton.layer.cornerRadius = 10;
    roundImageButton.clipsToBounds = YES;
    [roundImageButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        self.agree = !_agree;
        if (_agree) {
            [roundImageButton setBackgroundImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
            _signUpButton.backgroundColor = [UIColor colorWithRed:0.30 green:0.79 blue:0.50 alpha:1.0];
            roundImageButton.backgroundColor = [UIColor colorWithRed:0.30 green:0.79 blue:0.50 alpha:1.0];
        } else {
            [roundImageButton setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
            _signUpButton.backgroundColor = nil;
            roundImageButton.backgroundColor = nil;
        }
        
    }];
    
    UILabel *serveItemLabel = [[UILabel alloc] init];
    serveItemLabel.text = @"I agreed to";
    serveItemLabel.font = [UIFont systemFontOfSize:13];
    serveItemLabel.textColor = [UIColor whiteColor];
    [self.downScrollView addSubview:serveItemLabel];
    [serveItemLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(roundImageButton.mas_right).offset(5);
        make.centerY.equalTo(roundImageButton.mas_centerY).offset(0);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    UIButton *serveItemButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [serveItemButton setTitle:@"Service agreement" forState:UIControlStateNormal];
    serveItemButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [serveItemButton setTitleColor:[UIColor colorWithRed:0.30 green:0.79 blue:0.50 alpha:1.0] forState:UIControlStateNormal];
    [self.downScrollView addSubview:serveItemButton];
    [serveItemButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(serveItemLabel.mas_right).offset(5);
        make.centerY.equalTo(roundImageButton.mas_centerY).offset(0);
        make.width.equalTo(@130);
        make.height.equalTo(@30);
    }];
    [serveItemButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        FZY_ServeViewController *serveVC = [[FZY_ServeViewController alloc] init];
        [self presentViewController:serveVC animated:YES completion:nil];
    }];
}

// 隐藏键盘
-(void)resignKeyboard {
    [_passwordTextField resignFirstResponder];
}
#pragma mark - 创建上面的登录注册 Button
- (void)creatLoginOrRegisterButton {
    
    self.upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    
    _upView.backgroundColor = [UIColor colorWithRed:0.32 green:0.78 blue:0.48 alpha:1.0];
    [self.view addSubview:_upView];
    
    // 返回
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn-x"] forState:UIControlStateNormal];
    
    //button的 封装的block方法
    [backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil]; 
    }];
    
    [_upView addSubview:backButton];
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_upView.mas_centerY).offset(10);
        make.left.equalTo(_upView).offset(10);
        make.width.equalTo(@15);
        make.height.equalTo(@15);
    }];
    
    UIButton *LoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [LoginButton setTitle:@"Log in" forState:UIControlStateNormal];
    [_upView addSubview:LoginButton];
    [LoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_upView.mas_centerY).offset(10);
        make.centerX.equalTo(self.view.mas_right).offset(- WIDTH / 4 + 10);
        make.width.equalTo(@65);
        make.height.equalTo(@40);
    }];
    
    [LoginButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [_loginPasswordTextField resignFirstResponder];
        [_loginAccountTextField resignFirstResponder];
        [_accountTextField resignFirstResponder];
        [_passwordTextField resignFirstResponder];

        self.downScrollView.contentOffset = CGPointMake(WIDTH, 0);
        
    }];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"Sign up" forState:UIControlStateNormal];
    [_upView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_upView.mas_centerY).offset(10);
        make.centerX.equalTo(self.view.mas_left).offset(WIDTH / 4 + 10);
        make.width.equalTo(@65);
        make.height.equalTo(@40);
    }];
    
    [registerButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [_loginPasswordTextField resignFirstResponder];
        [_loginAccountTextField resignFirstResponder];
        [_accountTextField resignFirstResponder];
        [_passwordTextField resignFirstResponder];
        
        self.downScrollView.contentOffset = CGPointMake(0, 0);
    }];

    
}

#pragma mark - 登录
-(void)creatLoginView {

    self.myImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_header"]];
    _myImageView.userInteractionEnabled = YES;
    [_downScrollView addSubview:_myImageView];
    [_myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftImageView.mas_right);
        make.top.equalTo(_downScrollView.mas_top);
        make.height.equalTo(@110);
        make.width.equalTo(@(WIDTH));
    }];
    
    self.loginAccountTextField = [[UITextField alloc]init];
    _loginAccountTextField.clearButtonMode = UITextFieldViewModeAlways;
    _loginAccountTextField.textColor = [UIColor whiteColor];
    _loginAccountTextField.placeholder = @"Username";
    [_loginAccountTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.000] forKeyPath:@"placeholderLabel.textColor"];
    [_downScrollView addSubview:_loginAccountTextField];
    [_loginAccountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downScrollView.mas_left).offset(WIDTH + 60);
        make.top.equalTo(_downScrollView.mas_top).offset(160);
        make.height.equalTo(@30);
        make.width.equalTo(@(WIDTH - 120));
        
    }];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *accountImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    accountImageView.image = [UIImage imageNamed:@"field-email"];
    [upView addSubview:accountImageView];
    _loginAccountTextField.leftViewMode = UITextFieldViewModeAlways;
    _loginAccountTextField.leftView = upView;
    
    UIView *accountLineView = [[UIView alloc]init];
    accountLineView.backgroundColor = [UIColor blackColor];
    [_loginAccountTextField addSubview:accountLineView];
    [accountLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_loginAccountTextField).offset(0);
        make.right.equalTo(_loginAccountTextField).offset(0);
        make.top.equalTo(_loginAccountTextField).offset(32);
        make.height.equalTo(@1);
    }];
    
   self.loginPasswordTextField = [[UITextField alloc]init];
    _loginPasswordTextField.delegate = self;
    _loginPasswordTextField.clearButtonMode = UITextFieldViewModeAlways;
    _loginPasswordTextField.secureTextEntry = YES;
    _loginPasswordTextField.textColor = [UIColor whiteColor];
    _loginPasswordTextField.placeholder = @"Password";
    [_loginPasswordTextField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.000] forKeyPath:@"placeholderLabel.textColor"];
    [_downScrollView addSubview:_loginPasswordTextField];
    [_loginPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_downScrollView.mas_left).offset(WIDTH + 60);
        make.top.equalTo(_downScrollView.mas_top).offset(220);
        make.height.equalTo(@30);
        make.width.equalTo(@(WIDTH - 120));
    }];
    
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    UIImageView *passwordImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    passwordImageView.image = [UIImage imageNamed:@"field-lock"];
    [downView addSubview:passwordImageView];
    _loginPasswordTextField.leftViewMode = UITextFieldViewModeAlways;;
    _loginPasswordTextField.leftView = downView;
    
    UIView *passwordLineView = [[UIView alloc]init];
    passwordLineView.backgroundColor = [UIColor blackColor];
    [_loginPasswordTextField addSubview:passwordLineView];
    [passwordLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_loginPasswordTextField).offset(0);
        make.right.equalTo(_loginPasswordTextField).offset(0);
        make.top.equalTo(_loginPasswordTextField).offset(32);
        make.height.equalTo(@1);
    }];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"Log in" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    loginButton.backgroundColor = [UIColor colorWithRed:0.30 green:0.79 blue:0.50 alpha:1.0];
    loginButton.layer.cornerRadius = 10;
    loginButton.clipsToBounds = YES;
    loginButton.layer.borderWidth = 1;
    loginButton.layer.borderColor = [UIColor blackColor].CGColor;
    [self.downScrollView addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_loginPasswordTextField).offset(-20);
        make.right.equalTo(_loginPasswordTextField).offset(20 );
        make.centerY.equalTo(_signUpButton.mas_centerY).offset(0);
        make.height.equalTo(@50);
    }];
    [loginButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self login];
    }];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat value = scrollView.contentOffset.x;
    
    _upView.backgroundColor = [UIColor colorWithRed:0.32 + value / (WIDTH * 2) green:0.78 blue:0.48 - (WIDTH * 2) / value alpha:1.0];
    
    if (self.position == WIDTH / 4 * 3) {
        
        value = value - WIDTH;
        
        [UIView animateWithDuration:0.1 animations:^{
            _triangleImageView.transform = CGAffineTransformMakeTranslation(value / 2, 0);
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            _triangleImageView.transform = CGAffineTransformMakeTranslation(value / 2, 0);
        }];
    }
    
}

// 开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:_passwordTextField]) {
        _leftImageView.image = [UIImage imageNamed:@"login_header_cover_eyes"];
    }else if ([textField isEqual:_loginPasswordTextField]) {
        _myImageView.image = [UIImage imageNamed:@"login_header_cover_eyes"];
    }else if ([textField isEqual:_loginAccountTextField]) {
         _myImageView.image = [UIImage imageNamed:@"login_header"];
    }else {
        _leftImageView.image = [UIImage imageNamed:@"login_header"];
    }
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
        _leftImageView.image = [UIImage imageNamed:@"login_header"];
    _myImageView.image = [UIImage imageNamed:@"login_header"];
    
}

#pragma mark - 注册
- (void)register {
    if ([_confirmPasswordTextField.text isEqualToString:_passwordTextField.text]) {
        EMError *error = [[EMClient sharedClient] registerWithUsername:_accountTextField.text password:_passwordTextField.text];

        if (error == nil) {
            [UIView showMessage:@"Registered successfully"];
            [_confirmPasswordTextField resignFirstResponder];
            self.loginAccountTextField.text = _accountTextField.text;
            self.loginPasswordTextField.text = _passwordTextField.text;
            self.downScrollView.contentOffset = CGPointMake(WIDTH, 0);
            
        }else {
            [UIView showMessage:@"Registration failed"];
        }
        
    } else {
        [UIView showMessage:@"Confirm password mistake, please enter again"];
    }
}

#pragma mark - 登录
- (void)login {
    _error = [[EMClient sharedClient] loginWithUsername:_loginAccountTextField.text password:_loginPasswordTextField.text];
    
    if (!_error) {
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
                    
                    // 推送昵称
                    NSString *str = [EMClient sharedClient].currentUsername;
                    [[EMClient sharedClient] setApnsNickname:str];
                }
            }
        }];
        [UIView showMessage:@"Login successful"];
        
        [_loginPasswordTextField endEditing:YES];
        [self dismissViewControllerAnimated:NO completion:^{
            [_VC dismissViewControllerAnimated:YES completion:nil];
        }];
        
        if (!_error) {
            [[EMClient sharedClient].options setIsAutoLogin:YES];
        }
        
        self.view.window.rootViewController = [[FZYTabBarViewController alloc] init];
        
    }else {
        [UIView showMessage:@"Login failed"];
    }
}

// 点击return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:_confirmPasswordTextField]) {
        [self register];
    }
    
    if ([textField isEqual:_loginPasswordTextField]) {
        [self login];
    }
   
    return YES;
    
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
