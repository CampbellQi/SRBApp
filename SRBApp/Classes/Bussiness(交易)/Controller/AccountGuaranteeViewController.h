//
//  AccountGuaranteeViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/28.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <UIImageView+WebCache.h>

@interface AccountGuaranteeViewController : ZZViewController<UITextViewDelegate>
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
@property (nonatomic, strong)NSString * account;
@property (nonatomic, strong)NSString * idNumber;
@property (nonatomic, strong)NSString * thetitle;
@property (nonatomic, strong)NSString * nickname;
@property (nonatomic, strong)NSString * bangPrice;
@property (nonatomic, strong)NSString * postString;
@property (nonatomic, strong)NSString * photoUrl;
@property (nonatomic, strong)NSString * guaranteePrice;//担保赏金
@property (nonatomic, strong)NSString * freeShipment;//是否包邮
@property (nonatomic, strong) UILabel *assureLabel;//担保赏金
@property (nonatomic, strong)NSString * postPrice;//邮费


@end
