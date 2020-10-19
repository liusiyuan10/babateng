//
//  HDMyFriendListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/5/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HDMyFriendListModel : NSObject


@property (nonatomic, copy) NSString *inviteUserId;
@property (nonatomic, copy) NSString *invitedBy;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *userCount;
@end

NS_ASSUME_NONNULL_END
