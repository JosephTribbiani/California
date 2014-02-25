//
//  CLMapViewController.h
//  California
//
//  Created by Igor Bogatchuk on 2/22/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface CRMapViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView* mapView;

@end
