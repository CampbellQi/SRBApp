//
//  NameTextView.h
//  SRBApp
//
//  Created by zxk on 15/4/20.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "LocationTextView.h"
@class NameTextView;
typedef void (^nameClickHandler)(NameTextView * nameTextView,NSString * nameStr,NSString * nameNum);
@interface NameTextView : LocationTextView
@property (nonatomic,copy)nameClickHandler clickHandler;
@end
