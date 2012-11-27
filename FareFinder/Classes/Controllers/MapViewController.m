//
//  MapViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-26.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "MapViewController.h"
#import "DataSingleton.h"
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
  
  // Set region to view for the map
//  NSLog(@"%f,%f", _data.startPoint.coordinate.latitude, _data.startPoint.coordinate.longitude);
//  CLLocationCoordinate2D c = CLLocationCoordinate2DMake(_data.startPoint.coordinate.latitude, _data.startPoint.coordinate.longitude);
//  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(c, 10, 10);
//  // MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_data.startPoint.coordinate, 1000, 1000);
//  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
//  [_mapView setRegion:adjustedRegion animated:NO];
  
  // @TODO: Implement sub/pub pattern
  [_mapView setDelegate:self];
  [_mapView addOverlay:_data.polyline];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}



@end