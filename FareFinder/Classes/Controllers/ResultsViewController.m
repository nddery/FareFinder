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
  @property float km;
  @property (strong, nonatomic) NSString *time;
  @property float price;
  @property (weak, nonatomic) IBOutlet UILabel *priceField;
  @property (weak, nonatomic) IBOutlet UILabel *durationField;
  @property (weak, nonatomic) IBOutlet UILabel *firstlineField;
  - (IBAction)mapButtonPressed:(id)sender;
  - (void)waitForDataToBeLoaded;
@end

@implementation ResultsViewController

@synthesize data           = _data;
@synthesize price          = _price;
@synthesize time           = _time;
@synthesize km             = _km;
@synthesize priceField     = _priceField;
@synthesize durationField  = _durationField;
@synthesize firstlineField = _firstlineField;

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
  
  [self setTitle:NSLocalizedString(@"resultstitle", nil)];
  
  
//  CGSize appDim = [[UIScreen mainScreen] applicationFrame].size;
  
  _data = [DataSingleton sharedInstance];
  
  // Set view bg color
  [self.view setBackgroundColor:[UIColor colorWithRed:225/255.f
                                                green:226/255.f
                                                 blue:227/255.f
                                                alpha:1]];
  
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
    
    // Duration
    NSDictionary *duration = [foo objectForKey:@"duration"];
    _time = [duration objectForKey:@"text"];
    NSLog(@"%.2f", _km);
    NSLog(@"%@", _time);
    
    [_durationField setText:[NSString stringWithFormat:NSLocalizedString(@"duration", nil), _km, _time]];
    
    // Price
    float startingPrice = 3.3;
    float pricePerKm = 1.6;
//    float priceForMinuteWaited = 0.6;
    _price = startingPrice + ( pricePerKm * _km );
    [_priceField setText:[NSString stringWithFormat:@"$%.2f", _price]];
    
    [_firstlineField setText:NSLocalizedString(@"firstline", nil)];
  }
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end