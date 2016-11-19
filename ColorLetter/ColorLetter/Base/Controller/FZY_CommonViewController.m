//
//  FZY_CommonViewController.m
//  ColorLetter
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_CommonViewController.h"

@interface FZY_CommonViewController ()

@end

@implementation FZY_CommonViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default-736"]];
    [self createLabel];
}

- (void)createLabel {
    self.titleLabel = [[UILabel alloc] init];
    [_titleLabel sizeToFit];
    _titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(25);
        make.height.equalTo(@25);
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
