//
//  FZY_MessageTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/24.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_MessageTableViewCell.h"
#import "FZY_FriendsModel.h"
#import "NSData+Categories.h"

@interface FZY_MessageTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *latestMessageLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *unReadMessageLabel;

@end

@implementation FZY_MessageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.image = [UIImage imageNamed:@"mood-happy"];
        [self.contentView addSubview:_headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_nameLabel];
        
        self.latestMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_latestMessageLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_timeLabel];
        
        self.unReadMessageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _unReadMessageLabel.backgroundColor = [UIColor redColor];
        _unReadMessageLabel.textColor = [UIColor whiteColor];
        _unReadMessageLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return self;
}

- (void)setModel:(FZY_FriendsModel *)model {
    if (_model != model) {
        _model = model;
        
        if (model.isGroup) {
            _nameLabel.text = model.groupID;
            _headImageView.image = [UIImage imageNamed:@"bg-mob"];
            _headImageView.layer.cornerRadius = 10;
            _headImageView.layer.masksToBounds = YES;
        } else {
            _nameLabel.text = model.name;
            _headImageView.layer.cornerRadius = 35;
            _headImageView.layer.masksToBounds = YES;
        }
        
        _timeLabel.text = [NSData intervalSinceNow:model.time];
        _latestMessageLabel.text = model.latestMessage;
        
        if (model.unReadMessageNum) {
            _unReadMessageLabel.text = [NSString stringWithFormat:@"%d", model.unReadMessageNum];
            [self displayNumberOfUnreadMessagesWith:NO];
            
        } else {
            [self displayNumberOfUnreadMessagesWith:YES];
        }
       
    }
}

- (void)setUrlImage:(NSString *)urlImage {
    if (_urlImage != urlImage) {
        _urlImage = urlImage;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_urlImage] placeholderImage:[UIImage imageNamed:@"mood-happy"]];
    }
}

- (void)displayNumberOfUnreadMessagesWith:(BOOL)isRead {
    if (!isRead) {

        [self.contentView addSubview:_unReadMessageLabel];
        [_unReadMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@(24));
            make.right.equalTo(_headImageView).offset(5);
            make.top.equalTo(self.contentView).offset(5);
        }];
        _unReadMessageLabel.layer.cornerRadius = 12;
        _unReadMessageLabel.clipsToBounds = YES;
       
    } else {
        if (_unReadMessageLabel != nil) {
            [_unReadMessageLabel removeFromSuperview];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat h = self.contentView.frame.size.height;
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@(70));
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(15);
    }];

    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.width.equalTo(@(self.contentView.frame.size.width / 2 - 30));
        make.top.equalTo(self.contentView).offset(5);
        make.height.equalTo(@(h / 2 - 10));
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right).offset(0);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.equalTo(@(h / 2));
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [_latestMessageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(_nameLabel.mas_bottom).offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}

@end
