//
//  MyButton.h
//  拉手团购网
//
//  Created by a a a a a on 13-10-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyButton : UIButton
@property(nonatomic,strong) UIImageView *selerListImage;
@property(nonatomic,assign)NSInteger type;
-(UIButton*)initWithimage:(NSString*)normalImage heighlightImage:(NSString*)heighImage title:(NSString *)title frame:(CGRect)frame type:(NSInteger)newType;
-(UIButton *)initWithimage:(NSString *)normalImage heighlightImage:(NSString *)heighImage frame:(CGRect)frame;
-(UIButton*)initWithImage:(NSString*)image title:(NSString*)title frame:(CGRect)frame type:(NSString*)newType;


-(UIButton*)initWithImage111:(NSString *)image title:(NSString *)title frame:(CGRect)frame type:(NSString*)newType;

-(UIButton*)initWithImageEnglishStudentStyle:(NSString *)image title:(NSString *)title Subtitle:(NSString *)subtitle frame:(CGRect)frame type:(NSString*)newType;


-(UIButton*)initWithImage:(NSString*)image title:(NSString*)title subtitle:(NSString*)subtitle promotionPrice:(NSString*)promotionPrice price:(NSString*)price frame:(CGRect)frame ifsell:(NSString *)sell;

-(UIButton*)initWithShareImage:(NSString*)image title:(NSString*)title subtitle:(NSString*)subtitle frame:(CGRect)frame;

-(UIButton*)initWithImage1:(NSString*)image title:(NSString*)title frame:(CGRect)frame type:(NSInteger)newType;

-(UIButton*)initWithButtonTitle:(NSString *)buttonTitle ButtonBackgroundImage:(NSString *)buttonImage frame:(CGRect)frame;
-(UIButton*)initWithTitle:(NSString*)title Money:(NSString*)money frame:(CGRect)frame type:(NSInteger)newType;

-(UIButton*)initWithMyButtonTitle:(NSString *)buttonTitle ButtonBackgroundImage:(NSString *)buttonImage frame:(CGRect)frame;
-(UIButton*)initWithTitle1:(NSString *)title Money:(NSString *)money frame:(CGRect)frame type:(NSInteger)newType;

/**
 *  为图片的顶边添加一条线
 */
- (void)addTopLine:(BOOL)ifLine;
@end
