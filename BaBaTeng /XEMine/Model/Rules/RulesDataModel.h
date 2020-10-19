//
//  RulesDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RulesDataModel : NSObject

//rulesContent    规则内容    string    @mock=5555
//rulesId    规则编号    number    @mock=1
//rulesType    规则类型    number    @mock=1
//updateTime    更新时间
@property (nonatomic, copy) NSString *rulesContent;
@property (nonatomic, copy) NSString *rulesId;
@property (nonatomic, copy) NSString *rulesType;
@property (nonatomic, copy) NSString *updateTime;

@end

NS_ASSUME_NONNULL_END
