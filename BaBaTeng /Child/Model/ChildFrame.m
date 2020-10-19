//
//  ChildFrame.m
//  BaBaTeng
//
//  Created by xyj on 2018/5/13.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "ChildFrame.h"

#import "Header.h"



@implementation ChildFrame

- (void)setBulltindata:(BulletinData *)bulltindata
{
    _bulltindata = bulltindata;
    
//     [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 168)];
    CGFloat iconX = 0;
    CGFloat iconY = 0;
    CGFloat iconW = kDeviceWidth - 32;
    CGFloat iconH = 168;
    
    _iocnFrame = CGRectMake(iconX, iconY, iconW, iconH);
    
//    [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_iocnView.frame) + 8,kDeviceWidth - 32, 25)];
    
    CGFloat tilteX = 8;
    CGFloat tilteY = CGRectGetMaxY(_iocnFrame) + 8;
    CGFloat tilteW = kDeviceWidth - 32 - 16;
 
    CGSize tilteSize = [bulltindata.bulletinTitle sizeWithMaxSize:CGSizeMake(tilteW, MAXFLOAT) fontSize:18];
 
    
    _tilteFrame = (CGRect){{tilteX,tilteY},tilteSize};
//    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_tilteLabel.frame) + 6, kDeviceWidth - 32, 18)];
    CGFloat contentX = 8;
    CGFloat contentY = CGRectGetMaxY(_tilteFrame) + 8;
    CGFloat contentW = kDeviceWidth - 32 - 16;
    
    CGSize contentSize = [bulltindata.bulletinSummary sizeWithMaxSize:CGSizeMake(contentW, MAXFLOAT) fontSize:15];
    
    _contentFrame = (CGRect){{contentX,contentY},contentSize};
    
    _bgViewFrame = CGRectMake(0, 0, kDeviceWidth, CGRectGetMaxY(_contentFrame) + 16 + 8);
    
    _backViewFrame = CGRectMake(16, 16, kDeviceWidth - 32, CGRectGetMaxY(_contentFrame) + 8);
    
    _rowHeight = CGRectGetMaxY(_bgViewFrame);
    
    
    
    
    
    
    
    
    
}

@end
