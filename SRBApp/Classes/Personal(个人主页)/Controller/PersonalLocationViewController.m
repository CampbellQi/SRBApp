//
//  PersonalLocationViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalLocationViewController.h"
#import "MJRefresh.h"
#import "LocationModel.h"
#import "LocationCell.h"
#import "LeftImgAndRightTitleBtn.h"
#import "PersonalViewController.h"
#import "ImageViewController.h"
#import "PersonalViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"
#import "DDMenuController.h"
#import "AppDelegate.h"

@interface PersonalLocationViewController ()<TableViewCellDelegates>

@end

@implementation PersonalLocationViewController
{
    NSMutableArray * dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    UITapGestureRecognizer * hiddenTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTap:)];
    [self.view addGestureRecognizer:hiddenTap];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationModel * locationModel = dataArray[indexPath.row];
    CGRect rect = [locationModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 40 - 8, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    if ([locationModel.photos isEqualToString:@""]) {
        return rect.size.height + 144;
    }else{
        NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
        if (photosArr.count <= 3) {
            if (photosArr.count == 1) {
                return rect.size.height + 144 + 212;
            }
            return rect.size.height + 144 + 84;
        }else{
            return rect.size.height + 144 + 159;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell * cell = [LocationCell locationCellWithTaableView:tableView];
    LocationModel * locationModel = locationModel;
    cell.locationModel = dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.zanBtn.indexpath = indexPath;
    cell.moreBtn.indexpath = indexPath;
    [cell.moreBtn addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.zanBtn addTarget:self action:@selector(zanBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.indexpath = indexPath;
    [cell.shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    
    cell.photoImg.indexpath = indexPath;

    
    cell.photoImg1.indexpath = indexPath;
    cell.photoImg2.indexpath = indexPath;
    cell.photoImg3.indexpath = indexPath;
    cell.photoImg4.indexpath = indexPath;
    cell.photoImg5.indexpath = indexPath;
    cell.photoImg6.indexpath = indexPath;
    
    cell.logoImg.tag = indexPath.row;
    //大图点击事件
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
    [cell.photoImg addGestureRecognizer:imageTap];
    UITapGestureRecognizer *imageTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
    UITapGestureRecognizer *imageTap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
    UITapGestureRecognizer *imageTap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
    UITapGestureRecognizer *imageTap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
    UITapGestureRecognizer *imageTap5 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
    UITapGestureRecognizer *imageTap6 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToZoom:)];
    [cell.photoImg1 addGestureRecognizer:imageTap1];
    [cell.photoImg2 addGestureRecognizer:imageTap2];
    [cell.photoImg3 addGestureRecognizer:imageTap3];
    [cell.photoImg4 addGestureRecognizer:imageTap4];
    [cell.photoImg5 addGestureRecognizer:imageTap5];
    [cell.photoImg6 addGestureRecognizer:imageTap6];
    return cell;
}

//
////点击进入个人中心
//- (void)tapToLPersonal:(UITapGestureRecognizer *)tap
//{
//    NSLog(@"%lu",tap.view.tag);
//    LocationModel * locationModel = dataArray[tap.view.tag];
//    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
//    NSLog(@"%@",locationModel.account);
//    personalVC.account = locationModel.account;
//    personalVC.nickname = locationModel.nickname;
//    [self.navigationController pushViewController:personalVC animated:YES];
//}


//点击缩放
- (void)tapToZoom:(UITapGestureRecognizer *)tap
{
    MyImgView * imgview = (MyImgView *)tap.view;
    ImageViewController *imageVC = [[ImageViewController alloc] init];
    
    LocationModel * locationModel = dataArray[imgview.indexpath.row];
    NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
    if (photosArr.count == 1) {
        imageVC.imgIndex = 1;
    }else{
        imageVC.imgIndex = imgview.tag;
    }
    imageVC.hidesBottomBarWhenPushed = YES;
    imageVC.imageUrl = locationModel.photos;
    [self presentViewController:imageVC animated:YES completion:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray * temparr = [self.tableView visibleCells];
    for (LocationCell * tempCell in temparr) {
        CGRect rect = tempCell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
        rect.size.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            tempCell.twoButtonView.frame = rect;
        } completion:^(BOOL finished) {
            tempCell.twoButtonView.hidden = YES;
        }];
        tempCell.locationModel.isClick = NO;
    }
}

- (void)hiddenTap:(UITapGestureRecognizer *)tap
{
    NSArray * temparr = [self.tableView visibleCells];
    for (LocationCell * tempCell in temparr) {
        CGRect rect = tempCell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
        rect.size.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            tempCell.twoButtonView.frame = rect;
        } completion:^(BOOL finished) {
            tempCell.twoButtonView.hidden = YES;
        }];
        tempCell.locationModel.isClick = NO;
    }
}

- (void)showMoreView:(ZZGoPayBtn *)sender
{
    LocationCell * cell = (LocationCell *)[self.tableView cellForRowAtIndexPath:sender.indexpath];
    cell.locationModel.isClick = !cell.locationModel.isClick;
    NSArray * temparr = [self.tableView visibleCells];
    for (int i = 0 ; i < temparr.count; i++) {
        LocationCell * tempCell = temparr[i];
        if (![tempCell isEqual:cell]) {
            tempCell.locationModel.isClick = NO;
            CGRect rect = tempCell.twoButtonView.frame;
            rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
            rect.size.width = 0;
            [UIView animateWithDuration:0.2 animations:^{
                tempCell.twoButtonView.frame = rect;
            } completion:^(BOOL finished) {
                tempCell.twoButtonView.hidden = YES;
            }];
            
        }
    }
    
    if (cell.locationModel.isClick) {
        CGRect rect = cell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10 - 150;
        rect.size.width = 151;
        [UIView animateWithDuration:0.2 animations:^{
            cell.twoButtonView.hidden = NO;
            cell.twoButtonView.frame = rect;
        }];
        
    }else{
        CGRect rect = cell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
        rect.size.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            cell.twoButtonView.frame = rect;
        } completion:^(BOOL finished) {
            cell.twoButtonView.hidden = YES;
        }];
        
    }
    
}

- (void)viewreloadData
{
    [self.tableView reloadData];
}
#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

#pragma mark - 点赞
- (void)zanBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    LocationCell * cell = (LocationCell *)[self.tableView cellForRowAtIndexPath:sender.indexpath];
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"accountLikeLocation" parameters:@{@"id":locationModel.ID,@"account":name,@"password":pass}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [cell showAlertLabel];
            locationModel.likeCount = [NSString stringWithFormat:@"%d",[locationModel.likeCount intValue]+1];
            locationModel.isClick = NO;
            [self.tableView reloadRowsAtIndexPaths:@[sender.indexpath] withRowAnimation:NO];

        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
    
}

#pragma mark - 分享
- (void)shareBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    NSDictionary * dataDic = @{@"title":locationModel.title,@"photo":locationModel.url};
    NSLog(@"dataDic == %@",dataDic);
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[dataDic objectForKey:@"title"]
                                       defaultContent:[dataDic objectForKey:@"title"]
                                                image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                                title:[dataDic objectForKey:@"title"]
                                                  url:@"http://www.shurenbang.net/download/"
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    //以下信息为特定平台需要定义分享内容，如果不需要可省略下面的添加方法
    
    //定制新浪微博
    [publishContent addSinaWeiboUnitWithContent:[dataDic objectForKey:@"title"]
                                          image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]];
    
    
    //定制QQ空间信息
    [publishContent addQQSpaceUnitWithTitle:[dataDic objectForKey:@"title"]
                                        url:@"http://www.shurenbang.net/download/"
                                       site:nil
                                    fromUrl:nil
                                    comment:nil
                                    summary:nil
                                      image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                       type:nil
                                    playUrl:nil
                                       nswb:nil];
    
    //定制微信好友信息
    [publishContent addWeixinSessionUnitWithType:INHERIT_VALUE
                                         content:nil
                                           title:[dataDic objectForKey:@"title"]
                                             url:@"http://www.shurenbang.net/download/"
                                      thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                           image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                    musicFileUrl:nil
                                         extInfo:nil
                                        fileData:nil
                                    emoticonData:nil];
    
    //定制微信朋友圈信息
    [publishContent addWeixinTimelineUnitWithType:[NSNumber numberWithInteger:SSPublishContentMediaTypeImage | SSPublishContentMediaTypeText]
                                          content:nil
                                            title:[dataDic objectForKey:@"photo"]
                                              url:@"http://www.shurenbang.net/download/"
                                       thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                            image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                     musicFileUrl:nil
                                          extInfo:nil
                                         fileData:nil
                                     emoticonData:nil];
    
    //定制微信收藏信息
    [publishContent addWeixinFavUnitWithType:INHERIT_VALUE
                                     content:nil
                                       title:[dataDic objectForKey:@"photo"]
                                         url:@"http://www.shurenbang.net/download/"
                                  thumbImage:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                       image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]
                                musicFileUrl:nil
                                     extInfo:nil
                                    fileData:nil
                                emoticonData:nil];
    
    //定制QQ分享信息
    [publishContent addQQUnitWithType:INHERIT_VALUE
                              content:nil
                                title:[dataDic objectForKey:@"photo"]
                                  url:@"http://www.shurenbang.net/download/"
                                image:[ShareSDK imageWithUrl:[dataDic objectForKey:@"photo"]]];
    
    //定制邮件信息
    [publishContent addMailUnitWithSubject:nil
                                   content:[dataDic objectForKey:@"title"]
                                    isHTML:[NSNumber numberWithBool:YES]
                               attachments:nil
                                        to:nil
                                        cc:nil
                                       bcc:nil];
    
    //定制短信信息
    [publishContent addSMSUnitWithContent:[dataDic objectForKey:@"title"]];
    
    
    //结束定制信息
    
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


#pragma mark - 网络请求
- (void)urlRequestPost
{
    
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByUser"parameters:@{@"user":self.account,@"start":@"0",@"count":@"20"}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:locationModel];
            }
            [temTableView reloadData];
        }else if(result == 4){
            [temTableView reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView headerEndRefreshing];
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    static int page = 0;
    page += 20;
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByUser"parameters:@{@"user":self.account,@"start":[NSString stringWithFormat:@"%d",page],@"count":@"20"}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:locationModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    break;
                }
            }
            [temTableView reloadData];
        }else if(result == 4){
            [temTableView reloadData];
        }else{
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView footerEndRefreshing];
            
        }
        [temTableView footerEndRefreshing];
    }];
}

@end
