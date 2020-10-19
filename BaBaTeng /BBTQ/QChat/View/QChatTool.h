//
//  QChatTool.h
//  BaBaTeng
//
//  Created by liu on 17/8/15.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, ICChatBoxStatus) {
    ICChatBoxStatusNothing,     // 默认状态
    ICChatBoxStatusShowVoice,   // 录音状态
    ICChatBoxStatusShowFace,    // 输入表情状态
    ICChatBoxStatusShowMore,    // 显示“更多”页面状态
    ICChatBoxStatusShowKeyboard,// 正常键盘
    ICChatBoxStatusShowVideo    // 录制视频
};


@class QChatTool;
@protocol QChatToolDelegate <NSObject>


/**
 *  发送消息
 *
 *  @param chatBox     chatBox
 *  @param textMessage 消息
 */
- (void)chatBox:(QChatTool *)chatBox sendTextMessage:(NSString *)textMessage;


/**
 *  开始录音
 *
 *  @param chatBox chatBox
 */
- (void)chatBoxDidStartRecordingVoice:(QChatTool *)chatBox;
- (void)chatBoxDidStopRecordingVoice:(QChatTool *)chatBox;
- (void)chatBoxDidCancelRecordingVoice:(QChatTool *)chatBox;
- (void)chatBoxDidDrag:(BOOL)inside;


@end


@interface QChatTool : UIView

/** 保存状态 */
@property (nonatomic, assign) ICChatBoxStatus status;

@property (nonatomic, weak) id<QChatToolDelegate>delegate;

/** 输入框 */
@property (nonatomic, strong) UITextView *textView;

/** 录音按钮 */
@property (nonatomic, strong) UIButton *voiceButton;


@end
