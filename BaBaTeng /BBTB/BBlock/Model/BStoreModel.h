//
//  BStoreModel.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/8/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BStoreDataModel.h"

@interface BStoreModel : NSObject

@property(nonatomic, copy) NSString *message;

@property(nonatomic, copy) NSString *statusCode;

@property(nonatomic, strong) BStoreDataModel *data;

@end
