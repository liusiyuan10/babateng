//
//  GoodCategoryDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/6/19.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodCategoryDataModel : NSObject


@property (nonatomic, copy) NSString *categoryIcon;
@property (nonatomic, copy) NSString *categoryId;
@property (nonatomic, copy) NSString *categoryLevel;
@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, copy) NSString *delFlag;

@end

NS_ASSUME_NONNULL_END
