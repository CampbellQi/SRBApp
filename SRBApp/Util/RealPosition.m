//
//  RealPosition.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "RealPosition.h"

@implementation RealPosition
+ (void) changex:(double)x y:(double)y
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude =  x;
    coordinate.longitude = y;
    CLLocation *newLocation=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude: coordinate.longitude];
    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks,
                                       NSError *error)
     {
         CLPlacemark *placemark=[placemarks objectAtIndex:0];
         NSLog(@"我我的:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@ \n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
               placemark.name,
               placemark.country,
               placemark.postalCode,
               placemark.ISOcountryCode,
               placemark.ocean,
               placemark.inlandWater,
               placemark.administrativeArea,
               placemark.subAdministrativeArea,
               placemark.locality,
               placemark.subLocality,
               placemark.thoroughfare,
               placemark.subThoroughfare);
     }];
}

//-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
//    
//    
//    CLGeocoder *geocoder=[[CLGeocoder alloc] init];
//    [geocoder reverseGeocodeLocation:newLocation
//                   completionHandler:^(NSArray *placemarks,
//                                       NSError *error)
//     {
//         CLPlacemark *placemark=[placemarks objectAtIndex:0];
//         NSLog(@"name:%@\n country:%@\n postalCode:%@\n ISOcountryCode:%@\n ocean:%@\n inlandWater:%@\n locality:%@\n subLocality:%@ \n administrativeArea:%@\n subAdministrativeArea:%@\n thoroughfare:%@\n subThoroughfare:%@\n",
//               placemark.name,
//               placemark.country,
//               placemark.postalCode,
//               placemark.ISOcountryCode,
//               placemark.ocean,
//               placemark.inlandWater,
//               placemark.administrativeArea,
//               placemark.subAdministrativeArea,
//               placemark.locality,
//               placemark.subLocality,
//               placemark.thoroughfare,
//               placemark.subThoroughfare);
//     }];
//    if (wasFound) return;
//    wasFound = YES;
//    
//    CLLocationCoordinate2D loc = [newLocation coordinate];
//    
//    strLatitude = [NSString stringWithFormat: @"%f", loc.latitude];
//    strLongitude = [NSString stringWithFormat: @"%f", loc.longitude];
//    
//    NSLog(@"strLatitude==%@,strLongitude==%@",strLatitude,strLongitude);

@end
