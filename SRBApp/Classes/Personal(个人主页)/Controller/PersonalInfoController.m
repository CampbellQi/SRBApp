//
//  PersonalInfoController.m
//  SRBApp
//  个人信息
//  Created by fengwanqi on 16/1/25.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PersonalInfoController.h"
#import "AppDelegate.h"
#import "CommonView.h"
#import "PersonalSkinSettingController.h"
#import "ODMCombinationPickerViewController.h"
#import "UIImage+Compress.h"
#import "WQDatePickerView.h"
#import "PersonalNicknameSettingController.h"
#import "PersonalSignSettingController.h"
#import "NSDate+TimeInterval.h"

@interface PersonalInfoController ()<ODMCombinationPickerViewControllerDelegate>
{
    NSDictionary *_userInfoDict;
    MBProgressHUD *_hud;
    WQDatePickerView *_pickerView;
}
@end

@implementation PersonalInfoController
- (void)viewWillAppear:(BOOL)animated
{
    //[self urlRequestPost];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    
    [self loadUserInfoRequest];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"个性化设置";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    self.avaterIV.layer.cornerRadius = 0.5 * CGRectGetWidth(self.avaterIV.frame);
    self.avaterIV.layer.masksToBounds = YES;
}
#pragma mark- 数据
-(void)fillData {
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:_userInfoDict[@"avatar"]] placeholderImage:[UIImage imageNamed:@"pc_avater"]];
    self.nicknameLbl.text = _userInfoDict[@"nickname"];
    self.birthdayLbl.text = _userInfoDict[@"birthday"];
    self.reliableRateLbl.text = [NSString stringWithFormat:@"靠谱指数：%@", _userInfoDict[@"evaluationper"]];
    self.signTV.text = _userInfoDict[@"sign"];
    
    int sex = [_userInfoDict[@"sex"] intValue];
    self.maleBtn.selected = NO;
    self.femaleBtn.selected = NO;
    if (sex) {
        self.maleBtn.selected = YES;
    }else {
        self.femaleBtn.selected = YES;
    }
    
    
}
#pragma mark- 事件
- (IBAction)maleBtnClicked:(id)sender {
    self.femaleBtn.selected = NO;
    self.maleBtn.selected = YES;
    
    [self updateUserInfoRequest];
}

- (IBAction)femaleBtnClicked:(id)sender {
    self.maleBtn.selected = NO;
    self.femaleBtn.selected = YES;
    
    [self updateUserInfoRequest];
}
- (IBAction)avaterTap:(id)sender {
    ODMCombinationPickerViewController *vc = [[ODMCombinationPickerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}

- (IBAction)birthdayTap:(id)sender {
    [self showDatePickerView];
}

- (IBAction)skinTap:(id)sender {
    PersonalSkinSettingController *vc = [[PersonalSkinSettingController alloc] initWithSkin];
    vc.title = @"皮肤设置";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)statureTap:(id)sender {
    PersonalSkinSettingController *vc = [[PersonalSkinSettingController alloc] initWithStature];
    vc.title = @"身材设置";
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)signTap:(id)sender {
    PersonalSignSettingController *vc = [[PersonalSignSettingController alloc] init];
    
    vc.soureUserInfoDict = _userInfoDict;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)nicknameTap:(id)sender {
    PersonalNicknameSettingController *vc = [[PersonalNicknameSettingController alloc] init];
    vc.soureUserInfoDict = _userInfoDict;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)showDatePickerView{
    [self.view endEditing:YES];
    if (_pickerView == nil) {
        WQDatePickerView *pickerView = [[WQDatePickerView alloc] initWithFrame:CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT)];
        [pickerView.pickerView setMaximumDate:[NSDate date]];
        pickerView.dateFormat = @"yyyy-MM-dd";
        
        
        pickerView.confirmBlock = ^(NSString *date) {
            self.birthdayLbl.text = date;
            [self updateUserInfoRequest];
        };
        _pickerView = pickerView;
    }
    
    _pickerView.frame = CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
    [self.view addSubview:_pickerView];
    
    if (_userInfoDict && ((NSString *)_userInfoDict[@"birthday"]).length) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [formatter dateFromString:_userInfoDict[@"birthday"]];
        _pickerView.pickerView.date = date;
    }
    
    _pickerView.pickerView.maximumDate = [NSDate date];
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.y = MAIN_NAV_HEIGHT - PICKERVIEW_HEIGHT;
    }];
}
#pragma mark- ODMCombinationPickerViewController delegate
-(void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadAvaterRequest:image];
    }];
}
#pragma mark- 网络请求
//皮肤，身材
- (void)loadSkinRequest
{
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"getCategoryList" parameters:@{@"type": @"1048", @"feature": @"1", ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray *list = dic[@"data"][@"list"];
            NSString *skin = list[0][@"feature"];
            if (skin.length) {
                self.skinLbl.text = skin;
            }
            NSString *stature = list[1][@"feature"];
            if (stature.length != 0) {
                self.statureLbl.text = stature;
            }
            
        }else{
            //[AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        
    } andFailureBlock:^{
        //[_hud removeFromSuperview];
    }];
}
//获取用户信息
- (void)loadUserInfoRequest
{
//    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    _hud.labelText = @"获取中,请稍后";
//    _hud.dimBackground = YES;
//    [_hud show:YES];
    
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD, @"user":ACCOUNT_SELF}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        //[_hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _userInfoDict = [dic objectForKey:@"data"];
            [self fillData];
            [self loadSkinRequest];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        
    } andFailureBlock:^{
        //[_hud removeFromSuperview];
    }];
}
//修改头像
- (void)updateAvaterRequest:(NSString *)urlStr
{
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountSetUserPic" parameters:@{ACCOUNT_PASSWORD, @"url":urlStr, @"uuid":@"0"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        [_hud removeFromSuperview];
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            AppDelegate *app = APPDELEGATE;
            [app getFriendArr];
            [[NSUserDefaults standardUserDefaults] setObject:urlStr forKey:@"avatar"];
            [self loadUserInfoRequest];
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKey:@"message"]);
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }andFailureBlock:^{
        [_hud removeFromSuperview];
    }];
}
//上传头像
-(void)uploadAvaterRequest:(UIImage *)image {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"上传中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    
    //NSString *url = @"http://120.27.52.97:8080/tusstar/servlet/JJUploadImageServlet";
    NSString *url = iOS_POST_PICTURE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData *imageData = [image compressAndResize];
        [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", self.uuid] mimeType:@"image/*"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        NSLog(@"Success: %@", dic);
        
        NSLog(@"message: %@", [dic objectForKey:@"message"]);
        
        [self updateAvaterRequest:[dic objectForKey:@"msg"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [_hud removeFromSuperview];
        //[UIAlertView autoDismissAlert:@"上传失败"];
        //[HUD removeFromSuperview];
    }];
}
#pragma mark - 生成UUID
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
//修改用户信息
-(void)updateUserInfoRequest {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"更新中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    
    NSString *birthday = self.birthdayLbl.text;
    NSString *sex = @"0";
    if (self.maleBtn.selected) {
        sex = @"1";
    }
    
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountSetUserInfo" parameters:@{ACCOUNT_PASSWORD, @"sex":sex, @"nickname":_userInfoDict[@"nickname"], @"sign": _userInfoDict[@"sign"], @"birthday": birthday}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [_hud removeFromSuperview];
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            AppDelegate *app = APPDELEGATE;
            [app getFriendArr];
            //[[NSUserDefaults standardUserDefaults] setObject:newNickname forKey:@"nickname"];
        }else{
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }
    }andFailureBlock:^{
        [_hud removeFromSuperview];
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
