//
//  CLAnnotation.m
//  California
//
//  Created by Igor Bogatchuk on 2/23/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRAnnotation.h"

@implementation CRAnnotation

- (id)initWithLatitude:(CLLocationDegrees)latitude
				 longitude:(CLLocationDegrees)longitude
					  title:(NSString*)title
				  subtitle:(NSString*)subtitle
{
	self = [super init];
	if (self)
	{
		_latitude = latitude;
		_longitude = longitude;
		_title = title;
		_subtitle = subtitle;
	}
	return self;
}

- (CLLocationCoordinate2D)coordinate
{
	return CLLocationCoordinate2DMake(self.latitude, self.longitude);
}

@end
