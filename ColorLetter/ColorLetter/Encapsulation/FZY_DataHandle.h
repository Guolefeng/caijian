//
//  FZY_DataHandle.h
//  ColorLetter
//
//  Created by dllo on 16/10/31.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FZY_User;

@interface FZY_DataHandle : NSObject

+ (FZY_DataHandle *)shareDatahandle;

- (void)open;
- (void)inset:(NSString *)name imageUrl:(NSString *)imageUrl userId:(NSString *)userId;
- (void)insert:(FZY_User *)user;
- (void)deleteAll;
- (void)update:(NSString *)old new:(NSString *)newUrl;
- (NSArray *)select:(FZY_User *)user;


@end
