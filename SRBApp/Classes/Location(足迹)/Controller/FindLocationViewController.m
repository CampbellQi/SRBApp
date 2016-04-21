//
//  FindLocationViewController.m
//  SRBApp
//
//  Created by zxk on 15/3/18.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "FindLocationViewController.h"
#import "AppDelegate.h"
static int page = 0;

@interface FindLocationViewController ()<ISSShareViewDelegate>

@end

@implementation FindLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60 - 64, 45, 45);
    self.tableview.height = SCREEN_HEIGHT - 64;
    self.title = @"随便逛逛";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)backBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationModel * locationModel = dataArray[indexPath.row];
    NSArray * likesArr = locationModel.likes;
    int j = 0;
    int tempWidth = 0;
    if (locationModel.likes != nil && locationModel.likes.count != 0) {
        for (int i = 0; i < locationModel.likes.count + 1; i++) {
            @autoreleasepool {
                NSString * nameStr;
                NSDictionary * tempDic;
                if (i <= locationModel.likes.count - 1) {
                    tempDic = likesArr[i];
                    nameStr = [NSString stringWithFormat:@"%@,",[tempDic objectForKey:@"nickname"]];
                }else{
                    nameStr = @" 觉得很赞";
                }
                
                if (i == locationModel.likes.count - 1) {
                    nameStr = [nameStr substringToIndex:nameStr.length - 1];
                }
                
                CGSize tempSize = [nameStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                
                tempWidth += tempSize.width;
                
                if (tempWidth > (SCREEN_WIDTH - 78 - 20)) {
                    tempWidth = 0;
                    tempWidth += tempSize.width;
                    j += 1;
                }
            }
        }
    }
    
    NSArray * commentArr = locationModel.comments;
    double height = 0.0f;
    if (locationModel.comments != nil && locationModel.comments.count != 0) {
        for (int i = 0; i < locationModel.comments.count; i++) {
            NSDictionary * tempDic = commentArr[i];
            NSDictionary * fromuserDic = [tempDic objectForKey:@"fromuser"];
            NSDictionary * toUserDic = [tempDic objectForKey:@"touser"];
            
            NSString * commentStr;
            if (toUserDic == nil) {
                commentStr = [NSString stringWithFormat:@"%@：%@",[fromuserDic objectForKey:@"nickname"],[tempDic objectForKey:@"comment_content"]];
            }else{
                commentStr = [NSString stringWithFormat:@"%@ %@ %@：%@",[fromuserDic objectForKey:@"nickname"],@"回复",[toUserDic objectForKey:@"nickname"],[tempDic objectForKey:@"comment_content"]];
            }
            
            CGRect tempRect = [commentStr boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78 - 30 , 40000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
            height += tempRect.size.height + 6;
        }
    }
    
    CGRect rect = [[self appendStrWithLocationModel:locationModel] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];

    if (locationModel.comments == nil || locationModel.comments.count == 0) {
        if (locationModel.likes == nil || locationModel.likes.count == 0) {
            height -= 54;
        }else{
            height -= 44;
        }
    }
    
    //内容起始位置
    CGFloat tempY = 0;
    if ((locationModel.content == nil || [locationModel.content isEqualToString:@""] || locationModel.content.length == 0 )&& (locationModel.tags == nil || [locationModel.tags isEqualToString:@""])) {
        tempY = 12;
    }else{
        tempY = 12 + 20 + 8;
    }
    
    //名字 + locationImg + 内容 + height + 我来说一句 + 空白
    CGFloat someHeight = 32 + 25 + tempY + rect.size.height + height + 44;
    CGFloat zanHeight = (j + 1)* 15 + 15;
    
    //没有照片
    if ([locationModel.photos isEqualToString:@""]) {
        //是否是自己发布的足迹
        if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
            //是否有赞的人
            if (likesArr.count == 0) {
                return someHeight + 28;
            }else{
                return someHeight + zanHeight + 28;
            }
        }else{
            if (likesArr.count == 0) {
                return someHeight;
            }else{
                return someHeight + zanHeight;
            }
        }
    }else{
        //有图片的情况
        NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
        //图片数量<=3
        if (photosArr.count <= 3) {
            //图片数量==1
            if (photosArr.count == 1) {
                NSInteger tempHeight = 200;
                if (locationModel.width != nil && ![locationModel.width isEqualToString:@""] && locationModel.height != nil && ![locationModel.height  isEqualToString:@""] && ![locationModel.width isEqualToString:@"0"] && ![locationModel.height isEqualToString:@"0"]) {
                    CGSize tempSize = [self onScreenPointSizeOfImageInImageView:locationModel];
                    tempHeight = tempSize.height;
                }else{
                    tempHeight = 200;
                }
                if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
                    if (likesArr.count == 0) {
                        return someHeight + tempHeight + 9 + 28;
                    }else{
                        return someHeight + tempHeight + 9  + 28 + zanHeight;
                    }
                }else{
                    if (likesArr.count == 0) {
                        return someHeight + tempHeight + 9 ;
                    }else{
                        return someHeight + tempHeight + 9  + zanHeight;
                    }
                }
            }else{
                if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
                    if (likesArr.count == 0) {
                        return someHeight + 81 + 28;
                    }else{
                        return someHeight + 81 + zanHeight + 28;
                    }
                    
                }else{
                    if (likesArr.count == 0) {
                        return someHeight + 81;
                    }else{
                        return someHeight + 81 + zanHeight;
                    }
                    
                }
            }
        }else{
            if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
                if (likesArr.count == 0) {
                    return someHeight + 156 +28;
                }else{
                    return someHeight + 156 + zanHeight + 28;
                }
                
            }else{
                if (likesArr.count == 0) {
                    return someHeight + 156;
                }else{
                    return someHeight + 156 + zanHeight;
                }
            }
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * reuseID = @"cell";
    
    LocationCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[LocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    cell.descriptionLabel.delegate = self;
    cell.locationModel = dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moreBtn.indexpath = indexPath;
    [cell.moreBtn addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
    cell.zanBtn.indexpath = indexPath;
    [cell.zanBtn addTarget:self action:@selector(zanBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.indexpath = indexPath;
    [cell.shareBtn addTarget:self action:@selector(shareRequest:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    
    //cell.photoImg.indexpath = indexPath;
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLPersonal:)];
    [cell.logoImg addGestureRecognizer:logoTap];
    
    cell.logoImg.indexpath = indexPath;
    cell.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.logoImg.clipsToBounds = YES;
    
    cell.photoImg.indexpath = indexPath;
    cell.photoImg1.indexpath = indexPath;
    cell.photoImg2.indexpath = indexPath;
    cell.photoImg3.indexpath = indexPath;
    cell.photoImg4.indexpath = indexPath;
    cell.photoImg5.indexpath = indexPath;
    cell.photoImg6.indexpath = indexPath;
    
    cell.photoImg.t_delegate = self;
    cell.photoImg1.t_delegate = self;
    cell.photoImg2.t_delegate = self;
    cell.photoImg3.t_delegate = self;
    cell.photoImg4.t_delegate = self;
    cell.photoImg5.t_delegate = self;
    cell.photoImg6.t_delegate = self;
    
    cell.addressLabel.indexpath = indexPath;
    //地图
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTap:)];
    [cell.addressLabel addGestureRecognizer:addressTap];
    cell.delBtn.indexpath = indexPath;
    [cell.delBtn addTarget:self action:@selector(delLocation:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.commentBGView.hidden = YES;
    CGRect tempRect = cell.zanNumBgView.frame;
    tempRect.size.height -= 44;
    cell.zanNumBgView.frame = tempRect;
    LocationModel * locationModel = dataArray[indexPath.row];
    if ((locationModel.likes == nil || locationModel.likes.count == 0) && (locationModel.comments == nil || locationModel.comments.count == 0)) {
        cell.zanNumBgView.hidden = YES;
        cell.sanjiaoImg.hidden = YES;
    }else{
        cell.zanNumBgView.hidden = NO;
        cell.sanjiaoImg.hidden = NO;
    }
    if (locationModel.comments == nil || locationModel.comments.count == 0) {
        cell.zanLineView.hidden = YES;
    }
    
    return cell;
}

#pragma mark 进入地址页面
- (void)addressTap:(UITapGestureRecognizer *)tap
{
    MyLabel * tempLabel = (MyLabel *)tap.view;
    LocationModel * locationModel = dataArray[tempLabel.indexpath.row];
    MapViewController *mapVC = [[MapViewController alloc] init];
    
    if (![locationModel.xyz isEqualToString:@"0"] && ![locationModel.xyz isEqualToString:@""] && locationModel.xyz != nil) {
        NSArray *locationArr = [locationModel.xyz componentsSeparatedByString:@","];
        mapVC.lat = [[locationArr objectAtIndex:0] doubleValue];
        mapVC.lon = [[locationArr objectAtIndex:1]doubleValue];
        mapVC.address = locationModel.title;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

#pragma mark 删除自己的足迹
- (void)delLocation:(ZZGoPayBtn *)sender
{
    indexpath = sender.indexpath;
    UIAlertView *delLocationAlert = [[UIAlertView alloc] initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [delLocationAlert show];
}

#pragma mark 点击进入个人中心
- (void)tapToLPersonal:(UITapGestureRecognizer *)tap
{
    [self.hpTextView resignFirstResponder];
    MyImgView * tempImgView = (MyImgView *)tap.view;
    LocationModel * locationModel = dataArray[tempImgView.indexpath.row];
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    personalVC.hidesBottomBarWhenPushed = YES;
    personalVC.account = locationModel.account;
    personalVC.nickname = locationModel.nickname;
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark - 点赞
- (void)zanBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    LocationCell * cell = (LocationCell *)[self.tableview cellForRowAtIndexPath:sender.indexpath];
    NSDictionary * dic = [self parametersForDic:@"accountLikeLocation" parameters:@{@"id":locationModel.ID,ACCOUNT_PASSWORD}];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"处理中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [cell showAlertLabel];
            LocationModel * tempModel = [dataArray objectAtIndex:sender.indexpath.row];
            NSMutableArray * temparr = [NSMutableArray arrayWithArray:tempModel.likes];
            [temparr addObject:[dic objectForKey:@"data"]];
            tempModel.likes = temparr;
            [dataArray replaceObjectAtIndex:sender.indexpath.row withObject:tempModel];
            locationModel.isClick = NO;
            [self.tableview reloadRowsAtIndexPaths:@[sender.indexpath] withRowAnimation:NO];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [hud removeFromSuperview];
    }];
}

#pragma mark - 分享
- (void)shareBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    tempHpTextView = nil;
    
    NSString *content = [NSString stringWithFormat:@"%@ %@",locationModel.content, locationModel.shortUrl];
    //NSString *content = [NSString stringWithFormat:@"%@",_model.content];
    if (content.length > 140) {
        content = [content substringToIndex:140];
    }
    [ShareViewController shareToThirdPlatformWithUIViewController:self Title:locationModel.title SecondTitle:[self.userInfoDic objectForKey:@"note"] Content:locationModel.content ImageUrl:locationModel.url SencondImgUrl:[self.userInfoDic objectForKey:@"photo"] Btn:sender ShareUrl:locationModel.shareUrl];
}

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType;
{
    viewController.navigationController.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"#e5005d"];
}

#pragma mark - 评论代理
- (void)tapComment:(LocationCell *)locationCell index:(NSInteger)index withTap:(UITapGestureRecognizer *)tap
{
    
}

//#pragma mark - 分享
//- (void)shareBtn:(LeftImgAndRightTitleBtn *)sender
//{
//    LocationModel * locationModel = dataArray[sender.indexpath.row];
//    tempHpTextView = nil;
//    [ShareViewController shareToThirdPlatformWithUIViewController:self Title:locationModel.title Content:locationModel.title ImageUrl:locationModel.url Btn:sender ShareUrl:nil];
//}

#pragma mark 显示赞和分享按钮
- (void)showMoreView:(ZZGoPayBtn *)sender
{
    [self.hpTextView resignFirstResponder];
    self.hpTextView.text = @"";
    LocationCell * cell = (LocationCell *)[self.tableview cellForRowAtIndexPath:sender.indexpath];
    cell.locationModel.isClick = !cell.locationModel.isClick;
    NSArray * temparr = [self.tableview visibleCells];
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

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationList" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];

    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];

            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                locationModel.zanCount = locationModel.likeCount;
                [dataArray addObject:locationModel];
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
            toTopBtn.hidden = YES;
        }else{
            noData.hidden = NO;
            toTopBtn.hidden = YES;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView reloadData];
        page = 0;
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        toTopBtn.hidden = YES;
        [dataArray removeAllObjects];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        noData.hidden = NO;
    }];
}

- (void)shareRequest:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel *locationModel;
    NSDictionary * dic = [self parametersForDic:@"getShortUrl" parameters:@{ACCOUNT_PASSWORD,@"url":locationModel.shareUrl}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [locationModel setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            [self shareBtn:sender];
            
        }else if([result isEqualToString:@"4"]){
            NSLog(@"%@", result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }else{
            
        }
    }];
}
#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationList"
        parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];

    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:locationModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [temTableView reloadData];
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [temTableView footerEndRefreshing];
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
