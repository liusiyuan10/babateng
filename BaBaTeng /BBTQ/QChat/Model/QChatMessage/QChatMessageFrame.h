//
//  QTalkFrame.h
//  BaBaTeng
//
//  Created by liu on 17/5/19.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import <Foundation/Foundation.h>
//
//@interface QTalkFrame : NSObject
//
//@end


#import <UIKit/UIKit.h>

#define CZFONTSIZE 15

@class QChatMessage;

@interface QChatMessageFrame : NSObject

@property(nonatomic, assign, readonly)CGRect timeFrame;
@property(nonatomic, assign, readonly)CGRect iconFrame;
@property(nonatomic, assign, readonly)CGRect textFrame;
@property(nonatomic, assign, readonly)CGRect nameFrame;
@property(nonatomic, assign, readonly)CGRect errorFrame;

@property(nonatomic, assign, readonly)CGFloat rowHeight;

@property(nonatomic, strong)QChatMessage *message;



@end
