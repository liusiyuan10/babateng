//
//  NSString+MD5String.m
//  MD5~~
//
//  Created by 阳光 on 16/6/23.
//  Copyright © 2016年 com_qibei. All rights reserved.
//

#import "NSString+MD5String.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5String)

// 一般加密
+(NSString *)md5String:(NSString *)str
{
    const char *password=[str UTF8String];
    unsigned char mdc[16];
    CC_MD5(password,(CC_LONG)strlen(password),mdc);
    NSMutableString *md5String=[NSMutableString string];
    for (int i=0;i<16;i++)
    {
        [md5String appendFormat:@"%02x",mdc[i]];
    }
    return md5String;
}

+(NSString *)md5StringBest:(NSString *)str
{
    const char *password=[str UTF8String];
    unsigned char mdc[16];
    CC_MD5(password,(CC_LONG)strlen(password),mdc);
    NSMutableString *md5String=[NSMutableString string];
    for (int i=0;i<16;i++)
    {
        [md5String appendFormat:@"%02x",mdc[i]^mdc[0]];
    }
    return md5String;
}

@end
