//
//  QTalkCell.m
//  BaBaTeng
//
//  Created by liu on 17/5/19.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//
//
//#import "QTalkCell.h"
//
//@implementation QTalkCell
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//@end



#import "QTalkCell.h"
#import "QTalk.h"
#import "QTalkFrame.h"
#import "UIImage+Extension.h"


@interface QTalkCell ()
@property(nonatomic, strong) UILabel *timeView;
@property(nonatomic, strong) UIImageView *iconView;
//@property(nonatomic, strong) UIButton *textView;
@property(nonatomic, strong) UILabel *nameLabel;
@end

@implementation QTalkCell


// 1.创建自定义可重用的cell对象
+ (instancetype)messageCellWithTableView:(UITableView *)tableView
{
    
//    NSString *CellIdentifier = @"songcellID";
//    QSongCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (cell==nil) {
//        
//        cell = [[QSongCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//        //        cell.backgroundColor = [UIColor whiteColor];
//    }
    
    static NSString *reuseId = @"msg";
    
    QTalkCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [[QTalkCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

// 2.创建子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
        
        // 时间
        UILabel *timeView = [[UILabel alloc] init];
        [self.contentView addSubview:timeView];
        self.timeView = timeView;
        timeView.font = [UIFont systemFontOfSize:11.0];
        timeView.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
        timeView.textAlignment = NSTextAlignmentCenter;
        
        //用户名
        
        UILabel *nameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:nameLabel];
        
        nameLabel.font = [UIFont systemFontOfSize:11.0];
        nameLabel.textColor = [UIColor redColor];//[UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
        self.nameLabel = nameLabel;
//        timeView.textAlignment = NSTextAlignmentCenter;
//          if (msg.type == QTalkTypeSelf) {
//          }
//        else
//        {
//            
//        }
        
        // 头像
        UIImageView *iconView = [[UIImageView alloc] init];
        [self.contentView addSubview:iconView];
        self.iconView = iconView;
        // 设置圆形头像
        iconView.layer.cornerRadius = 7;
        iconView.layer.masksToBounds = YES;
        
        // 聊天内容
        UIButton *textView = [[UIButton alloc] init];
        [self.contentView addSubview:textView];
        self.textView = textView;
        textView.titleLabel.font = [UIFont systemFontOfSize:CZFONTSIZE];
        textView.titleLabel.numberOfLines = 0;
        [textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        textView.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        //        textView.backgroundColor = [UIColor redColor];
        
        [textView addTarget:self action:@selector(textBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
    }
    return self;
}


- (void)textBtnClicked:(UIButton *)btn
{
    //    NSLog(@"textBtnClicked");
    
    //通知代理
    if ([self.delegate respondsToSelector:@selector(qtalkCell:pathIndex:)]) {
        [self.delegate qtalkCell:self  pathIndex:btn.tag];
    }
    
}

// 3.重写属性的setter方法
- (void)setMessageFrame:(QTalkFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    [self settingData];
    
    [self settingFrame];
    
    
}

- (void)settingData
{
    QTalk *msg = self.messageFrame.message;
    
    self.timeView.text = msg.time;
    
    if (msg.type == QTalkTypeSelf)
    {
        self.iconView.image = [UIImage imageNamed:@"me"];
        
    }
    else
    {
        self.iconView.image = [UIImage imageNamed:@"other"];
    }
    
    [self.textView setTitle:msg.text forState:UIControlStateNormal];
    // 设置名字
    self.nameLabel.text = @"用户";
    
    if (msg.type == QTalkTypeSelf) {
        self.nameLabel.textAlignment = NSTextAlignmentRight;
      }
    else
    {
      self.nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    // 设置消息的背景图片
    if (msg.type == QTalkTypeSelf) {
        

        
        [self.textView setBackgroundImage:[UIImage resizeImage:@"chat_send_nor"] forState:UIControlStateNormal];
        [self.textView setBackgroundImage:[UIImage resizeImage:@"chat_send_press_pic"] forState:UIControlStateHighlighted];
        
        [self.textView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    else{
        [self.textView setBackgroundImage:[UIImage resizeImage:@"chat_recive_nor"] forState:UIControlStateNormal];
        [self.textView setBackgroundImage:[UIImage resizeImage:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
        
         [self.textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
}
- (void)settingFrame
{
    

    
    self.timeView.frame = self.messageFrame.timeFrame;
    
    
    self.iconView.frame = self.messageFrame.iconFrame;
    
    self.textView.frame = self.messageFrame.textFrame;
    
    self.nameLabel.frame = self.messageFrame.nameFrame;
    
}


@end
