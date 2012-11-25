//
//  LocationsViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-24.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "LocationsViewController.h"
#import "AutocompleteViewController.h"

@interface LocationsViewController () <AutocompleteViewControllerDelegate>

// We need a property that hold the last selected text field so we can
// reference it when we dismiss the modal view. Not elegant but it will work.
@property (strong, nonatomic) UITextField *selectedTextField;
// Keep track of MKPointAnnotation so no need to redo them.
@property (strong, nonatomic) MKPointAnnotation *startPoint;
@property (strong, nonatomic) MKPointAnnotation *endPoint;
@property (weak, nonatomic) IBOutlet UITextField *startDestination;
@property (weak, nonatomic) IBOutlet UITextField *endDestination;
- (IBAction)startDestinationBegin:(id)sender;
- (IBAction)startDestinationEnd:(id)sender;
- (IBAction)endDestinationBegin:(id)sender;
- (IBAction)endDestinationEnd:(id)sender;

@end

@implementation LocationsViewController

@synthesize selectedTextField = _selectedTextField;
@synthesize startDestination  = _startDestination;
@synthesize endDestination    = _endDestination;

#pragma mark - IBActions
- (IBAction)startDestinationBegin:(id)sender
{
  _selectedTextField = _startDestination;
  [self performSegueWithIdentifier:@"loadAutocompleteViewController" sender:self];
}


- (IBAction)startDestinationEnd:(id)sender
{
  NSLog(@"start destination");
}


- (IBAction)endDestinationBegin:(id)sender
{
  _selectedTextField = _endDestination;
  [self performSegueWithIdentifier:@"loadAutocompleteViewController" sender:self];
}


- (IBAction)endDestinationEnd:(id)sender
{
  NSLog(@"end destination");
}


#pragma mark - Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ( [segue.identifier isEqualToString:@"loadAutocompleteViewController"] ) {
    AutocompleteViewController *vc = [segue destinationViewController];
    [vc setDelegate:self];
  }
}


#pragma mark - AutocompleteViewController delegates
- (void)autocompleteViewControllerDidComplete:(AutocompleteViewController *)vc
{
  // Dismiss the keyboard for our own view keyboard.
  [_selectedTextField resignFirstResponder];
  // @TODO: Save MKAnotation
  [_selectedTextField setText:vc.selectedSuggestion.title];
  
  [self dismissViewControllerAnimated:YES
                           completion:^{
                           }];
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