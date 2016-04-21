//
//  ChangeSaleViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WaitPublishModel.h"
#import "NotPublishViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "PublishLaterView.h"

@interface FreeSaleViewController : ZZViewController<UITextFieldDelegate, UITextViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    MBProgressHUD * HUD;
    
}
@property (nonatomic, strong)NSString * categoryID;
@property (nonatomic, strong)DetailModel * model;
@property (nonatomic, strong)NSString * idNumber;
@property (nonatomic, strong)NSString * sign;
@property (nonatomic,strong)NotPublishViewController * notPublishVC;
@property (nonatomic, strong) PublishLaterView * publishLater;
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;  //反编码城市
@property (nonatomic, strong) NSDictionary *localDic;  //包含地址、经纬度
@property (nonatomic,strong)UIImageView * smallV;
@property (nonatomic,strong)UIView * bigV;

@end
