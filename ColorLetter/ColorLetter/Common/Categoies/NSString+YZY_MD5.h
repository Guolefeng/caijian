//
//  NSString+YZY_MD5.h
//  UI23_加密
//
//  Created by dllo on 16/9/9.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (YZY_MD5)

- (NSString *)yzy_stringByMD5Bit32;

- (NSString *)yzy_stringByMD5Bit32Uppercase;

- (NSString *)yzy_stringByMD5Bit16;

- (NSString *)yzy_stringByMD5Bit16Uppercase;

@end
