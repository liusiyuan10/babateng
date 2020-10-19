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


#import "TMForeigenQuiltViewCell.h"
#import "MyUtility.h"

const CGFloat kTMForeigenQuiltViewMargin = 14;

@implementation TMForeigenQuiltViewCell


@synthesize photoView = _photoView;
@synthesize titleLabel = _titleLabel;
@synthesize buyLabel = _buyLabel;
@synthesize picHeight;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor=[UIColor whiteColor];
        CALayer *layer= [self layer];
        
        //
//        [layer setShadowOffset:CGSizeMake(0, -3)];
//        [layer setShadowRadius:1.8];
//        [layer setShadowOpacity:2];
//        [layer setShadowColor:[UIColor redColor].CGColor];
        
        
        [layer setCornerRadius:10];
        [layer setBorderWidth:0.6];
        [layer setBorderColor:[UIColor colorWithWhite:0.85 alpha:1.0f].CGColor];
        
         
        self.clipsToBounds=YES;
        
        
        
//        bottomCainter= [[UIView alloc] init];
//        bottomCainter.backgroundColor=[UIColor clearColor];
//        [self addSubview:bottomCainter];
//
//
//
//        UIFont *promptFont=[UIFont fontWithName:nil size:10.0f];
//
//        self.likePrompt=[[UILabel alloc]init];
//        self.likePrompt.frame=CGRectMake(0, 0, 50, 20);
//        self.likePrompt.textColor = [UIColor colorWithWhite:0.42 alpha:1.0f];
//        self.likePrompt.textAlignment = NSTextAlignmentLeft;
//        self.likePrompt.font = promptFont;
//        [bottomCainter addSubview:self.likePrompt];
//
//        self.commontPrompt=[[LPLabel alloc]init];
//        self.commontPrompt.frame=CGRectMake(50, 0, 50, 20);
//        self.commontPrompt.textColor = [UIColor colorWithWhite:0.42 alpha:1.0f];
//        self.commontPrompt.textAlignment = NSTextAlignmentLeft;
//        self.commontPrompt.font = promptFont;
//         self.commontPrompt.strikeThroughColor = [UIColor grayColor];
//        [bottomCainter addSubview:self.commontPrompt];
//
//        self.buyLabel=[[UILabel alloc]init];
//        self.buyLabel.frame=CGRectMake(100, 0, 50, 20);
//        self.buyLabel.textColor = [UIColor colorWithWhite:0.42 alpha:1.0f];
//        self.buyLabel.textAlignment = NSTextAlignmentLeft;
//        self.buyLabel.font = promptFont;
//
//
//        [bottomCainter addSubview:self.buyLabel];

    }
    return self;
}

- (UIImageView *)photoView {
    if (!_photoView) {
        _photoView = [[UIImageView alloc] init];
        _photoView.contentMode = UIViewContentModeScaleAspectFill;
        _photoView.clipsToBounds = YES;
        [self addSubview:_photoView];
    }
    return _photoView;
}
-(void)setPhotoImage:(UIImage *)anImage{
    _photoView.image=anImage;

}


- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor =[UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        _titleLabel.font=[UIFont fontWithName:nil size:13.0f];
        _titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        _titleLabel.backgroundColor= [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}


- (UILabel *)buyLabel {
    if (!_buyLabel) {
        _buyLabel = [[UILabel alloc] init];
        _buyLabel.textColor =[UIColor colorWithRed:255/255.0 green:127/255.0 blue:0/255.0 alpha:1.0];
        _buyLabel.font=[UIFont boldSystemFontOfSize:16.0f];
//        _buyLabel.lineBreakMode=NSLineBreakByWordWrapping;
//        _buyLabel.numberOfLines = 0;
        _buyLabel.backgroundColor= [UIColor clearColor];
        [self addSubview:_buyLabel];
    }
    return _buyLabel;
}
- (void)layoutSubviews {
     
    self.photoView.frame = CGRectMake(0, 0, self.bounds.size.width, picHeight);
     CGSize contentSize=[MyUtility rectForString:_titleLabel.text font:[UIFont fontWithName:nil size:11.0f] andWidth:(self.bounds.size.width - 2 * kTMForeigenQuiltViewMargin)];
    self.titleLabel.frame = CGRectMake(kTMForeigenQuiltViewMargin,  self.photoView.frame.size.height+ kTMForeigenQuiltViewMargin,
                                       self.bounds.size.width - 2 * kTMForeigenQuiltViewMargin, contentSize.height);

    [self.titleLabel sizeToFit];
    
    self.buyLabel.frame = CGRectMake(kTMForeigenQuiltViewMargin, CGRectGetMaxY(self.titleLabel.frame) + kTMForeigenQuiltViewMargin, self.bounds.size.width - 2 * kTMForeigenQuiltViewMargin, 13);
    
 
//    bottomCainter.frame=CGRectMake(5, self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+5,self.bounds.size.width-10, 20);
//    bottomCainter.backgroundColor = [UIColor redColor];
//    self.backgroundColor = [UIColor greenColor];
//
}

@end
