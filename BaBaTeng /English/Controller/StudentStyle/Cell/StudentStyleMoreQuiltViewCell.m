//
//  QAlbumListQuiltViewCell.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/9/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "StudentStyleMoreQuiltViewCell.h"

@implementation StudentStyleMoreQuiltViewCell


@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;
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
        
        _photoView.layer.cornerRadius = 15.0;
        _photoView.layer.masksToBounds = YES;
        _photoView.layer.borderWidth = 1.0;
        _photoView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;

        _photoView.clipsToBounds = YES;//去除边界
        

        
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
        _titleLabel.textColor =[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        _titleLabel.font=[UIFont boldSystemFontOfSize:18.0f];
        _titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
//        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        

        
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)titlesubLabel {
    if (!_titlesubLabel) {
        _titlesubLabel = [[UILabel alloc] init];
        _titlesubLabel.textColor =[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
        _titlesubLabel.font=[UIFont systemFontOfSize:14.0f];
//        _titlesubLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _titlesubLabel.textAlignment = NSTextAlignmentLeft;
//        _titlesubLabel.numberOfLines = 0;
        _titlesubLabel.backgroundColor = [UIColor clearColor];
        
        
        [self addSubview:_titlesubLabel];
    }
    return _titlesubLabel;
}


- (void)layoutSubviews {
    
    self.photoView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);


    
    UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, self.bounds.size.width - 46, 30, 30)];
    
    playImageView.image = [UIImage imageNamed:@"studentstyle_play"];
    
    [self.photoView addSubview:playImageView];

//    CGFloat titleW = [self getWidthWithText:self.titleLabel.text height:20.0 font:18.0];
    
    self.titleLabel.frame = CGRectMake(0,  self.photoView.frame.size.height+16,
                                       self.bounds.size.width, 17);
    
//    CGFloat titlesubW = [self getWidthWithText:self.titlesubLabel.text height:20.0 font:14.0];
    
    
//    self.titlesubLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame) + 3,  self.photoView.frame.size.height+5,
//                                       titlesubW, 20);
    
//    CGFloat titlesubW = self.bounds.size.width - CGRectGetMaxX(self.titleLabel.frame)  - 3;
//
//    CGFloat titlesubH = [self getLabelHeightWithText:self.titlesubLabel.text width:titlesubW font:14.0];
    
    self.titlesubLabel.frame = CGRectMake(0,  CGRectGetMaxY(self.titleLabel.frame)+8,
                                        self.bounds.size.width, 13);
    
    
}

- (CGFloat)getWidthWithText:(NSString *)text height:(CGFloat)height font:(CGFloat)font{
    
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    
    return rect.size.width;
    
    
}

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font

{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    
    
    return rect.size.height;
    
    
    
    
}

@end
