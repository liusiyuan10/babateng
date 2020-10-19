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
#define VOICE_SEARCH          @"VOICESEARCH"
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
//第一个地方
//#define BBT_HTTP_URL   @"http://192.168.1.17:8080/"
//#define BBT_HTTP_URL   @"http://192.168.1.109/"
//#define BBT_HTTP_URL     @"http://192.168.1.19:8080/"
//#define BBT_HTTP_URL     @"http://192.168.1.219/"

//外网正式地址
#define BBT_HTTP_URL   @"http://ai.babateng.cn/"
//外网测试地址
//#define BBT_HTTP_URL   @"http://test.ai.babateng.cn/"

// #define  PROJECT_NAME_APP    @"bbt-phone" //内网
// #define  PROJECT_NAME_LOGIN   @"bbt-login" //内网

#define  PROJECT_NAME_APP  @"api/app" //外网
#define  PROJECT_NAME_LOGIN  @"sso"  //外网

//第二个地方
//#define APP_FISRT_ENTRY        @"usr_intro_defualt"
//#define BBT_HTML               @"http://192.168.1.17:8080/bbt-phone/resources/html/"
//#define BBT_HTML               @"http://192.168.1.109:8080/bbt-phone/resources/html/"
//#define BBT_HTML               @"http://192.168.1.19:8080/bbt-phone/resources/html/"
//#define BBT_HTML               @"http://192.168.1.219/bbt-phone/resources/html/"
//外网正式地址
#define BBT_HTML               @"http://ai.babateng.cn/api/app/resources/html/"

//外网测试地址
//#define BBT_HTML     @"http://test.ai.babateng.cn/api/app/resources/html/"

#define BBT_BACKGROUN_COLOR      [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1.0];

#define MNavBackgroundColor [UIColor colorWithRed:253.0/255 green:143.0/255 blue:45.0/255 alpha:1.0f]
#define NavBackgroundColor [UIColor colorWithRed:253.0/255 green:143.0/255 blue:45.0/255 alpha:1.0f]
#define DefaultBackgroundColor [UIColor colorWithRed:246.0/255 green:246.0/255 blue:246.0/255 alpha:1.0f]
#define CellBackgroundColor [UIColor colorWithRed:252.0/255 green:252.0/255 blue:231.0/255 alpha:1.0f]
#define CellSeperatorColor      [UIColor colorWithRed:252.0/255 green:252.0/255 blue:231.0/255 alpha:1.0f]
#define SelecetedCellBG   [UIColor colorWithRed:249.0/255 green:207.0/255 blue:150.0/255 alpha:1.0f]

#define MainFontColor    [UIColor colorWithRed:80.0/255 green:80.0/255 blue:80.0/255 alpha:1.0f]
#define MainFontColorTWO    [UIColor colorWithRed:119.0/255 green:116.0/255 blue:116.0/255 alpha:1.0f]


#define BBT_ONE_FONT          [UIFont systemFontOfSize:18.0f]
#define BBT_TWO_FONT          [UIFont systemFontOfSize:17.0f]
#define BBT_THREE_FONT        [UIFont systemFontOfSize:14.0f]
#define BBT_FOUR_FONT         [UIFont systemFontOfSize:12.0f]
//第三个地方
//#define kMQTTServerHost @"192.168.1.109"
//#define kMQTTServerHost @"192.168.1.17"
//#define kMQTTServerHost @"192.168.1.19"
//#define kMQTTServerHost @"192.168.1.219"
//外网正式地址
#define kMQTTServerHost   @"ai.babateng.cn"
//#define kMQTTServerHost   @"182.61.28.213"
//外网测试地址
//#define kMQTTServerHost   @"test.ai.babateng.cn"

//主题：需要从后台拿到
#define kTopic  @"storybox/0100000000000005/server/page"
#define kTopic1 @"storybox/0100000000000005/server"
#define kTopic2 @"storybox/0100000000000005/client"


//扫码绑定的二维码
//#define BBT_CODE_URL     @"testbd.babateng.cn"
#define BBT_CODE_URL @"bd.babateng.cn"

#define BBT_APP_TYPE @"1"


#define iPhoneX      ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
#define kDevice_Is_iPhoneX ( iPhoneX ?  34 : 0)
#define kDevice_IsE_iPhoneX ( iPhoneX ?  24 : 0)
#define  kDevice_IS_PAD (UI_USER_INTERFACE_IDIOM()== UIUserInterfaceIdiomPad)

//#define HEIGHT_TABBAR       49      // 就是chatBox的高度
#define HEIGHT_TABBAR    ( iPhoneX ?   113  : 49)       // 就是chatBox的高度
//#define HEIGHT_RDVTABBAR       50      // 就是TabBar的高度
#define HEIGHT_SCREEN       [UIScreen mainScreen].bounds.size.height
#define WIDTH_SCREEN        [UIScreen mainScreen].bounds.size.width

#define     CHATBOX_BUTTON_WIDTH        37
//#define     HEIGHT_TEXTVIEW             HEIGHT_TABBAR * 0.74
#define     HEIGHT_TEXTVIEW            ( iPhoneX ?   HEIGHT_TABBAR * 0.38  : HEIGHT_TABBAR * 0.74)
#define     MAX_TEXTVIEW_HEIGHT         104

#define videwViewH HEIGHT_SCREEN * 0.64 // 录制视频视图高度
#define videwViewX HEIGHT_SCREEN * 0.36 // 录制视频视图X

#define APP_Frame_Height   [[UIScreen mainScreen] bounds].size.height

#define App_Frame_Width    [[UIScreen mainScreen] bounds].size.width

#define kDiscvoerVideoPath @"Download/Video"  // video子路径
#define kChatVideoPath @"Chat/Video"  // video子路径
#define kVideoType @".mp4"        // video类型
#define kRecoderType @".wav"


#define kChatRecoderPath @"Chat/Recoder"
#define kRecodAmrType @".amr"

#define BBTVersionKey @"versionkey"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)


