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
   QChatMessageSelf,
   QChatMessageOther
} QChatMessageType;

@interface QChatMessage : NSObject

// 聊天内容
@property(nonatomic, strong) NSString *text;

// 聊天时间
@property(nonatomic, strong) NSString *time;

// 录音文件
@property(nonatomic, strong) NSString *voiceUrl;

// 用户昵称
@property(nonatomic, strong) NSString *nickName;

// 用户头像URL
@property(nonatomic, strong) NSString *userIcon;

// 聊天类型
@property(nonatomic, strong) NSString *recordType;

// 是否发送成功
@property(nonatomic, strong) NSString *IsSend;

// 是否正发送中
@property(nonatomic, strong) NSString *IsSendDing;

@property(nonatomic, assign) QChatMessageType type;

// 是否隐藏时间
@property(nonatomic, assign, getter=isHiddenTime) BOOL hiddenTime;


@end
