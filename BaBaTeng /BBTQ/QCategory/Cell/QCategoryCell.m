//
//  QCategoryCell.m
//  BaBaTeng
//
//  Created by liu on 17/6/12.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QCategoryCell.h"
#import "Header.h"

#import "QCategoryCollectionViewCell.h"

#define cellHight self.contentView.bounds.size.height
#define Kwidth kDeviceWidth/3.0

@implementation AFIndexedCollectionView

@end

@implementation QCategoryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    //    layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.itemSize = CGSizeMake((kDeviceWidth)/3.0 - 1 , 50);
    //    layout.itemSize = CGSizeMake(40 , 40);
    layout.minimumInteritemSpacing = 1;
    // 4.设置cell之间的垂直间距
    layout.minimumLineSpacing = 1;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.collectionView = [[AFIndexedCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[QCategoryCollectionViewCell class] forCellWithReuseIdentifier:CollectionViewCellIdentifier];
    self.collectionView.backgroundColor = [UIColor colorWithRed:246 /255.0 green:246 /255.0 blue:246 /255.0 alpha:1];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    [self.contentView addSubview:self.collectionView];
    
    self.iconView = [[UIView alloc] init];
    self.iconView.backgroundColor = [UIColor whiteColor];
    
    self.titleLabel = [[UILabel alloc] init];
//    self.titleLabel.text = @"场景";
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    self.titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    [self.iconView addSubview:self.titleLabel];
    
    self.leftImageView = [[UIImageView alloc] init];
    
//    self.leftImageView.image = [UIImage imageNamed:@"changjing"];
    
    [self.iconView addSubview:self.leftImageView];
    
//    self.iconView.backgroundColor = [UIColor redColor];
    
    [self.contentView addSubview:self.iconView];
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //    self.collectionView.frame = self.contentView.bounds;
    
    //    NSLog(@"")
    
    self.collectionView.frame = CGRectMake(kDeviceWidth /3.0, 0,kDeviceWidth/3.0 * 2.0, cellHight - 10);
    
    self.iconView.frame = CGRectMake(0, 0, kDeviceWidth /3.0 - 1,cellHight - 10);
    
    self.leftImageView.frame = CGRectMake((Kwidth - 50)/2.0, (cellHight - 10 - 20)/2.0, 20, 21);
    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.leftImageView.frame)+ 2, (cellHight - 10 - 20)/2.0 + 3, 60, 20);
    
}

- (void)setCollectionViewDataSourceDelegate:(id<UICollectionViewDataSource, UICollectionViewDelegate>)dataSourceDelegate indexPath:(NSIndexPath *)indexPath
{
    self.collectionView.dataSource = dataSourceDelegate;
    self.collectionView.delegate = dataSourceDelegate;
    self.collectionView.indexPath = indexPath;
    [self.collectionView setContentOffset:self.collectionView.contentOffset animated:NO];
    
    [self.collectionView reloadData];
}

@end
