//
//  CRPolyLine.m
//  California
//
//  Created by Igor Bogatchuk on 2/25/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRPolyLine.h"

@implementation CRPolyLine

- (id)initWithMKPolyLine:(MKPolyline *)polyline
{
    return (CRPolyLine*)[CRPolyLine polylineWithPoints:polyline.points count:polyline.pointCount];
}

@end
