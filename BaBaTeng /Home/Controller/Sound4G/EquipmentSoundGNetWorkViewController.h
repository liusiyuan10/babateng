//
//  EquipmentSoundGNetWorkViewController.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/26.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SinVoicePlayer.h"
#import "SinVoiceRecognizer.h"
#include "ESPcmPlayer.h"
#include "ESPcmRecorder.h"

#import "CommonViewController.h"


@interface EquipmentSoundGNetWorkViewController : CommonViewController
{
@private
    SinVoicePlayer*     mSinVoicePlayer;
    SinVoiceRecognizer* mSinVoiceRecorder;
    ESPcmPlayer         mPcmPlayer;
    ESPcmRecorder       mPcmRecorder;
    
@public
    int mRates[100];
    int mPlayCount;
    int mResults[100];
    int mResultCount;
    int mMaxEncoderIndex;
}

@property(nonatomic, copy) NSString *deviceTypeName;
@property(nonatomic, copy) NSString *deviceTypeId;

@property(nonatomic, copy) NSString *wifiName;
@property(nonatomic, copy) NSString *wifiPassword;

@property(nonatomic, copy) NSString *iconUrl;

-(void)onPlayData:(EquipmentSoundGNetWorkViewController*)data;
-(void)onRecogToken:(EquipmentSoundGNetWorkViewController*)data;
-(void)onPlayerStop:(EquipmentSoundGNetWorkViewController*)data;

@end
