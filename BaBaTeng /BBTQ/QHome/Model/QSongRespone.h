//
//  QSongRespone.h
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface QSongRespone : NSObject

@property (nonatomic, strong) NSString *totalCount;
@property (nonatomic, strong) NSString *page;
@property (nonatomic, strong) NSArray *tracks;
@property (nonatomic, strong) NSString *totalPage;

@end
