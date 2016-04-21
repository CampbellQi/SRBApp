//
//  NearbyLocationsViewController.h
//  SRBApp
//
//  Created by lizhen on 15/2/26.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
typedef void (^PositionBlock)(NSString *position, NSDictionary *location);

@interface NearbyLocationsViewController : ZZViewController
@property (nonatomic, copy) PositionBlock positionBlock;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *address;

- (void)position:(PositionBlock)block;
@end
