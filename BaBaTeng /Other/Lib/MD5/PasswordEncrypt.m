//
//  PasswordEncrypt.m
//  jiami
//
//  Created by liu on 17/9/8.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "PasswordEncrypt.h"

@implementation PasswordEncrypt

- (NSString *)Encode:(NSString *)code
{//ODgzZTk0ZmNmMjBmbm5jZmUwNTdkMXc1YmU1NnA3cnQ1OWFidWRvNDQ5YmFzMnQ1ZGMzOXJiY3VlMTBheTE2Mw==
    NSArray *strArr = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i",@"j",@"k",@"l",@"m",@"n",@"o",@"p",@"q",@"r",@"s",@"t",@"u",@"v",@"w",@"x",@"y",@"z"];
    NSMutableArray *codeArray = [self subsectionCode:code Num:8];
    NSMutableArray *codeArr = [self repalceStrArr:codeArray];
    
    NSString *newPassword = @"";
    for (NSString *str in codeArr) {
        
        NSString *rancStr = [self randNum:4 Strarr:strArr];
        
        newPassword = [NSString stringWithFormat:@"%@%@%@",newPassword,str,rancStr];
//        [newPassword stringByAppendingString:str];
//        [newPassword stringByAppendingString:rancStr];
    }
    
    //1.先把字符串转换为二进制数据
    
    NSData *data = [newPassword dataUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //2.对二进制数据进行base64编码，返回编码后的字符串
    
    return [data base64EncodedStringWithOptions:0];
    
//    return @"123";
}


/**
 * 分段方法
 * @param code 原密码
 * @param num 段数
 * @return 分段后的数组
 */
- (NSMutableArray *)subsectionCode:(NSString *)code Num:(NSInteger)num
{
    NSMutableArray *strArr = [[NSMutableArray alloc] init];
    
    NSInteger charnum = code.length / num;
//    substringToIndex
    NSInteger startIndex = 0;
    
    for (int i = 0; i < num; i++) {
        
        NSString *str = [code substringWithRange:NSMakeRange(startIndex,charnum)];
        startIndex = startIndex + charnum;
//        strArr[i] = str;
        [strArr addObject:str];
    }
    
    return strArr;
}


/**
 *
 * 1与8调换、2与7调换、3与6调换、4和5调换 其实就是首末倒置
 *
 * @param strarr 需要调换的数组
 *
 * @return 调换后的数组
 *
 */
- (NSMutableArray *)repalceStrArr:(NSMutableArray *)strarr
{
    NSInteger k = strarr.count;
    
    NSInteger h = k- 1;
    for (int j= 0; j<k; j++) {
        
        if (h > j) {
            NSString *middel = strarr[j];
            strarr[j] = strarr[h];
            strarr[h] = middel;
        }
        
        h--;
    }
//    NSLog(@"strarr===%@",strarr);
    return strarr;
}



- (NSString *)randNum:(NSInteger )num Strarr:(NSArray *)strarr
{

    NSString *str= @"";
//    int x = arc4random() % 2;
    
    for (int i = 0; i < num ; i++) {
        
        int index =  arc4random() % 36;
//        NSLog(@"strarr===%@",strarr[index]);
      // [str stringByAppendingString:strarr[index]];
//        [str stringByAppendingFormat:@"%@",strarr[index]];
        
        str = [NSString stringWithFormat:@"%@%@",str,strarr[index]];
        
        
    }
//    NSLog(@"randNumstr====%@",str);
    return str;
}


@end
