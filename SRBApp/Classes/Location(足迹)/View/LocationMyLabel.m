//
//  LocationMyLabel.m
//  SRBApp
//
//  Created by zxk on 15/2/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LocationMyLabel.h"

@implementation LocationMyLabel

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#e6e6e6"]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#f6f6f6"]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setBackgroundColor:[GetColor16 hexStringToColor:@"#f6f6f6"]];
}

@end
