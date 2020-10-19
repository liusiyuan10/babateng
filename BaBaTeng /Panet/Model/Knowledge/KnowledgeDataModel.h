//
//  KnowledgeDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/4.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KnowledgeInfoModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface KnowledgeDataModel : NSObject

//pageInfo
//scoreValue = 0;
//taskValue = 33;

@property (nonatomic, strong) KnowledgeInfoModel *pageInfo;

/***
 *价格
 */
//@property (nonatomic, copy) NSString *scoreValue;

@property (nonatomic, assign) CGFloat scoreValue;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *taskValue;

@property (nonatomic, assign) CGFloat circulateScore;

@property (nonatomic, assign) CGFloat lockedScore;

@end

NS_ASSUME_NONNULL_END
