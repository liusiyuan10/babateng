//
//  QChatFamilyMember.h
//  BaBaTeng
//
//  Created by liu on 17/8/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QChatFamilyMemberDevice.h"
#import "QChatFamilyMemberUser.h"

@interface QChatFamilyMember : NSObject

@property(nonatomic, strong) QChatFamilyMemberDevice * device;
@property(nonatomic, copy) NSString * deviceId;
@property(nonatomic, copy) NSString * familyMemberId;
@property(nonatomic, copy) NSString * familyMemberIcon;
@property(nonatomic, copy) NSString * isAdmin;
@property(nonatomic, copy) NSString * isDevice;
@property(nonatomic, copy) NSString * isHost;
@property(nonatomic, copy) NSString * joinTime;
@property(nonatomic, copy) NSString * nickName;
@property(nonatomic, strong) QChatFamilyMemberUser * user;
@property(nonatomic, copy) NSString * userId;


@end
