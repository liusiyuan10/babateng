//
//  QClockBellCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/28.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QClockBellCell.h"

#import "Header.h"

@implementation QClockBellCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = DefaultBackgroundColor;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 0, kDeviceWidth-50, 64)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.titleLabel];
        
        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
        self.selectBtn.imageEdgeInsets = UIEdgeInsetsMake(24, kDeviceWidth- 40, 24, 24);//设置边距
        
        [self.selectBtn setImage:[UIImage imageNamed:@"clock_normal"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"clock_select"] forState:UIControlStateSelected];
        [self.selectBtn addTarget:self action:@selector(selectPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.selectBtn];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 63, kDeviceWidth - 28, 1)];
    
        lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
        [self addSubview:lineView];
        
    }
    return self;
}

- (void)selectPressed:(UIButton *)sender{
    self.isSelect = !self.isSelect;
    if (self.qhxSelectBlock) {
        self.qhxSelectBlock(self.isSelect,sender.tag);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
