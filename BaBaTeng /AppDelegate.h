//
//  AppDelegate.h
//  BaBaTeng
//
//  Created by administrator on 16/10/10.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DlnaManager.h"
#import "WscPresenterImpl.h"
#import "DmrPlayerGlobalVista.h"
#import "NetworkVista.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import "BabyBluetooth.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,DmrPlayerGlobalVista,NetworkVista>
{
@public
    BabyBluetooth *baby;
}


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;

/**
 * 是否允许转向
 */
@property(nonatomic,assign)BOOL allowRotation;

@property (strong, nonatomic) WscPresenterImpl *wscPresenter;
@property (strong, nonatomic) id<DlnaScannerPresenter> dlnaScanner;
@property (strong, nonatomic) id<DmrStationPresenter> dmrStation;
@property (strong, nonatomic) id<DmrPlayerPresenter> dmrPlayer;


+ (AppDelegate *)appDelegate;
@property (strong, nonatomic) NSMutableArray *playSaveDataArray;
-(void)suspendButtonHidden:(BOOL)hidden;
-(void)suspendButtonEnabled:(BOOL)enabled;
- (void)AnimationPlay:(NSNotification *)noti;
- (void)NoDeviceAnimationPlay:(NSDictionary *)dic;
- (void)AnimationOutsidePlay:(NSString*)sign;

//+ (AppDelegate *)shareInstance;

@property (nonatomic,strong)CBCharacteristic *babycharacteristic;
@property (nonatomic,strong)CBCharacteristic *babycharacteristicrevice;
@property (nonatomic,strong)CBPeripheral *currPeripheral;


@property (assign, nonatomic) BOOL isHaveLoging;
@property (nonatomic, strong) NSDictionary *tmpdictionaryPayload;

+(AppDelegate*)shareInstance ;
- (void)saveRemotePushInfo:(NSDictionary *)userInfo;
- (void)saveRemotePushInfo_NoParameter;




@end

