//
//  EcgoSegmentTool.m
//  integral
//
//  Created by liu on 16/1/22.
//  Copyright © 2016年 ecg. All rights reserved.
//

#import "AoliSegmentTool.h"
#import "UIImage-Extensions.h"
#import "Header.h"

@implementation AoliSegmentTool

- (UIImageView *)btnClickedImg
{
    if (!_btnClickedImg) {
        _btnClickedImg = [[UIImageView alloc] init];
        _btnClickedImg.image = [UIImage streImageNamed:@"segment_line_Horizontal_green.png"];
//        _btnClickedImg.frame = CGRectMake(0, 33, kDeviceWidth/3, 2);
    }
    return _btnClickedImg;
}

- (NSMutableArray *)btnArray
{
    if (_btnArray == nil) {
        _btnArray = [NSMutableArray array];
    }
    
    return _btnArray;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        for (int i = 0; i < self.itemsArr.count; i++) {
//            NSLog(@"%@",self.itemsArr[i]);
//        }
        
    }
    return self;

   
}

- (void)drawRect:(CGRect)rect {
    
    NSInteger count = self.itemsArr.count;
    
    self.btnClickedImg.frame = CGRectMake(0, 33, kDeviceWidth/ count, 2);
    
    [self addSubview:self.btnClickedImg];
    for (int i = 0; i < count; i++) {
        
//        NSLog(@"%@",self.itemsArr[i]);
        
        [self createButton:self.itemsArr[i] Tag:i Count:self.itemsArr.count];
        

    }
    
//        self.lineView.frame = CGRectMake(self.introduceBtn.right, 7, 1, 15);
    
    for (int i = 1; i < count; i++) {
        UIImageView *lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment_line_vertical_gray.png"]];


        UIButton *btn = self.btnArray[i];
    
        CGFloat lineX = btn.frame.origin.x;

        lineView.frame = CGRectMake(lineX, 7, 1, 15);

        
        [self addSubview:lineView];
    
    }

    



}

- (void)createButton:(NSString *)btnTitle Tag:(NSInteger)tag Count:(NSInteger)count
{
    
    UIButton *btn = [[UIButton alloc] init];
    [btn addTarget:self action:@selector(btnChangeTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:btnTitle forState:UIControlStateNormal];
    
    btn.tag = tag;
    
    CGFloat w = self.frame.size.width / count;
    CGFloat h =  self.frame.size.height;
    CGFloat x = 0;
    CGFloat y = 0;
    
    [btn setTitleColor:AOLIGreenColor forState:UIControlStateSelected];
    
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    [btn setTitleColor:RGBCOLOR(93, 93, 93) forState:UIControlStateNormal];
    

    
    self.selectType = tag;
    
    if (tag == self.btntag) {
        btn.selected = YES;
        [self viewChangeWithType:self.selectType];
    }
    
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    

    
    x = tag * w;
    btn.frame = CGRectMake(x, y, w, h);
    

    [self addSubview:btn];
    
    [self.btnArray addObject:btn];
}

- (void)btnChangeTabAction:(UIButton *)btn
{
    //当改按钮没有选中时 点击该按钮响应一下操作
    if (!btn.isSelected) {
        
        //该按钮设为选中
        //其他按钮改为 非选中
        for (int i=0;i<[self.btnArray count];i++) {
            
            UIButton *obj = (UIButton *)[self.btnArray objectAtIndex:i];
            if (btn != obj) {
                
                obj.selected = NO;
            }
            else{
                
                obj.selected = YES;
                self.selectType = i;
            }
        }
        
        [self viewChangeWithType:self.selectType];
    }

}


// 切换
-(void)viewChangeWithType:(BtnSelectTypeCell)type{
    
    NSInteger count = self.itemsArr.count;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.btnClickedImg.frame = CGRectMake(type*kDeviceWidth/ count, 33, kDeviceWidth/count, 2);
    }];
    
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(viewChangeWithType:)])
    {
        [self.delegate viewChangeWithType:type];
        
    }
    
}



@end
