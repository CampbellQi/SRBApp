//
//  TopicDetailModel.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/30.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TopicDetailModel : NSObject
@property (nonatomic, strong)NSString * cityName;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSString *cover;
@property (nonatomic, strong)NSString *dealName;
@property (nonatomic, strong)NSString *dealType;
@property (nonatomic, strong)NSString *model_description;
@property (nonatomic, strong)NSString *model_id;
@property (nonatomic, strong)NSString *note;
@property (nonatomic, strong)NSString *photo;
@property (nonatomic, strong)NSString *photos;
@property (nonatomic, strong)NSString *sortName;
@property (nonatomic, strong)NSString *sortid;
@property (nonatomic, strong)NSString *tags;
@property (nonatomic, strong)NSString *title;
@property (nonatomic, strong)NSString *type;
//求购次数
@property (nonatomic, strong)NSString *quotes;
//长草次数
@property (nonatomic, strong)NSString *wishCount;
@property (nonatomic, strong)NSString *favCount;
@property(nonatomic, strong) NSAttributedString* attrContent;
@property(nonatomic, assign) float attrContentHeight;

//标签
@property (nonatomic, strong)NSArray * labels;

@property (nonatomic, assign)BOOL isAttached;
@property (nonatomic, strong)NSString *cell;

@end
