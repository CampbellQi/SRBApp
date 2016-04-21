//
//  CategoryModel.h
//  SRBApp
//
//  Created by 刘若曈 on 15/1/16.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject
@property (nonatomic, strong)NSString * categoryID;
@property (nonatomic, strong)NSString * categoryName;
@property (nonatomic, strong)NSString * categoryType;
@property (nonatomic, strong)NSString * pic;
@property (nonatomic, strong)NSString * color;
@property (nonatomic, strong)NSArray * subCategory;
@end
