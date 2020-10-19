//
//  TwoCurrencyListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TwoCurrencyListModel : NSObject

//createTime    解锁时间    string    @mock=2019-04-08 15:32:22
//reaateRate    解锁比例    number    @mock=5
//rebateValue    解锁数量    number    @mock=10
//recordId    记录编号    number    @mock=1
//userId    用户编号

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) CGFloat reaateRate;
@property (nonatomic, assign) CGFloat rebateValue;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
