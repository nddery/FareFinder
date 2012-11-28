//
//  Annotation.m
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-27.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

@synthesize name      = _name;
@synthesize latitude  = _latitude;
@synthesize longitude = _longitude;


- (CLLocationCoordinate2D)coordinate
{
  return CLLocationCoordinate2DMake(_latitude, _longitude);
}


- (NSString *)title
{
  // Just use the name as the title.
  return _name;
}

@end