//
//  POIAnotation.m
//  xinlife
//
//  Created by Eels on 11/30/13.
//  Copyright (c) 2013 com.qianxun. All rights reserved.
//

#import "CustomAnnotation.h"

@implementation CustomAnnotation
@synthesize imgURL,couponID,sellerID,selCategoryID;

- (id) initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates
title:(NSString *)paramTitle
subTitle:(NSString *)paramSubTitle
{
    if (self = [super init]) {
        _coordinate = paramCoordinates;
        _title = [paramTitle copy];
        _subtitle = [paramSubTitle copy];
    }
    return self;
}

+ (NSString *) reusableIdentifierforPinColor :(MKPinAnnotationColor)paramColor{
    NSString *result = nil;
    switch (paramColor){
        case MKPinAnnotationColorRed:{
            result = PIN_RED;
            break;
        }
        case MKPinAnnotationColorGreen:{
            result = PIN_GREEN;
            break;
        }
        case MKPinAnnotationColorPurple:{
            result = PIN_PURPLE;
            break;
        }
    }
    return result;
}
@end
