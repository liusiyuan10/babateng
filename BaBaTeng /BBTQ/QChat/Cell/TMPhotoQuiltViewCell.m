//
//  TMQuiltView
//
//  Created by Bruno Virlet on 7/20/12.
//
//  Copyright (c) 2012 1000memories

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
//  to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
//  and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR 
//  OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
//  DEALINGS IN THE SOFTWARE.
//


#import "TMPhotoQuiltViewCell.h"
//#import "MyUtility.h"

const CGFloat kTMPhotoQuiltViewMargin = 15;

@implementation TMPhotoQuiltViewCell


@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;
@synthesize picHeight;


- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
//        CALayer *layer= [self layer];
        
        //
//        [layer setShadowOffset:CGSizeMake(0.2, 0.3)];
//        [layer setShadowRadius:1.8];
//        [layer setShadowOpacity:0.2];
//        [layer setShadowColor:[UIColor colorWithWhite:0.1f alpha:0.3f].CGColor];
//        
//        
//        [layer setCornerRadius:3];
//        [layer setBorderWidth:0.6];
//        [layer setBorderColor:[UIColor colorWithWhite:0.85 alpha:1.0f].CGColor];
        
         
        //self.clipsToBounds=YES;
        
        
        
//        bottomCainter= [[UIView alloc] initWithFrame:CGRectMake(0, 0,100, 20)];
//        bottomCainter.backgroundColor=[UIColor redColor];
      self.backgroundColor = [UIColor clearColor];
//        [self addSubview:bottomCainter];
        


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


- (UIImageView *)toprightImageView {
    if (!_toprightImageView) {
        _toprightImageView = [[UIImageView alloc] init];
        _toprightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _toprightImageView.backgroundColor = [UIColor clearColor];
        
        _toprightImageView.clipsToBounds = YES;
        [self addSubview:_toprightImageView];
    }
    return _toprightImageView;
}


- (UIImageView *)lowerrightImageView {
    
    if (!_lowerrightImageView) {
        
        _lowerrightImageView = [[UIImageView alloc] init];
        _lowerrightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _lowerrightImageView.backgroundColor = [UIColor clearColor];
        
        _lowerrightImageView.clipsToBounds = YES;
        
        [self addSubview:_lowerrightImageView];
    }
    return _lowerrightImageView;
}



- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor =[UIColor colorWithRed:21/255.0 green:28/255.0 blue:29/255.0 alpha:1.0];
        _titleLabel.font=[UIFont systemFontOfSize:12.0f];
        _titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}
    
- (void)layoutSubviews {
     
    self.photoView.frame = CGRectMake(15, 6, self.bounds.size.width-30, self.bounds.size.width-30);
    
//    [self.photoView.layer setCornerRadius:(self.photoView.frame.size.height/2)];
    
      [self.photoView.layer setCornerRadius:((self.bounds.size.width-30)/2)];
    
    
    self.toprightImageView.frame =  CGRectMake(self.bounds.size.width-30, 10,20, 20);
    //[self.toprightImageView.layer setCornerRadius:(15.0)];
    
    
    self.lowerrightImageView.frame =  CGRectMake(self.bounds.size.width-30, self.bounds.size.width-50,20, 20);
    

    
   // [self.lowerrightImageView.layer setCornerRadius:(15.0)];
    
//     CGSize contentSize=[MyUtility rectForString:_titleLabel.text font:[UIFont fontWithName:nil size:11.0f] andWidth:(self.bounds.size.width - 2 * kTMPhotoQuiltViewMargin)];
    
    self.titleLabel.frame = CGRectMake(0,  self.photoView.frame.size.height+ 8*2,
                                       self.bounds.size.width , 40);

//    [self.titleLabel sizeToFit];
 
//    CGRect origionFrame=bottomCainter.frame;
//    bottomCainter.frame=CGRectMake(4, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height, origionFrame.size.width, 20);
// 
    
}

@end
