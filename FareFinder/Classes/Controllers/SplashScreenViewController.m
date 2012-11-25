//
//  SplashScreenViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-24.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "SplashScreenViewController.h"

@interface SplashScreenViewController ()

@end

@implementation SplashScreenViewController

- (void)fadeEverythingOut:(NSTimer *)sender
{
  [UIView animateWithDuration:0.5
                   animations:^{
                     // _logoImageView.alpha = 0;
                   }
                   completion:^(BOOL finished) {
                     [self performSegueWithIdentifier:@"loadLocationsViewController"
                                               sender:self];
                   }];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ( [ [segue identifier] isEqualToString:@"loadLocationsViewController" ] ) {
    
  }
}


# pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  /*
   This is a splash screen, after the view has loaded, fade out the logo,
   then load the destination view controller.
   */
  [NSTimer scheduledTimerWithTimeInterval:1
                                   target:self
                                 selector:@selector(fadeEverythingOut:)
                                 userInfo:nil
                                  repeats:NO];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end