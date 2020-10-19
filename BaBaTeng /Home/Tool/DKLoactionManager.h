//
//  DKLoactionManager.h
//  BaBaTeng
//
//  Created by xyj on 2019/11/16.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^LoactionBlock)(NSString *lat, NSString *lon);

NS_ASSUME_NONNULL_BEGIN

@interface DKLoactionManager : NSObject

//单利

+(instancetype)sharedManager;

-(void)getGPS:(LoactionBlock)block;

@end

NS_ASSUME_NONNULL_END

