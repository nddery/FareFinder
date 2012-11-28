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
  
  
////  CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(32, -122);
////  MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(coord, 500, 500);
////  [_mapView setRegion:newRegion animated:YES];
//  
//  // Center the map around the traject
//  // http://stackoverflow.com/a/7200744
//  NSDictionary *bounds = [_data.route objectForKey:@"bounds"];
//  NSDictionary *ne = [bounds objectForKey:@"northeast"];
//  NSDictionary *sw = [bounds objectForKey:@"southwest"];
//  CLLocationCoordinate2D topLeftCoord;
//  topLeftCoord.latitude = [[ne objectForKey:@"lat"] floatValue];
//  topLeftCoord.longitude = [[ne objectForKey:@"lng"] floatValue];
//  
//  // Values are good...
//  NSLog(@"%f, %f", [[ne objectForKey:@"lat"] floatValue], [[ne objectForKey:@"lng"] floatValue]);
//  NSLog(@"%f, %f", [[sw objectForKey:@"lat"] floatValue], [[sw objectForKey:@"lng"] floatValue]);
//  
//  CLLocationCoordinate2D bottomRightCoord;
//  bottomRightCoord.latitude = [[sw objectForKey:@"lat"] floatValue];
//  bottomRightCoord.longitude = [[sw objectForKey:@"lng"] floatValue];
//  
//  
//  MKCoordinateSpan s = MKCoordinateSpanMake(fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1, fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1);
//  CLLocationCoordinate2D c = CLLocationCoordinate2DMake(topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5, topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5);
//  MKCoordinateRegion region = MKCoordinateRegionMake(c, s);
//  
//  
////  region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
////  region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
////  region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
//  
//  // Add a little extra space on the sides
////  region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 10;
//  
//  // @TODO: Trying to set this region gives an error saying values are nil.. which is a lie.
//  region = [_mapView regionThatFits:region];
// [_mapView setRegion:region animated:YES];
//  
////  MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(bottomRightCoord, 500, 500);
////  [_mapView setRegion:newRegion animated:YES];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}



@end