//
//  FZY_CreateGroupViewController.m
//  ColorLetter
//
//  Created by dllo on 16/11/7.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_CreateGroupViewController.h"
#import "FZY_FriendsListViewController.h"

@interface FZY_CreateGroupViewController ()
<
UITextFieldDelegate,
FZY_FriendsListViewControllerDelegate
>
@property (weak, nonatomic) IBOutlet UITextField *groupName;
@property (weak, nonatomic) IBOutlet UITextView *groupDescription;
@property (weak, nonatomic) IBOutlet UITextField *maxMembers;
@property (nonatomic, strong) NSMutableArray *groupMembersArray;
@end

@implementation FZY_CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self backButton];
    [self completeButton];
}
#pragma mark - 返回按钮
- (void)backButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 30, 15, 15);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn-x"] forState:UIControlStateNormal];
    [backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:backButton];
}

#pragma mark - 完成按钮
- (void)completeButton {
    UIButton *completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    completeButton.frame = CGRectMake(WIDTH - 90, 20, 80, 40);
    [completeButton setTitle:@"完成" forState:UIControlStateNormal];
    [completeButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if (_groupMembersArray.count) {
            [self createGroup];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"群成员数不能为空" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:alertAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    [self.view addSubview:completeButton];
}

#pragma mark - textField 协议
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSInteger count = [self.maxMembers.text integerValue];
    if (count > 2000) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"群成员数不能超过2000人" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:alertAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - 创建群组
- (void)createGroup {
    
    EMError *error = nil;
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = [self.maxMembers.text integerValue];
    setting.style = EMGroupStylePublicOpenJoin; //  公开群组，Owner可以邀请用户加入; 非群成员用户发送入群申请，经Owner同意后才能入组
    
    if (setting.maxUsersCount <= 2000) {
        EMGroup *group = [[EMClient sharedClient].groupManager createGroupWithSubject:self.groupName.text description:self.groupDescription.text invitees:self.groupMembersArray message:@"邀请您加入群组" setting:setting error:&error];
        if (!error) {
//            NSLog(@"创建成功--- %@", group);
            [TSMessage showNotificationWithTitle:@"Success" subtitle:[NSString stringWithFormat:@"%@创建成功", _groupName.text] type:TSMessageNotificationTypeSuccess];
            
            [self.delegate insertNewGroupToTableViewWithName:_groupName.text description:_groupDescription.text];
            
        } else {
//            NSLog(@"创建群组失败--- %@", error);
            [TSMessage showNotificationWithTitle:@"Error" subtitle:[NSString stringWithFormat:@"%@创建失败", _groupName.text] type:TSMessageNotificationTypeError];
        }
    }
    
}

#pragma mark - 邀请群成员
- (IBAction)inviteGroupMembers:(id)sender {
    
    FZY_FriendsListViewController *friendsListVC = [[FZY_FriendsListViewController alloc] init];
    friendsListVC.delegate = self;
    [self presentViewController:friendsListVC animated:YES completion:nil];
}

- (void)getInvitedFriendsName:(NSMutableArray *)array {
    self.groupMembersArray = array;
    NSLog(@"%@", _groupMembersArray);
}

- (void)screenTap:(UIGestureRecognizer *)tap {
    // 取消当前屏幕所有第一响应
    [self.view endEditing:YES];
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
