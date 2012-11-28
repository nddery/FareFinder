//
//  DataSingleton.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-27.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "DataSingleton.h"
#import "AFJSONRequestOperation.h"
#import <CoreLocation/CoreLocation.h>

@interface DataSingleton () <CLLocationManagerDelegate>
  @property (strong, nonatomic) CLLocationManager *locationManager;
  @property (strong, nonatomic) NSString *response;
  - (NSMutableArray *)decodePolyLine:(NSString *)encodedStr;
  - (MKPolyline *)createPolylineFromArray:(NSArray *)array;
@end

@implementation DataSingleton

@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize startPoint      = _startPoint;
@synthesize endPoint        = _endPoint;
@synthesize polyline        = _polyline;
@synthesize route           = _route;

#pragma mark - Data queries
// http://iosguy.com/tag/mkmapview/
- (void)retrieveDirections
{
  if ( nil == _startPoint )
    _startPoint = _currentLocation;
  
	NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=true", _startPoint.coordinate.latitude, _startPoint.coordinate.longitude, _endPoint.coordinate.latitude, _endPoint.coordinate.longitude];
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
  
  AFJSONRequestOperation *operation = [AFJSONRequestOperation
                                       JSONRequestOperationWithRequest:request
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON)
                                       {
                                         NSArray *routes = [JSON objectForKey:@"routes"];
                                         _route = [routes lastObject];
                                         if ( _route ) {
                                           // @TODO: Implement sub/pub pattern
                                           NSString *overviewPolyline = [[_route objectForKey: @"overview_polyline"] objectForKey:@"points"];
                                           NSMutableArray *p = [self decodePolyLine:overviewPolyline];
                                           _polyline = [self createPolylineFromArray:p];
                                         }
                                         else {
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"loaderror" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                           [alertView show];
                                         }
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON)
                                       {
                                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                         [alertView show];
                                       }];
  [operation start];
}


#pragma mark - Getters
// If polyline is not yet defined, define it, else just return it.
- (MKPolyline *)polyline
{
  if ( nil == _polyline )
    [self retrieveDirections];
  
  return _polyline;
}


// If start point was not provided by the user, return current location
- (MKPointAnnotation *)startPoint
{
  if ( nil == _startPoint )
    _startPoint = _currentLocation;

  return _startPoint;
}


// If end point was not provided by the user, return current location
- (MKPointAnnotation *)endPoint
{
  if ( nil == _endPoint )
    _endPoint = _currentLocation;
  
  return _endPoint;
}


#pragma mark - Core Location Delegates
// The newLocation parameter may contain the data that was cached from a
// previous usage of the location service.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
  // Store the current location as a MKPointAnnotation
  _currentLocation = [[MKPointAnnotation alloc] init];
  _currentLocation.title = @"My Location";
  CLLocationCoordinate2D c = CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude);
  _currentLocation.coordinate = c;
  
  // Stop querying for location, we have what we came for.
//  [_locationManager stopUpdatingLocation];
}


#pragma mark - Shared Instance
// Get the shared instance and create it if necessary.
+ (DataSingleton *)sharedInstance
{
  
  static DataSingleton *sharedInstance = nil;
  static dispatch_once_t onceToken;
  
  // Called at most once per app.
  dispatch_once( &onceToken, ^{
    sharedInstance = [[DataSingleton alloc] init];
  } );
  
  return sharedInstance;
}


#pragma mark - Polyline methods
- (MKPolyline *)createPolylineFromArray:(NSArray *)array
{
  NSInteger numberOfSteps = array.count;
  
  CLLocationCoordinate2D coordinates[numberOfSteps];
  for ( NSInteger index = 0; index < numberOfSteps; index++ ) {
    CLLocation *location = [array objectAtIndex:index];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    coordinates[index] = coordinate;
  }
  
  return [MKPolyline polylineWithCoordinates:coordinates count:numberOfSteps];
}


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


#pragma mark - Lifecycle
- (id)init
{
  self = [super init];
  
//  _startPoint = [[MKPointAnnotation alloc] init];
//  _endPoint = [[MKPointAnnotation alloc] init];
//  _currentLocation = [[MKPointAnnotation alloc] init];
  
  if ( self ) {
    // Retrieve current location
    _currentLocation = [[MKPointAnnotation alloc] init];
    if ( [CLLocationManager locationServicesEnabled] ) {
      _locationManager = [[CLLocationManager alloc] init];
      // @TODO: Replace setPurpose - but by what?
      // [_locationManager setPurpose:@"We'd like to use your current location as your starting point. Can we?"];
      [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
      // Mostly for one-time location grabbing..
      [_locationManager setDistanceFilter:10];
      [_locationManager setDelegate:self];
      [_locationManager startUpdatingLocation];
    }
    // We'll just fallback gracefully, no need to tell anyone
    // it did'nt work out between us.
  }
  
  return self;
}

@end