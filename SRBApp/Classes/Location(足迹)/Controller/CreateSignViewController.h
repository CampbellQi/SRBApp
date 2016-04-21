//
//  CreateSignViewController.h
//  SRBApp
//
//  Created by zxk on 15/4/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

typedef void (^CompleteBlock) (NSString *signStr);
#import "ZZViewController.h"
//#import "RunViewController.h"

@interface CreateSignViewController : ZZViewController
@property (nonatomic,strong)UIScrollView * mainScroll;
@property (nonatomic,strong)UITextField * signText;
//@property (nonatomic,strong)RunViewController * runViewVC;
@property (nonatomic,copy)NSString * signStr;

@property (nonatomic, copy)CompleteBlock completeBlock;
@property (nonatomic, assign)BOOL isTopicMark;
//@property (nonatomic,strong) NSMutableArray * signArrs;      //标签数组
@end
