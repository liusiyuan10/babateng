//
//  QAlbumListQuiltViewCell.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/9/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <TMQuiltView/TMQuiltView.h>


#define CONTENT_HEIGHT 50
#define QuiltFont  [UIFont fontWithName:FontName size:11.0f]

@protocol  ImageFilledDelegate <NSObject>
- (void) imageChanged;
@end

@interface QAlbumListQuiltViewCell : TMQuiltViewCell{
    UIView *bottomCainter;
}

@property (nonatomic, retain) UIImageView *photoView;

@property (nonatomic, retain) UILabel *titleLabel;

@property (nonatomic, assign) float    picHeight;

@end
