//
//  TotalTableViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/6.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "LocationModel.h"
#import "LocationCell.h"
#import "LeftImgAndRightTitleBtn.h"
#import "PersonalViewController.h"
#import "ImageViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "DDMenuController.h"
#import "AppDelegate.h"
#import "MyImgView.h"
#import "MyView.h"


@interface TotalTableViewController : UITableViewController
{
    NSMutableArray * dataArray;
    NoDataView * noData;
    UITextView * commentTextView;
}
- (void)urlRequestPost;
- (void)headerRefresh;
- (void)footerRefresh;
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic;

@end
