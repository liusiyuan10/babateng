//
//  NewCollectionHeader.m
//  YijietongBuy
//
//  Created by YangGH on 16/2/2.
//  Copyright © 2016年 YangGH. All rights reserved.
//

#import "NewCollectionHeader.h"
#import "UIColor+SNFoundation.h"
#import "UIColor+Helper.h"
@implementation NewCollectionHeader


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
//        _headerImageView = [[UIView alloc] initWithFrame:CGRectMake(15,16,8, 8)];
         _headerImageView = [[UIView alloc] initWithFrame:CGRectMake(12.5,(50 - 16)/2,5, 16)];
        _headerImageView.backgroundColor = [UIColor clearColor];
//        [_headerImageView.layer setCornerRadius:4];
        [self addSubview:_headerImageView];
        
        _headerTitile = [[UILabel alloc]init];
        [_headerTitile setFrame:CGRectMake(25,(50 - 20)/2, 100,20)];
//        [_headerTitile setBackgroundColor:[UIColor redColor]];
        _headerTitile.textAlignment = NSTextAlignmentLeft;
         _headerTitile.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0  blue:51.0/255.0  alpha:1];
        _headerTitile.font = [UIFont systemFontOfSize:13.0];
        
        [self addSubview:_headerTitile];
        
        
        self.backgroundColor = [UIColor colorWithRGBHex:0xfbfafa];
    }
    return self;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
