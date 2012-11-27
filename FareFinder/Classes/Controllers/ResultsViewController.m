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
  - (IBAction)mapButtonPressed:(id)sender;
@end

@implementation ResultsViewController

@synthesize data = _data;

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
  
  _data = [DataSingleton sharedInstance];
  
  NSLog(@"%@", _data.startPoint.title);
  NSLog(@"%@", _data.endPoint.title);
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end