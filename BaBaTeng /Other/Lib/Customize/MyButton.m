//
//  MyButton.m
//  拉手团购网
//
//  Created by a a a a a on 13-10-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "MyButton.h"
#import "UIImage+FlatUI.h"
#import "UIImageView+AFNetworking.h"
#import "UIFont+FlatUI.h"

#import "LPLabel.h"
#import "UIButton+AFNetworking.h"

#import "Header.h"

#define JJM_FOUR_FONT          [UIFont systemFontOfSize:13.0f];

@implementation MyButton


@synthesize type;




-(UIButton*)initWithShareImage:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle frame:(CGRect)frame{
    
    int height = frame.size.height-5;
    
    CGRect userIconRect= CGRectMake(5,2,frame.size.width/2-10, frame.size.height-8);
    self.selerListImage=[[UIImageView alloc] initWithFrame:userIconRect];
    self.selerListImage.contentMode = UIViewContentModeScaleToFill;
    [self.selerListImage setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    //self.selerListImage.image = [UIImage imageNamed:image];
    self.selerListImage.backgroundColor = [UIColor clearColor];
    self.selerListImage.clipsToBounds = YES;
    self.selerListImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2,2,frame.size.width/2-2, height/3)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor=[UIColor grayColor];
    titleLabel.font=JJM_FOUR_FONT;
    titleLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2,height/3+2,frame.size.width/2-2, height/3)];
    subTitleLabel.text = subtitle;
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    subTitleLabel.textColor=[UIColor colorWithWhite:0.26 alpha:1.0f];
    subTitleLabel.font=JJM_FOUR_FONT;
    subTitleLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *shareTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2,height/3+height/3+4,frame.size.width/2-2, height/3-4)];
    shareTitleLabel.text = @"分享有礼";
    shareTitleLabel.textAlignment = NSTextAlignmentCenter;
    shareTitleLabel.textColor=[UIColor orangeColor];
    shareTitleLabel.font=JJM_FOUR_FONT;
    shareTitleLabel.backgroundColor = [UIColor clearColor];
    shareTitleLabel.layer.borderColor = [UIColor orangeColor].CGColor;
    shareTitleLabel.layer.borderWidth = 0.5;
    shareTitleLabel.layer.cornerRadius = 2;
    
    [self addSubview:titleLabel];
    [self addSubview:subTitleLabel];
    [self addSubview:shareTitleLabel];
    [self addSubview:self.selerListImage];
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(UIButton*)initWithImage:(NSString *)image title:(NSString *)title subtitle:(NSString *)subtitle promotionPrice:(NSString*)promotionPrice price:(NSString *)price frame:(CGRect)frame ifsell:(NSString *)sell{
    
    int item = frame.size.width;
    
    CGRect userIconRect= CGRectMake(0,2,56, frame.size.height-4);
    self.selerListImage=[[UIImageView alloc] initWithFrame:userIconRect];
    self.selerListImage.contentMode = UIViewContentModeScaleToFill;
    [self.selerListImage setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    
    self.selerListImage.backgroundColor = [UIColor whiteColor];
    self.selerListImage.clipsToBounds = YES;
    self.selerListImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,0,item-50, 25)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor= [UIColor grayColor];
    titleLabel.font=JJM_FOUR_FONT;
    titleLabel.backgroundColor = [UIColor clearColor];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60,22,item-60, 15)];
    subTitleLabel.text = subtitle;
    subTitleLabel.textAlignment = NSTextAlignmentLeft;
    //    subTitleLabel.textColor=[UIColor colorWithWhite:0.26 alpha:1.0f];
    subTitleLabel.textColor = [UIColor colorWithWhite:0.26 alpha:1.0f];
    subTitleLabel.font=JJM_FOUR_FONT;
    subTitleLabel.backgroundColor = [UIColor clearColor];
    
    
    UILabel *intergarlLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 40, 30, 15)];
    
    intergarlLabel.text = [NSString stringWithFormat:@"%@积分",promotionPrice];
    intergarlLabel.font = [UIFont systemFontOfSize:9];
    intergarlLabel.textColor = [UIColor grayColor];
    intergarlLabel.backgroundColor = [UIColor clearColor];
    LPLabel *priceLabel = [[LPLabel alloc] initWithFrame:CGRectMake(90, 40, 35, 15)];
    
    CGFloat myprice = [price floatValue];
    
    NSString *pricestr = [NSString stringWithFormat:@"%0.0f",myprice];
    
    priceLabel.text = [NSString stringWithFormat:@"¥%@",pricestr];
    priceLabel.font = JJM_FOUR_FONT;
    priceLabel.textColor = [UIColor grayColor];
    priceLabel.backgroundColor = [UIColor clearColor];
    priceLabel.strikeThroughColor = [UIColor grayColor];
    
    
    
    CGFloat buyWH = 35;
    // CGFloat buyX = kDeviceWidth/2-50;
    CGFloat buyY = 40;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(item-35, buyY, buyWH, 15)];
    
    label.layer.cornerRadius = 2.0f;
    label.clipsToBounds = YES;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    if ([sell isEqualToString:@"1"]) {
        label.text = @"已抢光";
        label.font = [UIFont systemFontOfSize:8];
        label.backgroundColor = [UIColor grayColor];
    }else{
        label.text = @"抢";
        label.font = JJM_FOUR_FONT;
        label.backgroundColor = [UIColor redColor];
    }
    
    
    [self addSubview:priceLabel];
    [self addSubview:intergarlLabel];
    [self addSubview:label];
    [self addSubview:titleLabel];
    [self addSubview:subTitleLabel];
    [self addSubview:self.selerListImage];
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

- (void)addTopLine:(BOOL)ifLine{
    
    if (ifLine) {
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.5)];
        topImageView.image = [self streImageNamed:@"line.png"];
        [self addSubview:topImageView];
        
    }
    
}

- (UIImage *)streImageNamed:(NSString *)imageName
{
    if (imageName == nil) {
        return nil;
    }
    UIImage *image = [UIImage imageNamed:imageName];
    UIImage *streImage = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return streImage;
}


-(UIButton*)initWithImage111:(NSString *)image title:(NSString *)title frame:(CGRect)frame type:(NSString*)newType
{
    
    int item = frame.size.width;
    
    CGRect userIconRect= CGRectMake(0,0,item, item);
    self.selerListImage=[[UIImageView alloc] initWithFrame:userIconRect];
    self.selerListImage.contentMode = UIViewContentModeScaleToFill;
//    self.selerListImage.image = [UIImage imageNamed:image];
    
     NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)image, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [self.selerListImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"image_recommend"]];
    
    self.selerListImage.backgroundColor = [UIColor clearColor];
    
//    self.selerListImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.selerListImage.layer.cornerRadius = 15.0;
    self.selerListImage.layer.masksToBounds = YES;
    self.selerListImage.layer.borderWidth = 1.0;
    self.selerListImage.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
//    self.selerListImage.layer.borderColor = [UIColor redColor].CGColor;
    self.selerListImage.clipsToBounds = YES;//去除边界
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,item + 12,item, 17)];
    //UIColor *fontColor=[UIColor colorWithWhite:0.5f alpha:1.0f];
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor=[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:1.0f];
//    label.textColor=[UIColor redColor];
    label.font=[UIFont systemFontOfSize:18.0f];;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    [self addSubview:self.selerListImage];
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    
    //[self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9f alpha:1.0f] cornerRadius:0] forState:UIControlStateHighlighted];
    
    return self;
}


-(UIButton*)initWithImageEnglishStudentStyle:(NSString *)image title:(NSString *)title Subtitle:(NSString *)subtitle frame:(CGRect)frame type:(NSString*)newType
{
    
    int item = frame.size.width;
    
    CGRect userIconRect= CGRectMake(0,0,item, item);
    self.selerListImage=[[UIImageView alloc] initWithFrame:userIconRect];
    self.selerListImage.contentMode = UIViewContentModeScaleToFill;
    //    self.selerListImage.image = [UIImage imageNamed:image];
    
    UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, item - 46, 30, 30)];
    
    playImageView.image = [UIImage imageNamed:@"studentstyle_play"];
    
    [self.selerListImage addSubview:playImageView];
    
    
    
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)image, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
    
    [self.selerListImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"image_recommend"]];
    
    self.selerListImage.backgroundColor = [UIColor clearColor];
    
    //    self.selerListImage.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.selerListImage.layer.cornerRadius = 15.0;
    self.selerListImage.layer.masksToBounds = YES;
    self.selerListImage.layer.borderWidth = 1.0;
    self.selerListImage.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    //    self.selerListImage.layer.borderColor = [UIColor redColor].CGColor;
    self.selerListImage.clipsToBounds = YES;//去除边界
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,item + 16,item, 17)];
    //UIColor *fontColor=[UIColor colorWithWhite:0.5f alpha:1.0f];
    label.text = title;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor=[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0f];
    //    label.textColor=[UIColor redColor];
    label.font=[UIFont boldSystemFontOfSize:18.0f];;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    
    UILabel *sublabel = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(label.frame) + 8,item, 14)];
 
    sublabel.text = subtitle;
    sublabel.textAlignment = NSTextAlignmentLeft;
    sublabel.textColor=[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0f];
 
    sublabel.font=[UIFont systemFontOfSize:14.0f];;
    sublabel.backgroundColor = [UIColor clearColor];
    [self addSubview:sublabel];
    
    
    [self addSubview:self.selerListImage];
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    
    
    
    
    //[self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9f alpha:1.0f] cornerRadius:0] forState:UIControlStateHighlighted];
    
    return self;
}


//-(UIButton*)initWithImageEnglishStudentStyle:(NSString *)image title:(NSString *)title frame:(CGRect)frame type:(NSString*)newType
//{
//
//    int item = frame.size.width;
//
//    CGRect userIconRect= CGRectMake(0,0,item, item);
//    UIButton  *selerListBtn=[[UIButton alloc] initWithFrame:userIconRect];
//
//
//    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)image, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));
//
////    [self.selerListImage setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"image_recommend"]];
//
//    [selerListBtn setBackgroundImageForState:UIControlStateNormal withURL:[NSURL URLWithString:encodedString]];
//
//    [selerListBtn setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
//
//
//    selerListBtn.backgroundColor = [UIColor clearColor];
//
//
//
//    selerListBtn.layer.cornerRadius = 15.0;
//    selerListBtn.layer.masksToBounds = YES;
//    selerListBtn.layer.borderWidth = 1.0;
//    selerListBtn.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
//
//    selerListBtn.clipsToBounds = YES;//去除边界
//
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,item + 12,item, 17)];
//
//    label.text = title;
//    label.textAlignment = NSTextAlignmentLeft;
//    label.textColor=[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:1.0f];
//
//    label.font=[UIFont systemFontOfSize:18.0f];;
//    label.backgroundColor = [UIColor clearColor];
//    [self addSubview:label];
//    [self addSubview:selerListBtn];
//    self.frame = frame;
//    self.backgroundColor = [UIColor clearColor];
//
//
//
//    return self;
//}


-(UIButton*)initWithImage:(NSString *)image title:(NSString *)title frame:(CGRect)frame type:(NSString*)newType
{
    
    int item = frame.size.width;
    
    CGRect userIconRect= CGRectMake((item-25/568.0*KDeviceHeight)/2,5,25/568.0*KDeviceHeight, 25/568.0*KDeviceHeight);
    self.selerListImage=[[UIImageView alloc] initWithFrame:userIconRect];
    self.selerListImage.contentMode = UIViewContentModeScaleAspectFit;
    if ([newType isEqualToString:@"no"]) {
        self.selerListImage.image = [UIImage imageNamed:image];
    }else{
        
        [self.selerListImage setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"home_page_laceholder"]];
    }
    
    self.selerListImage.backgroundColor = [UIColor clearColor];
    //self.selerListImage.clipsToBounds = YES;
    // self.selerListImage.layer.borderColor = [UIColor whiteColor].CGColor;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10/568.0*KDeviceHeight,30/568.0*KDeviceHeight,item-20/568.0*KDeviceHeight, 25/568.0*KDeviceHeight)];
    //UIColor *fontColor=[UIColor colorWithWhite:0.5f alpha:1.0f];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor  whiteColor];//[UIColor colorWithWhite:0.26 alpha:1.0f];
    label.font=JJM_FOUR_FONT;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    [self addSubview:self.selerListImage];
    self.frame = frame;
    self.backgroundColor = [UIColor clearColor];
    
    //[self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9f alpha:1.0f] cornerRadius:0] forState:UIControlStateHighlighted];
    
    return self;
    
}

-(UIButton*)initWithImage1:(NSString *)image title:(NSString *)title frame:(CGRect)frame type:(NSInteger)newType
{
    int item = frame.size.width;
    
    
    
    CGRect userIconRect= CGRectMake(10,0,item-20,frame.size.height-([UIScreen mainScreen].bounds.size.width>320.0?40:50));
    self.selerListImage=[[UIImageView alloc] initWithFrame:userIconRect];
    self.selerListImage.contentMode = UIViewContentModeScaleToFill;
    
    self.selerListImage.image = [UIImage imageNamed:image];
    //    CALayer *layer=self.selerListImage.layer;
    //    layer.cornerRadius=13;
    //
    //    //self.selerListImage.backgroundColor = [UIColor yellowColor];
    //    //self.selerListImage.layer.borderColor = [UIColor whiteColor].CGColor;
    //    self.selerListImage.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,userIconRect.size.height+5,item-20, 20)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithWhite:0.26 alpha:1.0f];
    label.font=[UIFont systemFontOfSize:14.0f];
    //label.backgroundColor = [UIColor redColor];
    
    [self addSubview:label];
    [self addSubview:self.selerListImage];
    
    self.frame = frame;
    
    
    //    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9f alpha:1.0f] cornerRadius:0] forState:UIControlStateHighlighted];
    
    return self;
}




-(UIButton*)initWithTitle:(NSString *)title Money:(NSString *)money frame:(CGRect)frame type:(NSInteger)newType{
    
    int item = frame.size.width;
    
    CGRect userIconRect= CGRectMake(0,10,item, 25);
    UILabel *myTitle=[[UILabel alloc] initWithFrame:userIconRect];
    myTitle.text = title;
    myTitle.textAlignment = NSTextAlignmentCenter;
    myTitle.textColor=[UIColor colorWithWhite:0.26 alpha:1.0f];
    myTitle.font=[UIFont systemFontOfSize:16.0f];
    myTitle.backgroundColor = [UIColor clearColor];
    [self addSubview:myTitle];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,35,item, 30)];
    label.text =  [money description];//换成字符串
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithRed:245.0/255 green:65.0/255 blue:77.0/255 alpha:1.000];
    label.font=[UIFont systemFontOfSize:18.0f];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    [self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9f alpha:1.0f] cornerRadius:0] forState:UIControlStateHighlighted];
    
    
    return self;
}


-(UIButton*)initWithTitle1:(NSString *)title Money:(NSString *)money frame:(CGRect)frame type:(NSInteger)newType{
    
    int item = frame.size.width;
    CGRect userIconRect= CGRectMake(0,10,item, 25);
    UILabel *myTitle=[[UILabel alloc] initWithFrame:userIconRect];
    myTitle.text = title;
    myTitle.textAlignment = NSTextAlignmentCenter;
    myTitle.textColor=[UIColor colorWithWhite:0.4 alpha:1.0f];
    myTitle.font=[UIFont systemFontOfSize:13.0f];
    myTitle.backgroundColor = [UIColor clearColor];
    [self addSubview:myTitle];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,32,item, 25)];
    label.text =  [money description];//换成字符串
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithRed:245.0/255 green:65.0/255 blue:77.0/255 alpha:1.000];
    label.font=[UIFont systemFontOfSize:13.5f];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    
    self.frame = frame;
    self.backgroundColor = [UIColor whiteColor];
    //[self setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9f alpha:1.0f] cornerRadius:0] forState:UIControlStateHighlighted];
    
    
    return self;
}



-(UIButton*)initWithMyButtonTitle:(NSString *)buttonTitle ButtonBackgroundImage:(NSString *)buttonImage frame:(CGRect)frame{
    
    self.frame = frame;
    int item = frame.size.width;
    int itemHeight = frame.size.height;
    [self setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,itemHeight/2,item, 30)];
    label.text = buttonTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor=[UIColor colorWithRed:245.0/255 green:65.0/255 blue:77.0/255 alpha:1.000];
    label.font=[UIFont systemFontOfSize:15.0f];
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
    
    return self;
}

-(UIButton*)initWithButtonTitle:(NSString *)buttonTitle ButtonBackgroundImage:(NSString *)buttonImage frame:(CGRect)buttonFrame
{
    
    self.frame = buttonFrame;
    
    [self setImage:[UIImage imageNamed:buttonImage] forState:UIControlStateNormal];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self setTitle:buttonTitle forState:UIControlStateNormal];
    
    return self;
    
    
}
-(UIButton*)initWithimage:(NSString *)normalImage heighlightImage:(NSString *)heighImage frame:(CGRect)frame
{
    self.frame = frame;
    
    [self setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:heighImage] forState:UIControlStateHighlighted];
    
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    return self;
}

-(UIButton*)initWithimage:(NSString *)normalImage heighlightImage:(NSString *)heighImage title:(NSString *)title frame:(CGRect)frame type:(NSInteger)newType
{
    self.type = newType;
    [self setBackgroundImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageNamed:heighImage] forState:UIControlStateHighlighted];
    [self setTitle:title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self .titleLabel.textAlignment = NSTextAlignmentCenter;
    self.frame = frame;
    return self;
}
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect rect;
    if(self.type==1)
    {
        rect = CGRectMake(20, 0, 37, 30);
    }
    if(self.type==2)
    {
        rect = CGRectMake(0, 55, 75, 20);
    }
    return rect;
}
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect rect;
    if(self.type==1)
    {
        CGRectMake(0 ,0, 57, 30);
    }
    if(self.type==2)
    {
        rect = CGRectMake((317/4-52)/2, 3, 52, 52);
    }
    return rect;
}
@end
