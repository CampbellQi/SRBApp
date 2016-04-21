//
//  NewLocationViewController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/5.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "NewLocationViewController.h"
#import "HandleNewsCenter.h"
#import "AppDelegate.h"

@interface NewLocationViewController ()
{
    //消息提醒字典
    NSDictionary *_msgDic;
    UIView *_msgView;
}
@end

@implementation NewLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getNewMsgRequest];
}
//消息提示view
-(void)showMsgView {
    if (!_msgView) {
        float width = 180,height = 40,y = 60,imgHeightRate = 0.8;
        UIView *msgView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - width)/2, y, width, height)];
        msgView.layer.cornerRadius = 5.0f;
        [self.view addSubview:msgView];
        msgView.backgroundColor = [UIColor colorWithRed:43/255.0 green:43/255.0 blue:43/255.0 alpha:0.7];
        [msgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(msgClicked:)]];
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake((height - imgHeightRate * height)/2, (height - imgHeightRate * height)/2 , imgHeightRate * height, imgHeightRate * height)];
        [iv sd_setImageWithURL:[NSURL URLWithString:[_msgDic objectForKey:@"avatar"]]];
        iv.layer.masksToBounds = YES;
        iv.layer.cornerRadius = iv.width * 0.5;
        iv.contentMode=UIViewContentModeScaleAspectFill;
        [msgView addSubview:iv];
        
        float arrowWidth = 10;
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(iv.x + iv.width, 0, width - (iv.x + iv.width) - 2*arrowWidth, height)];
        lbl.text = @"1条新消息";
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont boldSystemFontOfSize:12];
        lbl.textColor = [UIColor whiteColor];
        [msgView addSubview:lbl];
        
        
        UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(width - 2*arrowWidth, (height - arrowWidth)/2, arrowWidth, arrowWidth)];
        arrow.contentMode = UIViewContentModeScaleAspectFit;
        arrow.image = [UIImage imageNamed:@"right_arrow"];
        [msgView addSubview:arrow];
        
        _msgView = msgView;
    }
    _msgView.hidden = NO;
}
-(void)msgClicked:(UIGestureRecognizer *)gr {
    [HandleNewsCenter handleMsgCenterModule:[_msgDic objectForKey:@"module"] Value:[_msgDic objectForKey:@"value"] NavigationController:self.navigationController];
    _msgView.hidden = YES;
}
//获取位置新消息
- (void)getNewMsgRequest {
    NSDictionary * shareParam = @{@"method":@"getLocationNewMessage",@"parameters":@{@"account":ACCOUNT_SELF, @"password":PASSWORD_SELF}};
    [URLRequest postRequestssWith:iOS_POST_URL parameters:shareParam andblock:^(NSDictionary *dic) {
        if ([[dic objectForKey:@"result"] intValue] == 0) {
            _msgDic = [dic objectForKey:@"data"];
            [self showMsgView];
        }else {
            _msgView.hidden = YES;;
            //NSLog(@"totalDataDic == %@",self.userInfoDic);
            
        }
    } andFailureBlock:^{
        //NSLog(@"totalDataDic == %@",self.userInfoDic);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
