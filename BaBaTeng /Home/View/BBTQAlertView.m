//
//  CustomAlertView.m
//  AlertViewDemo
//
//  Created by apple on 17/2/11.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BBTQAlertView.h"


#define kScreen_Width  [[UIScreen mainScreen] bounds].size.width
#define kScreen_Height [[UIScreen mainScreen] bounds].size.height

#define kButtonHei 44 
#define kDistance 45

#define kTitleFont 17
#define kMassageFont 15
#define kBtnTitleFont  15
#define kBtnKwidth  15
#define kImageViewKwidth  15
#define kTitelHight  30

@interface BBTQAlertView (){
    UIView *_backgraoudView; //蒙板背景
    UIScrollView *_scrollView;
    UILabel *_titleLabel;
    UILabel *_massageLabel;
    UILabel *_TmassageLabel;
    UIView *_downView;
    UIView *_aletView;
    NSMutableArray *_titleBtnArray;

    
}
@end

@implementation BBTQAlertView
-(instancetype)initWithTitle:(NSString *)title andWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)otherButtonTitles, ...{
    self = [super init];
    if (self) {
         self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
         self.tag=tag;
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor blackColor];
        _backgraoudView.alpha = 0;
         [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        

        UIView *alertView = [[UIView alloc]init];
         alertView.backgroundColor = [UIColor whiteColor];
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
       
        //获取标题文字大小
        CGRect titleLabelRect = [self getStrimgRect:title andWithStringFontSize:kTitleFont andWithCurrentProlWitch:kScreen_Width-kDistance*2];
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 10, kScreen_Width-kDistance*2, titleLabelRect.size.height);
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
       // titleLabel.font = [UIFont systemFontOfSize:kTitleFont];
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kTitleFont]];
        [alertView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        //获取信息文字大小
        CGRect massageLabelRect = [self getStrimgRect:massage andWithStringFontSize:kMassageFont andWithCurrentProlWitch:kScreen_Width-kDistance*2];
        
        //信息内容
        UILabel *massageLabel = [[UILabel alloc]init];
        massageLabel.backgroundColor = [UIColor whiteColor];
        massageLabel.text = massage;
        massageLabel.numberOfLines = 0;
        massageLabel.font = [UIFont systemFontOfSize:kMassageFont];
        massageLabel.textAlignment = NSTextAlignmentCenter;
      
                massageLabel.frame =
            CGRectMake(0, CGRectGetMaxY(titleLabel.frame)+10, kScreen_Width-kDistance*2, massageLabelRect.size.height);
                if (massage == nil||[massage isEqualToString:@""]) {
                    massageLabel.frame =
                    CGRectMake(0, CGRectGetMaxY(titleLabel.frame), kScreen_Width-kDistance*2, 1);
                }

        [alertView addSubview:massageLabel];
        _massageLabel = massageLabel;
        
        
        //添加按钮
        va_list args;
        va_start(args, otherButtonTitles);
        NSMutableArray *buttonTitleArray = [NSMutableArray array];
        NSMutableString *allStr = [[NSMutableString alloc] initWithCapacity:16];
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
             [allStr appendFormat:@"%@,",str];
            [buttonTitleArray addObject:str];
        }
        
        //创建按钮
        //判断按钮是一个的时候
        if (buttonTitleArray.count == 1) {
            [_titleBtnArray removeAllObjects];
            UIButton *oneBtn = [[UIButton alloc]init];
            oneBtn.frame = CGRectMake(0, CGRectGetMaxY(massageLabel.frame)+15, massageLabel.frame.size.width ,kButtonHei);
            [oneBtn setTitle:buttonTitleArray[0] forState:(UIControlStateNormal)];
            [oneBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            oneBtn.backgroundColor = [UIColor whiteColor];
            oneBtn.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFont];
            [oneBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kBtnTitleFont]];
            oneBtn.tag = 0;
            [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [alertView addSubview:oneBtn];
           
            [oneBtn addSubview:[self getLineView:CGRectMake(0, 0, massageLabel.frame.size.width, 0.5)]];
             alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(oneBtn.frame));
            
            [_titleBtnArray addObject:oneBtn];
        }
        
    //判断按钮是两个的时候
       else if (buttonTitleArray.count == 2) {
             [_titleBtnArray removeAllObjects];
            CGRect oneBtnTitleRect = [self getStrimgRect:buttonTitleArray[0] andWithStringFontSize:kBtnTitleFont andWithCurrentProlWitch:massageLabel.frame.size.width];
            CGRect twoBtnTitleRect = [self getStrimgRect:buttonTitleArray[1] andWithStringFontSize:kBtnTitleFont andWithCurrentProlWitch:massageLabel.frame.size.width];
            
            UIButton *oneBtn = [[UIButton alloc]init];
            [oneBtn setTitle:buttonTitleArray[0] forState:(UIControlStateNormal)];
            [oneBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            oneBtn.backgroundColor = [UIColor whiteColor];
            oneBtn.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFont];
            [oneBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kBtnTitleFont]];
            oneBtn.tag = 0;
            [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
           [_titleBtnArray addObject:oneBtn];

            [alertView addSubview:oneBtn];
            [oneBtn addSubview:[self getLineView:CGRectMake(0, 0, massageLabel.frame.size.width, 0.5)]];
           
           
            UIButton *twoBtn = [[UIButton alloc]init];
            [twoBtn setTitle:buttonTitleArray[1] forState:(UIControlStateNormal)];
            [twoBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
            twoBtn.backgroundColor = [UIColor whiteColor];
            twoBtn.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFont];
            [twoBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kBtnTitleFont]];
            twoBtn.tag = 1;
            [twoBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
            [_titleBtnArray addObject:twoBtn];

            [alertView addSubview:twoBtn];
            [twoBtn addSubview:[self getLineView:CGRectMake(0, 0, massageLabel.frame.size.width, 0.5)]];
           
    
           //判断button文字长度
            if (oneBtnTitleRect.size.width>massageLabel.frame.size.width/2
                ||twoBtnTitleRect.size.width>massageLabel.frame.size.width/2) {
               
                    oneBtn.frame = CGRectMake(0, CGRectGetMaxY(massageLabel.frame)+15, massageLabel.frame.size.width ,kButtonHei);
                    twoBtn.frame = CGRectMake(0, CGRectGetMaxY(oneBtn.frame), massageLabel.frame.size.width ,kButtonHei);
            }else{
                    oneBtn.frame = CGRectMake(0, CGRectGetMaxY(massageLabel.frame)+15, massageLabel.frame.size.width/2,kButtonHei);
                    twoBtn.frame = CGRectMake(CGRectGetMaxX(oneBtn.frame), CGRectGetMaxY(massageLabel.frame)+15, massageLabel.frame.size.width /2,kButtonHei);
                [oneBtn addSubview:[self getLineView:CGRectMake(CGRectGetMaxX(oneBtn.frame)-0.5, 0, 0.5, oneBtn.frame.size.height)]];
            }
             alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(twoBtn.frame));
        }
        //判断按钮大于2个的时候
       else{
           [_titleBtnArray removeAllObjects];
           for (int i = 0; i<buttonTitleArray.count; i++) {
               UIButton *titleBtn = [[UIButton alloc]init];
               titleBtn.frame = CGRectMake(0, (i*kButtonHei)+CGRectGetMaxY(massageLabel.frame)+15, massageLabel.frame.size.width, kButtonHei);
               [titleBtn setTitle:buttonTitleArray[i] forState:(UIControlStateNormal)];
               [titleBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
               titleBtn.backgroundColor = [UIColor whiteColor];
               titleBtn.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFont];
               [titleBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kBtnTitleFont]];
               [titleBtn addSubview:[self getLineView:CGRectMake(0, 0, massageLabel.frame.size.width, 0.5)]];
               titleBtn.tag = i;
               [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
               [_titleBtnArray addObject:titleBtn];

               [alertView addSubview:titleBtn];
               alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(titleBtn.frame));
           }
       }
        _aletView = alertView;
    }

    return self;
}

-(instancetype)initWithBBTTitle:(NSString *)title andWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)otherButtonTitles, ...{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:235/255.0 alpha:1.0];;
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 20, kScreen_Width-kDistance*2, 15);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor orangeColor];
   
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
        [alertView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 16, Kdwidth - 20, 1.0)];
        
        lineView.backgroundColor = [UIColor orangeColor];
        
        [alertView addSubview: lineView];
        

        
        //信息内容
        UILabel *massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame) + 54, Kdwidth, 14)];
        massageLabel.backgroundColor = [UIColor clearColor];
        massageLabel.text = massage;
        massageLabel.numberOfLines = 0;
        massageLabel.font = [UIFont systemFontOfSize:15.0];
        massageLabel.textAlignment = NSTextAlignmentCenter;
        massageLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
        [alertView addSubview:massageLabel];
        _massageLabel = massageLabel;
        
        
        UIImageView *lineBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_massageLabel.frame) + 55, Kdwidth, 1.0)];
        
        lineBtnView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineBtnView];
        
        //添加按钮
        va_list args;
        va_start(args, otherButtonTitles);
        NSMutableArray *buttonTitleArray = [NSMutableArray array];
        NSMutableString *allStr = [[NSMutableString alloc] initWithCapacity:16];
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            [allStr appendFormat:@"%@,",str];
            [buttonTitleArray addObject:str];
        }
        

        [_titleBtnArray removeAllObjects];

        
        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(0, CGRectGetMaxY(lineBtnView.frame),  Kdwidth / 2.0 - 0.5, 50);
        
        [oneBtn setTitle:buttonTitleArray[0] forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        oneBtn.backgroundColor = [UIColor clearColor];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
 
        oneBtn.tag = 0;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:oneBtn];
        
        [alertView addSubview:oneBtn];

        
        UIImageView *lineMiddleView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oneBtn.frame), CGRectGetMaxY(lineBtnView.frame), 1, 50)];
        
        lineMiddleView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineMiddleView];
        
        UIButton *twoBtn = [[UIButton alloc]init];
        twoBtn.frame = CGRectMake( Kdwidth / 2.0 + 0.5, CGRectGetMaxY(lineBtnView.frame),  Kdwidth / 2.0 - 0.5, 50);
        [twoBtn setTitle:buttonTitleArray[1] forState:(UIControlStateNormal)];
        [twoBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        twoBtn.backgroundColor = [UIColor clearColor];
        twoBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];

        twoBtn.tag = 1;
        [twoBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:twoBtn];
        
        [alertView addSubview:twoBtn];
     
            
   
         alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(twoBtn.frame));
        
        _aletView = alertView;
    }
    
    return self;
}


-(instancetype)initWithSYNCBBTTitle:(NSString *)title andWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)otherButtonTitles, ...{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:235/255.0 alpha:1.0];;
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 20, kScreen_Width-kDistance*2, 15);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor orangeColor];
        
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
        [alertView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 16, Kdwidth - 20, 1.0)];
        
        lineView.backgroundColor = [UIColor orangeColor];
        
        [alertView addSubview: lineView];
        
        
        
        //信息内容
        UILabel *massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, CGRectGetMaxY(lineView.frame) +10, Kdwidth - 60, 50)];
//        UILabel *massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame) + 54, Kdwidth, 14)];
        massageLabel.backgroundColor = [UIColor clearColor];
        massageLabel.text = massage;
        massageLabel.numberOfLines = 0;
        massageLabel.font = [UIFont systemFontOfSize:15.0];
        massageLabel.textAlignment = NSTextAlignmentCenter;
        massageLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
        [alertView addSubview:massageLabel];
        _massageLabel = massageLabel;
        
        
        UIImageView *lineBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_massageLabel.frame) + 55, Kdwidth, 1.0)];
        
        lineBtnView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineBtnView];
        
        //添加按钮
        va_list args;
        va_start(args, otherButtonTitles);
        NSMutableArray *buttonTitleArray = [NSMutableArray array];
        NSMutableString *allStr = [[NSMutableString alloc] initWithCapacity:16];
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            [allStr appendFormat:@"%@,",str];
            [buttonTitleArray addObject:str];
        }
        
        
        [_titleBtnArray removeAllObjects];
        
        
        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(0, CGRectGetMaxY(lineBtnView.frame),  Kdwidth / 2.0 - 0.5, 50);
        
        [oneBtn setTitle:buttonTitleArray[0] forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        oneBtn.backgroundColor = [UIColor clearColor];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        oneBtn.tag = 0;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:oneBtn];
        
        [alertView addSubview:oneBtn];
        
        
        UIImageView *lineMiddleView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oneBtn.frame), CGRectGetMaxY(lineBtnView.frame), 1, 50)];
        
        lineMiddleView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineMiddleView];
        
        UIButton *twoBtn = [[UIButton alloc]init];
        twoBtn.frame = CGRectMake( Kdwidth / 2.0 + 0.5, CGRectGetMaxY(lineBtnView.frame),  Kdwidth / 2.0 - 0.5, 50);
        [twoBtn setTitle:buttonTitleArray[1] forState:(UIControlStateNormal)];
        [twoBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        twoBtn.backgroundColor = [UIColor clearColor];
        twoBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        twoBtn.tag = 1;
        [twoBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:twoBtn];
        
        [alertView addSubview:twoBtn];
        
        
        
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(twoBtn.frame));
        
        _aletView = alertView;
    }
    
    return self;
}

//实名认证
-(instancetype)initWithRMRZWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)otherButtonTitles, ...
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;
        
        
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor whiteColor];
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        
        //信息内容
        UILabel *massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 50, Kdwidth - 60, 50)];
        //        UILabel *massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame) + 54, Kdwidth, 14)];
        massageLabel.backgroundColor = [UIColor clearColor];
        massageLabel.text = massage;
        massageLabel.numberOfLines = 0;
        massageLabel.font = [UIFont systemFontOfSize:15.0];
        massageLabel.textAlignment = NSTextAlignmentCenter;
        massageLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
        [alertView addSubview:massageLabel];
        _massageLabel = massageLabel;
        
        
        UIImageView *lineBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_massageLabel.frame) + 55, Kdwidth, 1.0)];
        
        lineBtnView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineBtnView];
        
        //添加按钮
        va_list args;
        va_start(args, otherButtonTitles);
        NSMutableArray *buttonTitleArray = [NSMutableArray array];
        NSMutableString *allStr = [[NSMutableString alloc] initWithCapacity:16];
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            [allStr appendFormat:@"%@,",str];
            [buttonTitleArray addObject:str];
        }
        
        
        [_titleBtnArray removeAllObjects];
        
        
        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(0, CGRectGetMaxY(lineBtnView.frame),  Kdwidth / 2.0 - 0.5, 50);
        
        [oneBtn setTitle:buttonTitleArray[0] forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        oneBtn.backgroundColor = [UIColor clearColor];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        oneBtn.tag = 0;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:oneBtn];
        
        [alertView addSubview:oneBtn];
        
        
        UIImageView *lineMiddleView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oneBtn.frame), CGRectGetMaxY(lineBtnView.frame), 1, 50)];
        
        lineMiddleView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineMiddleView];
        
        UIButton *twoBtn = [[UIButton alloc]init];
        twoBtn.frame = CGRectMake( Kdwidth / 2.0 + 0.5, CGRectGetMaxY(lineBtnView.frame),  Kdwidth / 2.0 - 0.5, 50);
        [twoBtn setTitle:buttonTitleArray[1] forState:(UIControlStateNormal)];
        [twoBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:122/255.0 blue:0/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        twoBtn.backgroundColor = [UIColor clearColor];
        twoBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        twoBtn.tag = 1;
        [twoBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:twoBtn];
        
        [alertView addSubview:twoBtn];
        
        
        
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(twoBtn.frame));
        
        _aletView = alertView;
    }
    
    return self;
}

//未登陆
-(instancetype)initWithOneBBTTitle:(NSString *)title andWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)oneButtonTitle{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:235/255.0 alpha:1.0];;
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 20, kScreen_Width-kDistance*2, 15);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor orangeColor];
        
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
        [alertView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 16, Kdwidth - 20, 1.0)];
        
        lineView.backgroundColor = [UIColor orangeColor];
        
        [alertView addSubview: lineView];
        
        
        
        //信息内容
        UILabel *massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineView.frame) + 54, Kdwidth, 14)];
        massageLabel.backgroundColor = [UIColor clearColor];
        massageLabel.text = massage;
        massageLabel.numberOfLines = 0;
        massageLabel.font = [UIFont systemFontOfSize:15.0];
        massageLabel.textAlignment = NSTextAlignmentCenter;
        massageLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
        [alertView addSubview:massageLabel];
        _massageLabel = massageLabel;
        
        
        UIImageView *lineBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_massageLabel.frame) + 55, Kdwidth, 1.0)];
        
        lineBtnView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineBtnView];
    
        
        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(0, CGRectGetMaxY(lineBtnView.frame),  Kdwidth  - 1.0, 50);
        
        [oneBtn setTitle:oneButtonTitle forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        oneBtn.backgroundColor = [UIColor clearColor];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        oneBtn.tag = 1;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:oneBtn];
        
        [alertView addSubview:oneBtn];
        
        
        
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(oneBtn.frame));
        
        _aletView = alertView;
    }
    
    return self;
}



-(instancetype)initWithBBTupgradeTitle:(NSString*)title andWithMassage:(NSString*)massage andWithTwoMassage:(NSString *)massaageSecond andWithTag:(NSInteger)tag andWithButtonTitle:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:235/255.0 alpha:1.0];;
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        //标题
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(0, 20, kScreen_Width-kDistance*2, 15);
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.text = title;
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = [UIColor orangeColor];
        
        [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
        [alertView addSubview:titleLabel];
        _titleLabel = titleLabel;
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame) + 16, Kdwidth - 20, 1.0)];
        
        lineView.backgroundColor = [UIColor orangeColor];
        
        [alertView addSubview: lineView];
        
        
        
        //信息内容
        UILabel *massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(lineView.frame) + 19, Kdwidth -44, 14)];
        massageLabel.backgroundColor = [UIColor clearColor];
        massageLabel.text = massage;
        massageLabel.numberOfLines = 0;
        massageLabel.font = [UIFont systemFontOfSize:13.0];
        massageLabel.textAlignment = NSTextAlignmentLeft;
        massageLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
        [alertView addSubview:massageLabel];
        _massageLabel = massageLabel;
        
        UILabel *TmassageLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, CGRectGetMaxY(massageLabel.frame) , Kdwidth - 44, 14)];
        TmassageLabel.backgroundColor = [UIColor clearColor];
        TmassageLabel.text = massaageSecond;
        TmassageLabel.numberOfLines = 0;
        TmassageLabel.font = [UIFont systemFontOfSize:13.0];
        TmassageLabel.textAlignment = NSTextAlignmentLeft;
        TmassageLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
        [alertView addSubview:TmassageLabel];
        _TmassageLabel = TmassageLabel;
        
        
        
        UIImageView *lineBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_massageLabel.frame) + 78, Kdwidth, 1.0)];
        
        lineBtnView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineBtnView];
        
        //添加按钮
        va_list args;
        va_start(args, otherButtonTitles);
        NSMutableArray *buttonTitleArray = [NSMutableArray array];
        NSMutableString *allStr = [[NSMutableString alloc] initWithCapacity:16];
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            [allStr appendFormat:@"%@,",str];
            [buttonTitleArray addObject:str];
        }
        
        
        [_titleBtnArray removeAllObjects];
        
        
        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(0, CGRectGetMaxY(lineBtnView.frame),  Kdwidth / 2.0 - 0.5, 50);
        
        [oneBtn setTitle:buttonTitleArray[0] forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        oneBtn.backgroundColor = [UIColor clearColor];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        oneBtn.tag = 0;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:oneBtn];
        
        [alertView addSubview:oneBtn];
        
        
        UIImageView *lineMiddleView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oneBtn.frame), CGRectGetMaxY(lineBtnView.frame), 1, 50)];
        
        lineMiddleView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineMiddleView];
        
        UIButton *twoBtn = [[UIButton alloc]init];
        twoBtn.frame = CGRectMake( Kdwidth / 2.0 + 0.5, CGRectGetMaxY(lineBtnView.frame),  Kdwidth / 2.0 - 0.5, 50);
        [twoBtn setTitle:buttonTitleArray[1] forState:(UIControlStateNormal)];
        [twoBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        twoBtn.backgroundColor = [UIColor clearColor];
        twoBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        
        twoBtn.tag = 1;
        [twoBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:twoBtn];
        
        [alertView addSubview:twoBtn];
        
        
        
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(twoBtn.frame));
        
        _aletView = alertView;
    }
    
    return self;
}




- (instancetype)initWithImage:(NSString *)image andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)otherButtonTitles, ...{
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:235/255.0 alpha:1.0];
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((Kdwidth - 81)/2.0, kImageViewKwidth, 81, 81)];
        imageView.backgroundColor = [UIColor clearColor];
        
        imageView.image = [UIImage imageNamed:@"icon_jg"];
        
        [alertView addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+ kImageViewKwidth, Kdwidth, 20)];
        titleLabel.text = @"网络连接失败，请检查您的网络设置";
        titleLabel.textColor = [UIColor lightGrayColor];
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [alertView addSubview:titleLabel];
        
        
        //添加按钮
        va_list args;
        va_start(args, otherButtonTitles);
        NSMutableArray *buttonTitleArray = [NSMutableArray array];
        NSMutableString *allStr = [[NSMutableString alloc] initWithCapacity:16];
        for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
            [allStr appendFormat:@"%@,",str];
            [buttonTitleArray addObject:str];
        }

        [_titleBtnArray removeAllObjects];
        
        
        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(kBtnKwidth, CGRectGetMaxY(titleLabel.frame)+kTitelHight,  (Kdwidth - 3 *kBtnKwidth) / 2.0, kButtonHei);
        [oneBtn setTitle:buttonTitleArray[0] forState:(UIControlStateNormal)];

        
        [oneBtn setTitleColor:[UIColor lightGrayColor] forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateHighlighted)];
        

        
        [oneBtn setBackgroundImage:[UIImage imageNamed:@"btn_bai02_nor"] forState:UIControlStateNormal];
        [oneBtn setBackgroundImage:[UIImage imageNamed:@"btn_bai02_pre"] forState:UIControlStateHighlighted];
        
        
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFont];
        [oneBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kBtnTitleFont]];
        oneBtn.tag = 0;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:oneBtn];
        
        [alertView addSubview:oneBtn];
//        [oneBtn addSubview:[self getLineView:CGRectMake(0, 0, titleLabel.frame.size.width, 0.5)]];
        
        
        UIButton *twoBtn = [[UIButton alloc]init];
       twoBtn.frame = CGRectMake(CGRectGetMaxX(oneBtn.frame) + kBtnKwidth,CGRectGetMaxY(titleLabel.frame)+kTitelHight, (Kdwidth - 3 *kBtnKwidth) / 2.0 ,kButtonHei);
        
        [twoBtn setTitle:buttonTitleArray[1] forState:(UIControlStateNormal)];
        [twoBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [twoBtn setTitleColor:[UIColor blackColor] forState:(UIControlStateHighlighted)];

        [twoBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng02_nor"] forState:UIControlStateNormal];
        [twoBtn setBackgroundImage:[UIImage imageNamed:@"btn_cheng02_pre"] forState:UIControlStateHighlighted];
        
        twoBtn.titleLabel.font = [UIFont systemFontOfSize:kBtnTitleFont];
        [twoBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:kBtnTitleFont]];
        twoBtn.tag = 1;
        [twoBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:twoBtn];
        
        [alertView addSubview:twoBtn];

        
        
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(twoBtn.frame) + 15);
 
      
    
    
    _aletView = alertView;
        
        
    }
    
    return self;
    
}


//配网失败
- (instancetype)initWithNetImage:(NSString *)image andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)oneButtonTitle{
    self = [super init];
    
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;

        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:235/255.0 alpha:1.0];
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((Kdwidth - 81)/2.0, kImageViewKwidth, 81, 81)];
        imageView.backgroundColor = [UIColor clearColor];
        
        imageView.image = [UIImage imageNamed:@"icon_jg"];
        
        [alertView addSubview:imageView];
        
        UILabel *nettitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+ kImageViewKwidth, Kdwidth, 20)];
        nettitleLabel.text = @"网络连接失败，请检查后重试";
        nettitleLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        nettitleLabel.font = [UIFont systemFontOfSize:15.0];
        nettitleLabel.textAlignment = NSTextAlignmentCenter;
        
        [alertView addSubview:nettitleLabel];
        
        
        UIImageView *lineBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nettitleLabel.frame) + 20, Kdwidth, 1.0)];

        lineBtnView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];

        [alertView addSubview:lineBtnView];


        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(0, CGRectGetMaxY(lineBtnView.frame),  Kdwidth  - 1.0, 50);

        [oneBtn setTitle:oneButtonTitle forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        oneBtn.backgroundColor = [UIColor clearColor];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];

        oneBtn.tag = 1;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];

        [alertView addSubview:oneBtn];
        
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(oneBtn.frame));
        

        
        
        _aletView = alertView;
        
    }

    
    return self;
    
}


-(instancetype)initWithOneMassage:(NSString *)OneMassage andWithMassage:(NSString *)massage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)oneButtonTitle{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:235/255.0 alpha:1.0];;
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        
        //信息内容
        UILabel *massageOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,  30, Kdwidth, 14)];
        massageOneLabel.backgroundColor = [UIColor clearColor];
        massageOneLabel.text = OneMassage;
        massageOneLabel.numberOfLines = 0;
        massageOneLabel.font = [UIFont systemFontOfSize:15.0];
        massageOneLabel.textAlignment = NSTextAlignmentCenter;
        massageOneLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
        [alertView addSubview:massageOneLabel];
        
        //信息内容
        UILabel *massageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(massageOneLabel.frame) + 10, Kdwidth, 40)];
        massageLabel.backgroundColor = [UIColor clearColor];
        massageLabel.text = massage;
        massageLabel.numberOfLines = 0;
        massageLabel.font = [UIFont systemFontOfSize:15.0];
        massageLabel.textAlignment = NSTextAlignmentCenter;
        massageLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
        [alertView addSubview:massageLabel];
        
        
        _massageLabel = massageLabel;
        
        
        UIImageView *lineBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_massageLabel.frame) + 20, Kdwidth, 1.0)];
        
        lineBtnView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineBtnView];
        
        
        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(0, CGRectGetMaxY(lineBtnView.frame),  Kdwidth  - 1.0, 50);
        
        [oneBtn setTitle:oneButtonTitle forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        oneBtn.backgroundColor = [UIColor clearColor];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        oneBtn.tag = 1;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:oneBtn];
        
        [alertView addSubview:oneBtn];
        
        
        
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(oneBtn.frame));
        
        _aletView = alertView;
    }
    
    return self;
}


-(instancetype)initWithOneMassage:(NSString *)OneMassage andWithTag:(NSInteger)tag andWithButtonTitle:(NSString *)oneButtonTitle{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0,kScreen_Width, kScreen_Height);
        self.tag=tag;
        _titleBtnArray = [NSMutableArray array];
        //蒙板
        [_backgraoudView removeFromSuperview];
        _backgraoudView = nil;
        _backgraoudView = [[UIView alloc]init];
        _backgraoudView.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
        _backgraoudView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
        _backgraoudView.alpha = 0;
        [self addSubview:_backgraoudView];
        
        [UIView animateWithDuration:0.2 animations:^{
            _backgraoudView.alpha = 0.7;
        }];
        
        
        UIView *alertView = [[UIView alloc]init];
        alertView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:235/255.0 alpha:1.0];;
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, 1000);
        alertView.layer.masksToBounds = YES; //没这句话它圆不起来
        alertView.layer.cornerRadius =5; //设置图片圆角的尺度
        [self addSubview:alertView];
        
        CGFloat Kdwidth = kScreen_Width-kDistance*2;
        
        UIScrollView *ParamtView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, Kdwidth,150/ 568.0 *kScreen_Height)];
        
        ParamtView.scrollEnabled = YES;
        ParamtView.showsVerticalScrollIndicator =  NO;
        ParamtView.showsHorizontalScrollIndicator = YES;

        ParamtView.pagingEnabled = YES;
//        ParamtView.delegate = self;
        ParamtView.bounces = YES;
        
//        ParamtView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        ParamtView.backgroundColor = [UIColor clearColor];
        
        [alertView addSubview:ParamtView];
        
//        UIScrollView *ParamtView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, Kdwidth, 200)];
//
//
//        ParamtView.scrollEnabled = YES;
//        ParamtView.showsVerticalScrollIndicator =  NO;
//        ParamtView.showsHorizontalScrollIndicator = YES;
//
//        ParamtView.pagingEnabled = YES;
////        ParamtView.delegate = self;
//        ParamtView.bounces = YES;
//
//
//        ParamtView.backgroundColor = [UIColor redColor];
//        ParamtView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [alertView addSubview:ParamtView];
        
        
        //信息内容

        UILabel *massageOneLabel = [[UILabel alloc] init];
        CGFloat massageOneLabelY =  0;
        CGFloat massageOneLabelX =  5;



        CGSize massageOneLabelSize = [OneMassage sizeWithMaxSize:CGSizeMake(Kdwidth - massageOneLabelX *2, MAXFLOAT) fontSize:14];


        massageOneLabel.frame = (CGRect){massageOneLabelX,massageOneLabelY,Kdwidth - massageOneLabelX *2, massageOneLabelSize.height + 10};

        massageOneLabel.text = OneMassage;
        massageOneLabel.numberOfLines = 0;
        massageOneLabel.backgroundColor = [UIColor clearColor];
        massageOneLabel.font = [UIFont systemFontOfSize:14.0];
        massageOneLabel.textAlignment = NSTextAlignmentCenter;
        massageOneLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];

        ParamtView.contentSize = CGSizeMake(0,massageOneLabelSize.height + 50);

        [ParamtView addSubview:massageOneLabel];
//

        
        UIImageView *lineBtnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(ParamtView.frame), Kdwidth, 1.0)];
        
        lineBtnView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
        
        [alertView addSubview:lineBtnView];
        
        
        UIButton *oneBtn = [[UIButton alloc]init];
        oneBtn.frame = CGRectMake(0, CGRectGetMaxY(lineBtnView.frame),  Kdwidth  - 1.0, 50);
        
        [oneBtn setTitle:oneButtonTitle forState:(UIControlStateNormal)];
        [oneBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0] forState:(UIControlStateNormal)];
        oneBtn.backgroundColor = [UIColor clearColor];
        oneBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        
        
        oneBtn.tag = 1;
        [oneBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:(UIControlEventTouchUpInside)];
        [_titleBtnArray addObject:oneBtn];
        
        [alertView addSubview:oneBtn];
        
        
        
        alertView.frame = CGRectMake(kDistance, 0, kScreen_Width-kDistance*2, CGRectGetMaxY(oneBtn.frame));
        
        _aletView = alertView;
    }
    
    return self;
}



#pragma mark －－显示在控制器中
-(void)showInView:(UIView *)view{
    
    if (!view)
    {
        return;
    }
    

//    [UIView animateWithDuration:0.2 animations:^{
    
    _aletView.frame = CGRectMake(kDistance, kScreen_Height/2.0-_aletView.frame.size.height/2.0 , _aletView.frame.size.width, _aletView.frame.size.height);
        
//    }];

        [view addSubview:self];
    
//    UIWindow *window = [UIApplication sharedApplication].windows[0];
//    [window addSubview:self];
}

#pragma mark －－获取文字方法
-(CGRect)getStrimgRect:(NSString *)str andWithStringFontSize:(NSInteger)font andWithCurrentProlWitch:(CGFloat)witch{
    CGSize  maxSize;
    maxSize = CGSizeMake(witch,MAXFLOAT);
    CGRect rect=
    [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font],NSFontAttributeName,nil]context:nil];

    return rect;
}

#pragma mark －－创建灰色线
-(UIView*)getLineView:(CGRect)rect{
    UIView *lineView = [[UIView alloc]init];
    lineView.frame = rect;
    lineView.backgroundColor = [UIColor grayColor];
    return lineView;
}

#pragma mark  －－按钮点击方法
-(void)titleBtnClick:(UIButton*)btn{
    [self removeFromSuperview];
    self.resultIndex(btn.tag,self.tag);
}

#pragma mark －－设置按钮背景颜色－－设置按钮文字颜色
-(void)setTitleBtnWithBgColor:(UIColor *)bgColor andWithtitleColor:(UIColor *)titleColor atBtnTag:(NSInteger)tag{
    if (tag <_titleBtnArray.count) {
        UIButton *btn = _titleBtnArray[tag];
        
        if (bgColor != nil) {
             btn.backgroundColor = bgColor;
        }
        if (titleColor != nil) {
            [btn setTitleColor:titleColor forState:(UIControlStateNormal)];
        }
    }else{
        NSLog(@"并没有创建tag相对应的btn");
    }
}

#pragma mark －－设置标题文字颜色
-(void)setTitleTextColorr:(UIColor *)textColor{
    if (textColor != nil) {
        _titleLabel.textColor = textColor;
    }
}


#pragma mark －－设置信息文字颜色
-(void)setMassageTextColor:(UIColor *)textColor {
       if (textColor != nil) {
        _massageLabel.textColor = textColor;
    }
}

#pragma mark －－设置背景颜色
-(void)setAlertViewBgColor:(UIColor*)bgColor{
    if (bgColor != nil) {
        _aletView.backgroundColor = bgColor;
    }
}
@end
