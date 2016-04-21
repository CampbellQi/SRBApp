//
//  ShareDetailViewController.h
//  SRBApp
//
//  Created by lizhen on 15/3/2.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyFriendsViewController.h"
#import "ChangeSaleViewController.h"
@class ChangeBuyViewController;

@interface ShareDetailViewController : MyFriendsViewController
@property (nonatomic, strong) NSString *detailTitle;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *photoUrl;
@property (nonatomic, strong) NSString *photo;
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *account;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) ChangeSaleViewController * changeSaleVC;
@property (nonatomic,strong) ChangeBuyViewController * changeBuyVC;
@end
