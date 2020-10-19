//
//  HDMyFriendModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/5/14.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HDMyFriendDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HDMyFriendModel : NSObject

@property (nonatomic, strong) HDMyFriendDataModel *data;

/***
 *价格
 */
@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@end

NS_ASSUME_NONNULL_END
