//
//  FZY_MessageTableViewCell.h
//  ColorLetter
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_BaseTableViewCell.h"

@class FZY_FriendsModel;

@interface FZY_MessageTableViewCell : FZY_BaseTableViewCell

@property (nonatomic, strong) FZY_FriendsModel *model;

@property (nonatomic, copy) NSString *urlImage;

- (void)displayNumberOfUnreadMessagesWith:(BOOL)isRead;

@end
