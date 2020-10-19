//
//  QCategoryCollectionViewCell.m
//  BaBaTeng
//
//  Created by liu on 17/6/13.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import "QCategoryCollectionViewCell.h"
//
//@implementation QCategoryCollectionViewCell
//
//@end


#import "QCategoryCollectionViewCell.h"

@implementation QCategoryCollectionViewCell

-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 15, (375 - 60) /3.0, 20)];
        
        
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        
//        self.nameLabel.text = @"洗澡";
        
        self.nameLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
        
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:self.nameLabel];
        
        
        
    }
    
    return self;
    
}


@end
