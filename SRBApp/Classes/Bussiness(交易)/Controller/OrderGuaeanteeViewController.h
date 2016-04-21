//
//  OrderGuaeanteeViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/29.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <UIImageView+WebCache.h>
#import "OrderAssureViewController.h"

@interface OrderGuaeanteeViewController : ZZViewController<UITextViewDelegate>
{
    UILabel * publishiMan;
    UILabel * bussinessInformation;
    UITextView * detailTV;
    UIButton * button1;
    UIButton * button2;
    UIButton * button3;
    UIButton * button4;
    UIButton * button5;
    UILabel * labeltext;
    
    NSString * xinxinnumber;
}
@property (nonatomic, strong)NSString * idNumber;
@property (nonatomic, strong)NSString * thetitle;
@property (nonatomic, strong)NSString * sellernick;
@property (nonatomic, strong)NSString * buyernick;
@property (nonatomic, strong)NSString * bangPrice;
@property (nonatomic, strong)NSString * postString;
@property (nonatomic, strong)NSString * photoUrl;
@property (nonatomic, strong)NSString * guaranteePrice;//担保赏金
@property (nonatomic, strong)NSString * freeShipment;//是否包邮
@property (nonatomic, strong) UILabel * assureLabel;//担保赏金
@property (nonatomic,strong)OrderAssureViewController * orderAssureVC;

@end
