//
//  TerminologyTool.h
//  mTrackCargo
//
//  Created by liu on 16/6/17.
//  Copyright © 2016年 com.alphastark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"

@interface MessageTool : NSObject

- (void)insertMessageArr:(NSMutableArray *)modelarr;//插入数据库
- (void)updateMessage:(NSString*)sql;//修改数据库
- (NSMutableArray *)selectAllModel:(NSString*)sql;//查询数据库


- (NSMutableArray *)selectWithTermName:(NSString *)TerName;
- (NSString *)selectLatTimeStr;

@end
