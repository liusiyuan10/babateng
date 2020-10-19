//
//  Utility.h
//  xinlife
//
//  Created by qianxun on 13-8-6.
//  Copyright (c) 2013年 com.qianxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface
MyUtility : NSObject
 
 
+(BOOL) connectedToNetwork;
 
+(BOOL)isvalidateEmail:(NSString*)email;
+(BOOL)isValidateString:(NSString *)myString;


+ (NSString*)fileAvataPathWithID:(NSString *)ID;


+(NSString *)getCSSandJSGray;
+(NSString *)getCSSandJSWhite;

+(NSString *)getServer;

/**
 *将日期字符串格式化
 */
+(NSString *)getFormatDate:(NSString *) originalDate;


/**
 *用最简短的格式显示两个日期的间隔
 */
+(NSString *)getSimpleSpanWithBegin:(NSString *) begin end:(NSString *)end isTimeExist:(bool) isTimeExist;

 /**
  * 将普通View变为高大上的CardView
  */
+(void) convert2CardView:(UIView *)view withCornerRadius:(int) radius borderWidth:(float ) borderWidth;


+(void) convert2BorderView:(UIView *) view;

+(void) addLiteralShadow:(UIView *) view;
/**
 @method 获取指定宽度情况下，字符串value的size
 @param value 待计算的字符串
 @param fontSize 字体
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的size
 */
+(CGSize) rectForString:(NSString *)value font:(UIFont *) font andWidth:(float) width;
+ (float) heightForString:(NSString *)value andWidth:(float)width;
+ (float) heightForTextView: (UILabel *)label WithText: (NSString *) strText;

/**
 *缩放图片
 */
+(UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;
 
@end
