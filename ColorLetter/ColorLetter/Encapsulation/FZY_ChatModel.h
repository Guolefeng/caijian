//
//  FZY_ChatModel.h
//  ColorLetter
//
//  Created by dllo on 16/10/27.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseModel.h"

@interface FZY_ChatModel : FZYBaseModel

@property (nonatomic, assign) long long time;
@property (nonatomic, assign) BOOL isSelf;
@property (nonatomic, copy) NSString *fromUser;

// 文字
@property (nonatomic, copy) NSString *context;

// 图片
@property (nonatomic, assign) BOOL isPhoto;
@property (nonatomic, copy) NSString *photoName;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) float height;


// 语音
@property (nonatomic, assign) BOOL isVoice;
@property (nonatomic, assign) int voiceDuration;
@property (nonatomic, copy) NSString *localVoicePath;
@property (nonatomic, copy) NSString *remoteVoicePath;



@end
