//
//  ResultsViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-25.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "ResultsViewController.h"

@interface ResultsViewController ()
  @property float price;
  @property float time;
  @property float km;
@end

@implementation ResultsViewController

@synthesize startPoint  = _startPoint;
@synthesize endPoint    = _endPoint;

- (void)viewDidLoad
{
  [super viewDidLoad];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end