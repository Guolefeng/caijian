//
//  FZY_FriendRequestViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/26.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_FriendRequestViewController.h"

static NSString *const cellIdentifier = @"cell";


@interface FZY_FriendRequestViewController ()

<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate
>

@property (nonatomic, retain)UITableView *tableView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextField *groupTextField;

@property (nonatomic, retain)NSMutableArray *dataArray;
@property (nonatomic, retain)NSMutableArray *searchArray;

@end

@implementation FZY_FriendRequestViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _textField.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self create];
    [self getArray];
//    [self createTableView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)create {
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setTitle:@"Add" forState:UIControlStateNormal];
    cancel.titleLabel.textColor = [UIColor whiteColor];
    cancel.backgroundColor = [UIColor clearColor];
   
    [self.view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).offset(WIDTH / 2);
        make.top.equalTo(self.view.mas_top).offset(30);
        make.height.equalTo(@30);
        make.width.equalTo(@50);
    }];
    
    UIButton *backImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImage setBackgroundImage:[UIImage imageNamed:@"btn-x"] forState:UIControlStateNormal];
    [backImage handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:backImage];
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(35                                                             );
        make.height.equalTo(@15);
        make.width.equalTo(@15);
    }];
    
    UIImageView *backgroudImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64)];
    backgroudImageView.userInteractionEnabled = YES;
    backgroudImageView.image = [UIImage imageNamed:@"friendShip"];
    [self.view addSubview:backgroudImageView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [backgroudImageView addGestureRecognizer:tap];
    
    UIImageView *placeHoder = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, HEIGHT / 2 - 80, WIDTH, 50)];
    _textField.delegate = self;
    _textField.leftView = placeHoder;
    _textField.leftViewMode = UITextFieldViewModeUnlessEditing;// 此处用来设置leftview现实时机
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.backgroundColor = [UIColor lightGrayColor];
    _textField.alpha = 0.7;
    _textField.clearButtonMode = UITextFieldViewModeAlways;
    _textField.placeholder = @"请输入好友 ID 以添加好友";
    [_textField setValue:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.000] forKeyPath:@"placeholderLabel.textColor"];
    [backgroudImageView addSubview:_textField];
    
    UIImageView *placeHoderImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 50)];
    self.groupTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, HEIGHT / 2 - 10, WIDTH, 50)];
    _groupTextField.delegate = self;
    _groupTextField.alpha = 0.7;
    _groupTextField.leftView = placeHoderImage;
    _groupTextField.leftViewMode = UITextFieldViewModeAlways;
    _groupTextField.backgroundColor = [UIColor lightGrayColor];
    _groupTextField.clearButtonMode = UITextFieldViewModeAlways;
    _groupTextField.placeholder = @"请输入群组 ID 以加入群";
    [_groupTextField setValue:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.000] forKeyPath:@"placeholderLabel.textColor"];
    [backgroudImageView addSubview:_groupTextField];
    
}

- (void)tapAction {
    [self.view endEditing:YES];
}

- (void)getArray {
    self.dataArray = [NSMutableArray array];
    self.searchArray = [NSMutableArray array];
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, WIDTH, HEIGHT - 114) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    cell.textLabel.text = _dataArray[indexPath.row];

    return cell;
}

// 开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}


// 点击return
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    //回收键盘
    //(放弃第一响应者)
    [textField resignFirstResponder];
    // 结束编辑状态
//    [textField endEditing:YES];
    
    NSString *searchString = textField.text;
    
    if (searchString.length == 0) {
        return YES;
    }
    
    if (textField == _textField) {
        
        NSString *loginUsername = [[EMClient sharedClient] currentUsername];
        if ([searchString isEqualToString:loginUsername]) {
            [TSMessage showNotificationWithTitle:@"警告" subtitle:@"不能添加自己为好友" type:TSMessageNotificationTypeError];
            return YES;
        }
        for (NSString *string in _array) {
            if ([searchString isEqualToString:string]) {
                [TSMessage showNotificationWithTitle:[NSString stringWithFormat:@"%@已经是你的好基友了", searchString] subtitle:[NSString stringWithFormat:@"%@ 无需重新添加", searchString] type:TSMessageNotificationTypeError];
                return YES;
            }
        }
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定添加 %@ as a friend?", searchString] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"说点什么吧...";
        }];
        //创建一个取消和一个确定按钮
        UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"cancl" style:UIAlertActionStyleCancel handler:nil];
        //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"嗯呐" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alert.textFields.firstObject;
            EMError *error = [[EMClient sharedClient].contactManager addContact:searchString message:[NSString stringWithFormat:@"%@", textField.text]];
            if (!error) {
                [UIView showMessage:@"等待对方接受你的请求"];
            }else {
                [UIView showMessage:@"发送失败, 请再试一次."];
            }
        }];
        //将取消和确定按钮添加进弹框控制器
        [alert addAction:actionCancle];
        [alert addAction:actionOk];
        //显示弹框控制器
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (textField == _groupTextField) {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定加入 %@ 群?", searchString] message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
            textField.placeholder = @"说点什么吧...";
        }];
        //创建一个取消和一个确定按钮
        UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"嗯呐" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            UITextField *textField = alert.textFields.firstObject;
            
            EMError *error = nil;
            [[EMClient sharedClient].groupManager applyJoinPublicGroup:searchString message:[NSString stringWithFormat:@"%@", textField.text] error:&error];
            if (!error) {
                [UIView showMessage:@"等待群主接受你的请求"];
            } else {
                [UIView showMessage:@"发送失败, 请再试一次"];
            }
            
        }];
        //将取消和确定按钮添加进弹框控制器
        [alert addAction:actionCancle];
        [alert addAction:actionOk];
        //显示弹框控制器
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [_tableView reloadData];
    
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
