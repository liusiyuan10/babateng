//
//  GYZSheetView.m
//  GYZCustomActionSheet
//  
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import "BPlaySheetView.h"
#import "BPlaySheetCell.h"
#import "BPlayCommon.h"
#import "Header.h"
#define GYZSHEETCELL @"BPlaySheetCell"

@implementation BPlaySheetView

// 代码创建输入框视图
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]){
        
        self.divLine = [[UIView alloc]init];
        self.divLine.backgroundColor = kGrayLineColor;
        [self addSubview:self.divLine];
        
        self.tableView = [[UITableView alloc]init];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:self.tableView];
        
        [self.tableView registerClass:[BPlaySheetCell class] forCellReuseIdentifier:GYZSHEETCELL];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.divLine.frame = CGRectMake(0, 0, self.frame.size.width, kLineHeight);
    self.tableView.frame = CGRectMake(0, MaxY(self.divLine), WIDTH(self), HEIGHT(self));
}

#pragma mark - UITableView数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BPlaySheetCell *cell= [tableView dequeueReusableCellWithIdentifier:GYZSHEETCELL forIndexPath:indexPath];
    
    
    
    if (_cellTextColor) {
        cell.myLabel.textColor = _cellTextColor;
    }
    
    self.resultRespone = _dataSource[indexPath.row];
    
    if (!IsStrEmpty(self.resultRespone.trackName)) {
        
         cell.myLabel.text =self.resultRespone.trackName;
        
    }else{
        
        cell.myLabel.text =@"无数据";
    }
   
    
    if (_cellTextFont) {
        cell.myLabel.font = _cellTextFont;
    }

    cell.myLabel.textAlignment = NSTextAlignmentLeft;

    
    if (_showTableDivLine) {
        cell.tableDivLine.hidden = NO;
    }
    
    if( self.resultRespone.isPlaying==YES){
         cell.myLabel.textColor =NavBackgroundColor;
        cell.myImageView.hidden = NO;
        cell.myLabel.frame = CGRectMake(35, 0, kScreenWidth-20-40, 44.5);
        cell.myImageView.frame = CGRectMake(10, 13,19, 14);
        [self startAnimation:cell.myImageView];
    
    }else{
         cell.myLabel.textColor = [UIColor blackColor];
        [cell.myImageView stopAnimating];
         cell.myLabel.frame = CGRectMake(15, 0, kScreenWidth-20-25, 44.5);
        cell.myImageView.hidden = YES;
    }
    
    return cell;
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row;
    //GYZSheetCell *cell = (GYZSheetCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    //NSString *cellTitle = cell.myLabel.text;
    
    //self.productRespone =_dataSource[indexPath.row];
    
    for (int i=0; i<_dataSource.count; i++) {
        
         self.resultRespone = _dataSource[i];
        
        self.resultRespone.isPlaying =NO;
           
      
    }
    
    self.resultRespone = _dataSource[indexPath.row];
    self.resultRespone.isPlaying =YES;
    
    [self.tableView  reloadData];
   
    
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectIndex:selectTitle:)]) {
        [self.delegate sheetViewDidSelectIndex:index selectTitle: _dataSource[indexPath.row]];
    }
}
@end
