//
//  BeansListDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BeansListDataModel : NSObject

//createTime    创建时间    string    @mock=$order('2019-03-05 16:01:31','2019-03-05 16:01:11','2019-03-05 16:01:07')
//produceId    编号    number    @mock=$order(319,318,317)
//producePeasValue    英豆数量    number    @mock=$order(20,30,20)
//produceWay    2：英豆释放    number    @mock=$order(2,2,2)
//status    0：待领取，1：已领取，2：已过期未领取    number    @mock=$order(-1,1,0)
//userId


@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *produceId;
//@property (nonatomic, copy) NSString *produceScoreValue;
@property (nonatomic, assign) CGFloat produceScoreValue;
//@property (nonatomic, copy) NSString *peasValue;
@property (nonatomic, assign) CGFloat peasValue;

@property (nonatomic, copy) NSString *produceWay;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
