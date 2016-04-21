//
//  AskedAddressBookViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "AddressBookListActivityViewController.h"

@interface AskedAddressBookViewController : ZZViewController
{
    MBProgressHUD * HUD;
}
@property (nonatomic, strong)NSMutableArray * addressBookArray;
- (void)back;
@property (nonatomic,assign)BOOL isFaxian;
@property (nonatomic,strong)AddressBookListActivityViewController * addressBookVC;
@end
