//
//  JSNativeMethod.h
//  S-T-Communication
//
//  Created by yans on 16/4/15.
//  Copyright © 2016年 yans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class JSNativeMethod;

@protocol JSNativeMethodDelegate <NSObject>

- (void)JSNativeMethodBtnClicked:(JSNativeMethod *)Method selectName:(NSString *)name;
- (void)JSNativeMethodEnglisBack:(JSNativeMethod *)Method selectName:(NSString *)name;
- (void)JSNativeMethodBBolckBack:(JSNativeMethod *)Method selectName:(NSString *)name;

@end



//首先创建一个实现了JSExport协议的协议
@protocol JSNativeMethodJSObjectProtocol <JSExport>

// js 调用的时候 多参数是 share(title,content) 默认是 shareTitleContent:(title,content)   JSExportAs 做兼容
//JSExportAs(OCSend,
//- (BOOL)OCSend:(NSString *)title content:(NSString *)content
//);

JSExportAs(share,
           - (BOOL)share:(NSString *)title content:(NSString *)content
           );

- (BOOL)OCSend:(NSString *)code;

- (BOOL)appBackfre:(NSString *)code;

- (BOOL)appOCBack:(NSString *)code;


//此处我们测试几种参数的情况
- (NSString *)imgCallBack:(NSString *)url;

// 通过JSON传过来
- (void)callWithDict:(NSDictionary *)params;

// JS调用此方法来调用OC的系统相册方法
- (void)callSystemCamera;

// JS调用Oc，然后在OC中通过调用JS方法来传值给JS。
- (void)jsCallObjcAndObjcCallJsWithDict:(NSDictionary *)params;

// 在JS中调用时，函数名应该为showAlertMsg(arg1, arg2)
// 这里是只两个参数的。
- (void)showAlert:(NSString *)title msg:(NSString *)msg;

//- (BOOL)share:(NSString *)title content:(NSString *)content;

@end


@interface JSNativeMethod : NSObject<JSNativeMethodJSObjectProtocol>


@property(nonatomic, assign) id<JSNativeMethodDelegate> delegate;
@property (nonatomic, weak) JSContext *jsContext;


@end
