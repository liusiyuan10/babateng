//
//  ZMRocker.m
//  ZMRockerDemo
//
//  Created by 钱长存 on 15-1-26.
//  Copyright (c) 2015年 com.zmodo. All rights reserved.
//

#import "XXZMRocker.h"

#define kRadius ([self bounds].size.width * 0.5f)
#define kTrackRadius kRadius * 0.8f

@interface XXZMRocker ()
{
    CGFloat _x;
    CGFloat _y;
}

@property (strong, nonatomic) UIImageView *handleImageView;
@end

@implementation XXZMRocker

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
    [self setRockerStyle:XXRockStyleTranslucent];
    
    _direction = XXRockDirectionCenter;
    
    if (!_handleImageView) {
        UIImage *handleImage = [UIImage imageNamed:@"XXhandleNormal"];
        
        _handleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*0.5f-handleImage.size.width*0.5f,
                                                                         self.bounds.size.height*0.5f-handleImage.size.height*0.5f,
                                                                         handleImage.size.width,
                                                                         handleImage.size.height)];
        _handleImageView.image = handleImage;

        [self addSubview:_handleImageView];
    }
    
    _x = 0;
    _y = 0;

}
- (void)setRockerStyle:(XXRockStyle)style
{
    NSArray *imageNames = @[@"XXrockerOpaqueBg",@"XXrockerTranslucentBg"];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:imageNames[style]]]];
}

- (void)resetHandle
{
    _handleImageView.image = [UIImage imageNamed:@"XXhandleNormal"];

    _x = 0.0;
    _y = 0.0;
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(([self bounds].size.width - [_handleImageView bounds].size.width) * 0.5f,
                                          ([self bounds].size.height - [_handleImageView bounds].size.height) * 0.5f);
    [_handleImageView setFrame:handleImageFrame];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"XXrockerTranslucentBg"]]];

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
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(location.x - ([_handleImageView bounds].size.width * 0.5f),
                                          location.y - ([_handleImageView bounds].size.width * 0.5f));
    [_handleImageView setFrame:handleImageFrame];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _handleImageView.image = [UIImage imageNamed:@"XXhandlePressed"];
    
    [self setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"XXrockerOpaqueBg"]]];
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self setHandlePositionWithLocation:location];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [[touches anyObject] locationInView:self];
    
    [self setHandlePositionWithLocation:location];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    
    [self rockerValueChanged];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetHandle];
    
    [self rockerValueChanged];
    
  
}

- (void)rockerValueChanged
{
    NSInteger rockerDirection = -1;

    float arc = atan2f(_y,_x);
    
    if ((arc > (3.0f/4.0f)*M_PI &&  arc < M_PI) || (arc < -(3.0f/4.0f)*M_PI &&  arc > -M_PI)) {
        rockerDirection = XXRockDirectionLeft;
    }else if (arc > (1.0f/4.0f)*M_PI &&  arc < (3.0f/4.0f)*M_PI) {
        rockerDirection = XXRockDirectionUp;
    }else if ((arc > 0 &&  arc < (1.0f/4.0f)*M_PI) || (arc < 0 &&  arc > -(1.0f/4.0f)*M_PI)) {
        rockerDirection = XXRockDirectionRight;
    }else if (arc > -(3.0f/4.0f)*M_PI &&  arc < -(1.0f/4.0f)*M_PI) {
        rockerDirection = XXRockDirectionDown;
    }else if (0 == _x && 0 == _y)
    {
        rockerDirection = XXRockDirectionCenter;
    }
    
    if (-1 != rockerDirection && rockerDirection != _direction) {
        _direction = rockerDirection;
        
        if ([self.delegate respondsToSelector:@selector(rockerDidChangeDirection:)])
        {
            [self.delegate rockerDidChangeDirection:self];
        }
    }
}
@end
