//
//  FadeCustomSegue.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-24.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "FadeCustomSegue.h"

@implementation FadeCustomSegue

- (void) perform
{
  [[self sourceViewController] presentModalViewController:[self destinationViewController] animated:NO];
}

@end
