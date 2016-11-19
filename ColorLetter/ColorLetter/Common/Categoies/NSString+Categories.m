//
//  NSString+Categories.m
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "NSString+Categories.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Categories)

/**
 *  计算 MD5 值
 *
 *
 *
 *
 */
- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    return  output;
}

+ (BOOL)isEmpty:(NSString *)str trim:(BOOL)trim{
    if(str == nil || str.length == 0){
        return YES;
    }else{
        if(trim){
            return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0;
        }
    }
    return NO;
}

- (NSString *)urlEncode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}


@end
