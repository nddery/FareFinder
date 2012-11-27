//
//  ResultsViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-25.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "ResultsViewController.h"
#import "MapViewController.h"

@interface ResultsViewController ()
  @property float price;
  @property float time;
  @property float km;
  - (IBAction)mapButtonPressed:(id)sender;
@end

@implementation ResultsViewController

@synthesize startPoint  = _startPoint;
@synthesize endPoint    = _endPoint;


#pragma mark - IBActions
- (void)mapButtonPressed:(id)sender
{
  [self performSegueWithIdentifier:@"laodMapViewController" sender:self];
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ( [segue.identifier isEqualToString:@"loadMapViewController"] ) {
    MapViewController *vc = [segue destinationViewController];
    [vc setStartPoint:_startPoint];
    [vc setEndPoint:_endPoint];
  }
}


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