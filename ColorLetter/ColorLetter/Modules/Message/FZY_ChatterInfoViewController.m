//
//  FZY_ChatterInfoViewController.m
//  ColorLetter
//
//  Created by dllo on 16/11/10.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ChatterInfoViewController.h"
#import "FZY_ChatterInfoTableViewCell.h"

@interface FZY_ChatterInfoViewController ()
<
UITableViewDelegate,
UITableViewDataSource
>
@property (nonatomic, strong) UITableView *tableViwe;

@end

@implementation FZY_ChatterInfoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self createTableView];
}

- (void)createTableView {
    
    self.tableViwe = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableViwe.delegate = self;
    _tableViwe.dataSource = self;
    _tableViwe.separatorStyle = NO;
    [_tableViwe registerClass:[FZY_ChatterInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_tableViwe];
    
    UIView *upView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200)];
    [self.view addSubview:upView];
    // 设置模糊效果
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    // 创建模糊效果的视图
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    // 添加到有模糊效果的控件上
    effectView.frame = upView.bounds;
    [upView addSubview:effectView];

    UIImageView *imageView = [[UIImageView alloc] init];
//    imageView.image =  [UIImage imageNamed:@"mood-unhappy"];
    [imageView sd_setImageWithURL:[NSURL URLWithString:_friendImage] placeholderImage:[UIImage imageNamed:@"mood-unhappy"]];
    [upView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(upView.mas_centerY).offset(-20);
        make.centerX.equalTo(upView.mas_centerX).offset(0);
        make.width.height.equalTo(@100);
    }];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = _friendName;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [upView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(upView.mas_bottom).offset(-20);
        make.centerX.equalTo(upView.mas_centerX).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
    }];
    _tableViwe.tableHeaderView = upView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FZY_ChatterInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.blackList = _friendName;
    cell.textLabel.text = @"加入黑名单";
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
