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
@property (strong, nonatomic) MKMapView  *map;
  - (IBAction)mapButtonPressed:(id)sender;
@end

@implementation ResultsViewController

@synthesize data        = _data;
@synthesize scrollView  = _scrollView;
@synthesize mapView     = _mapView;
@synthesize map         = _map;

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
  
  // Get the path
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end