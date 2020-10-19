//
//  WalletDetailListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailListModel : NSObject

//changeType    变动类型 1:兑换商品，2充值，3，升级，4分成收益    number    @mock=1
//changeValue    积分值    number    @mock=1
//createTime    创建时间

//@property (nonatomic, copy) NSString *changeType;
//@property (nonatomic, assign) CGFloat changeValue;
//@property (nonatomic, copy) NSString *createTime;


@property (nonatomic, copy) NSString *awardMount;
@property (nonatomic, copy) NSString *awardType;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
