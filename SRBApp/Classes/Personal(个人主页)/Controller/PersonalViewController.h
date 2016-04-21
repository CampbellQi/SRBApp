//
//  PersonalViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "MineFragmentViewController.h"
#import "JTSImageInfo.h"
#import "JTSImageViewController.h"
#import "DACircularProgressView.h"
#import "MyChatViewController.h"
/**
 *  @brief  个人中心
 */
@interface PersonalViewController : ZZViewController
{
    MBProgressHUD * HUD;
    UIActivityIndicatorView * activity;
    BOOL isBack;
    NSString * userAccount;
    BOOL isDown;
    BOOL isChatBtnDrag;
    BOOL _canedit;
    UIView * lineView;
    UIButton * relationBtn;
    UIButton * circleBtn;
    UIButton * totalBtn;
    BOOL isBig;
}
@property (nonatomic, strong) NSDictionary *dataDic;
@property (nonatomic, assign) CGRect  labelRect;        //自适应
@property (nonatomic, strong) UIImageView *sexImageV;  //性别标签
@property (nonatomic, strong) UIImageView *xingzuoImageV;//星座
@property (nonatomic,copy)NSString * account;       //用户账号
@property (nonatomic, strong) NSString *invitecode; //邀请码
@property (nonatomic, strong) NSString *nickname;   //昵称
@property (nonatomic, strong) NSString *avatar;     //头像
@property (nonatomic, strong) NSString *friendId;   //朋友id
@property (nonatomic, strong) NSString *isFriend;   //是否是朋友
@property (nonatomic, strong) UIScrollView *sv;
@property (nonatomic, strong) NSString * myRun;
@property (nonatomic, strong)NSString * signNum;
@property (nonatomic,strong)MineFragmentViewController * mineFragmentVC;
@property (nonatomic, strong) UILabel *remarkLabel;       //备注
@property (nonatomic, strong) UIImageView *topView;     //背景
@property (nonatomic, strong) UIImageView *logoImageV;  //头像
@property (nonatomic, strong) UIButton *rightTopBtn;    //下拉
@property (nonatomic, strong) UIButton *rightTopPic;    //下拉图片

@property (nonatomic, strong) UILabel *nikeNameLabel;       //昵称
@property (nonatomic, strong) UILabel *signLabel;       //个性签名
@property (nonatomic, strong) UILabel *honestyLabel;    //靠谱指数
@property (nonatomic, strong) UILabel *lieLabel;        //忽悠指数
@property (nonatomic, strong) UIImageView *addressImageV;//地址图标
@property (nonatomic, strong) MyLabel *addressLabel;    //地址
@property (nonatomic, strong) UIButton *pullUpBtn;      //上拉
@property (nonatomic, strong) UIView * topBGView;       //按钮背景
@property (nonatomic, strong) UIView *honestyBGView;    //靠谱底图
@property (nonatomic, strong) UIView *lieBGView;        //忽悠底图
@property (nonatomic, strong) UIView *honestyOnView;    //靠谱上层图
@property (nonatomic, strong) UIView *lieOnView;        //忽悠上层图
@property (nonatomic, strong) UILabel *hoestyPercentLabel;//靠谱百分比
@property (nonatomic, strong) UILabel *liePercentLabel;  //忽悠百分比
@property (nonatomic, strong) NSArray *imageArray;      //头像
@property (nonatomic, strong) UIView *tempView;
@property (nonatomic, strong) UIButton *chatbutton;
- (void)customView;
- (void)bigOrSmallWidth:(int)width;
- (void)backBtn:(UIButton *)sender;
- (void)urlRequestPostTAgain;
/**
 *  删除或者添加熟人
 */
- (void)operationFriend;
/**
 *  屏蔽与取消屏蔽
 */
- (void)operationBlack;
- (void)viewWillAppear:(BOOL)animated;
- (void)viewWillDisappear:(BOOL)animated;
@end
