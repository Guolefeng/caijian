//
//  FZYBaseViewController.h
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DrawerViewController;

@protocol FZYBaseViewControllerDelegate <NSObject>

- (void)refreshTableView;

@end

@interface FZYBaseViewController : UIViewController

@property (nonatomic, strong) id<FZYBaseViewControllerDelegate>delegate;

@property (nonatomic, strong) UIButton *drawerButton;

@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, strong) UILabel *titleLabel;

- (void)create;
@end
