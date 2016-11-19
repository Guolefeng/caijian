//
//  FZY_RequestTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/28.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_RequestTableViewCell.h"
#import "FZY_RequestModel.h"


@interface FZY_RequestTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation FZY_RequestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.numberOfLines = 0;
        _nameLabel.font = [UIFont systemFontOfSize:20];
        [self.contentView addSubview:_nameLabel];
        
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _messageLabel.textColor = [UIColor grayColor];
        _messageLabel.numberOfLines = 0;
        [_messageLabel sizeToFit];
        _messageLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_messageLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(self.contentView.frame.size.height - 20));
        make.height.equalTo(@(self.contentView.frame.size.height - 20));
    }];
    _headImageView.layer.cornerRadius = (self.contentView.frame.size.height - 20) / 2;
    _headImageView.clipsToBounds = YES;
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(20);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.height.equalTo(@20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
    [_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(20);
        make.top.equalTo(_nameLabel.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
}


- (void)setFzy:(FZY_RequestModel *)fzy {
    if (_fzy != fzy) {
        _fzy = fzy;
        
        if (fzy.isGroup) {
            _headImageView.image = [UIImage imageNamed:@"bg-mob"];
        } else {
            _headImageView.image = [UIImage imageNamed:@"mood-confused"];
        }
        _nameLabel.text = _fzy.aUsername;
        _messageLabel.text = _fzy.aMessage;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
