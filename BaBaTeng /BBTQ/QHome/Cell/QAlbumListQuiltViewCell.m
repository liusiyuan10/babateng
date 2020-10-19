//
//  QAlbumListQuiltViewCell.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/9/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QAlbumListQuiltViewCell.h"

@implementation QAlbumListQuiltViewCell


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
        _titleLabel.textColor =[UIColor colorWithRed:21/255.0 green:28/255.0 blue:29/255.0 alpha:1.0];
        _titleLabel.font=[UIFont systemFontOfSize:12.0f];
        _titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
//        [_titleLabel setContentMode:UIViewContentModeTop];
        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (void)layoutSubviews {
    
    self.photoView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);

   // [self.photoView.layer setCornerRadius:((self.bounds.size.width-30)/2)];
    
    
    self.titleLabel.frame = CGRectMake(0,  self.photoView.frame.size.height+5,
                                       self.bounds.size.width , 40);
    
}


@end
