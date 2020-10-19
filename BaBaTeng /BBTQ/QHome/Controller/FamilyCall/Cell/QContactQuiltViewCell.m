//
//  QContactQuiltViewCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QContactQuiltViewCell.h"
#import "Header.h"

@implementation QContactQuiltViewCell


@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;
@synthesize numLabel = _numLabel;
@synthesize picHeight;


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
 
    }
    return self;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.backgroundColor = [UIColor clearColor];
        
//        _photoView.layer.cornerRadius = 32;
//        _photoView.layer.masksToBounds = YES;
        
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
        _titleLabel.textColor =[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        _titleLabel.font=[UIFont systemFontOfSize:16.0f];
        _titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)numLabel {
    if (!_numLabel) {
        _numLabel = [[UILabel alloc] init];
        _numLabel.textColor =[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
        _numLabel.font=[UIFont systemFontOfSize:12.0f];
        _numLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _numLabel.textAlignment = NSTextAlignmentLeft;
        _numLabel.numberOfLines = 0;
        _numLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_numLabel];
    }
    return _numLabel;
}

- (void)layoutSubviews {
    
    CGFloat Kwidth = self.bounds.size.width;
    
    self.photoView.frame = CGRectMake(0/375.0 * kDeviceWidth, 28, 64, 64);
    
    // [self.photoView.layer setCornerRadius:((self.bounds.size.width-30)/2)];
    
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.photoView.frame) + 8,  38,
                                       80 , 22);
    
    self.numLabel.frame = CGRectMake(CGRectGetMaxX(self.photoView.frame) + 8,  CGRectGetMaxY(self.titleLabel.frame) + 8,85, 17);
    
}


@end
