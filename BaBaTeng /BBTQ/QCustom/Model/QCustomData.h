//
//  QCustomData.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QplayType;
@interface QCustomData : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *listId;
@property (nonatomic, strong) QplayType *playType;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, strong) NSMutableArray *tracks;

@end
