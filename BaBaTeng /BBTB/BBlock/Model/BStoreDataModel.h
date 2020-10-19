//
//  BStoreDataModel.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/8/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface BStoreDataModel : NSObject<MJKeyValue>



@property(nonatomic, copy) NSString *endRow;
@property(nonatomic, copy) NSString *firstPage;
@property(nonatomic, copy) NSString *hasNextPage;
@property(nonatomic, copy) NSString *hasPreviousPage;

@property(nonatomic, copy) NSString *isFirstPage;
@property(nonatomic, copy) NSString *isLastPage;
@property(nonatomic, copy) NSString *lastPage;

@property(nonatomic, strong) NSArray *list;

@property(nonatomic, copy) NSString *navigatePages;
@property(nonatomic, copy) NSString *navigatepageNums;
@property(nonatomic, copy) NSString *nextPage;
@property(nonatomic, copy) NSString *orderBy;

@property(nonatomic, copy) NSString *pageNum;
@property(nonatomic, copy) NSString *pageSize;
@property(nonatomic, copy) NSString *pages;
@property(nonatomic, copy) NSString *prePage;

@property(nonatomic, copy) NSString *size;
@property(nonatomic, copy) NSString *startRow;
@property(nonatomic, copy) NSString *total;


@end
