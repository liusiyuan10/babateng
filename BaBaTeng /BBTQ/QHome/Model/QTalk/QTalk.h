//
//  QTalk.h
//  BaBaTeng
//
//  Created by liu on 17/5/19.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//
//
//#import <Foundation/Foundation.h>
//
//@interface QTalk : NSObject
//
//@end


#import <Foundation/Foundation.h>

typedef enum{
   QTalkTypeSelf,
   QTalkTypeOther
}QTalkType;

@interface QTalk : NSObject
@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSString *time;
@property(nonatomic, strong) NSString *filePath;
@property(nonatomic, assign) QTalkType type;

// 是否隐藏时间
@property(nonatomic, assign, getter=isHiddenTime) BOOL hiddenTime;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)messageWithDict:(NSDictionary *)dict;
+ (NSArray *)messages;
@end
