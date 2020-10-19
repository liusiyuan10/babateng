//
//  QNewSongDetailsData.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/9/4.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"
@interface QNewSongDetailsData : NSObject

@property (nonatomic, copy) NSString *pages;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, strong) NSMutableArray  *list;


@end
