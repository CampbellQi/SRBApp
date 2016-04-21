//
//  TPMarkModel.h
//  testImageEdit
//
//  Created by fengwanqi on 15/11/2.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TPMarkModel : NSObject

@property (strong, nonatomic) NSString *birthland;

@property (strong, nonatomic) NSString *chinaprice;
@property (strong, nonatomic) NSString *goodsId;



@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *tagprice;


@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *origin;
@property (strong, nonatomic) NSString *brand;
@property (strong, nonatomic) NSString *shopprice;
@property (strong, nonatomic) NSString *shopland;
@property (strong, nonatomic) NSString *unit;
//@property (strong, nonatomic) NSString *xScale;
//@property (strong, nonatomic) NSString *yScale;
@property (strong, nonatomic) NSString *xyz;
@property (strong, nonatomic) NSString *shape;

-(NSDictionary *)transToDict;
@end
