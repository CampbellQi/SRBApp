//
//  ChangeBuyViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/1/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WaitPublishModel.h"
#import "NotPublishViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <UIImageView+WebCache.h>
#import "MyPublishViewController.h"
#import "UpImageView.h"
#import "CTAssetsPickerController.h"
#import "NearbyLocationsViewController.h"
#import "FinishView.h"
#import <UIImageView+WebCache.h>
#import "PublishLaterView.h"
#import "PublishLaterBackViewController.h"




@interface ChangeBuyViewController : ZZViewController<UITextFieldDelegate, UITextViewDelegate, UIAlertViewDelegate,UIGestureRecognizerDelegate,CLLocationManagerDelegate>
{
    MBProgressHUD * HUD;
    UILabel * positionLB;
    UIImageView * chooseImage;
    
    UILabel * thingTitle;
    UILabel * thingDetail;
    UITextView * detailTV;
    UITextField * titleTT;
    
    UILabel * labeltext;
    
    UIImageView * imageView1;
    UIImageView * imageView2;
    UIImageView * imageView3;
    UIImageView * imageView4;
    UIImageView * imageView5;
    UIImageView * imageView6;
    UIImageView * imageView7;
    
    UIButton * imageButton;
    int imageNumber;
    AVCaptureDevice *device;
    
    NSString * uuid1;
    NSString * uuid2;
    NSString * uuid3;
    NSString * uuid4;
    NSString * uuid5;
    NSString * uuid6;
    
    UIView * theView;
    
    NSString * positionsign;
    UIButton * positionbutton;
    
    NSMutableString * myphotos;
    
    int imageSign;
    
    int publishNum;
    int postTime;
    
    NSMutableString * theStr;
    NSMutableArray * assets;
    
    UIImage * image1;
    UIImage * image2;
    UIImage * image3;
    UIImage * image4;
    UIImage * image5;
    UIImage * image6;
    
    NSInteger uploadnum;
    
    NSMutableArray * arr;
    
    NSTimer * timer;
    
    int camera;
}
@property (nonatomic, strong) PublishLaterView * publishLater;
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)NSMutableArray *imageArr;
@property (nonatomic, strong) NSString *latitude;//纬度
@property (nonatomic, strong) NSString *longitude;//经度
@property (nonatomic, strong) NSString *latitudeHad;//纬度
@property (nonatomic, strong) NSString *longitudeHad;//经度
@property (nonatomic, strong) NSString *city;//城市
@property (nonatomic, strong) NSString *detailAddress;//具体地址
@property (nonatomic, strong)NSString * categoryID;
@property (nonatomic, strong)DetailModel * model;
@property (nonatomic, strong)NSString * idNumber;
@property (nonatomic, strong)NSString * sign;
@property (nonatomic,strong)NotPublishViewController * notPublishVC;

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) CLGeocoder *geocoder;  //反编码城市
@property (nonatomic, strong) NSDictionary *localDic;  //包含地址、经纬度
@property (nonatomic,strong)UIImageView * smallV;
@property (nonatomic,strong)UIView * bigV;

@end
