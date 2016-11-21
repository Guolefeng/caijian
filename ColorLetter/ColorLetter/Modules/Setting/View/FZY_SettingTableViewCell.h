//
//  FZY_SettingTableViewCell.h
//  ColorLetter
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FZY_SettingTableViewCell : UITableViewCell

@property (nonatomic, copy) NSString *cellName;

@property (nonatomic, copy) NSString *cellImage;

@property (nonatomic, strong) UILabel *cellLabel;

@property (nonatomic, strong) UIImageView *cellImageView;

@end
