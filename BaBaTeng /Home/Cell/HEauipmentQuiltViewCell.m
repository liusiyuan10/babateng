//
//  HEauipmentQuiltViewCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/30.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//#import "HEauipmentQuiltViewCell.h"
//
//@implementation HEauipmentQuiltViewCell
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end

#import "HEauipmentQuiltViewCell.h"

@implementation HEauipmentQuiltViewCell


@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;
@synthesize picHeight;


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        
        self.backgroundColor = [UIColor clearColor];
        
        
        
        
    }
    return self;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.backgroundColor = [UIColor clearColor];
        
        _photoView.clipsToBounds = YES;
        
        [self addSubview:_photoView];
    }
    return _photoView;
}
-(void) setPhotoImage:(UIImage *)anImage{
    _photoView.image=anImage;
    
}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor =[UIColor colorWithRed:114/255.0 green:77/255.0 blue:90/255.0 alpha:1.0];
        _titleLabel.font=[UIFont systemFontOfSize:11.0f];
        _titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)layoutSubviews {
    
    self.photoView.frame = CGRectMake((self.bounds.size.width-60)/2, 0, 60, 60);
    
    // [self.photoView.layer setCornerRadius:((self.bounds.size.width-30)/2)];
    
    
    self.titleLabel.frame = CGRectMake(0,  self.photoView.frame.size.height+5,
                                       self.bounds.size.width , 12);
    
}


@end

