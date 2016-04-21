//
//  NewLocationViewController.h
//  SRBApp
//
//  Created by zxk on 15/6/24.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "LocationModel.h"



@class LoginViewController,TagLocationsViewController;

@interface BaseLocationViewController : ZZViewController
{
    NSMutableArray * dataArray;         //存放请求回来的数据
    NSMutableArray * _rectArray;        //存放描述内容的frame
    NoDataView * noData;                //没有数据的时候显示
}
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic,strong)UIButton *toTopBtn;
//点击全文要展开的指定行
@property (nonatomic,assign)long spreadIndex;//返回顶部

- (NSString *)appendStrWithLocationModel:(LocationModel *)locationmodel;
- (void)urlRequestPost;
@end
