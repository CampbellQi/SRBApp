//
//  MapViewController.h
//  CoolCar
//
//  Created by zz on 14-10-20.
//  Copyright (c) 2014年 winter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface MapViewController : UIViewController
@property (nonatomic,retain)MKMapView * mapView;
@property (nonatomic,assign)double lat;
@property (nonatomic,assign)double lon;
@property (nonatomic,retain)NSString * address;
@property (nonatomic,retain)NSString * name;
@property (nonatomic,assign)int number;
@end
