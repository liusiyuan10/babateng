//
//  GetIntelligenceDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/4.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetIntelligenceDataModel : NSObject

//finished    是否完成    boolean    @mock=$order(false,true,true,true)
//scoreValue    获得知识豆    number    @mock=$order(0,10,0,0)
//taskName    任务名称    string    @mock=$order('今日签到','关注公众号','邀请好友','实名认证')
//taskValue    获取智力


@property (nonatomic, copy) NSString *finished;

@property (nonatomic, copy) NSString *scoreValue;

@property (nonatomic, copy) NSString *taskName;

@property (nonatomic, copy) NSString *taskValue;
@end

NS_ASSUME_NONNULL_END
