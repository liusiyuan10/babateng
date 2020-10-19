//
//  FavoriteCell.h
//  BaBaTeng
//
//  Created by liu on 17/2/17.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EquipmentCell : UITableViewCell
@property(nonatomic,strong)UIImageView *bgImageView;
@property(nonatomic,strong)UILabel *nameLabel;
//@property(nonatomic,strong)UILabel *onlineLabel;
@property(nonatomic,strong)UIImageView *leftImage;
@property(nonatomic,strong)UIImageView *selecetedCellBG;
@property(nonatomic,strong)UIImageView *normalCellBG;
//需要画一条横线
@property(nonatomic,strong)UIImageView *topImageView;

@end
