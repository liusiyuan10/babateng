//
//  QMessageData.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QFamily,QinvitationStatus,Qreceiver,Qsender;
@interface QMessageData : NSObject

@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *pages;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *publishTime;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userId;

//以下是家人邀请详情数据结构
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, strong) QFamily *family;
@property(nonatomic, copy)   NSString * familyId;
@property(nonatomic, copy)   NSString * invitationId;
@property(nonatomic, copy)   NSString * invitationMessage;
@property(nonatomic, strong) QinvitationStatus *invitationStatus;
@property(nonatomic, strong) Qreceiver *receiver;
@property(nonatomic, copy)   NSString * receiverId;
@property(nonatomic, strong) Qsender *sender;
@property(nonatomic, copy)   NSString * senderId;











@end
