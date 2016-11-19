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

@end

@implementation FZY_SettingViewController

- (void)dealloc {
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"Setting";
    [self createTableView];

}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT) style:UITableViewStylePlain];
    _tableView.scrollEnabled = NO;
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
        return @"Options";
    }
    return @"ColorLetter";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (0 == section) {
        return 1;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_SettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (0 == indexPath.section) {
        FZY_SwitchTableViewCell *cells = [tableView dequeueReusableCellWithIdentifier:IdentifierCell];
        if (0 == indexPath.row) {
            cells.cellName = @"Notifications";
        }
        cells.selectionStyle = UITableViewCellSelectionStyleNone;
        return cells;
    }else {
        if (0 == indexPath.row){
            cell.cellName = @"Share";
        }else if (1 == indexPath.row){
            cell.cellName = @"Clear Cache";
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            
        }
    }else if (1 == indexPath.section) {
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
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Sure to remove%.2fMcache?", cacheSize] message:nil preferredStyle:UIAlertControllerStyleAlert];
            //创建一个取消和一个确定按钮
            UIAlertAction *actionCancle=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
            //因为需要点击确定按钮后改变文字的值，所以需要在确定按钮这个block里面进行相应的操作
            UIAlertAction *actionOk=[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [self clearCache:cachePath];
                [UIView showMessage:@"Clear success"];
            }];
            //将取消和确定按钮添加进弹框控制器
            [alert addAction:actionCancle];
            [alert addAction:actionOk];
            
            //显示弹框控制器
            [self presentViewController:alert animated:YES completion:nil];

        }
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
