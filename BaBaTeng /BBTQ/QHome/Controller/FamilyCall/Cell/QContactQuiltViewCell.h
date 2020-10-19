//
//  QContactQuiltViewCell.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QContactQuiltViewCell : UITableViewCell
//
//@end

#import <TMQuiltView/TMQuiltView.h>


#define CONTENT_HEIGHT 50
#define QuiltFont  [UIFont fontWithName:FontName size:11.0f]

@protocol  ImageFilledDelegate <NSObject>
- (void) imageChanged;
@end

@interface QContactQuiltViewCell : TMQuiltViewCell{
    UIView *bottomCainter;
}

@property (nonatomic, retain) UIImageView *photoView;

@property (nonatomic, retain) UILabel *titleLabel;


@property (nonatomic, retain) UILabel *numLabel;


@property (nonatomic, assign) float    picHeight;

@end
