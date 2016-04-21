//
//  MyQrCodeController.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/5.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "SRBBaseViewController.h"

@interface MyQrCodeController : SRBBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nicknameLbl;
@property (weak, nonatomic) IBOutlet UIButton *sexBtn;
@property (weak, nonatomic) IBOutlet UILabel *invitationCodeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeIV;
@property (weak, nonatomic) IBOutlet UIImageView *qqIV;
@property (weak, nonatomic) IBOutlet UIImageView *qqZoneIV;
@property (weak, nonatomic) IBOutlet UIImageView *weixinIV;
@property (weak, nonatomic) IBOutlet UIImageView *weixinCircleIV;
@property (weak, nonatomic) IBOutlet UIImageView *avaterIV;

@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSDictionary *dataDic;
@end
