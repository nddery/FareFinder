//
//  MapViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-26.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <MKMapViewDelegate,
                                  CLLocationManagerDelegate>
  @property (weak, nonatomic) IBOutlet MKMapView *mapView;
  @property (strong, nonatomic) CLLocationManager *locationManager;
@end

@implementation MapViewController

@synthesize startPoint      = _startPoint;
@synthesize endPoint        = _endPoint;
@synthesize mapView         = _mapView;
@synthesize locationManager = _locationManager;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end