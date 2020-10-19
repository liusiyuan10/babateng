//
//  QMessageDataList.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QDeviceNoticeType,QFamily,QinvitationStatus,Qreceiver,Qsender;
@interface QMessageDataList : NSObject

@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *publishTime;
@property(nonatomic, copy) NSString *systemNoticeId;
@property(nonatomic, copy) NSString *title;

@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *deviceNoticeContent;
@property(nonatomic, copy) NSString *deviceNoticeId;
@property(nonatomic, strong) QDeviceNoticeType *deviceNoticeType;
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
