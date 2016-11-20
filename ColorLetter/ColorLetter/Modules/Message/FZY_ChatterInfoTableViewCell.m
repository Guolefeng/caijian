//
//  FZY_ChatterInfoTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/11/10.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ChatterInfoTableViewCell.h"

@interface FZY_ChatterInfoTableViewCell ()

@property (nonatomic, strong) UISwitch *blackListSwitch;

@end

@implementation FZY_ChatterInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.blackListSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
        [_blackListSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:_blackListSwitch];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_blackListSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-70);
        make.top.equalTo(self.contentView).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}

- (void)switchChange:(UISwitch *)switchValue {
    if (switchValue.on) {
//        NSLog(@"加入黑名单");
        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:_blackList relationshipBoth:YES];
        if (!error) {
//            NSLog(@"发送成功");
        }
    } else {
//        NSLog(@"取消黑名单");
        EMError *error = [[EMClient sharedClient].contactManager removeUserFromBlackList:_blackList];
        if (!error) {
//            NSLog(@"发送成功");
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
