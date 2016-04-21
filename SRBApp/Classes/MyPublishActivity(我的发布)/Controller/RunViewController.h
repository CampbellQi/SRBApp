//
//  RunViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TotalViewController.h"
#import "CircleTable.h"
#import "RelationTable.h"
#import "CTAssetsPickerController.h"
#import "CTAppDelegate.h"
#import <TuSDK/TuSDKICViewController.h>

@class NewLocationViewController;

typedef void (^RelationBlock)(NSString *relation);

@interface RunViewController : TuSDKICViewController<UITextViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate,CLLocationManagerDelegate,CTAssetsPickerControllerDelegate>
{
    MBProgressHUD * HUD;
}

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;  //反编码城市
@property (nonatomic, strong) NSDictionary *localDic;  //包含地址、经纬度

//@property (nonatomic,strong)TotalViewController * totalVC;

/** 暂时不用 */
@property (nonatomic,strong)CircleTable * circleVC;
/** 暂时不用 */
@property (nonatomic,strong)RelationTable * relationVC;

//@property (nonatomic,strong)NewLocationViewController * locationVC;

//@property (nonatomic, copy) RelationBlock relationBlock;
@property (nonatomic,strong)UILabel * showSignLabel;    //显示标签
@property (nonatomic,copy)NSString * signStr;
@property (nonatomic,copy)NSMutableArray * signArray;  //标签
//-(void)relation:(RelationBlock)block;
@end
