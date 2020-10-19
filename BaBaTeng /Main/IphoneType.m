//
//  IphoneType.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/10/24.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "IphoneType.h"
#import "Header.h"
@implementation IphoneType

+(BOOL)IFChangeCoordinates{
   
    if (IS_IPAD) {
        
        
        return YES;
            

        
    }else{
    
        return NO;
    }

}
@end

