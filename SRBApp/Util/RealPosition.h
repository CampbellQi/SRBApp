//
//  RealPosition.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface RealPosition : NSObject<CLLocationManagerDelegate>
+ (void) changex:(double)x y:(double)y;
@end
