//
//  QCategoryCell.h
//  BaBaTeng
//
//  Created by liu on 17/6/12.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QCategoryCell : UITableViewCell
//
//@property (nonatomic, assign) CGFloat cellHight;
//
////- (void)setCellHight:(CGFloat)cellHight;
//
//@end


#import <UIKit/UIKit.h>


@interface AFIndexedCollectionView : UICollectionView

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

static NSString *CollectionViewCellIdentifier = @"CollectionViewCellIdentifier";

@interface QCategoryCell : UITableViewCell

@property (nonatomic, strong) AFIndexedCollectionView *collectionView;

@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *leftImageView;

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath;

@end
