//
//  Share.m
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "Share.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"

@implementation Share
- (void)share:(NSDictionary *)dataDic
{
    __block NSDictionary *temDic = dataDic;
    //拼接post请求所需参数
    NSDictionary * shareParam = @{@"method":@"getShareInfo",@"parameters":@{@"type":@"1"}};
    [URLRequest postRequestWith:iOS_POST_URL parameters:shareParam andblock:^(NSDictionary *dic) {
        NSLog(@"shareDic == %@",dic);
        NSDictionary *dataDict = [dic objectForKey:@"data"];
        if (dataDic == nil) {
            temDic = dataDict;
        }
        
        //构造分享内容
        id<ISSContent> publishContent = [ShareSDK content:[dataDic objectForKey:@"note"]
                                           defaultContent:[dataDic objectForKey:@"note"]
                                                    image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                    title:[dataDic objectForKey:@"title"]
                                                      url:[dataDic objectForKey:@"url"]
                                              description:nil
                                                mediaType:SSPublishContentMediaTypeNews];
        
        //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
        
        //定制QQ空间信息
        [publishContent addQQSpaceUnitWithTitle:[dataDic objectForKey:@"title"]                                            url:[dataDic objectForKey:@"url"]
                                           site:nil
                                        fromUrl:nil
                                        comment:nil
                                        summary:nil
                                          image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                           type:INHERIT_VALUE
                                        playUrl:nil
                                           nswb:nil];
        
        //定制微信好友信息
        [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                             content:[dataDic objectForKey:@"note"]
                                               title:[dataDic objectForKey:@"title"]
                                                 url:[dataDic objectForKey:@"url"]
                                          thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                               image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                        musicFileUrl:nil
                                             extInfo:nil
                                            fileData:nil
                                        emoticonData:nil];
        
        //定制微信朋友圈信息
        [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage | SSPublishContentMediaTypeText | SSPublishContentMediaTypeNews]
                                              content:[dataDic objectForKey:@"note"]
                                                title:[dataDic objectForKey:@"title"]
                                                  url:[dataDic objectForKey:@"url"]
                                           thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                         musicFileUrl:nil
                                              extInfo:nil
                                             fileData:nil
                                         emoticonData:nil];
        
        
        //定制QQ分享信息
        [publishContent addQQUnitWithType:INHERIT_VALUE
                                  content:[dataDic objectForKey:@"note"]
                                    title:[dataDic objectForKey:@"title"]
                                      url:[dataDic objectForKey:@"url"]
                                    image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]];
        
        //定制邮件信息
        [publishContent addMailUnitWithSubject:[dataDic objectForKey:@"title"]
                                       content:[dataDic objectForKey:@"note"]
                                        isHTML:[NSNumber numberWithBool:YES]
                                   attachments:INHERIT_VALUE
                                            to:nil
                                            cc:nil
                                           bcc:nil];
        
        //定制短信信息

        [publishContent addSMSUnitWithContent:[[dataDic objectForKey:@"note"] stringByAppendingString:[dataDic objectForKey:@"url"]]];
        
        
        //结束定制信息
        
        //创建弹出菜单容器
        id<ISSContainer> container = [ShareSDK container];
//        [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
        
        id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                             allowCallback:NO
                                                             authViewStyle:SSAuthViewStyleFullScreenPopup
                                                              viewDelegate:nil
                                                   authManagerViewDelegate:nil];
        //
        //在授权页面中添加关注官方微博
//        [authOptions setFollowAccounts:[NSDictionary dictionaryWithObjectsAndKeys:
//                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),
//                                        [ShareSDK userFieldWithType:SSUserFieldTypeName value:@"ShareSDK"],
//                                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),
//                                        nil]];
//        //
        id<ISSShareOptions> shareOptions = [ShareSDK defaultShareOptionsWithTitle:NSLocalizedString(@"熟人帮", @"内容分享")
                                                                  oneKeyShareList:[NSArray defaultOneKeyShareList]
                                                                   qqButtonHidden:YES
                                                            wxSessionButtonHidden:YES
                                                           wxTimelineButtonHidden:YES
                                                             showKeyboardOnAppear:NO
                                                                shareViewDelegate:nil
                                                              friendsViewDelegate:nil
                                                            picViewerViewDelegate:nil];
        
        //弹出分享菜单
        [ShareSDK showShareActionSheet:container
                             shareList:nil
                               content:publishContent
                         statusBarTips:YES
                           authOptions:authOptions
                          shareOptions:shareOptions
                                result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                    
                                    if (state == SSResponseStateSuccess)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                    }
                                    else if (state == SSResponseStateFail)
                                    {
                                        NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                    }
                                }];
    }];

}
@end
