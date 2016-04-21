//
//  PublishTopicModel.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/3.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishTopicModel : NSObject

@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *original;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSArray *marksArray;
@property (nonatomic, strong)NSString *imageUrl;
@property (nonatomic, assign)float contentHeight;
-(NSArray *)getMarks;
@end
