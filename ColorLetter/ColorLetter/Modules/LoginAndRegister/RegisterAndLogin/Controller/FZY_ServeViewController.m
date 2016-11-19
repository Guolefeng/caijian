//
//  FZY_ServeViewController.m
//  ColorLetter
//
//  Created by dllo on 16/11/16.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ServeViewController.h"

@interface FZY_ServeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation FZY_ServeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createBackButton];
    
    self.textView.editable = NO;

}
- (void)createBackButton {
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 30, 20, 20);
    [backButton setBackgroundImage:[UIImage imageNamed:@"btn-searchclear"] forState:UIControlStateNormal];
    [backButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self.view addSubview:backButton];
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
