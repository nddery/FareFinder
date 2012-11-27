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
  @property float price;
  @property float time;
  @property float km;
  @property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
  @property (weak, nonatomic) IBOutlet MKMapView *mapView;
  - (IBAction)mapButtonPressed:(id)sender;
@end

@implementation ResultsViewController

@synthesize data        = _data;
@synthesize scrollView  = _scrollView;
@synthesize mapView     = _mapView;

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
  
  CGSize appDim = [[UIScreen mainScreen] applicationFrame].size;
  
  _data = [DataSingleton sharedInstance];
  
  // Adjust the height of the map.
  [_mapView setFrame:CGRectMake(0, -(appDim.height - 50), appDim.width, appDim.height-50)];
  
  
  // Get the path
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end