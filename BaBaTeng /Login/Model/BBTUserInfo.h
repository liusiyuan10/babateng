//
//  BBTUserInfo.h
//  BaBaTeng
//
//  Created by liu on 17/6/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTUserInfo : NSObject

//accountStatus = 1;
//bindDeviceNumber = 0;
//createTime = "2017-06-06 14:45:17";
//nickName = "\U624b\U673a\U7528\U623718503051096";
//onlineStatus = 1;
//phoneNumber = 18503051096;
//token = "5cdde446-74b1-46b9-b4aa-72652d878a5c";
//userIcon = "";
//userId = 149673151696414636;

@property (nonatomic, copy) NSString *accountStatus;
@property (nonatomic, copy) NSString *bindDeviceNumber;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *onlineStatus;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userAddress;
//头像上传到七牛 新增的属性
@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *key;

//星球新增的属性
@property (nonatomic, copy) NSString  *intellectValue;

//@property (nonatomic, copy) CGFloat   scoreValue;
@property (nonatomic, assign) CGFloat   scoreValue;
@property (nonatomic, copy) NSString   *inviteCode;
//@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString   *etherAddress;
@property (nonatomic, assign) CGFloat   currencyValue;
@property (nonatomic, copy) NSString *agentUser;

@end
