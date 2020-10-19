//
//  NewMultilevelTableViewCell.h
//  YijietongBuy
//
//  Created by YangGH on 15/11/19.
//  Copyright © 2015年 YangGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMultilevelTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *labTip;
@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UIImageView *rightLineImage;


-(void)setZero;
@end
