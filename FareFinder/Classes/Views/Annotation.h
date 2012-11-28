//
//  Annotation.h
//  FareFinder
//
//  Created by Nicolas Duvieusart Dery on 12-11-27.
//  Copyright (c) 2012 Nicolas Duvieusart Dery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) double latitude;
@property (assign, nonatomic) double longitude;

@end