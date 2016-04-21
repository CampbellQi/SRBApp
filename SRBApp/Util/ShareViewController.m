//
//  ShareViewController.m
//  SRBApp
//
//  Created by lizhen on 15/3/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

/**
 *  此类是对shareSDK分享平台的封装
 *  开发者可以选择自定义分享平台的方法，
 *  也可以延用此宏观定义的方法
 *  @param void account（账号：用户唯一标识）nickname（昵称）avatar（头像）cover（商品封面）idnumber(商品id)title(商品标题)content(商品简介)photo(判断是否有图片)btn(分享按钮)shareurl(分享回调url)
 */

#import "ShareViewController.h"
#import "ChangeBuyViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController
+ (void)shareToThirdPlatformWithUIViewController:(UIViewController *)viewController Account:(NSString *)account Nickname:(NSString *)nickname Avatar:(NSString *)avatar Cover:(NSString *)cover IdNumber:(NSString *)idNumber Title:(NSString *)title Content:(NSString *)content Photo:(NSString *)photo Btn:(UIButton *)sender ShareUrl:(NSString *)shareUrl{
    if ([shareUrl isEqualToString:@""] || shareUrl == nil || shareUrl.length == 0) {
        shareUrl = SHARE_URL;
    }
//    if (title == nil || [title isEqualToString:@""] || title.length == 0) {
//        title = @"来自熟人邦";
//    }
    
    if ([photo isEqualToString:@"0"]) {
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:content
                                                    image:nil
                                                    title:title
                                                      url:shareUrl
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];
        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"熟人邦", @"内容分享")
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:viewController
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        //自定义分享内容
        id<ISSShareActionSheetItem> shurenbang = [ShareSDK shareActionSheetItemWithTitle:@"熟人邦" icon:[UIImage imageNamed:@"shareTypeShurenbang"] clickHandler:^{                                 ShareDetailViewController *shareDetailVC = [[ShareDetailViewController alloc] init];
            ZZNavigationController *shareNav = [[ZZNavigationController alloc] initWithRootViewController:shareDetailVC];
            shareDetailVC.detailTitle = title;
            shareDetailVC.content = content;
            shareDetailVC.photoUrl = cover;
            //                                                                           shareDetailVC.photo = _model.photo;
            shareDetailVC.idNumber = idNumber;
            shareDetailVC.account = account;
            shareDetailVC.nickname = nickname;
            shareDetailVC.avatar = avatar;
            [viewController presentViewController:shareNav animated:NO completion:nil];
        }];
        
        NSArray *shareList = nil;
        if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                         SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                         SHARE_TYPE_NUMBER(ShareTypeQQ),
                         shurenbang,
                         nil];
        }
        else if ([QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeQQ),
                         shurenbang,
                         nil];
        }
        else if (![QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                         shurenbang,
                         nil];
        }
        else if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         shurenbang,
                         nil];
        }
        
        
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:authOptions
                          shareOptions:shareOptions
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    if (state == SSResponseStateSuccess)
                                    {
                                        [AutoDismissAlert autoDismissAlert:@"分享成功"];
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                                }];
    }else{
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:content
                                                    image:[ShareSDK imageWithUrl:cover]
                                                    title:title
                                                      url:shareUrl
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        /*
         //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
         
         //定制新浪微博
         //        [publishContent addSinaWeiboUnitWithContent:[dataDic objectForKey:@"note"]
         //                                              image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]];
         //
         //
         //        //定制QQ空间信息
         //        [publishContent addQQSpaceUnitWithTitle:[dataDic objectForKey:@"note"]
         //                                            url:@"http://www.shurenbang.net/download/"
         //                                           site:nil
         //                                        fromUrl:nil
         //                                        comment:nil
         //                                        summary:nil
         //                                          image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
         //                                           type:nil
         //                                        playUrl:nil
         //                                           nswb:nil];
         //
         //        //定制微信好友信息
         //        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
         //                                             content:[dataDic objectForKey:@"note"]
         //                                               title:[dataDic objectForKey:@"title"]
         //                                                 url:@"http://www.shurenbang.net/download/"
         //                                          thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
         //                                               image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
         //                                        musicFileUrl:nil
         //                                             extInfo:nil
         //                                            fileData:nil
         //                                        emoticonData:nil];
         //
         //        //定制微信朋友圈信息
         //        [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage | SSPublishContentMediaTypeText]
         //                                              content:[dataDic objectForKey:@"note"]
         //                                                title:[dataDic objectForKey:@"photo"]
         //                                                  url:@"http://www.shurenbang.net/download/"
         //                                           thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
         //                                                image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
         //                                         musicFileUrl:nil
         //                                              extInfo:nil
         //                                             fileData:nil
         //                                         emoticonData:nil];
         //
         //        //定制微信收藏信息
         //        [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
         //                                         content:nil
         //                                           title:[dataDic objectForKey:@"photo"]
         //                                             url:@"http://www.shurenbang.net/download/"
         //                                      thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
         //                                           image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
         //                                    musicFileUrl:nil
         //                                         extInfo:nil
         //                                        fileData:nil
         //                                    emoticonData:nil];
         //
         
         //
         //        //定制邮件信息
         //        [publishContent addMailUnitWithSubject:nil
         //                                       content:[dataDic objectForKey:@"note"]
         //                                        isHTML:[NSNumber numberWithBool:YES]
         //                                   attachments:nil
         //                                            to:nil
         //                                            cc:nil
         //                                           bcc:nil];
         //
         //        //定制短信信息
         //        [publishContent addSMSUnitWithContent:[dataDic objectForKey:@"note"]];
         
         //结束定制信息
         */
        
//        if (title == nil || [title isEqualToString:@""] || title.length == 0) {
//            title = @"来自熟人邦";
//        }
//        //定制QQ分享信息
//        [publishContent addQQUnitWithType:INHERIT_VALUE
//                                  content:content
//                                    title:title
//                                      url:shareUrl
//                                    image:[ShareSDK imageWithUrl:cover]];
        
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];
        
        //自定义分享内容
        id<ISSShareActionSheetItem> shurenbang = [ShareSDK shareActionSheetItemWithTitle:@"熟人邦" icon:[UIImage imageNamed:@"shareTypeShurenbang"] clickHandler:^{                                 ShareDetailViewController *shareDetailVC = [[ShareDetailViewController alloc] init];
            ZZNavigationController *shareNav = [[ZZNavigationController alloc] initWithRootViewController:shareDetailVC];
            shareDetailVC.detailTitle = title;
            shareDetailVC.content = content;
            shareDetailVC.photoUrl = cover;
            //                                                                                shareDetailVC.photo = _model.photo;
            shareDetailVC.idNumber = idNumber;
            shareDetailVC.account = account;
            shareDetailVC.nickname = nickname;
            shareDetailVC.avatar = avatar;
            
            if ([viewController isKindOfClass:[ChangeSaleViewController class]]) {
                ChangeSaleViewController * tempVC = (ChangeSaleViewController *)viewController;
                shareDetailVC.changeSaleVC = tempVC;
                [viewController presentViewController:shareNav animated:NO completion:^{
                    tempVC.publishLater.hidden = YES;
                }];
            }else if ([viewController isKindOfClass:[ChangeBuyViewController class]]){
                ChangeBuyViewController * tempVC = (ChangeBuyViewController *)viewController;
                shareDetailVC.changeBuyVC = tempVC;
                [viewController presentViewController:shareNav animated:NO completion:^{
                    tempVC.publishLater.hidden = YES;
                }];
            }
            else{
                [viewController presentViewController:shareNav animated:NO completion:nil];
            }
        }];
        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"熟人邦", @"内容分享")
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:viewController
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        
        NSArray *shareList = nil;
        if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                         SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                         SHARE_TYPE_NUMBER(ShareTypeQQ),
                         shurenbang,
                         nil];
        }
        else if ([QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeQQ),
                         shurenbang,
                         nil];
        }
        else if (![QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                         shurenbang,
                         nil];
        }
        else if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         shurenbang,
                         nil];
        }
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:authOptions
                          shareOptions:shareOptions
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        [AutoDismissAlert autoDismissAlert:@"分享成功"];
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                                }];
    }
}

+ (void)shareToThirdPlatformWithUIViewController:(UIViewController *)viewController Title:(NSString *)title SecondTitle:(NSString *)secondTitle Content:(NSString *)content ImageUrl:(NSString *)imageurl SencondImgUrl:(NSString *)secondImgUrl Btn:(UIButton *)sender ShareUrl:(NSString *)shareUrl{
    if (!title || [title stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        title = @"分享";
    }
    
    if (!secondTitle || [secondTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        secondTitle = @"分享";
    }
    if (!content || [content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        content = @"内容来自熟人帮";
    }
    
//    if (title == nil || [title isEqualToString:@""] || title.length == 0) {
//        title = secondTitle;
//    }
    
    if (imageurl == nil || [imageurl isEqualToString:@""] || imageurl.length == 0) {
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:content
                                                    image:[ShareSDK imageWithUrl:secondImgUrl]
                                                    title:title
                                                      url:shareUrl
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];


        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"熟人邦", @"内容分享")
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:viewController
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        
        NSArray *shareList = nil;
        if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                         SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                         SHARE_TYPE_NUMBER(ShareTypeQQ),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                         nil];
        }
        else if ([QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeQQ),
                         nil];
        }
        else if (![QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                         nil];
        }
        else if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         nil];
        }
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:authOptions
                          shareOptions:shareOptions
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        [AutoDismissAlert autoDismissAlert:@"分享成功"];
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                        NSLog(@"TEXT_ShARE_FAI 分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    }
                                }];
        
    }else
    {
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:content
                                                    image:[ShareSDK imageWithUrl:imageurl]
                                                    title:title
                                                      url:shareUrl
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        
        //在授权页面中添加关注官方微博
        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
                                        nil]];

        
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"熟人邦", @"内容分享")
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:viewController
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        
        NSArray *shareList = nil;
        if ([QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                         SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                         SHARE_TYPE_NUMBER(ShareTypeQQ),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                         nil];
        }
        else if ([QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeQQSpace),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeQQ),
                         nil];
        }
        else if (![QQApiInterface isQQInstalled] && [WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeWeixiTimeline),
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiSession),
                         SHARE_TYPE_NUMBER(ShareTypeWeixiFav),
                         nil];
        }
        else if (![QQApiInterface isQQInstalled] && ![WXApi isWXAppInstalled]) {
            shareList = [ShareSDK customShareListWithType:
                         SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
                         nil];
        }
        
        
//        //定制QQ分享信息
//        [publishContent addQQUnitWithType:INHERIT_VALUE
//                                  content:content
//                                    title:title
//                                      url:@"http://www.shurenbang.net/download/"
//                                    image:[ShareSDK imageWithUrl:imageurl]];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:shareList
                               content:publishContent
                         statusBarTips:YES
                           authOptions:authOptions
                          shareOptions:shareOptions
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        [AutoDismissAlert autoDismissAlert:@"分享成功"];
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        [AutoDismissAlert autoDismissAlert:[error errorDescription]];
                                        NSLog(@"TEXT_ShARE_FAI 分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    }
                                }];
        
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
