//
//  AutocompleteViewController.h
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-24.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@protocol AutocompleteViewControllerDelegate;

@interface AutocompleteViewController : ViewController
  @property (weak, nonatomic) id  delegate;
  @property (strong, nonatomic) MKPointAnnotation *selectedSuggestion;

@end


@protocol AutocompleteViewControllerDelegate
  - (void)autocompleteViewControllerDidComplete:(AutocompleteViewController *)vc;
@end