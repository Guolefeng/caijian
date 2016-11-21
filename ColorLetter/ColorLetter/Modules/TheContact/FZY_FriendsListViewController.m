//
//  FZY_FriendsListViewController.m
//  ColorLetter
//
//  Created by dllo on 16/11/8.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_FriendsListViewController.h"
#import "FZY_RequestModel.h"
#import "FZY_FriendsTableViewCell.h"
#import "FZY_RequestModel.h"

@interface FZY_FriendsListViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *friendsArray;
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, retain) UIButton *selectButton;
@property (nonatomic, retain) UIButton *selectAllButton;
@end

@implementation FZY_FriendsListViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getFriendList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.friendsArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    
    [self createButton];
    [self createTableView];
}

#pragma mark - 获取好友列表
- (void)getFriendList {
    EMError *error = nil;
    if (_friendsArray.count > 0) {
        [_friendsArray removeAllObjects];
    }
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        [_friendsArray addObjectsFromArray:userlist];
    }
    
}

#pragma mark - 按钮
- (void)createButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 30, 20, 20);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn-back"] forState:UIControlStateNormal];
    [backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:backButton];
    
    // 选择
    self.selectButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectButton.frame = CGRectMake(WIDTH - 75, 20, 50, 30);
    [_selectButton setTitle:@"选择" forState:UIControlStateNormal];
    [_selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_selectButton];
    [_selectButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        
        _tableView.allowsMultipleSelectionDuringEditing = YES;
        _tableView.editing = !_tableView.editing;
        
        if ([_tableView isEditing]) {
            _selectAllButton.hidden = NO;
            [_selectButton setTitle:@"完成" forState:UIControlStateNormal];
        }else {
            [self.delegate getInvitedFriendsName:_dataArray];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    // 全选
    self.selectAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _selectAllButton.frame = CGRectMake(WIDTH - 150, 20, 50, 30);
    [_selectAllButton setTitle:@"全选" forState:UIControlStateNormal];
    [_selectAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_selectAllButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        if ([_tableView isEditing]) {
            for (int i = 0; i < _friendsArray.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            }
            [_dataArray addObjectsFromArray:_friendsArray];
        }
    }];
    [self.view addSubview:_selectAllButton];
    _selectAllButton.hidden = YES;
}

#pragma mark - 创建 tableView
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.rowHeight = 80;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"friendsCell"];
}
#pragma mark - tableView 协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _friendsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"friendsCell"];
    cell.textLabel.text = _friendsArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_tableView isEditing]) {
        [_dataArray addObject:_friendsArray[indexPath.row]];
    }
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
