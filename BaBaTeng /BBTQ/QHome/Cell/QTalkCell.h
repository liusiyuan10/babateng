//
//  QTalkCell.h
//  BaBaTeng
//
//  Created by liu on 17/5/19.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QTalkCell : UITableViewCell
//
//@end

#import <UIKit/UIKit.h>

@class  QTalkCell,QTalkFrame;

@protocol QTalkCellDelegate <NSObject>

-(void)qtalkCell:(QTalkCell *)textBtnClicked pathIndex:(NSInteger)pathindex;

@end

@interface QTalkCell : UITableViewCell

@property(nonatomic, strong) QTalkFrame *messageFrame;

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@property(nonatomic,weak)id<QTalkCellDelegate> delegate;

@property(nonatomic, strong)UIButton *textView;

@end

