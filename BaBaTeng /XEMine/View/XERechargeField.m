//
//  XERechargeField.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/24.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XERechargeField.h"

@implementation XERechargeField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController*menuController = [UIMenuController sharedMenuController];
    if(menuController) {
        [UIMenuController sharedMenuController].menuVisible=NO;
    }
    return NO;
}

@end
