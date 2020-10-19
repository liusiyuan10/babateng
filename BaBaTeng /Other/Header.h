//
//  Header.h
//  integral
//
//  Created by liu on 15/9/16.
//  Copyright (c) 2015年 ecg. All rights reserved.
//

#ifndef integral_Header_h
#define integral_Header_h


#define APPID_VALUE           @"564438d3"
#define URL_VALUE             @""                 // url
#define TIMEOUT_VALUE         @"20000"            // timeout      连接超时的时间，以ms为单位
#define BEST_URL_VALUE        @"1"                // best_search_url 最优搜索路径
#define VOICE_SEARCH  @"VOICESEARCH"
#define kStatusBarHeight                    20
#define kUITabBarFrameHeight                49.0f
#define kUINavigationBarFrameHeight         44.0f
#define IOS5_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"5.0"] != NSOrderedAscending )
//登录完成
#define  LOGIN_OK_MESSAGE                           @"LOGIN_OK_MESSAGE"
//自动登陆完成
#define  AUTOLOGIN_OK_MESSAGE                       @"AUTOLOGIN_OK_MESSAGE"
#define  AUTOLOGIN_Failed_MESSAGE                   @"AUTOLOGIN_Failed_MESSAGE"
//注册完成
#define  REGISTE_OK_MESSAGE                         @"REGISTE_OK_MESSAGE"
//找回密码成功
#define Find_Password_Success                   @"Find_Password_Success"
#define AutoFill_Password                       @"AutoFill_Password"
#define MERGE_SUCCESS_ACTION                    @"MERGE_SUCCESS_ACTION"
#define  POPUP_MESSAGE                              @"POPUP_MESSAGE"

#define kTableViewNumberOfRowsKey       @"numberOfRows"
#define kTableViewCellListKey           @"cellList"
#define kTableViewCellHeightKey         @"cellHeight"
#define kTableViewCellTypeKey           @"cellType"
#define kTableViewCellDataKey           @"cellData"
#define kTableViewSectionHeaderHeightKey      @"sectionHeaderHeight"
#define kTableViewSectionHeaderTypeKey        @"sectionHeaderType"
#define kTableViewSectionFooterHeightKey      @"sectionFooterHeight"
#define kTableViewSectionFooterTypeKey        @"sectionFooterType"

#define DefaultBackgroundColor [UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0f]

#define DefaultMainColor   [UIColor colorWithRed:228.0/255 green:108.0/255 blue:28.0/255 alpha:1.000]
#define DarkerMainColor     [UIColor colorWithRed:181.0/255.0f green:68.0/255.0f blue:40.0/255.0f alpha:1]
#define DefaultGrayColor    [UIColor colorWithRed:199.0/255 green:205.0/255 blue:209.0/255 alpha:1.0f]
#define WarmColor    [UIColor colorWithRed:255.0/255 green:249.0/255 blue:235.0/255 alpha:1.0f]
#define DefaultMainBackgroundColor [UIColor colorWithWhite:0.2 alpha:1.0f]

#define SeperatorColor   [UIColor colorWithWhite:0.8f alpha:1.0f]
#define DefaultFontColor    [UIColor colorWithWhite:0.42 alpha:1.0f]
#define LightFontColor      [UIColor colorWithWhite:0.57 alpha:1.0f]

#define   BaseURLString   @"http://app.suopin.net/web_service/"
#define   FontName     @"FZLTXHK--GBK1-0"
#define   BoldFontName @"FZLTXHK--GBK1-0"
#define   PaddingBorder 12
#define kDeviceWidth [UIScreen mainScreen].bounds.size.width
#define KDeviceHeight [UIScreen mainScreen].bounds.size.height

#define Width [UIScreen mainScreen].bounds.size.width/320.0
#define Height [UIScreen mainScreen].bounds.size.height/568.0

#define MaskLayerBackground [UIColor colorWithWhite:0 alpha:0.5]
#define kStatusBarHeight                    20
#define kUITabBarFrameHeight                49.0f

#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS6_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"6.0"] != NSOrderedAscending )
#define IPHONE_6_OR_LARGER (kDeviceWidth>320.0)

#pragma mark ------------------------------拖动ui效果开关 by chupeng
#define kPanUISwitch 1

//是否为空或是[NSNull null]
#define NotNilAndNull(_ref)  (((_ref) != nil) && (![(_ref) isEqual:[NSNull null]]))
#define IsNilOrNull(_ref)   (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]))

//字符串是否为空
#define IsStrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref)isEqualToString:@""]))
//数组是否为空
#define IsArrEmpty(_ref)    (((_ref) == nil) || ([(_ref) isEqual:[NSNull null]]) ||([(_ref) count] == 0))

//颜色创建
#undef  RGBCOLOR
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#undef  RGBACOLOR
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

//便捷创建NSString
#undef  STR_FROM_INT
#define STR_FROM_INT( __x )     [NSString stringWithFormat:@"%lu", (__x)]
#endif

//弹出选择搜索类型页面
#define SEARCHTYPE_CHANGED                  @"SEARCHTYPE_CHANGED"



#define kShadowOffsetY (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 4.0f : 2.0f)
#define kShadowBlur (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 10.0f : 5.0f)
#define kStrokeSize (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ? 6.0f : 3.0f)

#define PLATFORM_VERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

#define APP_VERSION  [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"]

#define DEVICE_MODEL [[UIDevice currentDevice] model]

#define  ING 19.570505
#define  LAT 22.570505

//#define AOLIURL       @"http://staging.api.ollieo2o.com.cn/"
#define AOLIURL       @"http://app.ollieo2o.com.cn/"


#define AOLIGreenColor [UIColor colorWithRed:25.0/255.0f green:154.0/255.0f blue:55.0/255.0f alpha:1]

#define AOLIGreenColor1 [UIColor colorWithRed:25.0/255.0f green:134.0/255.0f blue:55.0/255.0f alpha:1]


