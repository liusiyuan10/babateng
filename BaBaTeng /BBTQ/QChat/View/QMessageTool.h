//
//  QMessageTool.h
//  BaBaTeng
//
//  Created by xyj on 2018/5/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QMessageTool : UIView
//
//@end


#import <UIKit/UIKit.h>


@class QMessageTool;
@protocol QMessageToolDelegate <NSObject>


/**
 *  发送消息
 *
 *  @param chatBox     chatBox
 *  @param textMessage 消息
 */
- (void)chatBox:(QMessageTool *)chatBox sendTextMessage:(NSString *)textMessage;

@end


@interface QMessageTool : UIView



@property (nonatomic, weak) id<QMessageToolDelegate>delegate;

/** 输入框 */
@property (nonatomic, strong) UITextView *textView;


@end
