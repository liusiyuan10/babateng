//
//  BeansDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeansModelDataPage.h"


NS_ASSUME_NONNULL_BEGIN

@interface BeansDataModel : NSObject

@property (nonatomic, strong) BeansModelDataPage *page;

/***
 *价格
 */
@property (nonatomic, copy) NSString *desc;

/***
 *是否成功
 */
//@property (nonatomic, copy) NSString *peaseValue;
@property (nonatomic, assign) CGFloat peaseValue;
@end

NS_ASSUME_NONNULL_END
