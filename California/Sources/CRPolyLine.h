//
//  CRPolyLine.h
//  California
//
//  Created by Igor Bogatchuk on 2/25/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import <MapKit/MapKit.h>

typedef enum
{
    CRRouteTypePrimary,
    CRRouteTypeSecondary
}CRRouteType;

@interface CRPolyLine : MKPolyline

@property (nonatomic, assign) NSTimeInterval expectedTravelTime;
@property (nonatomic, assign) CRRouteType routeType;

- (id)initWithMKPolyLine:(MKPolyline *)polyline;

@end
