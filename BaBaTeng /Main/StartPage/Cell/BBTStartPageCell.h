//
//  BBTStartPageCell.h
//  BaBaTeng
//
//  Created by liu on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTStartPageCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, weak) UIButton *registerButton;
@property (nonatomic, weak) UIButton *loginButton;


// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count;

@end
