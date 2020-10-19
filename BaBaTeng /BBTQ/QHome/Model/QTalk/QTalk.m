//
//  QTalk.m
//  BaBaTeng
//
//  Created by liu on 17/5/19.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import "QTalk.h"
//
//@implementation QTalk
//
//@end


#import "QTalk.h"

@implementation QTalk

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)messageWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
    
}

+ (NSArray *)messages
{
    NSArray *array = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"messages.plist" ofType:nil]];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    QTalk *preMessage;
    for ( NSDictionary *dict in array) {
        
        QTalk *message = [QTalk messageWithDict:dict];
        
        if ([message.time isEqualToString:preMessage.time]) {
            message.hiddenTime = YES;
        }
        
        //        [arrayM addObject:[self messageWithDict:dict]];
        
        [arrayM addObject:message];
        
        preMessage = message;
    }
    
    return arrayM;
}
@end
