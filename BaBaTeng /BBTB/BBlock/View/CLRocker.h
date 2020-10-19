//
//  CLRocker.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/17.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface CLRocker : UIView
//
//@end


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LockerStyle)
{
    LockStyleOpaque = 0,
    LockStyleTranslucent
};

typedef NS_ENUM(NSInteger, LockDirection)
{
    LockDirectionLeft = 0,
    LockDirectionUp,
    LockDirectionRight,
    LockDirectionDown,
    LockDirectionCenter,
    LockDirectionFive,
    LockDirectionSix,
    LockDirectionSeven,
    LockDirectionEight,
    
};

@protocol CLRockerDelegate;

@interface CLRocker : UIView

@property (weak ,nonatomic) id <CLRockerDelegate> delegate;
@property (nonatomic, readonly) LockDirection direction;



- (void)setLockerStyle:(LockerStyle)style;

@end


@protocol CLRockerDelegate <NSObject>
@optional
- (void)clrockerDidChangeDirection:(CLRocker *)rocker;
@end
