//
//  MapViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-26.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "MapViewController.h"
#import "DataSingleton.h"
#import "AFJSONRequestOperation.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <MKMapViewDelegate,
                                  CLLocationManagerDelegate>
  @property DataSingleton *data;
  @property (weak, nonatomic) IBOutlet MKMapView *mapView;
  @property (strong, nonatomic) CLLocationManager *locationManager;
  @property (strong, nonatomic) NSMutableArray *path;
  - (void)retrievePolyline;
  - (NSMutableArray *)decodePolyLine:(NSString *)encodedStr;
@end

@implementation MapViewController

@synthesize data            = _data;
@synthesize mapView         = _mapView;
@synthesize locationManager = _locationManager;
@synthesize path            = _path;

#pragma mark - Methods
// http://iosguy.com/tag/mkmapview/
- (void)retrievePolyline
{
	NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", _data.startPoint.coordinate.latitude, _data.startPoint.coordinate.longitude, _data.endPoint.coordinate.latitude, _data.endPoint.coordinate.longitude];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                       JSONRequestOperationWithRequest:request
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                       {
                                         NSArray *routes = [JSON objectForKey:@"routes"];
                                         NSDictionary *route = [routes lastObject];
                                         if ( route ) {
                                           NSString *overviewPolyline = [[route objectForKey: @"overview_polyline"] objectForKey:@"points"];
                                           _path = [self decodePolyLine:overviewPolyline];
                                         }
                                         
                                         NSInteger numberOfSteps = _path.count;
                                         
                                         CLLocationCoordinate2D coordinates[numberOfSteps];
                                         for (NSInteger index = 0; index < numberOfSteps; index++) {
                                           CLLocation *location = [_path objectAtIndex:index];
                                           CLLocationCoordinate2D coordinate = location.coordinate;
                                           
                                           coordinates[index] = coordinate;
                                         }
                                         
                                         NSLog(@"%d", numberOfSteps);
                                         MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
                                         [_mapView addOverlay:polyLine];
                                         
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                       {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                         [alertView show];
                                       }];
  [operation start];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _data = [DataSingleton sharedInstance];
  
  // Set region to view for the map
  MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_data.startPoint.coordinate, 10, 10);
  MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
  [_mapView setRegion:adjustedRegion animated:NO];
  
  [self retrievePolyline];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}


#pragma mark - Decode Polyline
// http://stackoverflow.com/a/8427172
// https://developers.google.com/maps/documentation/utilities/polylinealgorithm?hl=fr
- (NSMutableArray *)decodePolyLine:(NSString *)encodedStr
{
  NSMutableString *encoded = [[NSMutableString alloc] initWithCapacity:[encodedStr length]];
  [encoded appendString:encodedStr];
  [encoded replaceOccurrencesOfString:@"\\\\" withString:@"\\"
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [encoded length])];
  NSInteger len = [encoded length];
  NSInteger index = 0;
  NSMutableArray *array = [[NSMutableArray alloc] init];
  NSInteger lat=0;
  NSInteger lng=0;
  while (index < len) {
    NSInteger b;
    NSInteger shift = 0;
    NSInteger result = 0;
    do {
      b = [encoded characterAtIndex:index++] - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    NSInteger dlat = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lat += dlat;
    shift = 0;
    result = 0;
    do {
      b = [encoded characterAtIndex:index++] - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    NSInteger dlng = ((result & 1) ? ~(result >> 1) : (result >> 1));
    lng += dlng;
    NSNumber *latitude = [[NSNumber alloc] initWithFloat:lat * 1e-5];
    NSNumber *longitude = [[NSNumber alloc] initWithFloat:lng * 1e-5];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    [array addObject:location];
  }
  
  return array;
}

@end