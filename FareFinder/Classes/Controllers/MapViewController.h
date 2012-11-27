//
//  MapViewController.h
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-26.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController
  @property (strong, nonatomic) MKPointAnnotation *startPoint;
  @property (strong, nonatomic) MKPointAnnotation *endPoint;
@end