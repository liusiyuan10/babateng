//
//  FamilyDataList.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FamilyDevice,FamilyUser;
@interface FamilyDataList : NSObject

@property(nonatomic, copy) NSString *deviceId;
@property(nonatomic, copy) NSString *familyMemberId;
@property(nonatomic, copy) NSString *isAdmin;
@property(nonatomic, copy) NSString * isDevice;
@property(nonatomic, copy) NSString * isHost;
@property(nonatomic, copy) NSString * joinTime;
@property(nonatomic, copy) NSString * nickName;
@property(nonatomic, copy) NSString * userId;

@property(nonatomic, strong) FamilyDevice *device;
@property(nonatomic, strong) FamilyUser *user;
@end
