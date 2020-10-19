//
//  CLRocker.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/17.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "CLRocker.h"

#define kRadius ([self bounds].size.width * 0.5f)
#define kTrackRadius kRadius * 0.8f

@interface CLRocker ()
{
    CGFloat _x;
    CGFloat _y;
}

@property (strong, nonatomic) UIImageView *handleImageView;
@property (nonatomic, assign) NSInteger BtnNum;

@end

@implementation CLRocker

- (void)awakeFromNib
{
    [self commonInit];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder]))
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    [self setLockerStyle:LockStyleOpaque];
    
    _direction = LockDirectionCenter;
    
    if (!_handleImageView) {
        UIImage *handleImage = [UIImage imageNamed:@"btn_led_0"];

        _handleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.5f-handleImage.size.width*0.5f,
                                                                         self.bounds.size.height*0.5f-handleImage.size.height*0.5f,
                                                                         handleImage.size.width,
                                                                         handleImage.size.height)];
        _handleImageView.image = handleImage;
        _handleImageView.userInteractionEnabled = YES;
//
//        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleImageViewClicked)];
//
//        [_handleImageView addGestureRecognizer:singleTap];
        
//        [_handleImageView setImage:handleImage forState:UIControlStateNormal];
//        [_handleImageView addTarget:self action:@selector(handleImageViewClicked) forControlEvents:UIControlEventTouchUpInside];


        [self addSubview:_handleImageView];
    }
    
    _x = 0;
    _y = 0;
    
    self.BtnNum = 0;
    
}
- (void)setLockerStyle:(LockerStyle)style
{
    NSArray *imageNames = @[@"btn_led_9",@"btn_led_9"];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:imageNames[style]]]];
}

- (void)resetHandle
{
//    _handleImageView.image = [UIImage imageNamed:@"btn_led_0"];
    
    _x = 0.0;
    _y = 0.0;
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(([self bounds].size.width - [_handleImageView bounds].size.width) * 0.5f,
                                          ([self bounds].size.height - [_handleImageView bounds].size.height) * 0.5f);
    [_handleImageView setFrame:handleImageFrame];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_led_9"]]];
    
}

- (void)setHandlePositionWithLocation:(CGPoint)location
{
    _x = location.x - kRadius;
    _y = -(location.y - kRadius);
    
    float r = sqrt(_x * _x + _y * _y);
    
    if (r >= kTrackRadius) {
        
        _x = kTrackRadius * (_x / r);
        _y = kTrackRadius * (_y / r);
        
        location.x = _x + kRadius;
        location.y = -_y + kRadius;
        
        [self rockerValueChanged];
    }
    
//    CGRect handleImageFrame = [_handleImageView frame];
//    handleImageFrame.origin = CGPointMake(location.x - ([_handleImageView bounds].size.width * 0.5f),
//                                          location.y - ([_handleImageView bounds].size.width * 0.5f));
//    [_handleImageView setFrame:handleImageFrame];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//    _handleImageView.image = [UIImage imageNamed:@"handlePressed"];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"btn_led_9"]]];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
//    self.BtnNum = 0;
    
    [self setHandlePositionWithLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
//    self.BtnNum = 0;
    
    [self setHandlePositionWithLocation:location];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self resetHandle];
    
//    self.BtnNum = 0;
    
//    if (self.BtnNum == 1) {
//        return;
//    }
    
    [self rockerValueChanged];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self resetHandle];
    
//    self.BtnNum = 0;
//    if (self.BtnNum == 1) {
//        return;
//    }
    [self rockerValueChanged];
    
    
}
- (void)handleImageViewClicked
{
      NSLog(@"开关");
//    self.BtnNum = 1;
//    NSLog(@"self.BtnNum = %ld",(long)self.BtnNum);
}
- (void)rockerValueChanged
{
    

    
    NSInteger rockerDirection = -1;
    
    float arc = atan2f(_y,_x);
    
    NSLog(@"arc12345678 ===== %f",arc);
    
    if ( (arc > (8.0f/12.0f)*M_PI&&  arc < (11.0f/12.0f)*M_PI) ) {
        rockerDirection = 1;
        
        
    }
   else if ( (arc > (5.0f/12.0f)*M_PI&&  arc < (8.0f/12.0f)*M_PI) ) {
        rockerDirection = 2;
        
        
    }
   else if ( (arc > (2.0f/12.0f)*M_PI&&  arc < (5.0f/12.0f)*M_PI) ) {
        rockerDirection = 3;
        
        
    }
   else if ((arc > (0.0f)*M_PI &&  arc < (2.0f/12.0f)*M_PI) || (arc > -(1.0f/12.0f)*M_PI &&  arc < (0.0f)*M_PI)) {
                rockerDirection = 4;
        }
   else if ( (arc > -(4.0f/12.0f)*M_PI &&  arc <  -(1.0f/12.0f)*M_PI)) {
       rockerDirection = 5;
   }
   else if ( (arc > -(7.0f/12.0f)*M_PI &&  arc <  -(4.0f/12.0f)*M_PI)) {
       rockerDirection = 6;
   }
   else if ( (arc > -(10.0f/12.0f)*M_PI &&  arc <  -(7.0f/12.0f)*M_PI)) {
       rockerDirection = 7;
   }
   else if ((arc > (11.0f/12.0f)*M_PI &&  arc < (1.0f)*M_PI) || (arc >(-1.0f)*M_PI &&  arc <  -(10.0f/12.0f)*M_PI)) {
       rockerDirection = 8;
   }
//    else
//
//    {
//       rockerDirection = 11;
//    }
    
//        if ( (arc > (7.0f/8.0f)*M_2_PI &&  arc < M_2_PI) ) {
//            rockerDirection = 1;
//        }
//        else if (arc > (6.0f/8.0f)*M_2_PI &&  arc < (7.0f/8.0f)*M_2_PI) {
//            rockerDirection = 2;
//        }
//        else if ( arc > (5.0f/8.0f)*M_2_PI &&  arc < (6.0f/8.0f)*M_2_PI ) {
//            rockerDirection = 3;
//        }
//        else if ( arc > (4.0f/8.0f)*M_2_PI &&  arc < (5.0f/8.0f)*M_2_PI ) {
//            rockerDirection = 4;
//        }
//        else if ( arc > (3.0f/8.0f)*M_2_PI &&  arc < (4.0f/8.0f)*M_2_PI ) {
//            rockerDirection = 5;
//        }
//        else if ( arc > (2.0f/8.0f)*M_2_PI &&  arc < (3.0f/8.0f)*M_2_PI ) {
//            rockerDirection = 6;
//        }
//        else if ( arc > (1.0f/8.0f)*M_2_PI &&  arc < (2.0f/8.0f)*M_2_PI ) {
//            rockerDirection = 7;
//        }
//        else if ( arc > (0)*M_2_PI &&  arc < (1.0f/8.0f)*M_2_PI ) {
//            rockerDirection = 8;
//        }
//        else if (0 == _x && 0 == _y)
//            {
//
//            }

    
//    if ((arc > (3.0f/4.0f)*M_PI &&  arc < M_PI) || (arc < -(3.0f/4.0f)*M_PI &&  arc > -M_PI)) {
//        rockerDirection = LockDirectionLeft;
//    }else if (arc > (1.0f/4.0f)*M_PI &&  arc < (3.0f/4.0f)*M_PI) {
//        rockerDirection = LockDirectionUp;
//    }else if ((arc > 0 &&  arc < (1.0f/4.0f)*M_PI) || (arc < 0 &&  arc > -(1.0f/4.0f)*M_PI)) {
//        rockerDirection = LockDirectionRight;
//    }else if (arc > -(3.0f/4.0f)*M_PI &&  arc < -(1.0f/4.0f)*M_PI) {
//        rockerDirection = LockDirectionDown;
//    }else if (0 == _x && 0 == _y)
//    {
//        rockerDirection = LockDirectionCenter;
//    }
    
    if (-1 != rockerDirection) {
        _direction = rockerDirection;
        
        if ([self.delegate respondsToSelector:@selector(clrockerDidChangeDirection:)])
        {
            [self.delegate clrockerDidChangeDirection:self];
        }
    }
    
    
}
@end
