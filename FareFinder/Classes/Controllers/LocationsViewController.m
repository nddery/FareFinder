//
//  LocationsViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-24.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "LocationsViewController.h"
#import "AutocompleteViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface LocationsViewController () <AutocompleteViewControllerDelegate,
                                        CLLocationManagerDelegate,
                                        UITextFieldDelegate>
  // We need a property that hold the last selected text field so we can
  // reference it when we dismiss the modal view. Not elegant but it will work.
  @property (strong, nonatomic) UITextField *selectedTextField;
  // Keep track of MKPointAnnotation so no need to redo them.
  @property (strong, nonatomic) MKPointAnnotation *startPoint;
  @property (strong, nonatomic) MKPointAnnotation *endPoint;
  @property (weak, nonatomic) IBOutlet UITextField *startDestination;
  @property (weak, nonatomic) IBOutlet UITextField *endDestination;
  @property (strong, nonatomic) CLLocationManager *locationManager;
  - (IBAction)startDestinationBegin:(id)sender;
  - (IBAction)endDestinationBegin:(id)sender;
  - (IBAction)calculatePressed:(id)sender;
  - (void)updateTextColor:(UITextField *)tf;
@end

@implementation LocationsViewController

@synthesize selectedTextField = _selectedTextField;
@synthesize startPoint        = _startPoint;
@synthesize endPoint          = _endPoint;
@synthesize startDestination  = _startDestination;
@synthesize endDestination    = _endDestination;
@synthesize locationManager   = _locationManager;

#pragma mark - IBActions
- (IBAction)startDestinationBegin:(id)sender
{
  _selectedTextField = _startDestination;
  [self performSegueWithIdentifier:@"loadAutocompleteViewController" sender:self];
}


- (IBAction)endDestinationBegin:(id)sender
{
  _selectedTextField = _endDestination;
  [self performSegueWithIdentifier:@"loadAutocompleteViewController" sender:self];
}


# pragma mark - 
- (void)updateTextColor:(UITextField *)tf
{
  // If is current location, make the text blue
  if ( [[tf text] isEqualToString:@"My Location"] )
    [tf setTextColor:[UIColor blueColor]];
  else
    [tf setTextColor:[UIColor blackColor]];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ( [segue.identifier isEqualToString:@"loadAutocompleteViewController"] ) {
    AutocompleteViewController *vc = [segue destinationViewController];
    [vc setDelegate:self];
    [vc setCurrentLocation:_startPoint];
  }
}


#pragma mark - Core Location Delegates
// The newLocation parameter may contain the data that was cached from a
// previous usage of the location service.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
  // Store the current location as a MKPointAnnotation
  MKPointAnnotation *currentLocation = [[MKPointAnnotation alloc] init];
  currentLocation.title = @"My Location";
  CLLocationCoordinate2D c = CLLocationCoordinate2DMake(manager.location.coordinate.latitude, manager.location.coordinate.longitude);
  currentLocation.coordinate = c;
  
  _startPoint = currentLocation;
  [_startDestination setText:_startPoint.title];
  [self updateTextColor:_startDestination];
  
  // Stop querying for location, we have what we came for.
  [_locationManager stopUpdatingLocation];
}


#pragma mark - AutocompleteViewController delegates
- (void)autocompleteViewControllerDidComplete:(AutocompleteViewController *)vc
{
  // Dismiss the keyboard for our own view keyboard.
  [_selectedTextField resignFirstResponder];
  [_selectedTextField setText:vc.selectedSuggestion.title];
  
  // Save the selected suggestion (MKPointAnotation)
  if ( _selectedTextField == _startDestination )
    _startPoint = vc.selectedSuggestion;
  else
    _endPoint = vc.selectedSuggestion;
  
  [self updateTextColor:_selectedTextField];
  
  [self dismissViewControllerAnimated:YES
                           completion:^{
                           }];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  if ( [CLLocationManager locationServicesEnabled] ) {
    _locationManager = [[CLLocationManager alloc] init];
    // @TODO: Replace setPurpose - but by what?
    [_locationManager setPurpose:@"We'd like to use your current location as your starting point. Can we?"];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    // Mostly for one-time location grabbing..
    [_locationManager setDistanceFilter:50];
    [_locationManager setDelegate:self];
  }
  // We'll just fallback gracefully, no need to tell anyone it did'nt work out
  // between us.
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  if ( _locationManager )
    [_locationManager startUpdatingLocation];
}


- (void)viewWillDisappear:(BOOL)animated
{
  if ( _locationManager )
    [_locationManager stopUpdatingLocation];
  
  [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (IBAction)calculatePressed:(id)sender {
}
@end