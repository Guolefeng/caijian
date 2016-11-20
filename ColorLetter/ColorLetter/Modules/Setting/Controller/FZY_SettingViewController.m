//
//  FZY_SettingViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_SettingViewController.h"
#import "FZY_SettingTableViewCell.h"
#import "FZY_SwitchTableViewCell.h"

static NSString *const cellIdentifier = @"settingCell";
static NSString *const IdentifierCell = @"switchCell";

@interface FZY_SettingViewController ()

<
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, strong) NSArray *imageArray;

@property (nonatomic, strong) NSMutableArray *friendsOfBlackList;

@end

@implementation FZY_SettingViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self getBlackList];
    [_tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsOfBlackList = [NSMutableArray array];
    
    self.titleLabel.text = @"设置";
    [self createTableView];

}

- (void)getBlackList {
    EMError *error = nil;
    NSArray *array = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
    [self.friendsOfBlackList addObjectsFromArray:array];
    if (!error) {
       // NSLog(@"获取好友黑名单成功 -- %@", _friendsOfBlackList);
    }
    
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT - 64 - 49) style:UITableViewStylePlain];
    _tableView.separatorStyle = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[FZY_SettingTableViewCell class] forCellReuseIdentifier:cellIdentifier];
    [_tableView registerClass:[FZY_SwitchTableViewCell class] forCellReuseIdentifier:IdentifierCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEIGHT / 16.27;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (0 == section) {
        return @"我的彩笺";
    } else {
        return @"好友黑名单";
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 2;
    } else {
        return _friendsOfBlackList.count;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            cell.cellName = @"分享";
        }else if (1 == indexPath.row) {
            cell.cellName = @"清除缓存";
        }
    } else {
        if (_friendsOfBlackList.count) {
            cell.cellName = _friendsOfBlackList[indexPath.row];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[@"Share"] applicationActivities:nil];
            // 不能用push
            //    [self.navigationController pushViewController:activityVC animated:YES];
            // 在数组里的不显示
            activityVC.excludedActivityTypes = @[UIActivityTypeMail, UIActivityTypePostToWeibo,  UIActivityTypeMessage, UIActivityTypeAirDrop, ];
            [self presentViewController:activityVC animated:YES completion:nil];
        }else if (1 == indexPath.row) {
            NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask ,YES) firstObject];
            CGFloat cacheSize = [self folderSizeAtPath:cachePath];
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定要清除%.2fM缓存?", cacheSize] message:nil preferredStyle:UIAlertControllerStyleAlert];
            //创建一个取消和一个确定按钮
            UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
            UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"嗯呐" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self clearCache:cachePath];
                [UIView showMessage:@"清除成功"];
            }];
            //将取消和确定按钮添加进弹框控制器
            [alert addAction:actionCancle];
            [alert addAction:actionOk];
            
            //显示弹框控制器
            [self presentViewController:alert animated:YES completion:nil];
        }
    } else {
        
        UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"确定将%@移出黑名单", _friendsOfBlackList[indexPath.row]] message:nil preferredStyle:UIAlertControllerStyleAlert];
        //创建一个取消和一个确定按钮
        UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"呆着吧" style:UIAlertActionStyleCancel handler:nil];
        //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"嗯呐" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {

            // 移除黑名单
            EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:_friendsOfBlackList[indexPath.row]];
            if (!error) {
                [UIView showMessage:@"移出成功"];
            } else {
                [UIView showMessage:@"移出失败, 请再试一次"];
            }
            [_friendsOfBlackList removeObjectAtIndex:indexPath.row];
            [_tableView reloadData];
            
        }];
        //将取消和确定按钮添加进弹框控制器
        [alert addAction:actionCancle];
        [alert addAction:actionOk];
        //显示弹框控制器
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
}

- (float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    long long folderSize=0;
    if ([fileManager fileExistsAtPath:path])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath=[path stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[EMSDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}

- (long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

// 清除缓存
- (void)clearCache:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[EMSDImageCache sharedImageCache] cleanDisk];
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
