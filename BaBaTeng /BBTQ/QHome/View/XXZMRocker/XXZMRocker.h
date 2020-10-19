//
//  ZMRocker.h
//  ZMRockerDemo
//
//  Created by 钱长存 on 15-1-26.
//  Copyright (c) 2015年 com.zmodo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XXRockStyle)
{
    XXRockStyleOpaque = 0,
    XXRockStyleTranslucent
};

typedef NS_ENUM(NSInteger, XXRockDirection)
{
    XXRockDirectionLeft = 0,
    XXRockDirectionUp,
    XXRockDirectionRight,
    XXRockDirectionDown,
    XXRockDirectionCenter,
};

@protocol XXZMRockerDelegate;

@interface XXZMRocker : UIView

@property (weak ,nonatomic) id <XXZMRockerDelegate> delegate;
@property (nonatomic, readonly) XXRockDirection direction;

- (void)setRockerStyle:(XXRockStyle)style;

@end


@protocol XXZMRockerDelegate <NSObject>
@optional
- (void)rockerDidChangeDirection:(XXZMRocker *)rocker;
@end
