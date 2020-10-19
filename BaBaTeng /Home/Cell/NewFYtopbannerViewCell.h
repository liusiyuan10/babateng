//
//  FYFiveViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/11.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewFYtopbannerViewCellDelegate <NSObject>

@optional
-(void)NewdidSelectedTopbannerViewCellIndex:(NSInteger)index;

@end

@interface NewFYtopbannerViewCell : UITableViewCell

@property (nonatomic, assign) id<NewFYtopbannerViewCellDelegate> delegate;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)array;

-(void)addTimer;
-(void)closeTimer;

@end
