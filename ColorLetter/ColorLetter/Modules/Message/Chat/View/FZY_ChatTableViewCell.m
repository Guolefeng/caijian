//
//  FZY_ChatTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/27.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_ChatTableViewCell.h"
#import "FZY_ChatModel.h"
#import "NSData+Categories.h"
#import "UIImageAvatarBrowser.h"
#import "YZYNetWorkingManager.h"

@interface FZY_ChatTableViewCell ()

// 左头像
@property (nonatomic, strong) UIImageView *leftIconImageView;
// 右头像
@property (nonatomic, strong) UIImageView *rightIconImageView;
// 左昵称
@property (nonatomic, strong) UILabel *leftName;
// 右昵称
@property (nonatomic, strong) UILabel *rightName;
// 左气泡
@property (nonatomic, strong) UIImageView *leftBubble;
// 右气泡
@property (nonatomic, strong) UIImageView *rightBubble;
// 左label
@property (nonatomic, strong) UILabel *leftLabel;
// 右label
@property (nonatomic, strong) UILabel *rightLabel;
// 左图片
@property (nonatomic, strong) UIButton *leftPhotoImageView;
// 右图片
@property (nonatomic, strong) UIButton *rightPhotoImageView;
// 时间
@property (nonatomic, strong) UILabel *leftTimeLabel;
@property (nonatomic, strong) UILabel *rightTimeLabel;

// 语音
@property (nonatomic, strong) UIButton *leftVoiceButton;
@property (nonatomic, strong) UIButton *rightVoiceButton;

// 正在播放语音
@property (nonatomic, assign) BOOL isPlayVoice;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@property (nonatomic, strong) UIImageView *lefeVoice;

@property (nonatomic, strong) UIImageView *rightVoice;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) float i;

@property (nonatomic, strong) UIImage * rightImageChange;

@end

@implementation FZY_ChatTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 左头像
        self.leftIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftIconImageView.image = [UIImage imageNamed:@"mood-confused"];
        _leftIconImageView.layer.cornerRadius = 5;
        _leftIconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_leftIconImageView];
        
        // 右头像
        self.rightIconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightIconImageView.image = [UIImage imageNamed:@"mood-unhappy"];
        _rightIconImageView.layer.cornerRadius = 5;
        _rightIconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_rightIconImageView];
        
        // 左名字
        self.leftName = [[UILabel alloc]initWithFrame:CGRectZero];
        _leftName.text = @"左用户";
        _leftName.textAlignment = NSTextAlignmentCenter;
        _leftName.font = [UIFont systemFontOfSize:8];
        _leftName.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_leftName];
        
        // 右名字
        self.rightName = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightName.text = @"右用户";
        _rightName.textAlignment = NSTextAlignmentCenter;
        _rightName.font = [UIFont systemFontOfSize:8];
        _rightName.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:_rightName];
        
        // 1、得到图片信息
        UIImage * leftImage = [UIImage imageNamed:@"chatfrom_bg_normal"];
        self.rightImageChange = [[UIImage alloc] init];
        _rightImageChange = [UIImage imageNamed:@"chatto_bg_normal"];
        
        

        // 2、抓取像素拉伸
        leftImage = [leftImage stretchableImageWithLeftCapWidth:15 topCapHeight:40];
        _rightImageChange = [_rightImageChange stretchableImageWithLeftCapWidth:15 topCapHeight:40];
        
        // 左气泡
        self.leftBubble = [[UIImageView alloc] initWithFrame:CGRectZero];
        _leftBubble.image = leftImage;
        _leftBubble.userInteractionEnabled = YES;
        [self.contentView addSubview:_leftBubble];
        // 右气泡
        self.rightBubble = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightBubble.image = _rightImageChange;
        _rightBubble.userInteractionEnabled = YES;
        [self.contentView addSubview:_rightBubble];
        
        // 气泡上的文字
        self.leftLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftLabel.numberOfLines = 0;
        _leftLabel.textAlignment = NSTextAlignmentCenter;
        [_leftLabel sizeToFit];
        [_leftBubble addSubview:_leftLabel];
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLabel.numberOfLines = 0;
        _rightLabel.textAlignment = NSTextAlignmentCenter;
        [_rightLabel sizeToFit];
        [_rightBubble addSubview:_rightLabel];
        
        // 左图片
        self.leftPhotoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftPhotoImageView.frame = CGRectMake(0, 0, 220, 200);
        [_leftBubble addSubview:_leftPhotoImageView];
        
        
        // 右图片
        self.rightPhotoImageView = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightPhotoImageView.frame = CGRectMake(0, 0, 220, 200);
        [_rightBubble addSubview:_rightPhotoImageView];
       
        
        
        // 时间Label
        self.leftTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _leftTimeLabel.textAlignment = NSTextAlignmentCenter;
        _leftTimeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_leftTimeLabel];
        
        self.rightTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightTimeLabel.textAlignment = NSTextAlignmentCenter;
        _rightTimeLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:_rightTimeLabel];
        
        // 左语音
        self.leftVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_leftBubble addSubview:_leftVoiceButton];
        
        self.lefeVoice = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.lefeVoice.image = [UIImage imageNamed:@"chat_animation3"];
        self.lefeVoice.animationImages = [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"chat_animation1"],
                                           [UIImage imageNamed:@"chat_animation2"],
                                           [UIImage imageNamed:@"chat_animation3"],nil];
        self.lefeVoice.animationDuration = 1;
        self.lefeVoice.animationRepeatCount = 0;
        self.lefeVoice.userInteractionEnabled = NO;
        self.lefeVoice.backgroundColor = [UIColor clearColor];
        [_leftBubble addSubview:_lefeVoice];

        
        // 右语音
        self.rightVoiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightVoiceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_rightBubble addSubview:_rightVoiceButton];
        
        self.rightVoice = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.rightVoice.image = [UIImage imageNamed:@"chat_animation_white3"];
        self.rightVoice.animationImages = [NSArray arrayWithObjects:
                                           [UIImage imageNamed:@"chat_animation_white1"],
                                           [UIImage imageNamed:@"chat_animation_white2"],
                                           [UIImage imageNamed:@"chat_animation_white3"],nil];
        self.rightVoice.animationDuration = 1;
        self.rightVoice.animationRepeatCount = 0;
        self.rightVoice.userInteractionEnabled = NO;
        self.rightVoice.backgroundColor = [UIColor clearColor];
        [_rightBubble addSubview:_rightVoice];
        

        self.i = 0;

    }
    
    return self;
}

- (void)setLeftImage:(NSString *)leftImage {
    if (_leftImage != leftImage) {
        _leftImage = leftImage;
        [_leftIconImageView sd_setImageWithURL:[NSURL URLWithString:_leftImage] placeholderImage:[UIImage imageNamed:@"mood-confused"]];
    }
}

- (void)setRightImage:(NSString *)rightImage {
    if (_rightImage != rightImage) {
        _rightImage = rightImage;
        [_rightIconImageView sd_setImageWithURL:[NSURL URLWithString:_rightImage] placeholderImage:[UIImage imageNamed:@"mood-unhappy"]];
    }
}

- (void)setModel:(FZY_ChatModel *)model {
    if (_model != model) {
        _model = model;
        
        //根据文字确定显示大小
        CGSize size = [model.context boundingRectWithSize:CGSizeMake(160, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0]} context:nil].size;
        
        
        if (model.isSelf) {
            //只显示右侧气泡
            self.leftBubble.hidden = YES;
            self.rightBubble.hidden = NO;
            self.leftIconImageView.hidden = YES;
            self.rightIconImageView.hidden = NO;
            self.leftName.hidden = YES;
            self.rightName.hidden = NO;
            self.leftTimeLabel.hidden = YES;
            self.rightTimeLabel.hidden = NO;
            
            // 图片
            if (model.isPhoto) {
                self.lefeVoice.hidden = YES;
                self.rightVoice.hidden = YES;
                self.leftPhotoImageView.hidden = YES;
                self.rightPhotoImageView.hidden = NO;
                self.leftVoiceButton.hidden = YES;
                self.rightVoiceButton.hidden = YES;
                NSURL *url = [NSURL URLWithString:model.photoName];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:imageData];
                [_rightPhotoImageView setImage:image forState:UIControlStateNormal];
                
                [_rightPhotoImageView handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                    
                    [UIImageAvatarBrowser showImage:_rightPhotoImageView.imageView];
                }];               
                
                [_rightBubble mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.contentView.mas_right).offset(-50);
                        make.top.equalTo(self.contentView.mas_top).offset(10);
                        make.width.equalTo(@220);
                    make.height.equalTo(self.contentView.mas_height).offset(-20);
                }];
                
              
                [_rightPhotoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_rightBubble.mas_left);
                    make.top.equalTo(_rightBubble.mas_top);
                    make.bottom.equalTo(_rightBubble.mas_bottom);
                    make.right.equalTo(_rightBubble.mas_right).offset(-5);
                }];
        }
            else {
                
                // 语音
                if (model.isVoice) {
                    self.lefeVoice.hidden = YES;
                    self.rightVoice.hidden = NO;

                    self.leftPhotoImageView.hidden = YES;
                    self.rightPhotoImageView.hidden = YES;
                    
                    self.leftVoiceButton.hidden = YES;
                    self.rightVoiceButton.hidden = NO;

                    int w = (WIDTH / 60) * model.voiceDuration;
                    
                    [_rightVoiceButton setTitle:[NSString stringWithFormat:@"%d's", model.voiceDuration] forState:UIControlStateNormal];
                    
                    [_rightVoiceButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        _i = 0;
                        [self.rightVoice startAnimating];
                        [self playVoiceWithPath:model.localVoicePath];
                    }];
                    
                    [_rightBubble mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.contentView.mas_right).offset(-50);
                        make.top.equalTo(self.contentView.mas_top).offset(10);
                        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
                        make.width.equalTo(@(120 + w));
                    }];
                    [_rightVoiceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(_rightBubble.mas_left);
                        make.height.equalTo(_rightBubble.mas_height);
                        make.top.equalTo(_rightBubble.mas_top);
                        make.width.equalTo(@(100 + w));
                    }];
                    
                } else {
                    // 文字
                    self.lefeVoice.hidden = YES;
                    self.rightVoice.hidden = YES;
                    self.leftPhotoImageView.hidden = YES;
                    self.rightPhotoImageView.hidden = YES;
                    self.leftVoiceButton.hidden = YES;
                    self.rightVoiceButton.hidden = YES;
                    //调整坐标 根据label文字自适应
                    [_rightBubble mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(self.contentView.mas_right).offset(-50);
                        make.top.equalTo(self.contentView.mas_top).offset(10);
                        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
                        make.width.equalTo(@(size.width + 30));
                    }];
                    
                }
                
            }
            
            self.rightLabel.text = model.context;
            self.rightName.text = model.fromUser;
            self.rightTimeLabel.text = [NSData intervalSinceNow:model.time];

        }else{
            
            //只显示左侧气泡
            self.leftBubble.hidden = NO;
            self.rightBubble.hidden = YES;
            self.leftIconImageView.hidden = NO;
            self.rightIconImageView.hidden = YES;
            self.leftName.hidden = NO;
            self.rightName.hidden = YES;
            self.leftTimeLabel.hidden = NO;
            self.rightTimeLabel.hidden = YES;
            
            // 图片
            if (model.isPhoto) {
                self.lefeVoice.hidden = YES;
                self.rightVoice.hidden = YES;
                self.leftPhotoImageView.hidden = NO;
                self.rightPhotoImageView.hidden = YES;
                self.leftVoiceButton.hidden = YES;
                self.rightVoiceButton.hidden = YES;
                NSURL *url = [NSURL URLWithString:model.photoName];
                NSData *imageData = [NSData dataWithContentsOfURL:url];
                UIImage *image = [UIImage imageWithData:imageData];
                [_leftPhotoImageView setImage:image forState:UIControlStateNormal];
                
                [_leftPhotoImageView handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                    
                    [UIImageAvatarBrowser showImage:_leftPhotoImageView.imageView];
                }];
                
                [_leftBubble mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.contentView.mas_left).offset(50);
                        make.top.equalTo(self.contentView.mas_top).offset(10);
                        make.width.equalTo(@220);
//                        make.height.equalTo(@(model.height * 220 / model.width));
                    make.height.equalTo(self.contentView.mas_height).offset(-20);
                }];

               
                [_leftPhotoImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(_leftBubble.mas_left).offset(5);
                    make.top.equalTo(_leftBubble.mas_top);
                    make.right.equalTo(_leftBubble.mas_right);
                    make.bottom.equalTo(_leftBubble.mas_bottom);
                }];

                
                
            } else {
                
                // 语音
                if (model.isVoice) {
                    self.lefeVoice.hidden = NO;
                    self.rightVoice.hidden = YES;

                    self.leftPhotoImageView.hidden = YES;
                    self.rightPhotoImageView.hidden = YES;
                    
                    self.leftVoiceButton.hidden = NO;
                    self.rightVoiceButton.hidden = YES;
                    
                    int w = (WIDTH / 60) * model.voiceDuration;
                    
                    [_leftVoiceButton setTitle:[NSString stringWithFormat:@"%d's", model.voiceDuration] forState:UIControlStateNormal];
                    
                    [_leftVoiceButton handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                        _i = 0;
                        [self.lefeVoice startAnimating];
                        [self playVoiceWithPath:model.localVoicePath];
                    }];
                    
                    [_leftBubble mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.contentView.mas_left).offset(50);
                        make.top.equalTo(self.contentView.mas_top).offset(10);
                        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
                        make.width.equalTo(@(120 + w));
                    }];
                    
                    
                    [_leftVoiceButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.right.equalTo(_leftBubble.mas_right).offset(-10);
                        make.height.equalTo(_leftBubble.mas_height);
                        make.top.equalTo(_leftBubble.mas_top);
                        make.width.equalTo(@(100 + w));
                    }];
                    
                } else {
                    // 文字
                    self.lefeVoice.hidden = YES;
                    self.rightVoice.hidden = YES;
                    self.leftVoiceButton.hidden = YES;
                    self.rightVoiceButton.hidden = YES;
                    self.leftPhotoImageView.hidden = YES;
                    self.rightPhotoImageView.hidden = YES;

                    [_leftBubble mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(self.contentView.mas_left).offset(50);
                        make.top.equalTo(self.contentView.mas_top).offset(10);
                        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
                        make.width.equalTo(@(size.width + 30));
                    }];
                }
            }
            self.leftLabel.text = model.context;
            self.leftName.text = model.fromUser;
            self.leftTimeLabel.text = [NSData intervalSinceNow:model.time];
        }
        
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_leftIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.height.equalTo(@40);
    }];
    
    [_rightIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.top.equalTo(self.contentView.mas_top).offset(5);
        make.width.height.equalTo(@40);
    }];
    
    [_leftName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_leftIconImageView.mas_bottom).offset(2);
        make.centerX.equalTo(_leftIconImageView.mas_centerX);
        make.width.equalTo(_leftIconImageView.mas_width);
    }];
    
    [_rightName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rightIconImageView.mas_bottom).offset(2);
        make.centerX.equalTo(_rightIconImageView.mas_centerX);
        make.width.equalTo(_rightIconImageView.mas_width);
    }];
    
    [_rightVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_rightBubble.mas_right).offset(-15);
        make.top.equalTo(_rightBubble.mas_top).offset(10);
        make.width.height.equalTo(@25);
    }];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_rightBubble.mas_left);
        make.top.equalTo(_rightBubble.mas_top);
        make.centerY.equalTo(_rightBubble.mas_centerY);
        make.right.equalTo(_rightBubble.mas_right);
    }];
    
    [_lefeVoice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBubble.mas_left).offset(15);
        make.top.equalTo(_leftBubble.mas_top).offset(10);
        make.width.height.equalTo(@25);
    }];
    
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftBubble.mas_left).offset(5);
        make.top.equalTo(_leftBubble.mas_top).offset(5);
        make.centerY.equalTo(_leftBubble.mas_centerY);
        make.right.equalTo(_leftBubble.mas_right).offset(-10);
    }];
    
    [_leftTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_leftBubble.mas_centerX).offset(0);
        make.top.equalTo(_leftBubble.mas_bottom).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@10);
    }];
    
    [_rightTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_rightBubble.mas_centerX).offset(0);
        make.top.equalTo(_rightBubble.mas_bottom).offset(0);
        make.width.equalTo(@100);
        make.height.equalTo(@10);
    }];
    
    if (_change == YES) {
        _rightImageChange = [UIImage imageNamed:@"SenderTextNodeBkg"];
    }else {
        _rightImageChange = [UIImage imageNamed:@"chatto_bg_normal"];
    }
    
    
    
}

- (void)prepareForReuse {
    if (_change == YES) {
        _rightImageChange = [UIImage imageNamed:@"SenderTextNodeBkg"];
    }else {
        _rightImageChange = [UIImage imageNamed:@"chatto_bg_normal"];
    }
}

- (void)AVAudioPlayerDidFinishPlay {
    [self.audioPlayer stop];
    [self.lefeVoice stopAnimating];
    [self.rightVoice stopAnimating];
}


//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)playVoiceWithPath:(NSString *)voicePath {
    
        NSData *data = [NSData dataWithContentsOfFile:voicePath];
        NSError *error = nil;
        // 初始化音频播放器
        self.audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    if (_audioPlayer.isPlaying) {
        [_audioPlayer stop];
    }
        if (error) {
            NSLog(@"error : %@", error);
        }
        [self.audioPlayer setVolume:1];
        // 设置循环播放 0 -> 语音只会播放一次
        [self.audioPlayer setNumberOfLoops:0];
        [self.audioPlayer prepareToPlay];
        [self.audioPlayer play];
         self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(change) userInfo:nil repeats:YES];


}

- (void)change {
    
    self.i += 0.1;
    
        if (_i > (float)_model.voiceDuration) {
        //清除定时器
        if (![_audioPlayer isPlaying]) {
            [self.timer invalidate];
            [self AVAudioPlayerDidFinishPlay];

        }
    
    }
}
 
+ (CGFloat)getImageHeight:(NSString *)imageName withWidth:(CGFloat)width{
    NSURL *imageURL = [NSURL URLWithString:imageName];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageURL]];
    CGFloat imageHeight = image.size.height / image.size.width * width;
    return imageHeight;
}

@end
