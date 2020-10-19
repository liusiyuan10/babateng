//
//  QChatCell.h
//  BaBaTeng
//
//  Created by liu on 17/8/21.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>


@class  QChatMessageCell,QChatMessageFrame;

@protocol QChatMessageCellDelegate <NSObject>

-(void)qtalkCell:(QChatMessageCell *)textBtnClicked pathIndex:(NSInteger)pathindex;
-(void)qtalkerrorBtnCell:(QChatMessageCell *)errorBtnClicked pathIndex:(NSInteger)pathindex;

@end

@interface QChatMessageCell : UITableViewCell

@property(nonatomic, strong) QChatMessageFrame *messageFrame;

+ (instancetype)messageCellWithTableView:(UITableView *)tableView;

@property(nonatomic,weak)id<QChatMessageCellDelegate> delegate;

@property(nonatomic, strong)  UIButton *textView;

@property(nonatomic, strong)UIImageView *voiceView;

@property(nonatomic, strong)  UIButton *errorBtn;

@property(nonatomic, strong)  UIActivityIndicatorView *activity;

@end
