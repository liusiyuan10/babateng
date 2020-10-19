//
//  KnowledgeListDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/4.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KnowledgeListDataModel : NSObject

//createTime    获取时间    string    @mock=$order('2019-02-28 14:53:53','2019-02-25 16:54:08','2019-02-22 15:57:53','2019-02-22 15:33:54','2019-02-22 11:29:56')
//getScoreValue    知识豆    number    @mock=$order(1,2,3,2,1)
//getWay    获取方式    number    @mock=$order(5,3,2,1,4)
//itemName    获取名称    string    @mock=$order('日常领取','邀请好友','关注微信公众号','签到获得','实名认证')
//recordId    主键    number    @mock=$order(6,4,3,2,1)
//relatedId    关联编号    number    @mock=$order(1,1,1,1,1)
//userId    用户编号
@property (nonatomic, copy) NSString *createTime;
//@property (nonatomic, copy) NSString *getScoreValue;
@property (nonatomic, assign) CGFloat getScoreValue;
@property (nonatomic, copy) NSString *getTaskValue;
@property (nonatomic, copy) NSString *getWay;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *recordId;
@property (nonatomic, copy) NSString *relatedId;
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
