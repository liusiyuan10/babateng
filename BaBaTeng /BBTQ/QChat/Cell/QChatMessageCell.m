//
//  QChatCell.m
//  BaBaTeng
//
//  Created by liu on 17/8/21.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QChatMessageCell.h"
#import "QChatMessage.h"
#import "QChatMessageFrame.h"
#import "UIImage+Extension.h"
#import "Header.h"

#import "UIImageView+AFNetworking.h"


@interface QChatMessageCell ()

@property(nonatomic, strong) UILabel *timeView;

@property(nonatomic, strong) UIImageView *iconView;

@property(nonatomic, strong) UILabel *nameLabel;
@end

@implementation QChatMessageCell


// 1.创建自定义可重用的cell对象
+ (instancetype)messageCellWithTableView:(UITableView *)tableView
{

    static NSString *reuseId = @"msg";
    
    QChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if(cell == nil)
    {
        cell = [[QChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    return cell;
}

// 2.创建子控件
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.backgroundColor = [UIColor clearColor];
//        self.backgroundColor = [UIColor redColor];
        
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
        nameLabel.textColor = [UIColor colorWithRed:119/255.0 green:116/255.0 blue:116/255.0 alpha:1.0];
        self.nameLabel = nameLabel;

        
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
        
        self.errorBtn = [[UIButton alloc] init];
        
        [self.errorBtn setImage:[UIImage imageNamed:@"errorbtn"] forState:UIControlStateNormal];
        
        [self.errorBtn addTarget:self action:@selector(errorBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.errorBtn];
        
        //发送中动画
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGAffineTransform transform = CGAffineTransformMakeScale(.9f, .9f);
        _activity.transform = transform;
        _activity.hidden = YES;
        _activity.userInteractionEnabled  = NO;
        [self.contentView addSubview:_activity];


 
        
        UIImageView *voiceView = [[UIImageView alloc] init];
        
//        voiceView.backgroundColor = [UIColor redColor];
        
        self.voiceView = voiceView;
        
        [self.textView addSubview:voiceView];
        
        
        
    }
    return self;
}

- (void)errorBtnClicked:(UIButton *)btn
{
    btn.hidden = YES;
    // 通知代理
    if ([self.delegate respondsToSelector:@selector(qtalkerrorBtnCell:pathIndex:)]) {
        
        [self.delegate qtalkerrorBtnCell:self pathIndex:btn.tag];
    }
    
}

- (void)textBtnClicked:(UIButton *)btn
{
    //    NSLog(@"textBtnClicked");
    
//    btn.hidden = YES;
    //通知代理
    if ([self.delegate respondsToSelector:@selector(qtalkCell:pathIndex:)]) {
        [self.delegate qtalkCell:self  pathIndex:btn.tag];
    }
    
}

// 3.重写属性的setter方法
- (void)setMessageFrame:(QChatMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    
    [self settingData];
    
    [self settingFrame];
    
    
}

- (void)settingData
{
    QChatMessage *msg = self.messageFrame.message;
    
    self.timeView.text = msg.time;
    
    if (msg.type == QChatMessageSelf)
    {
//        self.iconView.image = [UIImage imageNamed:@"me"];
        
        [self.iconView setImageWithURL:[NSURL URLWithString:msg.userIcon] placeholderImage:[UIImage imageNamed:@"me"]];
        
    }
    else
    {
//        self.iconView.image = [UIImage imageNamed:@"other"];
        [self.iconView setImageWithURL:[NSURL URLWithString:msg.userIcon] placeholderImage:[UIImage imageNamed:@"me"]];
    }
    
    [self.textView setTitle:msg.text forState:UIControlStateNormal];
    // 设置名字
    self.nameLabel.text = msg.nickName;
    
    if (msg.type == QChatMessageSelf) {
        self.nameLabel.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    if (msg.type == QChatMessageSelf) {
        
        if ([msg.IsSend isEqualToString:@"1"]) {
            
            self.errorBtn.hidden = YES;
            
            if ([msg.IsSendDing isEqualToString:@"1"]) {
                
                _activity.hidden = NO;
                
          
                [_activity startAnimating];
              
                
                
                
            }else{
                
               _activity.hidden = YES;
                
                [_activity stopAnimating];
            }
        }
        else
        {
            self.errorBtn.hidden = NO;
        }

    }
    else
    {
        self.errorBtn.hidden = YES;
    }
    
    
    // 设置消息的背景图片
    if (msg.type == QChatMessageSelf) {
        
        
        [self.textView setBackgroundImage:[UIImage resizeImage:@"chat_send_nor"] forState:UIControlStateNormal];
        [self.textView setBackgroundImage:[UIImage resizeImage:@"chat_send_press_pic"] forState:UIControlStateHighlighted];
        
        [self.textView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        if ([msg.recordType isEqualToString:@"1"]) {

            self.voiceView.hidden = YES;
        }
        else
        {
            self.voiceView.hidden = NO;
            
             self.voiceView.image = [UIImage imageNamed:@"chat_send_voice"];
        }

        
    }
    else{
        
        
        [self.textView setBackgroundImage:[UIImage resizeImage:@"chat_recive_nor"] forState:UIControlStateNormal];
        [self.textView setBackgroundImage:[UIImage resizeImage:@"chat_recive_press_pic"] forState:UIControlStateHighlighted];
        
        [self.textView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if ([msg.recordType isEqualToString:@"1"]) {

            self.voiceView.hidden = YES;
        }
        else
        {
             self.voiceView.hidden = NO;
             self.voiceView.image = [UIImage imageNamed:@"chat_recive_voice"];
        }
    }
    
}
- (void)settingFrame
{
    
     QChatMessage *msg = self.messageFrame.message;
    
    self.timeView.frame = self.messageFrame.timeFrame;
    
    
    self.iconView.frame = self.messageFrame.iconFrame;
    
    self.textView.frame = self.messageFrame.textFrame;
    
    self.errorBtn.frame = self.messageFrame.errorFrame;
     _activity.frame = self.messageFrame.errorFrame;
    
    if (msg.type == QChatMessageSelf ) {
        self.voiceView.frame = CGRectMake(self.textView.frame.size.width - 20 -21, (self.textView.frame.size.height - 23)/2, 21, 23);
        
//       self.errorBtn.frame = CGRectMake(CGRectGetMaxX(self.textView.frame) - 10 - 24, (self.textView.frame.size.height - 24)/2 , 24, 24);
    }
    else
    {
       self.voiceView.frame = CGRectMake(20, (self.textView.frame.size.height - 23)/2, 21, 23);
    }
    
//    if (msg.type == QChatMessageSelf) {
//        
//    }
   
   
    
    self.nameLabel.frame = self.messageFrame.nameFrame;
    
}


-(void)startAnimation:(UIImageView*)cellImageView{
    
    NSArray *images=[NSArray arrayWithObjects:[UIImage imageNamed:@"nlk_1"],[UIImage imageNamed:@"nlk_2"],[UIImage imageNamed:@"nlk_3"],[UIImage imageNamed:@"nlk_4"],[UIImage imageNamed:@"nlk_5"], nil];
    
    //imageView的动画图片是数组images
    cellImageView .animationImages = images;
    //按照原始比例缩放图片，保持纵横比
    cellImageView.contentMode = UIViewContentModeScaleAspectFit;
    //切换动作的时间3秒，来控制图像显示的速度有多快，
    cellImageView.animationDuration = 3;
    //动画的重复次数，想让它无限循环就赋成0
    cellImageView .animationRepeatCount = 0;
    //开始动画
    [cellImageView startAnimating];
    
}


@end
