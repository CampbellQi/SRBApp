//
//  TopicCommentModel.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TopicCommentModel : NSObject
@property(nonatomic, strong) NSString* account;
@property(nonatomic, strong) NSString* avatar;
@property(nonatomic, strong) NSString* commonCount;
@property(nonatomic, strong) NSString* content;
@property(nonatomic, strong) NSString* friendId;
@property(nonatomic, strong) NSString* model_id;
@property(nonatomic, strong) NSString* isCollected;
@property(nonatomic, strong) NSString* isFriended;
@property(nonatomic, strong) NSString* markId;
@property(nonatomic, strong) NSString* memo;
@property(nonatomic, strong) NSString* nickname;
@property(nonatomic, strong) NSString* sex;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* updatetime;
@property(nonatomic, strong) NSAttributedString* attrContent;

@property(nonatomic, strong)NSDictionary *touser;
@property(nonatomic, assign) float attrContentHeight;

@property(nonatomic, assign) double updatetimeLong;

@end
