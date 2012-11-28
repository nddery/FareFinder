//
//  LocationsViewController.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-24.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "LocationsViewController.h"
#import "AutocompleteViewController.h"
#import "ResultsViewController.h"
#import "DataSingleton.h"

@interface LocationsViewController () <AutocompleteViewControllerDelegate,
                                        UITextFieldDelegate>
  @property DataSingleton *data;
  // We need a property that hold the last selected text field so we can
  // reference it when we dismiss the modal view. Not elegant but it will work.
  @property (strong, nonatomic) UITextField *selectedTextField;
  @property (weak, nonatomic) IBOutlet UITextField *startDestination;
  @property (weak, nonatomic) IBOutlet UITextField *endDestination;
  @property (weak, nonatomic) IBOutlet UIButton *calculateButton;
  @property (strong, nonatomic) CLLocationManager *locationManager;
  - (IBAction)startDestinationBegin:(id)sender;
  - (IBAction)endDestinationBegin:(id)sender;
  - (IBAction)calculatePressed:(id)sender;
  - (void)updateTextColor:(UITextField *)tf;
@end

@implementation LocationsViewController

@synthesize data              = _data;
@synthesize selectedTextField = _selectedTextField;
@synthesize startDestination  = _startDestination;
@synthesize endDestination    = _endDestination;
@synthesize calculateButton   = _calculateButton;
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


- (IBAction)calculatePressed:(id)sender
{
  [self performSegueWithIdentifier:@"loadResultsViewController" sender:self];
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
    [vc setCurrentSearch:_selectedTextField.text];
  }
  else if ( [segue.identifier isEqualToString:@"loadResultsViewController"] ) {
    [_data retrieveDirections];
  }
}


#pragma mark - AutocompleteViewController delegates
- (void)autocompleteViewControllerDidComplete:(AutocompleteViewController *)vc
{
  // Dismiss the keyboard for our own view keyboard.
  [_selectedTextField resignFirstResponder];
  [_selectedTextField setText:vc.selectedSuggestion.title];
  
  // Save the selected suggestion (MKPointAnotation)
  if ( _selectedTextField == _startDestination )
    [_data setStartPoint:vc.selectedSuggestion];
  else
    [_data setEndPoint:vc.selectedSuggestion];
  
  [self updateTextColor:_selectedTextField];
  
  [self dismissViewControllerAnimated:YES
                           completion:^{
                           }];
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Do this here so it "stays" even if pushing back
  [self setTitle:NSLocalizedString(@"appname", nil)];
  [self.navigationItem setHidesBackButton:YES animated:YES];
  
  _data = [DataSingleton sharedInstance];
  
  // Add padding to the textfields.
  UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
  _startDestination.leftView = paddingView;
  _startDestination.leftViewMode = UITextFieldViewModeAlways;
  UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 20)];
  _endDestination.leftView = paddingView2;
  _endDestination.leftViewMode = UITextFieldViewModeAlways;
  
  // Fake current location (we are referencing DataSingleton anyway)
  [_startDestination setText:@"My Location"];
  [self updateTextColor:_startDestination];
}


- (void)viewDidAppear:(BOOL)animated
{
  // Animate the quote button in
  [UIView animateWithDuration:0.3
                   animations:^{
                     _calculateButton.alpha = 1;
                   }
                   completion:^(BOOL finished) {
                     //
                   }];
}


- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  CGSize appDim = [[UIScreen mainScreen] applicationFrame].size;
  
  // Move the start field to the left
  _startDestination.frame = CGRectMake(
                                       _startDestination.frame.origin.x - appDim.width,
                                       _startDestination.frame.origin.y,
                                       _startDestination.frame.size.width,
                                       _startDestination.frame.size.height
                                       );
  
  // Move the end field to the right
  _endDestination.frame = CGRectMake(
                                     _endDestination.frame.origin.x + appDim.width,
                                     _endDestination.frame.origin.y,
                                     _endDestination.frame.size.width,
                                     _endDestination.frame.size.height
                                     );
  
  // Get quote button will fade, set opacity
  _calculateButton.alpha = 0;
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

@end