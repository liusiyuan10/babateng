//
//  NSString+MD5String.h
//  MD5~~
//
//  Created by 阳光 on 16/6/23.
//  Copyright © 2016年 com_qibei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5String)

// 一般加密
+(NSString *)md5String:(NSString *)str;

+(NSString *)md5StringBest:(NSString *)str;

@end
