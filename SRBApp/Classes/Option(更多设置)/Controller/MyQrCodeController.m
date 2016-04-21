//
//  MyQrCodeController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/5.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "MyQrCodeController.h"
#import "CommonView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "AppDelegate.h"

@interface MyQrCodeController ()

@end

@implementation MyQrCodeController
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
    self.title = @"我的二维码";
    //导航栏
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"保 存" Target:self Action:@selector(saveBtnClicked)];
    //头像
    self.avaterIV.layer.cornerRadius = 4.0f;
    self.avaterIV.layer.masksToBounds = YES;
    
    self.qrcodeIV.contentMode = UIViewContentModeScaleAspectFill;
    
    //邀请熟人按钮
    self.qqIV.tag = 100;
    self.qqZoneIV.tag = 101;
    self.weixinIV.tag = 102;
    self.weixinCircleIV.tag = 103;
    
    [self.qqIV addTapAction:@selector(share:) forTarget:self];
    [self.qqZoneIV addTapAction:@selector(share:) forTarget:self];
    [self.weixinIV addTapAction:@selector(share:) forTarget:self];
    [self.weixinCircleIV addTapAction:@selector(share:) forTarget:self];
    
    [self loadUserInfoRequest];
}
#pragma mark- 事件
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)saveBtnClicked {
    if (self.qrcodeIV.image) {
        
        UIImageWriteToSavedPhotosAlbum(self.qrcodeIV.image, nil, nil, nil);
        [AutoDismissAlert autoDismissAlert:@"保存成功"];
    }
    
}
-(void)share:(UIGestureRecognizer *)gr {
    long tag = gr.view.tag;
    
    NSDictionary * shareParam = @{@"method":@"getShareInfo",@"parameters":@{@"account":ACCOUNT_SELF, @"password":PASSWORD_SELF,@"type":@"1"}};
    [URLRequest postRequestWith:iOS_POST_URL parameters:shareParam andblock:^(NSDictionary *dic) {
        NSDictionary *dataDic = [dic objectForKey:@"data"];
        NSLog(@"dataDic == %@",dataDic);
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:[dataDic objectForKey:@"note"]
                                           defaultContent:[dataDic objectForKey:@"note"]
                                                    image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                    title:[dataDic objectForKey:@"title"]
                                                      url:[dataDic objectForKey:@"url"]
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"熟人邦", @"内容分享")
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:nil
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        if ([WXApi isWXAppInstalled] && (tag == 102 || tag == 103)) {
            if (tag == 102){
                [ShareSDK clientShareContent:publishContent
                                        type:ShareTypeWeixiSession
                                 authOptions:authOptions
                                shareOptions:shareOptions
                               statusBarTips:YES
                                     targets:nil
                                      result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                          if (error) {
                                              [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                          }
                                      }];
                
            }else{
                [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeNews]
                                                      content:[dataDic objectForKey:@"note"]
                                                        title:[dataDic objectForKey:@"note"]
                                                          url:[dataDic objectForKey:@"url"]
                                                   thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                        image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                 musicFileUrl:nil
                                                      extInfo:nil
                                                     fileData:nil
                                                 emoticonData:nil];
                [ShareSDK clientShareContent:publishContent
                                        type:ShareTypeWeixiTimeline
                                 authOptions:authOptions
                                shareOptions:shareOptions
                               statusBarTips:YES
                                     targets:nil
                                      result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                          if (error) {
                                              [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                          }else{
                                          }
                                      }];
            }
        }else if ([QQApiInterface isQQInstalled]){
            if (tag == 100) {
                [ShareSDK clientShareContent:publishContent
                                        type:ShareTypeQQ
                                 authOptions:authOptions
                                shareOptions:shareOptions
                               statusBarTips:YES
                                     targets:nil
                                      result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                          if (error) {
                                              [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                          }
                                      }];
                
            }else if (tag == 101){
                [publishContent addQQSpaceUnitWithTitle:[dataDic objectForKey:@"note"]
                                                    url:[dataDic objectForKey:@"url"]
                                                   site:nil
                                                fromUrl:nil
                                                comment:nil
                                                summary:nil
                                                  image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                   type:INHERIT_VALUE
                                                playUrl:nil
                                                   nswb:nil];
                [ShareSDK clientShareContent:publishContent
                                        type:ShareTypeQQSpace
                                 authOptions:authOptions
                                shareOptions:shareOptions
                               statusBarTips:YES
                                     targets:nil
                                      result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                          if (error) {
                                              [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                          }else{
                                          }
                                      }];
                
            }
        }else {
            [AutoDismissAlert autoDismissAlert:@"请先安装微信或QQ哦"];
        }
        
    }];
}
#pragma mark- 网络请求
- (void)loadUserInfoRequest
{
    if (self.account == nil || [self.account isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"账号不存在"];
        return;
    }
    
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD,@"user":self.account}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            self.dataDic = [dic objectForKey:@"data"];
            [self fillData];
            
            
//            if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
////                self.labelRect = [[self.dataDic objectForKey:@"nickname"] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
//                
//                self.nicknameLbl.text = [self.dataDic objectForKey:@"nickname"];
//                //NSString *str = [self.dataDic objectForKey:@"nickname"];
////                if ([ChangeSizeOfNSString convertToInts: str]  > 12) {
////                    self.nicknameLabel.frame = CGRectMake(self.headImageV.frame.origin.x + self.headImageV.frame.size.width + 10, self.headImageV.frame.origin.y + 5, self.customView.frame.size.width - 100 - 20 -20 -20, self.labelRect.size.height);
////                }else{
////                    self.nicknameLabel.frame = CGRectMake(self.headImageV.frame.origin.x + self.headImageV.frame.size.width + 10, self.headImageV.frame.origin.y + 5, self.labelRect.size.width, self.labelRect.size.height);
////                }
////            }else{
////                self.labelRect = [memo boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
////                self.nicknameLabel.text = memo;
////                if (memo.length >=7) {
////                    self.nicknameLabel.frame = CGRectMake(self.headImageV.frame.origin.x + self.headImageV.frame.size.width + 10, self.headImageV.frame.origin.y, self.customView.frame.size.width - 100 - 20 -20 -20, self.labelRect.size.height);
////                }else{
////                    self.nicknameLabel.frame = CGRectMake(self.headImageV.frame.origin.x + self.headImageV.frame.size.width + 10, self.headImageV.frame.origin.y, self.labelRect.size.width, self.labelRect.size.height);                }
////            }
//            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"0"]) {
//                self.sexBtn.selected = YES;
//            }
//            
//            }
            
            
        }else if(result == 4){
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}
-(void)fillData {
    
    [self.qrcodeIV sd_setImageWithURL:[NSURL URLWithString:[self.dataDic objectForKey:@"userqrcode"]] placeholderImage:[UIImage imageNamed:@"zanwu_clean"]];
    [self.avaterIV sd_setImageWithURL:[NSURL URLWithString:[self.dataDic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    self.invitationCodeLbl.text = [self.dataDic objectForKey:@"invitecode"];
    self.nicknameLbl.text = [self.dataDic objectForKey:@"nickname"];
    //            //赋值部分
    //NSString *memo = [self.dataDic objectForKey:@"memo"];
    if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"1"]) {
        self.sexBtn.selected = YES;
    }
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
