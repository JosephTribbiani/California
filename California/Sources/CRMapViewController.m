//
//  CLMapViewController.m
//  California
//
//  Created by Igor Bogatchuk on 2/22/14.
//  Copyright (c) 2014 cogniance. All rights reserved.
//

#import "CRMapViewController.h"
#import "CRAnnotation.h"
#import "CRPolyLine.h"
#import "CRRoutedDetailsViewController.h"

#define OCEAN_PLAZA_LATITUDE 50.412316
#define OCEAN_PLAZA_LONGITUDE 30.522562

NSString* const kAnnotationViewReuseIdentifier = @"AnnotationViewReuseIdentifier";

@interface CRMapViewController ()
@property (strong, nonatomic) UIPopoverController* masterPopoverController;
@property (nonatomic, strong) UILongPressGestureRecognizer* longPressGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer* tapGestureRecognizer;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actiomButton;
@property (nonatomic, strong) NSMutableArray* annotations;
@property (nonatomic, strong) id<MKAnnotation> selectedAnnotation;
@property (nonatomic, strong) UIPopoverController *routeDetailsPopover;

@end

@implementation CRMapViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
    
    self.mapView.showsUserLocation = YES;
	self.mapView.delegate = self;
    self.annotations = [NSMutableArray new];
    
    [self.actiomButton setTitle:NSLocalizedString((IS_IOS7_AND_UP ? @"iOS7ActionButtonName" : @"iOS6ActionButtonName"), @"")];

	[self configureGestureRecognizers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureGestureRecognizers
{
    self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    self.longPressGestureRecognizer.minimumPressDuration = 1;
    self.longPressGestureRecognizer.numberOfTouchesRequired = 1;
    [self.longPressGestureRecognizer setDelaysTouchesBegan:YES];
    [self.mapView addGestureRecognizer:self.longPressGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesure:)];
    [self.mapView addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark MapView Delegate

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    self.selectedAnnotation = view.annotation;
}

- (MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:kAnnotationViewReuseIdentifier];
    if (view == nil)
    {
        view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:kAnnotationViewReuseIdentifier];
    }
    view.image = [UIImage imageNamed:@"pin2"];
    view.canShowCallout = YES;

    return view;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (IS_IOS7_AND_UP)
    {
        [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    }
    else
    {
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)animated:YES];
    }
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[CRPolyLine class]])
    {
        MKPolylineRenderer* renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor redColor]];
        renderer.alpha = (((CRPolyLine*)overlay).routeType == CRRouteTypePrimary ? 1.0 : 0.3);
        [renderer setLineWidth:5.0];
        [self updateExpectedTimeForRoute:overlay];
        return renderer;
    }
    return nil;
}

#pragma mark - Gesture Recognizer

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan)
    {
        return;
    }
    if (recognizer == self.longPressGestureRecognizer)
    {
        CGPoint location = [recognizer locationInView:self.mapView];
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
        CRAnnotation *annotation = [[CRAnnotation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude title:NSLocalizedString(@"LocationTitle", @"") subtitle:NSLocalizedString(@"LocationSubTitle", @"")];
        [self updateAnnotationsWithObject:annotation];
    }
}

- (void)handleTapGesure:(UITapGestureRecognizer*)recognizer
{
    CGPoint location = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D tapCoordinate = [self.mapView convertPoint:location toCoordinateFromView:self.mapView];
    MKMapPoint tapMapPoint = MKMapPointForCoordinate(tapCoordinate);
    NSArray* overlays = self.mapView.overlays;
    for (id<MKOverlay> overlay in overlays)
    {
        if ([overlay isKindOfClass:[CRPolyLine class]])
        {
            MKPolylineRenderer* renderer = (MKPolylineRenderer *)[self mapView:self.mapView rendererForOverlay:overlay];
            CGPoint tapPoint = [renderer pointForMapPoint:tapMapPoint];
            CGPathRef pathRef = [renderer path];
#warning QUESTION
            CGPathRef strokedPath = CGPathCreateCopyByStrokingPath(pathRef, NULL, 400, kCGLineCapRound, kCGLineJoinRound, 1);
            BOOL isRouteSelected = (CGPathContainsPoint(strokedPath, NULL, tapPoint, NO));
            CGPathRelease(strokedPath);
            if (isRouteSelected)
            {
                [self showRouteDetails:overlay];
                ((CRPolyLine*)overlay).routeType = CRRouteTypePrimary;
                [self assignPrimaryRoute:overlay];
                break;
            }
        }
    }
}

- (void)assignPrimaryRoute:(CRPolyLine*)polyline
{
#warning QUESTION
    /*
    NSArray* overlays = self.mapView.overlays;
    for (id<MKOverlay> overlay in overlays)
    {
        if ([overlay isKindOfClass:[CRPolyLine class]])
        {
            if (polyline == (CRPolyLine*)overlay)
            {
                ((CRPolyLine*)overlay).routeType = CRRouteTypePrimary;
            }
            else
            {
                ((CRPolyLine*)overlay).routeType = CRRouteTypeSecondary;
            }
            MKPolylineRenderer *renderer = (MKPolylineRenderer *)[self.mapView rendererForOverlay:polyline];
            renderer.alpha = (((CRPolyLine*)overlay).routeType == CRRouteTypePrimary ? 1.0 : 0.3);
            [renderer invalidatePath];
        }
    }
     */
    NSArray* overlays = self.mapView.overlays;
    [self.mapView removeOverlays:self.mapView.overlays];
    
    for (id<MKOverlay> overlay in overlays)
    {
        if ([overlay isKindOfClass:[CRPolyLine class]])
        {
            CRPolyLine* newPolyline = [[CRPolyLine alloc] initWithMKPolyLine:overlay];
            newPolyline.expectedTravelTime = ((CRPolyLine*)overlay).expectedTravelTime;
            
            if (polyline == (CRPolyLine*)overlay)
            {
                newPolyline.routeType = CRRouteTypePrimary;
                [self.mapView insertOverlay:newPolyline atIndex:0 level:MKOverlayLevelAboveRoads];
            }
            else
            {
                newPolyline.routeType = CRRouteTypeSecondary;
                [self.mapView addOverlay:newPolyline level:MKOverlayLevelAboveRoads];
            }
        }
    }
}

#pragma mark - Actions

- (IBAction)traceRoute:(id)sender
{
    [self.mapView removeOverlays:self.mapView.overlays];
    
    id<MKAnnotation> annotation = self.selectedAnnotation;
    
    MKPlacemark* sourcePlaceMark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude) addressDictionary:nil];
    MKMapItem* sourceItem = [[MKMapItem alloc] initWithPlacemark:sourcePlaceMark];
    
    MKPlacemark* destinationPlaceMark = [[MKPlacemark alloc] initWithCoordinate:annotation.coordinate addressDictionary:nil];
    MKMapItem* destinationItem = [[MKMapItem alloc] initWithPlacemark:destinationPlaceMark];
    
    if (IS_IOS7_AND_UP)
    {
        MKDirectionsRequest* request = [[MKDirectionsRequest alloc] init];
        [request setSource:sourceItem];
        [request setDestination:destinationItem];
        [request setTransportType:MKDirectionsTransportTypeAutomobile];
        [request setRequestsAlternateRoutes:YES];

        MKDirections* directions = [[MKDirections alloc] initWithRequest:request];
        
        [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error)
        {
            if (error)
            {
                return ;
            }
            for (MKRoute* route in [[response routes] reverseObjectEnumerator])
            {
                CRPolyLine* overlay =  [[CRPolyLine alloc] initWithMKPolyLine:[route polyline]];
                overlay.routeType = ([[response routes] firstObject] == route ? CRRouteTypePrimary : CRRouteTypeSecondary);
                overlay.expectedTravelTime = [route expectedTravelTime];
                [self.mapView addOverlay:overlay level:MKOverlayLevelAboveRoads];
            }
        
        }];
    }
    else
    {
        [MKMapItem openMapsWithItems:@[sourceItem, destinationItem] launchOptions:@{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving}];
    }
}

#pragma mark -

- (void)updateAnnotationsWithObject:(id<MKAnnotation>)annotation
{
	[self.mapView removeAnnotations:self.annotations];
    [self.annotations addObject:annotation];
    [self.mapView addAnnotations:self.annotations];
    self.selectedAnnotation = annotation;
    
    if (IS_IOS7_AND_UP)
    {
       [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    }
}

- (void)updateExpectedTimeForRoute:(CRPolyLine*)polyline
{
    if (polyline.routeType == CRRouteTypeSecondary)
    {
        return;
    }
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0,0, 300, 50)];
    
    NSString *stringToSet = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"ExpectedTime", @""), [self stringFromTimeInterval:polyline.expectedTravelTime]];
    [label setText:stringToSet];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:label];
    [self.navigationController.toolbar setItems:@[barButtonItem]];
}

- (NSString *)stringFromTimeInterval:(NSTimeInterval)timeInterval
{
    NSInteger integerTimeInterval = (NSInteger)timeInterval;
    NSInteger seconds = integerTimeInterval % 60;
    NSInteger minutes = (integerTimeInterval / 60) % 60;
    NSInteger hours = (integerTimeInterval / 3600);
    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

#pragma mark - 

- (void)showRouteDetails:(CRPolyLine*)overlay
{
    MKMapPoint mapPoint = overlay.points[overlay.pointCount/2];
    CGPoint point = [self.mapView convertCoordinate:MKCoordinateForMapPoint(mapPoint) toPointToView:self.mapView];
    CRRoutedDetailsViewController *routeDetailsViewController = [[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"RouteDetails"];
    
    routeDetailsViewController.expectedTime = [self stringFromTimeInterval:overlay.expectedTravelTime];
    
    UIPopoverController *detailsPopover = [[UIPopoverController alloc] initWithContentViewController:routeDetailsViewController];
    self.routeDetailsPopover = detailsPopover;
    [self.routeDetailsPopover presentPopoverFromRect:CGRectMake(point.x, point.y, 10, 10) inView:self.mapView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

@end
