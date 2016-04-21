//
//  TotalViewController.h
//  SRBApp
//
//  Created by zxk on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "MJRefresh.h"
#import "LocationModel.h"
#import "LocationCell.h"
#import "LeftImgAndRightTitleBtn.h"
#import "PersonalViewController.h"
#import "ImageViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
//#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "MyImgView.h"
#import "MyView.h"
#import "HPGrowingTextView.h"

#import "ImgScrollView.h"
#import "TapImageView.h"
#import <UIImageView+WebCache.h>

#import "ZZNavigationController.h"
#import "MapViewController.h"
#import "ShareViewController.h"
#import "RegexKitLite.h"
#import "LocationTextView.h"
#import "EmotionKeyboard.h"

@class LoginViewController,TagLocationsViewController;

@interface TotalViewController : ZZViewController<UITableViewDataSource,UITableViewDelegate,TableViewCellDelegates,ISSShareViewDelegate,UITextViewDelegate,UIActionSheetDelegate,HPGrowingTextViewDelegate,TapImageViewDelegate,ImgScrollViewDelegate,UIScrollViewDelegate,LocationTextViewDelegate>
{
    NSMutableArray * dataArray;         //存放请求回来的数据
    NoDataView * noData;                //没有数据的时候显示
    UIView * commentTextBGView;         //评论输入框的父视图
    UIButton * submitBtn;               //提交评论按钮
    CGPoint tapPoint;                   //获取点击时的坐标
    UITextView * tempTextView;          //
    HPGrowingTextView * tempHpTextView; //评论输入框
    UIActionSheet * actionSheets;       //删除自己的评论
    NSInteger tempIndex;
    NSIndexPath * tempIndexPath;
    UIButton *toTopBtn;                 //返回顶部
    CGRect viewTempRect;
    BOOL isKeyboardHidden;
    
    NSIndexPath * indexpath;
    UIScrollView * myScrollView;        //
    int currentIndex;
    UIView * markView;
    UIView * scrollPanel;
    ImgScrollView * lastImgScrollView;
    int imgPage;
    int totalImgPage;
    NSMutableArray * imgArr;
    UIButton * downBtn;
    MBProgressHUD * huds;
    
    BOOL switchKeyBoard;            //键盘是否在切换
}
@property (nonatomic,strong)NSString * tempCommentStr;
@property (nonatomic,strong)NSString * tempCommentID;
@property (nonatomic,strong)UILabel * placeHolderLabel;
@property (nonatomic,strong)NSString * locationID;      //足迹的id
@property (nonatomic,strong)NSString * markID;          //回复评论的id
@property (nonatomic,strong)NSString * contentStr;
@property (nonatomic,strong)UITextView * commentTextView;
@property (nonatomic,strong)UIScrollView * tempScrollView;
@property (nonatomic,strong)HPGrowingTextView * hpTextView;
@property (nonatomic,strong)UITableView * tableview;
@property (nonatomic, strong) NSDictionary *userInfoDic;
@property (nonatomic,strong)EmotionKeyboard * emotionKeyboard;

@property (nonatomic,strong)UIView * listNoDataView;    //没有数据的时候显示

- (void)showMoreView:(ZZGoPayBtn *)sender;
- (void)hiddenBtn;
- (void)urlRequestPost;
- (void)headerRefresh;
- (void)footerRefresh;
- (NSString *)appendStrWithLocationModel:(LocationModel *)locationmodel;
- (CGSize)onScreenPointSizeOfImageInImageView:(LocationModel *)locationModel;
- (void)noDataView;
@end
