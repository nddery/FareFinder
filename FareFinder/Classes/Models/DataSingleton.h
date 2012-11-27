//
//  DataSingleton.h
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-27.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DataSingleton : NSObject

@property (strong, nonatomic) MKPointAnnotation *currentLocation;
@property (strong, nonatomic) MKPointAnnotation *startPoint;
@property (strong, nonatomic) MKPointAnnotation *endPoint;
@property (strong, nonatomic) NSMutableArray    *pathInformation;
@property (strong, nonatomic) MKPolyline        *polyline;

+ (id)sharedInstance;

- (void)retrieveDirections;

@end