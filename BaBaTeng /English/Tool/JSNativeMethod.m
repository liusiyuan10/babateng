//
//  JSNativeMethod.m
//  S-T-Communication
//
//  Created by yans on 16/4/15.
//  Copyright © 2016年 yans. All rights reserved.
//

#import "JSNativeMethod.h"

@implementation JSNativeMethod

- (NSString *)imgCallBack:(NSString *)url {
    NSLog(@"touch image %@",url);
    return @"iOS To H5";
}

- (void)callWithDict:(NSDictionary *)params {
    NSLog(@"ssssJs调用了OC的方法，参数为：%@", params);
}

// Js调用了callSystemCamera
- (void)callSystemCamera {
    NSLog(@"JS调用了OC的方法，调起系统相册");
    
    // JS调用后OC后，又通过OC调用JS，但是这个是没有传参数的
    JSValue *jsFunc = self.jsContext[@"jsFunc"];
    [jsFunc callWithArguments:nil];
}

- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params {
    NSLog(@"jsCallObjcAndObjcCallJsWithDict was called, params is %@", params);
    // 调用JS的方法
    JSValue *jsParamFunc = self.jsContext[@"jsParamFunc"];
    [jsParamFunc callWithArguments:@[@{@"age": @10, @"name": @"lili", @"height": @158}]];
}

- (void)showAlert:(NSString *)title msg:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{
//        UIAlertView *a = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [a show];
    });
}

- (BOOL)share:(NSString *)title content:(NSString *)content{

    NSLog(@"title:%@\ncontent:%@",title,content);

    if ([self.delegate respondsToSelector:@selector(JSNativeMethodBtnClicked:selectName:)]) {


        [self.delegate JSNativeMethodBtnClicked:self selectName:title];

    }


    return YES;
}


- (BOOL)OCSend:(NSString *)code;{

//    NSLog(@"title:%@\ncontent:%@",title,content);
    NSLog(@"code=====%@",code);

    if ([self.delegate respondsToSelector:@selector(JSNativeMethodBtnClicked:selectName:)]) {


        [self.delegate JSNativeMethodBtnClicked:self selectName:code];

    }


    return YES;
}

- (BOOL)appBackfre:(NSString *)code
{
    
    if ([self.delegate respondsToSelector:@selector(JSNativeMethodEnglisBack:selectName:)]) {
        
        
        [self.delegate JSNativeMethodEnglisBack:self selectName:code];
        
    }
    
    return YES;
    
}


- (BOOL)appOCBack:(NSString *)code
{
    NSLog(@"appOCBack=====%@",code);
    if ([self.delegate respondsToSelector:@selector(JSNativeMethodBBolckBack:selectName:)]) {
        
        
        [self.delegate JSNativeMethodBBolckBack:self selectName:code];
        
    }
    
    return YES;
}

@end
