//
//  QChatList.h
//  BaBaTeng
//
//  Created by liu on 17/8/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QChatFamilyMember.h"
#import "QChatRecordType.h"

@interface QChatList : NSObject

@property(nonatomic, copy) NSString * createTime;
@property(nonatomic, copy) NSString * familyId;
@property(nonatomic, strong) QChatFamilyMember *familyMember;
@property(nonatomic, copy) NSString * familyMemberId;
@property(nonatomic, copy) NSString * pictureUrl;
@property(nonatomic, copy) NSString * recordData;
@property(nonatomic, copy) NSString * recordId;
@property(nonatomic, strong) QChatRecordType * recordType;
@property(nonatomic, copy) NSString * voiceUrl;


@end
