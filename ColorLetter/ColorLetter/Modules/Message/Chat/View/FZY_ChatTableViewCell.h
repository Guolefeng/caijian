//
//  FZY_ChatTableViewCell.h
//  ColorLetter
//
//  Created by dllo on 16/10/27.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_BaseTableViewCell.h"

@class FZY_ChatModel;

@interface FZY_ChatTableViewCell : FZY_BaseTableViewCell

@property (nonatomic, strong) FZY_ChatModel *model;

@property (nonatomic, copy) NSString *leftImage;

@property (nonatomic, copy) NSString *rightImage;

@property (nonatomic, assign) BOOL change;

@end
