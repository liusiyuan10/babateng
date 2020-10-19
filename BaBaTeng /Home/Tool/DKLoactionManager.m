//
//  DKLoactionManager.m
//  BaBaTeng
//
//  Created by xyj on 2019/11/16.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import "DKLoactionManager.h"

@interface DKLoactionManager ()

@property(nonatomic,strong) CLLocationManager *locmanager;

@property(nonatomic,copy) LoactionBlock block;

@end

@implementation DKLoactionManager

//1.单利

+(instancetype)sharedManager{

static DKLoactionManager *_manager;

static dispatch_once_t onceToken;

dispatch_once(&onceToken, ^{

_manager = [[DKLoactionManager alloc]init];

});
    return _manager;

}

    //2.

-(instancetype)init{

    self = [super init];

    if (self) {

    _locmanager = [[CLLocationManager alloc]init];

    [_locmanager setDesiredAccuracy:kCLLocationAccuracyBest];//所需的精度设置为最好

    _locmanager.distanceFilter = 100;//距离过滤

    _locmanager.delegate = self;

    if (![CLLocationManager locationServicesEnabled]) {

    NSLog(@"开启定位服务");
        
    } else {
        


    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];//设置授权


    if (status == kCLAuthorizationStatusNotDetermined) {//如果未确定授权状态

    [_locmanager requestWhenInUseAuthorization];//请求用户授权

    }

    }

    }

    return self;

}

- (void)locationManager:(CLLocationManager *)manager

didUpdateToLocation:(CLLocation *)newLocation

fromLocation:(CLLocation *)oldLocation{

CLLocationCoordinate2D coor = newLocation.coordinate;//coordinate坐标

NSLog(@"%@",@(coor.latitude));

NSLog(@"%@",@(coor.longitude));

}

-(void)getGPS:(LoactionBlock)block{

self.block = block;

[self.locmanager startUpdatingLocation];//开始定位位置

}

@end




