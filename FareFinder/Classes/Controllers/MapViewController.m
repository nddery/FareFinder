//
//  MapViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-26.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "MapViewController.h"
#import "DataSingleton.h"
#import "Annotation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <MKMapViewDelegate,
                                  CLLocationManagerDelegate>
  @property DataSingleton *data;
  @property (weak, nonatomic) IBOutlet MKMapView *mapView;
  @property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation MapViewController

@synthesize data            = _data;
@synthesize mapView         = _mapView;
@synthesize locationManager = _locationManager;

#pragma mark - MKMapView delegate
- (MKOverlayView *)mapView:(MKMapView *)mapView
            viewForOverlay:(id<MKOverlay>)overlay
{
  MKPolylineView *polylineView = [[MKPolylineView alloc] initWithPolyline:overlay];
  polylineView.strokeColor = [UIColor blueColor];
  polylineView.lineWidth = 4.0;
  
  return polylineView;
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _data = [DataSingleton sharedInstance];
  
  [self setTitle:NSLocalizedString(@"mapview", nil)];
  
  // @TODO: Implement sub/pub pattern
  [_mapView setDelegate:self];
  [_mapView addOverlay:_data.polyline];
  
  // Move to current location for a start
  // Move the map to the new location.
  MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(_data.currentLocation.coordinate, 500, 500);
  [_mapView setRegion:newRegion animated:YES];
  
  // @TODO: Annotaion aren't at the same place as the polyline.. ?
  // Add an annotation near the newLocation.
//  Annotation *startAnnotation = [[Annotation alloc] init];
//  [startAnnotation setLatitude:_data.startPoint.coordinate.latitude + 0.001];
//  [startAnnotation setLongitude:_data.startPoint.coordinate.longitude + 0.001];
//  [startAnnotation setName:_data.startPoint.title];
//  [_mapView addAnnotation:startAnnotation];
//  
//  Annotation *endAnnotation = [[Annotation alloc] init];
//  [endAnnotation setLatitude:_data.endPoint.coordinate.latitude + 0.001];
//  [endAnnotation setLongitude:_data.endPoint.coordinate.longitude + 0.001];
//  [endAnnotation setName:_data.endPoint.title];
//  [_mapView addAnnotation:endAnnotation];
}


-(void)viewDidAppear:(BOOL)animated
{
  // Center the map around the traject
  // http://stackoverflow.com/a/7200744
  NSDictionary *bounds = [_data.route objectForKey:@"bounds"];
  NSDictionary *ne = [bounds objectForKey:@"northeast"];
  NSDictionary *sw = [bounds objectForKey:@"southwest"];
  CLLocationCoordinate2D topLeftCoord;
  topLeftCoord.latitude = [[ne objectForKey:@"lat"] floatValue];
  topLeftCoord.longitude = [[ne objectForKey:@"lng"] floatValue];
  
//  // Values are good...
//  NSLog(@"%f, %f", [[ne objectForKey:@"lat"] floatValue], [[ne objectForKey:@"lng"] floatValue]);
//  NSLog(@"%f, %f", [[sw objectForKey:@"lat"] floatValue], [[sw objectForKey:@"lng"] floatValue]);
  
  CLLocationCoordinate2D bottomRightCoord;
  bottomRightCoord.latitude = [[sw objectForKey:@"lat"] floatValue];
  bottomRightCoord.longitude = [[sw objectForKey:@"lng"] floatValue];
  
  MKCoordinateSpan s = MKCoordinateSpanMake(fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1, fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1);
  CLLocationCoordinate2D c = CLLocationCoordinate2DMake(topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5, topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5);
  MKCoordinateRegion region = MKCoordinateRegionMake(c, s);
  
  // Add a little extra space on the sides so it fits nicely within the view
  // (and the nav bar)
  region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
  region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.4;
  
  NSLog(@"%f,%f", region.span.latitudeDelta, region.span.longitudeDelta);
  region = [_mapView regionThatFits:region];
  [_mapView setRegion:region animated:YES];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


@end