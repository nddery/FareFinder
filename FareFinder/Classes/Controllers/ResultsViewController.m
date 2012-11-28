//
//  ResultsViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-25.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "ResultsViewController.h"
#import "MapViewController.h"
#import "DataSingleton.h"

@interface ResultsViewController ()
  @property DataSingleton *data;
  // Declare these primitive as nonatomic so we can define a getter without
  // defining a setter.
  @property float price;
  @property (strong, nonatomic) NSString *time;
  @property float km;
  @property (weak, nonatomic) IBOutlet UILabel *priceField;
  @property (weak, nonatomic) IBOutlet UILabel *timeField;
  @property (weak, nonatomic) IBOutlet UILabel *kmField;
  - (IBAction)mapButtonPressed:(id)sender;
  - (void)waitForDataToBeLoaded;
@end

@implementation ResultsViewController

@synthesize data        = _data;
@synthesize price       = _price;
@synthesize time        = _time;
@synthesize km          = _km;
@synthesize priceField  = _priceField;
@synthesize timeField   = _timeField;
@synthesize kmField     = _kmField;

#pragma mark - IBActions
- (void)mapButtonPressed:(id)sender
{
  [self performSegueWithIdentifier:@"loadMapViewController" sender:self];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ( [segue.identifier isEqualToString:@"loadMapViewController"] ) {
    // MapViewController *vc = [segue destinationViewController];
  }
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
//  CGSize appDim = [[UIScreen mainScreen] applicationFrame].size;
  
  _data = [DataSingleton sharedInstance];
  
  // Set view bg color
  [self.view setBackgroundColor:[UIColor colorWithRed:225/255.f
                                                green:226/255.f
                                                 blue:227/255.f
                                                alpha:1]];
  
  // @TODO: WTF can't set frame for a IB map ?????
  // Adjust the height of the map.
//  [_mapView setFrame:CGRectMake(0, -(appDim.height - 50), appDim.width, appDim.height-50)];
//  [_mapView setFrame:CGRectMake(0, 0, 320, 400)];
//  NSLog(@"%d", _mapView.frame.size.height);
//  // Also need to adjust scroll view height
//  [_scrollView setContentSize:CGSizeMake(appDim.width, _scrollView.frame.size.height + _mapView.frame.size.height)];
//  _map = [[MKMapView alloc] initWithFrame:CGRectMake(0, -(appDim.height - 50), appDim.width, appDim.height - 50)];
//  _map = [[MKMapView alloc] initWithFrame:CGRectMake(0, appDim.width, 320, 400)];
//  [self.view addSubview:_map];
  [self waitForDataToBeLoaded];
}


- (void)waitForDataToBeLoaded
{
  if ( _data.route == nil ) {
    [self performSelector:@selector(waitForDataToBeLoaded) withObject:self afterDelay:0.1];
  }
  else {
    // Getters aren't even f**** called (sorry getting late and i'm tired/pissed a bit)
    // Define those here, might even be better anyway...
    // KM
    NSArray *legs = [_data.route objectForKey:@"legs"];
    NSDictionary *foo = [legs objectAtIndex:0];
    NSDictionary *distance = [foo objectForKey:@"distance"];
    _km = [[distance objectForKey:@"text"] floatValue];
    [_kmField setText:[NSString stringWithFormat:@"Ride lenght: %.2f km", _km]];
    
    // Price
    float startingPrice = 3;
    float pricePerKm = 1;
//    float priceForMinuteWaited = 2;
    _price = startingPrice + ( pricePerKm * _km );
    [_priceField setText:[NSString stringWithFormat:@"$%.2f", _price]];
    
    // Time
    NSDictionary *duration = [foo objectForKey:@"duration"];
    _time = [duration objectForKey:@"text"];
    [_timeField setText:_time];
  }
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end