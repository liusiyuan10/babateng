//
//  Drawer_TableViewCell.m
//  XTZL
//
//  Created by 虞海飞 on 16/8/4.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import "Drawer_TableViewCell.h"

@implementation Drawer_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDic_Data:(NSDictionary *)dic_Data{
    _dic_Data = dic_Data;

    [self addView];
    self.backgroundColor = [UIColor clearColor];
}

-(void) addView{

    self.label_Title.text = self.dic_Data[@"title"];
    self.label_Title.font = [UIFont systemFontOfSize:12.0];
//    self.label_Title.backgroundColor = [UIColor colorWithRed:206/255.0 green:240/255.0 blue:255/255.0 alpha:1.0];
     self.label_Title.textColor = [UIColor whiteColor];
    self.label_Title.numberOfLines = 0;
  
}

@end
