//
//  IdSafeViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "MineFragmentViewController.h"

@interface IdSafeViewController : ZZViewController<UITableViewDataSource, UITableViewDelegate,UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    MBProgressHUD * HUD;
    MBProgressHUD * HUD1;
}
@property (nonatomic,strong)MineFragmentViewController * mineFragmentVC;
@property (nonatomic, strong)NSString * sex;
@property(nonatomic, retain)UITableView * tableView;
- (void)backBtn:(UIButton *)sender;
@end
