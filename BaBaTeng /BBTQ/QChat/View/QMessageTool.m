//
//  QMessageTool.m
//  BaBaTeng
//
//  Created by xyj on 2018/5/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//#import "QMessageTool.h"
//
//@implementation QMessageTool
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end


#import "QMessageTool.h"
#import "UIImage+Extension.h"
#import "Header.h"
#import <AVFoundation/AVFoundation.h>
@interface QMessageTool ()<UITextViewDelegate>

/** chotBox的顶部边线 */
@property (nonatomic, strong) UIView *topLine;


/** 按住说话 */
@property (nonatomic, strong) UIButton *talkButton;

/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;

/** 定时器 **/
@property (nonatomic, strong) NSTimer *talktimer;

@end

@implementation QMessageTool


- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //        [self setBackgroundColor:IColor(241, 241, 248)];
        [self addSubview:self.topLine];
        
        [self addSubview:self.textView];

        [self addSubview:self.sendButton];
    }
    return self;
}


#pragma mark - Getter and Setter

- (UIView *) topLine
{
    if (_topLine == nil) {
        _topLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [_topLine setBackgroundColor:[UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]];
    }
    return _topLine;
}



- (UITextView *) textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(10,self.height * 0.13, kDeviceWidth - 80, HEIGHT_TEXTVIEW)];
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
        [_textView.layer setMasksToBounds:YES];
        [_textView.layer setCornerRadius:4.0f];
        [_textView.layer setBorderWidth:0.5f];
        [_textView.layer setBorderColor:self.topLine.backgroundColor.CGColor];
        [_textView setScrollsToTop:NO];
        [_textView setReturnKeyType:UIReturnKeySend];
        [_textView setDelegate:self];
    }
    return _textView;
}

- (UIButton *)sendButton
{
    if (_sendButton == nil) {
        
        _sendButton = [[UIButton alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_textView.frame) + 10, self.height * 0.13, 50, HEIGHT_TEXTVIEW)];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];

        [_sendButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

        [_sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        
        [_sendButton addTarget:self action:@selector(sendButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//        [_sendButton.layer setMasksToBounds:YES];
//        [_sendButton.layer setCornerRadius:4.0f];
//        [_sendButton.layer setBorderWidth:0.5f];
        
    }
    
    return _sendButton;
}

#pragma mark - UITextViewDelegate

- (void) textViewDidBeginEditing:(UITextView *)textView
{
//    self.status = ICChatBoxStatusShowKeyboard;
}

- (void) textViewDidChange:(UITextView *)textView
{
    //    CGFloat height = [textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)].height;
    if (textView.text.length > 200) { // 限制5000字内
        textView.text = [textView.text substringToIndex:200];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        if (self.textView.text.length > 0) {     // send Text
            
            if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
                [_delegate chatBox:self sendTextMessage:self.textView.text];
            }
            //            }
        }
        [self.textView setText:@""];
        return NO;
    }
    return YES;
}


- (void)sendButtonClicked
{
    if (self.textView.text.length > 0) {     // send Text
        
        if (_delegate && [_delegate respondsToSelector:@selector(chatBox:sendTextMessage:)]) {
            [_delegate chatBox:self sendTextMessage:self.textView.text];
        }
       
    }
}

#pragma mark - Public Methods

- (BOOL)resignFirstResponder
{
    [self.textView resignFirstResponder];
    return [super resignFirstResponder];
}


- (void)dealloc
{
    
}


@end
