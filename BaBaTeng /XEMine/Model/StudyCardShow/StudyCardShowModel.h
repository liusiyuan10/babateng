//
//  StudyCardShowModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/11/14.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudyCardShowDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface StudyCardShowModel : NSObject

@property (nonatomic, strong) StudyCardShowDataModel *data;

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
