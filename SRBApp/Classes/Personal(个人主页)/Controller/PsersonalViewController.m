//
//  PsersonalViewController.m
//  SRBApp
//
//  Created by zxk on 14/12/24.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "PsersonalViewController.h"
#import "PersonalHeaderLabelView.h"
#import "MJRefresh.h"
#import "PersonalModel.h"
#import "PersonalCell.h"
#import <UIImageView+WebCache.h>
#import "MoreViewController.h"
#import "LocationModel.h"
#import "BussinessModel.h"
#import "LocationCell.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"


@interface PsersonalViewController ()<UITableViewDataSource,UITableViewDelegate,TableViewCellDelegate>

@property (nonatomic,strong) UIButton * danbaoBtn;           //担保按钮
@property (nonatomic,strong) UIButton * zujiBtn;             //组建牛
@property (nonatomic,strong) UIButton * jiaoyiBtn;           //交易按钮
@end

@implementation PsersonalViewController
{
    UITableView * tableview;
    NSMutableArray * dataArray;     //
    UIImageView * logoImgView;      //头像
    UILabel * nameLabel;            //昵称
    UIImageView * sexImgView;       //性别
    UILabel * beizhuLabel;          //备注
    UIButton * changeBeizhuBtn;     //改变备注按钮
    UILabel * signLabel;            //签名
    UILabel * addressLabel;         //地址
    UIImageView * locationImg;      //坐标图
    UILabel * kaopuLabel;           //靠谱指数

    PersonalModel * personalModel;  //个人信息model
    UIImageView * expandZoomImageView;  //头部图片
    
    UIView * bgView;                //遮挡view
    CGRect frame ;
    
    NSString * type;                //model类型
    
    int where;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    where = 0;
    [self customInit];
    [self headerURLRequestPost];
    [self urlRequest];
}

// scrollView 结束拖动
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
//    logoImgView.frame = CGRectMake(15, 175 - 75 - 18, 75, 75);
//    nameLabel.frame = CGRectMake(logoImgView.frame.size.width + logoImgView.frame.origin.x + 16, logoImgView.frame.size.height / 2 + logoImgView.frame.origin.y - 7, 150, 14);
    NSLog(@"结束拖动");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    
//    CGFloat yOffset = scrollView.contentOffset.y;
//
//    if (scrollView != tableview) {
//        NSLog(@"12312312");
//    }
//    NSLog(@"%f",yOffset);
//    
////    if ((yOffset < 40)) {
////        bgView.alpha = yOffset /100 + 0.6;
////        frame.size.height = yOffset + 30;
////    }else if(yOffset > 40){
////        bgView.alpha = 1;
////        frame.size.height = 70;
////    }else if(yOffset < -30){
////        frame.size.height = 0;
////        bgView.alpha = 0;
////    }
//    
//    CGRect logoImgFrame = logoImgView.frame;
//    CGRect nameFrame = nameLabel.frame;
//    if (yOffset < 40) {
//        logoImgFrame.origin.y = yOffset;
//        if (yOffset <= -50) {
//            logoImgFrame.origin.y = yOffset;
//            nameFrame.origin.y = logoImgFrame.origin.y + 30;
//        }
//    }
//    logoImgView.frame = logoImgFrame;
//    nameLabel.frame = nameFrame;
}

#pragma mark - 自定义控件
- (void)customInit
{
    
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    imageview.image = [UIImage imageNamed:@"bg.jpg"];
    [self.view addSubview:imageview];
    
    type = @"交易";
    dataArray = [NSMutableArray array];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.contentInset = UIEdgeInsetsMake(-70, 0, 0, 0);
    [self.view addSubview:tableview];
    //tableview.backgroundColor = [UIColor clearColor];
    //self.view = tableview;
    
}

#pragma mark - tableviewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([type isEqualToString:@"交易"]) {
        return 130;
    }else if([type isEqualToString:@"足迹"]){
        if ([dataArray[indexPath.row] isKindOfClass:[LocationModel class]]) {
            LocationModel * locationModel = dataArray[indexPath.row];
            CGRect rect = [locationModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 20 - 8, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
            if ([locationModel.url isEqualToString:@""]) {
                return rect.size.height + 144;
            }else{
                return rect.size.height + 144 + 212;
            }
        }else{
            return 80;
        }
    }
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PersonalCell * cell = [PersonalCell personalCellWithTaableView:tableView];
    if ([type isEqualToString:@"交易"]) {
        if ([dataArray[indexPath.row] isKindOfClass:[BussinessModel class]]) {
            BussinessModel * bussinessModel = dataArray[indexPath.row];
            cell.bussinessModel = bussinessModel;
        }
    }else if ([type isEqualToString:@"足迹"]){
        if ([dataArray[indexPath.row] isKindOfClass:[LocationModel class]]) {
            LocationModel * locationModel = dataArray[indexPath.row];
            cell.locationModel = locationModel;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.zanBtn.indexpath = indexPath;
            cell.shareBtn.indexpath = indexPath;
            [cell.zanBtn addTarget:self action:@selector(zanBtn:) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareBtn addTarget:self action:@selector(shareBtn:) forControlEvents:UIControlEventTouchUpInside];
            cell.delegate = self;
        }
    }
    //cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark - 点赞
- (void)zanBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    LocationCell * cell = (LocationCell *)[tableview cellForRowAtIndexPath:sender.indexpath];
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"accountLikeLocation" parameters:@{@"id":locationModel.ID,@"account":name,@"password":pass}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [cell showAlertLabel];
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
}

- (void)viewreloadData
{
    [tableview reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self makeValueToHeader];
    });
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 网络请求
- (void)urlRequest
{
    self.jiaoyiBtn.selected = YES;
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostListByUser" parameters:@{@"user":self.account, @"type":@"0",@"dealType":@"0",@"status":@"0", @"start":@"0", @"count":@"100"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i<arr.count; i++) {
                BussinessModel * model = [[BussinessModel alloc]init];
                NSDictionary * tempdic = arr[i];
                [model setValuesForKeysWithDictionary:tempdic];
                NSLog(@"%@",model.account);
                [dataArray addObject:model];
            }
            NSLog(@"%lu",dataArray.count);
            [tableview reloadData];
        }else if(result == 4){
            [tableview reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self makeValueToHeader];
        });
    }];
}

#pragma mark - 个人信息请求
- (void)headerURLRequestPost
{
    NSString * name = [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
    NSString * pass = [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"];
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{@"account":self.account,@"user":name,@"password":pass}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSDictionary * tempdic = [dic objectForKey:@"data"];
            personalModel = [[PersonalModel alloc]init];
            [personalModel setValuesForKeysWithDictionary:tempdic];
            [self makeValueToHeader];
        }else if(result == 4){
            NSLog(@"%@",[dic objectForKey:@"message"]);
        }else{
            NSLog(@"%@",[dic objectForKey:@"message"]);
        }
    }];
    

}


#pragma mark - 足迹和交易按钮
- (void)jiaoyiBtn:(UIButton *)btn
{
    type = @"交易";
    where = 0;
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostListByUser" parameters:@{@"user":self.account, @"type":@"0",@"dealType":@"0",@"status":@"0", @"start":@"0", @"count":@"100"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"]intValue];
        [dataArray removeAllObjects];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i<arr.count; i++) {
                BussinessModel * model = [[BussinessModel alloc]init];
                NSDictionary * tempdic = arr[i];
                [model setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:model];
            }
            [tableview reloadData];
        }else if(result == 4){
            [tableview reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self makeValueToHeader];
        });
    }];
}
- (void)zujiBtn:(UIButton *)btn
{
    where = 1;
    type = @"足迹";
    
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByUser" parameters:@{@"user":self.account,@"start":@"0",@"count":@"100"}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        [dataArray removeAllObjects];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:locationModel];
            }
            [tableview reloadData];
        }else if(result == 4){
            [tableview reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.001 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self makeValueToHeader];
        });
    }];
}

#pragma mark - 定义头部样式
- (id)headerView
{
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 35, 30);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"sandian"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(more:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    UIImageView * headerBgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 110)];
    headerBgImg.image = [UIImage imageNamed:@"bg.jpg"];
    headerBgImg.userInteractionEnabled = YES;
    
//    //头像
//    logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 9, 75, 75)];
//    logoImgView.layer.masksToBounds = YES;
//    //logoImgView.backgroundColor = [UIColor orangeColor];
//    logoImgView.layer.cornerRadius = 37.5;
//    [headerBgImg addSubview:logoImgView];
//    
//    //名字
//    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImgView.frame.size.width + logoImgView.frame.origin.x + 16, 15, 150, 18)];
//    nameLabel.font = SIZE_FOR_14;
//    nameLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
//    
//    //签名
//    signLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 9, SCREEN_WIDTH - 15, 32)];
//    signLabel.lineBreakMode = NSLineBreakByCharWrapping;
//    signLabel.numberOfLines = 0;
//    signLabel.font = SIZE_FOR_14;
//    signLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
//    
//    //定位图
//    logoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(signLabel.frame.origin.x, signLabel.frame.size.height + signLabel.frame.origin.y + 12, 11, 16)];
//    
//    //地址
//    addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImgView.frame.size.width + logoImgView.frame.origin.x + 6, logoImgView.frame.origin.y, SCREEN_WIDTH - 120, 12)];
//    addressLabel.font = SIZE_FOR_12;
//    addressLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
//    
//
    //交易按钮
    self.jiaoyiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.jiaoyiBtn.frame = CGRectMake(0, headerBgImg.frame.size.height - 40, SCREEN_WIDTH/2, 40);
    [self.jiaoyiBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [self.jiaoyiBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    self.jiaoyiBtn.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
////    danbaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
////    danbaoBtn.frame = CGRectMake(0, lineView.frame.origin.y+lineView.frame.size.height, SCREEN_WIDTH/2, 30);
////    [danbaoBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
//    
//    
    //足迹按钮
    self.zujiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zujiBtn.frame = CGRectMake(self.jiaoyiBtn.frame.size.width + self.jiaoyiBtn.frame.origin.x, headerBgImg.frame.size.height - 40, SCREEN_WIDTH/2, 40);
    [self.zujiBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [self.zujiBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    self.zujiBtn.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];

    [self.jiaoyiBtn addTarget:self action:@selector(jiaoyiBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.zujiBtn addTarget:self action:@selector(zujiBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.jiaoyiBtn.titleLabel.font = SIZE_FOR_14;
    self.danbaoBtn.titleLabel.font = SIZE_FOR_14;
    self.zujiBtn.titleLabel.font = SIZE_FOR_14;
    if (where ==0) {
        self.jiaoyiBtn.selected = YES;
    }else{
        self.zujiBtn.selected = YES;
    }
    //交易足迹等中间分割线
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, self.jiaoyiBtn.frame.origin.y, 1, 40)];
//    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(danbaoBtn.frame.size.width + danbaoBtn.frame.origin.x, 0, 1, 30)];
    lineView1.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//    lineView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//
//    //底部分割线
//    UIView * lineViewBottom = [[UIView alloc]initWithFrame:CGRectMake(0, lineView1.frame.origin.y + lineView1.frame.size.height, SCREEN_WIDTH, 1)];
//    lineViewBottom.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//    
//
    [headerBgImg addSubview:self.jiaoyiBtn];
//    [headerBgImg addSubview:self.danbaoBtn];
    [headerBgImg addSubview:self.zujiBtn];
//    [headerBgImg addSubview:nameLabel];
//    [headerBgImg addSubview:signLabel];
    [headerBgImg addSubview:lineView1];
//    [headerBgImg addSubview:lineViewBottom];
    
    return headerBgImg;
}

#pragma mark - 右上角button
- (void)more:(UIButton *)sender
{
    MoreViewController * moreVC = [[MoreViewController alloc]init];
    moreVC.array = @[@"修改备注",@"在线聊天",@"删除好友"];
    moreVC.imgArr = @[@"daipingjia",@"pop_chat",@"pop_friend_del"];
    [[[UIApplication sharedApplication].windows lastObject]addSubview:moreVC.view];
    [self addChildViewController:moreVC];
}

#pragma mark - 头部赋值
- (void)makeValueToHeader
{
//    NSLog(@"------%@",personalModel.avatar);
//    [logoImgView sd_setImageWithURL:[NSURL URLWithString:personalModel.avatar] placeholderImage:[UIImage imageNamed:@"wutu"]];
//    nameLabel.text = personalModel.nickname;
//    signLabel.text = personalModel.sign;
//    NSLog(@"%@",personalModel.nickname);
    [self.jiaoyiBtn setTitle:[NSString stringWithFormat:@"交易"] forState:UIControlStateNormal];
    [self.zujiBtn setTitle:[NSString stringWithFormat:@"足迹"] forState:UIControlStateNormal];
//
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
