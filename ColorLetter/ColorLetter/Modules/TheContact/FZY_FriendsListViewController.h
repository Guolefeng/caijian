//
//  FZY_FriendsListViewController.h
//  ColorLetter
//
//  Created by dllo on 16/11/8.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseViewController.h"

@protocol FZY_FriendsListViewControllerDelegate <NSObject>

- (void)getInvitedFriendsName:(NSMutableArray *)array;

@end

@interface FZY_FriendsListViewController : FZYBaseViewController

@property (nonatomic, assign) id<FZY_FriendsListViewControllerDelegate>delegate;
@end
