//
//  FZY_CreateGroupViewController.h
//  ColorLetter
//
//  Created by dllo on 16/11/7.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseViewController.h"

@protocol FZY_CreateGroupViewControllerDelegate <NSObject>

- (void)insertNewGroupToTableViewWithName:(NSString *)groupName description:(NSString *)groupDescription;

@end

@interface FZY_CreateGroupViewController : FZYBaseViewController

@property (nonatomic, assign) id<FZY_CreateGroupViewControllerDelegate>delegate;

@end
