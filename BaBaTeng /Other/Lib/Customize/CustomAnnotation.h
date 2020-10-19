//
//  POIAnotation.h
//  xinlife
//
//  Created by Eels on 11/30/13.
//  Copyright (c) 2013 com.qianxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

#define PIN_RED @"Red"
#define PIN_GREEN @"Green"
#define PIN_PURPLE @"Purple"



@interface CustomAnnotation  : NSObject <MKAnnotation>
@property (nonatomic, assign, readonly)     CLLocationCoordinate2D coordinate;

@property (nonatomic, copy, readonly)       NSString *title;

@property (nonatomic, copy, readonly)       NSString *subtitle;

@property (nonatomic,copy)   NSString *imgURL;  //优惠券图片
@property (nonatomic,assign) int couponID;    //优惠券ID
@property (nonatomic,assign) int sellerID;    //商家ID
@property (nonatomic,copy)   NSString *selCategoryID; //所属商家分类
@property (nonatomic, assign)int type;//0----pin  1---pop


@property (nonatomic, unsafe_unretained) MKPinAnnotationColor pinColor;

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates

title:(NSString *)paramTitle

subTitle:(NSString *)paramSubTitle;



+ (NSString *) reusableIdentifierforPinColor :(MKPinAnnotationColor)paramColor;

@end
