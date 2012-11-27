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
  - (void)retrievePath;
@end

@implementation DataSingleton

@synthesize locationManager = _locationManager;
@synthesize currentLocation = _currentLocation;
@synthesize startPoint      = _startPoint;
@synthesize endPoint        = _endPoint;
@synthesize path            = _path;

#pragma mark - Data queries
- (void)retrievePath
{
  //
}


#pragma mark - Getters
- (MKPointAnnotation *)startPoint
{
  if ( nil == _startPoint )
    _startPoint = _currentLocation;
  
  return _startPoint;
}


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
  _currentLocation.title = @"My Location";
  CLLocationCoordinate2D c = CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude);
  _currentLocation.coordinate = c;
  
  // Stop querying for location, we have what we came for.
  [_locationManager stopUpdatingLocation];
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


#pragma mark - Lifecycle
- (id)init
{
  self = [super init];
  
  if ( self ) {
    // Retrieve current location
    _currentLocation = [[MKPointAnnotation alloc] init];
    if ( [CLLocationManager locationServicesEnabled] ) {
      _locationManager = [[CLLocationManager alloc] init];
      // @TODO: Replace setPurpose - but by what?
      // [_locationManager setPurpose:@"We'd like to use your current location as your starting point. Can we?"];
      [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
      // Mostly for one-time location grabbing..
      [_locationManager setDistanceFilter:50];
      [_locationManager setDelegate:self];
      [_locationManager startUpdatingLocation];
    }
    // We'll just fallback gracefully, no need to tell anyone
    // it did'nt work out between us.
  }
  
  return self;
}

@end