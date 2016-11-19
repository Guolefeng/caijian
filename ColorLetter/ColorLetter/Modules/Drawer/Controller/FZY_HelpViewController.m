//
//  FZY_HelpViewController.m
//  ColorLetter
//
//  Created by dllo on 16/11/9.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_HelpViewController.h"
#import "UIButton+Block.h"
#import "YYImage.h"
#import <YYWebImage/YYWebImage.h>
@interface FZY_HelpViewController ()
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation FZY_HelpViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.82 green:0.79 blue:0.19 alpha:1.0];
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
    upView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.21 alpha:1.0];
    [self.view addSubview:upView];
    
    UIButton *backImage = [UIButton buttonWithType:UIButtonTypeCustom];
    [backImage setBackgroundImage:[UIImage imageNamed:@"btn-x"] forState:UIControlStateNormal];
    [backImage handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [upView addSubview:backImage];
   
    [backImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).offset(5);
            make.top.equalTo(self.view.mas_top).offset(35                                                             );
            make.height.equalTo(@15);
            make.width.equalTo(@15);
    }];
   
    UILabel *label = [[UILabel alloc] init];
    label.text = @"ColorLetter Help Center";
    label.textAlignment = UITextAlignmentCenter;
    [label setTextColor:[UIColor whiteColor]];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
       make.centerX.equalTo(self.view.mas_left).offset(WIDTH / 2);
       make.top.equalTo(self.view.mas_top).offset(30);
       make.height.equalTo(@30);
       make.width.equalTo(@300);
   }];
        
    UILabel *helpLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT / 2 , WIDTH, HEIGHT * 0.1 + 7)];
    helpLabel.backgroundColor = [UIColor colorWithRed:0.82 green:0.79 blue:0.19 alpha:1.0 ];
    helpLabel.text = @"This product is instant messaging products,  If you have any questions, please call 8888888";
    helpLabel.font=[UIFont systemFontOfSize:15];
    helpLabel.numberOfLines = 0;
    helpLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [self.view addSubview:helpLabel];
   
    YYImage *image = [YYImage imageNamed:@"1"];
    self.imageView = [[YYAnimatedImageView alloc]initWithImage:image];
    _imageView.frame = CGRectMake(0, 64 + HEIGHT / 2, WIDTH,  HEIGHT * 0.3);
    [self.view addSubview:_imageView];
    
    YYImage *image2 = [YYImage imageNamed:@"3"];
    self.imageView = [[YYAnimatedImageView alloc]initWithImage:image2];
    _imageView.frame = CGRectMake(0, 64 + (HEIGHT - (64 + HEIGHT / 2 + HEIGHT * 0.3)), WIDTH, HEIGHT * 0.3); 
    [self.view addSubview:_imageView];

   
    
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
