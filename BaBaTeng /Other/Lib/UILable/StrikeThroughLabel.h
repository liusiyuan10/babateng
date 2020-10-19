//
//  StrikeThroughLabel.h
//  YijietongBuy
//
//  Created by YangGH on 15/10/9.
//  Copyright © 2015年 YangGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StrikeThroughLabel : UILabel
{
    BOOL isWithStrikeThrough_;
    
    CALayer *line;
}

@property (nonatomic, assign) BOOL isWithStrikeThrough;

@end
