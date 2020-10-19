//
//  CustomAlertView.h
//  AlertViewDemo
//
//  Created by apple on 17/2/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AlertResult)(NSInteger titleBtnTag,NSInteger alertViewTag);

@interface BBTQAlertView : UIView
-(instancetype)initWithTitle:(NSString*)title andWithMassage:(NSString*)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(instancetype)initWithBBTTitle:(NSString*)title andWithMassage:(NSString*)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(instancetype)initWithBBTupgradeTitle:(NSString*)title andWithMassage:(NSString*)massage andWithTwoMassage:(NSString *)massaageSecond andWithTag:(NSInteger)tag andWithButtonTitle:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

- (instancetype)initWithImage:(NSString *)image andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(instancetype)initWithOneBBTTitle:(NSString *)title andWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)oneButtonTitle;

-(instancetype)initWithOneMassage:(NSString *)OneMassage andWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)oneButtonTitle;

-(instancetype)initWithOneMassage:(NSString *)OneMassage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)oneButtonTitle;

//配网失败
- (instancetype)initWithNetImage:(NSString *)image andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)oneButtonTitle;

//同步英语
-(instancetype)initWithSYNCBBTTitle:(NSString *)title andWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

-(instancetype)initWithRMRZWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

#pragma mark －－展示alertview
-(void)showInView:(UIView *)view;

#pragma mark －－设置标题文字颜色
-(void)setTitleTextColorr:(UIColor *)textColor;

#pragma mark －－设置信息文字颜色
-(void)setMassageTextColor:(UIColor *)textColor;

#pragma mark －－设置背景颜色
-(void)setAlertViewBgColor:(UIColor*)bgColor;

#pragma mark －－设置按钮背景颜色－－设置按钮文字颜色
-(void)setTitleBtnWithBgColor:(UIColor *)bgColor andWithtitleColor:(UIColor *)titleColor atBtnTag:(NSInteger)tag;

@property(nonatomic,copy)AlertResult resultIndex;
@end
