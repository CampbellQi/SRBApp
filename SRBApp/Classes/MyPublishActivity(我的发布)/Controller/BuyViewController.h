//
//  BuyViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface BuyViewController : ZZViewController<UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate,CLLocationManagerDelegate>
{
    MBProgressHUD * HUD;
}
@property (nonatomic,strong)NSString * categoryID;
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;  //反编码城市
@property (nonatomic, strong) NSDictionary *localDic;  //包含地址、经纬度

@end
