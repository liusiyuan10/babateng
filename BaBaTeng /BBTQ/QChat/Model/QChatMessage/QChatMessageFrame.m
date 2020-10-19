//
//  QTalkFrame.m
//  BaBaTeng
//
//  Created by liu on 17/5/19.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import "QTalkFrame.h"
//
//@implementation QTalkFrame
//
//@end

#import "QChatMessageFrame.h"
#import "QChatMessage.h"
#import "NSString+Extension.h"
#import "Header.h"

@implementation QChatMessageFrame

- (void)setMessage:(QChatMessage *)message
{
    _message = message;
    
    CGFloat margin = 10;
    
    UIScreen *screen = [UIScreen mainScreen];
    
    // 时间的frame
    CGFloat timeW = screen.bounds.size.width;
    CGFloat timeH = 40;
    CGFloat timeX = 0;
    CGFloat timeY = 0;
    if (!message.hiddenTime) {
        
        _timeFrame = CGRectMake(timeX, timeY, timeW, timeH);
    }
    
    // 头像
    CGFloat iconW = 50;
    CGFloat iconH = 50;
    
    //用户名
    
    // 时间的frame
    CGFloat nameW = screen.bounds.size.width/2;
    CGFloat nameH = 20;
    CGFloat nameX;
    CGFloat nameY = CGRectGetMaxY(_timeFrame);
    
    if (message.type == QChatMessageSelf) {
 
        nameX = screen.bounds.size.width - iconW - margin - nameW - 10;
    }
    else{
        nameX = margin + iconW + 10;
      
    }

    _nameFrame = CGRectMake(nameX, nameY, nameW, nameH);

    CGFloat iconX;
    CGFloat iconY = CGRectGetMaxY(_timeFrame);
    
    if (message.type == QChatMessageSelf) {
        iconX = screen.bounds.size.width - iconW - margin;
    }
    else{
        iconX = margin;
    }
    _iconFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
    // 内容
    //    CGSize textSize = [self sizeWithText:message.text maxSize:CGSizeMake(250, MAXFLOAT) fontSize:CZFONTSIZE];
    
    CGSize textSize = [message.text sizeWithMaxSize:CGSizeMake(kDeviceWidth/320*180, MAXFLOAT) fontSize:CZFONTSIZE];
    
    
    CGSize buttonSize = CGSizeMake(textSize.width + 20 * 2, textSize.height + 20 *2);
    
    
    CGFloat textY = iconY + 20;
    CGFloat textX;
    if (message.type == QChatMessageSelf) {
        textX = iconX - margin - buttonSize.width;
    }
    else{
        textX = CGRectGetMaxX(_iconFrame) + margin;
    }
    
    _textFrame = (CGRect){{textX,textY}, buttonSize};
    
    CGFloat errorY = textY + (buttonSize.height - 30)/2.0;
    CGFloat errorX = textX -30;
    
    _errorFrame = CGRectMake(errorX, errorY, 30, 30);
    
    
    // 计算行高
    CGFloat iconMaxY = CGRectGetMaxY(_iconFrame);
    CGFloat textMaxY = CGRectGetMaxY(_textFrame);
    
    _rowHeight = MAX(iconMaxY, textMaxY) + margin;
    
}





@end
