
//  Created by L2H on 16/7/13.


#import "CollectviewChooseCell.h"
#import "Masonry.h"
#import "Header.h"

#define SelectNum_ItemHeight 51
#define SelectNum_ItemWidth 77
#define ItemFont1 17
#define ItemFont2 16
//加油包订购——流量包cell展示

@implementation CollectviewChooseCell

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return  self;
}


-(void)initView{
    
    
    if (kDevice_IS_PAD) {
        _SelectIconBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth/3.0 - 164)/3.0, 3, 164, 44)];
    }
    else
    {
        _SelectIconBtn = [[UIButton alloc] initWithFrame:CGRectMake( (kDeviceWidth/2.0 - 164)/2.0, 3, 164, 44)];
    }
    
//    _SelectIconBtn.backgroundColor = [UIColor colorWithRed:250/255.0 green:165/255.0 blue:26/255.0 alpha:1.0];

     _SelectIconBtn.userInteractionEnabled = NO;
    
    [_SelectIconBtn setImage:[UIImage imageNamed:@"collectview_Unselect"] forState:UIControlStateNormal];
    [_SelectIconBtn setImage:[UIImage imageNamed:@"collectview_Selected"] forState:UIControlStateSelected];

//    [_SelectIconBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

//    _SelectIconBtn.titleLabel.font = [UIFont systemFontOfSize:18.0];
    _SelectIconBtn.backgroundColor = [UIColor clearColor];


    _SelectIconBtn.layer.cornerRadius = 15; //设置图片圆角的尺度
    _SelectIconBtn.layer.masksToBounds = YES; //没这句话它圆不起来

    [self.contentView addSubview:_SelectIconBtn];
    
    _titleLab = [[UILabel alloc] initWithFrame:CGRectMake( (164 - 120)/2.0, 15, 120, 14)];
    _titleLab.textColor = [UIColor blackColor];
    _titleLab.font = [UIFont systemFontOfSize:15.0];
    
    _titleLab.textAlignment = NSTextAlignmentCenter;
    
    _titleLab.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    
    [_SelectIconBtn addSubview:_titleLab];
    
    
//    _SelectIconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    _SelectIconBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, self.frame.size.height)];
//    _SelectIconBtn.userInteractionEnabled = NO;
//    [_SelectIconBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    [_SelectIconBtn setImage:[UIImage imageNamed:@"collectview_Unselect"] forState:UIControlStateNormal];
//    [_SelectIconBtn setImage:[UIImage imageNamed:@"collectview_Selected"] forState:UIControlStateSelected];
//    [self.contentView addSubview:_SelectIconBtn];
//    [_SelectIconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView.mas_left).offset(0);
//        make.right.equalTo(self.contentView.mas_right).offset(0);
//        make.top.equalTo(self.contentView.mas_top).offset(0);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
//    }];
//
////    self.contentView.backgroundColor = [UIColor redColor];
//
//    _titleLab = [[UILabel alloc]init];
//    _titleLab.textColor = [UIColor blackColor];
//    _titleLab.font = [UIFont systemFontOfSize:15];
//    _titleLab.textAlignment = NSTextAlignmentLeft;
//    _titleLab.textAlignment = NSTextAlignmentCenter;
//    [self.contentView addSubview:_titleLab];
//    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.top.equalTo(self.mas_top);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
}

-(void)UpdateCellWithState:(BOOL)select{
    self.SelectIconBtn.selected = select;
    _isSelected = select;
    if (_isSelected) {
        _titleLab.textColor = [UIColor whiteColor];
    }
    else
    {
        //_titleLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:102/255.0];
        _titleLab.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
        
    }
}

//-(void)setData:(CommonItem *)titleItem selected:(BOOL)Selected{
//    NSString * titleStr1 = titleItem.Package_Mb;
//    NSString  * titleStr2 = titleItem.Package_Price;
//    _titleLab.text = [NSString stringWithFormat:@"%@M",titleStr1];
////    titleLab2.text = [NSString stringWithFormat:@"%@元",titleStr2];
//    if (Selected == YES) {
//        _titleLab.textColor = [UIColor blackColor];
////        titleLab2.textColor = [UIColor blackColor];
//        [_SelectIconBtn setSelected:Selected];
//        [_SelectIconBtn setBackgroundImage:[UIImage imageNamed:@"Package_selected"] forState:UIControlStateSelected];
//    }
//    else{
//        _titleLab.textColor = [UIColor lightGrayColor];
////        titleLab2.textColor = [UIColor lightGrayColor];
//        [_SelectIconBtn setSelected:Selected];
//        [_SelectIconBtn setBackgroundImage:[UIImage imageNamed:@"Package_normal"] forState:UIControlStateNormal];
//    }
//    
//}
//
//-(void)setData:(CommonItem *)titleItem index:(NSIndexPath *)indexPath{
//    [self setData:titleItem selected:YES];
//}

@end
