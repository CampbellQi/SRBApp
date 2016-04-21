//
//  PersonalViewController2.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/21.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "MineFragmentViewController2.h"
#import "MineFragmentSliderScrollView.h"
#import "PersonalLocationListController.h"
#import "PersonalTopicListController.h"
#import "OptionViewController.h"
#import "PersonalSPController.h"
#import "PersonalHelpSPController.h"
#import "MyWalletActivityViewController.h"
#import "NewAttentionViewController.h"
#import "LayoutFrame.h"
#import "PersonalAttentionListController.h"
#import "PersonalSingleGrassListController.h"
#import "NewsCenterMainViewController.h"
#import "PersonalInfoController.h"
#import "PersonalSpotGoodsListController.h"
#import "ODMCombinationPickerViewController.h"
#import "UIImage+Compress.h"

@interface MineFragmentViewController2 ()<SliderScrollViewDelegate, PersonalTopicListControllerDelegate, PersonalLocationListControllerDelegate,PersonalSingleGrassListControllerDelegate, ODMCombinationPickerViewControllerDelegate>
{
    MineFragmentSliderScrollView *_ssv;
    NSDictionary *_userInfoDict;
    MBProgressHUD *_hud;
    
    //PersonalSingleGrassListController *_singleGrassVC;
}
@end

@implementation MineFragmentViewController2

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
//    if (_singleGrassVC) {
//         [_singleGrassVC totalPriceRequest];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.avaterIV.layer.cornerRadius = CGRectGetHeight(self.avaterIV.frame) * 0.5;
    self.avaterIV.layer.masksToBounds = YES;
    self.constellationLbl.layer.cornerRadius = 6.0f;
    self.constellationLbl.layer.masksToBounds = YES;
    self.constellationLbl.layer.borderColor = DICECOLOR(240, 240, 240, 240).CGColor;
    self.constellationLbl.layer.borderWidth = 1.0f;
    [self.avaterIV addTapAction:@selector(avaterIVTapped) forTarget:self];
    // Do any additional setup after loading the view from its nib.
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self loadUserInfoRequest];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    if (!_ssv) {
        MineFragmentSliderScrollView *ssv = [[MineFragmentSliderScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.mineSuperView.frame), SCREEN_WIDTH, MAIN_NAV_HEIGHT - CGRectGetMaxY(self.mineSuperView.frame)) TitlesArray:@[@"话题", @"足迹", @"草单"] FirstView:[self getShowItemViewWithIndex:0]];
        ssv.delegate = self;
        _ssv = ssv;
        [self.view addSubview:ssv];
    }
    _ssv.frame = CGRectMake(0, CGRectGetMaxY(self.mineSuperView.frame), SCREEN_WIDTH, MAIN_NAV_HEIGHT - CGRectGetMaxY(self.mineSuperView.frame)+20);
//    _ssv.backgroundColor = [UIColor redColor];
}
#pragma mark- 页面
#pragma mark- slider delegate
-(UIView *)getShowItemViewWithIndex:(int)index {
    UIView *resultView = nil;
    switch (index) {
        case 0:{
            PersonalTopicListController *vc = [[PersonalTopicListController alloc] init];
            //vc.account = ACCOUNT_SELF;
            vc.delegate = self;
            [self addChildViewController:vc];
            resultView = vc.view;
            break;
        }
        case 1:{
            PersonalLocationListController *vc = [[PersonalLocationListController alloc] init];
            
            //vc.account = ACCOUNT_SELF;
            vc.delegate = self;
            [self addChildViewController:vc];
            resultView = vc.view;
            break;
        }
            break;
        case 2:
        {
            PersonalSingleGrassListController *vc = [[PersonalSingleGrassListController alloc] init];
            vc.delegate = self;
            //_singleGrassVC = vc;
            [vc totalPriceRequest];
            [self addChildViewController:vc];
            resultView = vc.view;
            break;
        }
        case 3:
        {
            resultView = [UIView new];
            break;
        }
        default:
            break;
    }
    return resultView;
}

#pragma mark- 事件
- (IBAction)settingBtnClicked:(id)sender {
    OptionViewController * myAssureVC = [[OptionViewController alloc]init];
    myAssureVC.userqrcode = [_userInfoDict objectForKey:@"userqrcode"];
    [self.navigationController pushViewController:myAssureVC animated:YES];
}
//求购
- (IBAction)spBtnClicked:(id)sender {
    PersonalSPController *vc = [[PersonalSPController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//接单
- (IBAction)takeOrderBtnClicked:(id)sender {
    PersonalHelpSPController *vc = [[PersonalHelpSPController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//商品库
- (IBAction)goodsSpotBtnClicked:(id)sender {
    PersonalSpotGoodsListController *vc = [[PersonalSpotGoodsListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//我的钱包
- (IBAction)wallertBtnClicked:(id)sender {
    MyWalletActivityViewController * vc = [[MyWalletActivityViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
//我的消息
- (IBAction)myNewsTap:(id)sender {
    NewsCenterMainViewController *vc = [[NewsCenterMainViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
//我的收藏
- (IBAction)myCollectionTap:(id)sender {
    NewAttentionViewController *vc = [[NewAttentionViewController alloc]init];
    //vc.mineFragmentVC = self;
    [self.navigationController pushViewController:vc animated:YES];
}
//我的关注
- (IBAction)myAttentionTap:(id)sender {
    PersonalAttentionListController *vc = [[PersonalAttentionListController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)userBgTap:(id)sender {
    ODMCombinationPickerViewController *vc = [[ODMCombinationPickerViewController alloc] init];
    vc.delegate = self;
    [self.navigationController presentViewController:vc animated:YES completion:nil];
}
//头像点击
-(void)avaterIVTapped {
    PersonalInfoController *vc = [[PersonalInfoController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 数据
-(void)fillData {
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound ||[_userInfoDict[@"constellation"] isEqualToString:@"" ]) {
        self.constellationLbl.hidden = YES;
    }
    self.attentionLbl.text = [_userInfoDict objectForKey:@"collectTagCount"];
    self.collectLbl.text = [_userInfoDict objectForKey:@"collectTopicCount"];
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:_userInfoDict[@"avatar"]] placeholderImage:[UIImage imageNamed:@"pc_avater"]];
    self.nickNameLbl.text = _userInfoDict[@"nickname"];
    NSString *signLbl0 = _userInfoDict[@"sign"];
    if(signLbl0.length > 0){
      self.signLbl.text = [NSString stringWithFormat:@"%@",signLbl0];
    }else{
      self.signLbl.text = @"";
    }
    [self.userBgIV sd_setImageWithURL:[NSURL URLWithString:[_userInfoDict objectForKey:@"userbackground"]] placeholderImage:[UIImage imageNamed:@"pc_bg"]];
    self.constellationLbl.text = _userInfoDict[@"constellation"];
    self.reliableLbl.text = [NSString stringWithFormat:@"靠谱：%@", _userInfoDict[@"evaluationper"]];
    if ([[_userInfoDict objectForKey:@"sex"] isEqualToString:@"0"]) {
        self.sexIV.image = [UIImage imageNamed:@"pc_female"];
    }
    if ([[_userInfoDict objectForKey:@"sex"] isEqualToString:@"1"]) {
        self.sexIV.image = [UIImage imageNamed:@"pc_male"];
    }
    
}
#pragma scroll delegate
-(void)scrollwithVelocity:(CGPoint)velocity {
    if (velocity.y > 0) {
        [UIView animateWithDuration:0.5 animations:^{
            if (CGRectGetMinY(self.mineSuperView.frame) > 0) {
                [LayoutFrame showViewConstraint:self.userBgIV AttributeTop:-CGRectGetMaxY(self.mineSuperView.frame)];
            }
            
            //[self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
        
    }else if(velocity.y < 0){
        [UIView animateWithDuration:0.5 animations:^{
            if (CGRectGetMinY(self.mineSuperView.frame) < 0) {
                [LayoutFrame showViewConstraint:self.userBgIV AttributeTop:0];
            }
            
            //[self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            
        }];
    }
}
#pragma mark- ODMCombinationPickerViewController delegate
-(void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadUserBgRequest:image];
    }];
}
#pragma mark- 网络请求
- (void)loadUserInfoRequest
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD, @"user":ACCOUNT_SELF}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _userInfoDict = [dic objectForKey:@"data"];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self fillData];
        [self loadNewsReqeuest];
    } andFailureBlock:^{
    }];
}
- (void)loadNewsReqeuest
{
    NSDictionary * dic = [self parametersForDic:@"accountGetNewMessageCount"parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            self.newsLbl.text = [NSString stringWithFormat:@"%@/%@", [[dic objectForKey:@"data"] objectForKey:@"newMessageCount"], [[dic objectForKey:@"data"] objectForKey:@"systemMessageCount"]];
            int count = [[[dic objectForKey:@"data"] objectForKey:@"count"] intValue];
            int countSP = [[[dic objectForKey:@"data"] objectForKey:@"newBuyerMessageCount"] intValue];
            int countHSP = [[[dic objectForKey:@"data"] objectForKey:@"newSellerMessageCount"] intValue];
            AppDelegate *app = APPDELEGATE;
            
            if (count > 0) {
                app.versionSignView.hidden = NO;
                self.newsRedPointIV.hidden = NO;
            }else{
                app.versionSignView.hidden = YES;
                self.newsRedPointIV.hidden = YES;
            }
            if (countSP > 0) {
                self.SPRedPointIV.hidden = NO;
            }else{
                self.SPRedPointIV.hidden = YES;
            }
            if (countHSP > 0) {
                self.HSPRedPointIV.hidden = NO;
            }else{
                self.HSPRedPointIV.hidden = YES;
            }
        } else{
            self.newsLbl.text = @"0";
        }
    } andFailureBlock:^{
    }];
    
}
//更换背景图
- (void)updateUserBgRequest:(NSString *)str
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountSetBackground" parameters:@{ACCOUNT_PASSWORD, @"url":str, @"uuid":@"0"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [_hud removeFromSuperview];
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [self loadUserInfoRequest];
            //[[NSUserDefaults standardUserDefaults] setObject:str forKey:@"avatar"];
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKey:@"message"]);
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }andFailureBlock:^{
        [_hud removeFromSuperview];
    }];
}
//上传背景图
-(void)uploadUserBgRequest:(UIImage *)image {
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"上传中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    
    //NSString *url = @"http://120.27.52.97:8080/tusstar/servlet/JJUploadImageServlet";
    NSString *url = iOS_POST_REALPICTURE_URL;
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
        
        [self updateUserBgRequest:[dic objectForKey:@"msg"]];
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
