
//  XEMallOrderTwoCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/4.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMallOrderTwoCell.h"
#import "Header.h"
#define XEMallOrderTwo_MAX_LIMIT_NUMS     20

@interface XEMallOrderTwoCell ()<UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic, assign) NSInteger ordercount;

@end



@implementation XEMallOrderTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.ordercount = 1;
        
        UIView*cellView = [self contentViewCell];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,278 + 16 + 16)];
    bgView.backgroundColor = [UIColor clearColor];
    
    CGFloat backViewW = kDeviceWidth - 32;
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,278 + 16)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    backView.userInteractionEnabled = YES;
    [bgView addSubview:backView];
    
    _leftImage = [[UIImageView alloc]initWithFrame:CGRectMake(17, 17,100, 100)];
    _leftImage.userInteractionEnabled = YES;
    _leftImage.backgroundColor = [UIColor clearColor];

    
    _leftImage.image = [UIImage imageNamed:@"order_image_empty"];
    
    _leftImage.layer.cornerRadius= 5.0f;
    


    _leftImage.layer.masksToBounds = YES;
    
    [backView addSubview:_leftImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, 29,kDeviceWidth - 32 - CGRectGetMaxX(_leftImage.frame)  -16 , 40)];
    
    _nameLabel.font = [UIFont systemFontOfSize:14.0];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
    _nameLabel.text = @"晓宝在线少儿英语套餐1";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.numberOfLines = 0;
    [backView addSubview:_nameLabel];
    
    _priceLabel = [[UILabel alloc] initWithFrame:CGRectMake( CGRectGetMaxX(_leftImage.frame) + 16, CGRectGetMaxY(_nameLabel.frame) + 22 ,160, 14)];
    
    _priceLabel.font = [UIFont boldSystemFontOfSize:18.0];
    _priceLabel.backgroundColor = [UIColor clearColor];
    _priceLabel.textColor = MNavBackgroundColor;
    _priceLabel.text = @"3600see";
    _priceLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_priceLabel];
    
    UILabel *buynoLabel = [[UILabel alloc] initWithFrame:CGRectMake( 18, CGRectGetMaxY(_leftImage.frame) + 26 ,70, 12)];
    
    buynoLabel.font = [UIFont systemFontOfSize:12.0];
    buynoLabel.backgroundColor = [UIColor clearColor];
    buynoLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    buynoLabel.text = @"购买数量";
    buynoLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:buynoLabel];
    
    CGFloat btnW = 48;
    UIButton *addBtn  = [[UIButton alloc]initWithFrame:CGRectMake( backViewW - btnW - 18, CGRectGetMaxY(_leftImage.frame) + 20 ,btnW, 24)];
    
    addBtn.backgroundColor = [UIColor clearColor];
    
    [addBtn setTitle:@"+" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:addBtn];
    
    
    _numField = [[UITextField alloc] initWithFrame:CGRectMake(backViewW - 40 - btnW - 18, CGRectGetMaxY(_leftImage.frame) + 20, 40, 32)];
    
    _numField.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    _numField.textAlignment=NSTextAlignmentCenter;
    _numField.textColor=[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
    _numField.text = [NSString stringWithFormat:@"%ld",(long)self.ordercount];
    _numField.keyboardType = UIKeyboardTypeNumberPad;
    _numField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _numField.font = [UIFont systemFontOfSize:14.0f];
    _numField.layer.cornerRadius = 5;
    
    _numField.clipsToBounds = YES;//去除_iocnView
    _numField.layer.masksToBounds = YES;
    _numField.delegate = self;
//    [_numField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];

    [backView addSubview:_numField];
    
    UIButton *minusBtn  = [[UIButton alloc]initWithFrame:CGRectMake( backViewW - 40 - btnW - 18 - btnW, CGRectGetMaxY(_leftImage.frame) + 20 ,btnW, 24)];
    
    minusBtn.backgroundColor = [UIColor clearColor];
    
    [minusBtn setTitle:@"-" forState:UIControlStateNormal];
    [minusBtn setTitleColor:[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [minusBtn addTarget:self action:@selector(minusBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:minusBtn];
    
    UILabel *noteLabel = [[UILabel alloc] initWithFrame:CGRectMake( 18, CGRectGetMaxY(buynoLabel.frame) + 37 ,70, 12)];
    
    noteLabel.font = [UIFont systemFontOfSize:12.0];
    noteLabel.backgroundColor = [UIColor clearColor];
    noteLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    noteLabel.text = @"备注信息";
    noteLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:noteLabel];
    
    _noteField = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(backViewW - 193 - 18, CGRectGetMaxY(buynoLabel.frame) + 26, 193, 32 + 16)];
    
    _noteField.backgroundColor=[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0];
    _noteField.textAlignment=NSTextAlignmentLeft;
    _noteField.textColor=[UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1.0];
    _noteField.placeholder = @"建议留言前先与商家确认";
    

    _noteField.layer.cornerRadius = 5;
    
    _noteField.clipsToBounds = YES;//去除_iocnView
    _noteField.layer.masksToBounds = YES;
    
    _noteField.keyboardType = UIKeyboardTypeDefault;
   
    _noteField.font = [UIFont systemFontOfSize:14.0f];
    
   _noteField.delegate = self;
   _noteField.showsVerticalScrollIndicator = YES;
    
  _noteField.editable = YES;
    
    [backView addSubview:_noteField];
    
    
    _phoneBtn = [[UIButton alloc]initWithFrame:CGRectMake(16,CGRectGetMaxY(noteLabel.frame) + 25 + 16 ,backViewW - 32, 33)];
    _phoneBtn.backgroundColor = [UIColor clearColor];
    _phoneBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_phoneBtn setTitleColor:MNavBackgroundColor forState:UIControlStateNormal];
    [_phoneBtn setTitle:@"联系客服" forState:UIControlStateNormal];
    
//    [_phoneBtn addTarget:self action:@selector(ExperienceBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _phoneBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    
    _phoneBtn.layer.borderWidth = 1.0f;
    
    _phoneBtn.layer.borderColor = MNavBackgroundColor.CGColor;
    
    _phoneBtn.layer.cornerRadius= 5.0f;
    
    _phoneBtn.clipsToBounds = YES;//去除边界
    
    [backView addSubview:_phoneBtn];

    return bgView;
}

- (void)addBtnClicked
{

        

    if(self.ordercount > 98)
    {
        return;
    }
    
    self.ordercount++;
    
    _numField.text = [NSString stringWithFormat:@"%ld",(long)self.ordercount];
    
    if ([self.delegate respondsToSelector:@selector(XEMallOrderTwoCellBtnClicked:selectnum:)]) {
        
        [self.delegate XEMallOrderTwoCellBtnClicked:self selectnum:_numField.text];
    }
    
}

- (void)minusBtnClicked
{
    if (self.ordercount == 1) return;
    
    self.ordercount--;
    
    _numField.text = [NSString stringWithFormat:@"%ld",(long)self.ordercount];
    
    if ([self.delegate respondsToSelector:@selector(XEMallOrderTwoCellBtnClicked:selectnum:)]) {
        
        [self.delegate XEMallOrderTwoCellBtnClicked:self selectnum:_numField.text];
    }
}

//- (void)textFieldEditChanged:(UITextField*)textField
//
//{
//
//    NSLog(@"textfield text %@",textField.text);
//
//    self.ordercount = [textField.text integerValue];
//
//
//
//    if ([self.delegate respondsToSelector:@selector(XEMallOrderTwoCellBtnClicked:selectnum:)]) {
//
//        [self.delegate XEMallOrderTwoCellBtnClicked:self selectnum:textField.text];
//    }
//
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    NSLog(@"textfield text %@",textField.text);
    
    self.ordercount = [textField.text integerValue];
    
    if (self.ordercount == 0)
    {
        textField.text = @"1";
        
        self.ordercount = 1;
    }
    
    if (self.ordercount > 99)
    {
        textField.text = @"99";
        
        self.ordercount = 99;
    }
    
    
    if ([self.delegate respondsToSelector:@selector(XEMallOrderTwoCellBtnClicked:selectnum:)]) {
        
        [self.delegate XEMallOrderTwoCellBtnClicked:self selectnum:textField.text];
    }
    
}

//- (void)notetextFieldEditDidEnd:(UITextField*)textField
//{
//        NSLog(@"-----textfield text %@",textField.text);
//    if ([self.delegate respondsToSelector:@selector(XEMallOrderTextFieldEditDidEnd:Text:)]) {
//        
//        [self.delegate XEMallOrderTextFieldEditDidEnd:self Text:textField.text];
//    }
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < XEMallOrderTwo_MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = XEMallOrderTwo_MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            
        }
        return NO;
    }
    
    
    
    
    
}



- (NSString *)disable_emoji:(NSString *)text{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:text
                                                               options:0
                                                                 range:NSMakeRange(0, [text length])
                                                          withTemplate:@""];
    return modifiedString;
}

- (void)textViewDidChange:(UITextView *)textView
{
    
    
    if (textView.text.length > 0) {
        // 禁止系统表情的输入
        NSString *text = [self disable_emoji:[textView text]];
        if (![text isEqualToString:textView.text]) {
            NSRange textRange = [textView selectedRange];
            textView.text = text;
            [textView setSelectedRange:textRange];
        }
    }
    
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > XEMallOrderTwo_MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符
        NSString *s = [nsTextContent substringToIndex:XEMallOrderTwo_MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
            NSLog(@"-----textfield text %@",textView.text);
    
        if ([self.delegate respondsToSelector:@selector(XEMallOrderTextFieldEditDidEnd:Text:)]) {
    
            [self.delegate XEMallOrderTextFieldEditDidEnd:self Text:textView.text];
        }
}

@end
