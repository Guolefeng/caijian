//
//  FZY_FriendsModel.h
//  ColorLetter
//
//  Created by dllo on 16/10/26.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseModel.h"

@interface FZY_FriendsModel : FZYBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) long long time;
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, assign) int unReadMessageNum;
@property (nonatomic, copy) NSString *latestMessage;
@property (nonatomic, strong) NSString *urlImage;

@end
