//
//  PanetKnIntelDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/3.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanetKnIntelDataModel : NSObject

//createTime    创建时间    number
//produceId    编号    number
//producePeasValue    英豆数量    number
//produceScoreValue    知识豆数量    number
//produceWay    产生方式    number    1表示知识豆，2表示英豆
//status    状态    number    0表示未收，1表示已收
//userId    用户编号    string
//vaildTime

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *produceId;
//@property (nonatomic, copy) NSString *producePeasValue;
//@property (nonatomic, copy) NSString *produceScoreValue;
@property (nonatomic, assign) CGFloat produceScoreValue;

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *vaildTime;

@end

NS_ASSUME_NONNULL_END
