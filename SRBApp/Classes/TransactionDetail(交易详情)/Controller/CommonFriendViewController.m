//
//  CommonFriendViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "CommonFriendViewController.h"

static int page = 0;
@interface CommonFriendViewController ()
@end

@implementation CommonFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"共同熟人";
    
    
    [self customInit];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = YES;
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInit
{
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    dataArray = [NSMutableArray array];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    tableview.backgroundColor = [UIColor clearColor];
    [self.view addSubview: tableview];
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    imageview = [[NoDataView alloc]initWithFrame:tableview.frame];
    imageview.hidden = YES;
    imageview.center = tableview.center;
    [tableview addSubview:imageview];
}


#pragma mark - 刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequest];
    });
}
#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendCommon" parameters:@{ACCOUNT_PASSWORD,@"user":self.sellerAccount,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                CommenFriendModel * commonFriendModel = [[CommenFriendModel alloc]init];
                [commonFriendModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:commonFriendModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            imageview.hidden = YES;
            [tableview reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [tableview footerEndRefreshing];
    }];
}


#pragma mark - tableviewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonFriendCell * cell = [CommonFriendCell settingCellWithTaableView:tableView];
    CommenFriendModel * commonFriendModel = dataArray[indexPath.row];
    cell.commenFriendModel = commonFriendModel;
    cell.chatBtn.indexpath = indexPath;
    cell.imgView.tag = indexPath.row;
    cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
    cell.imgView.clipsToBounds = YES;
    cell.imgView.userInteractionEnabled = YES;
    [cell.chatBtn addTarget:self action:@selector(chatBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapToPersonal:)];
    [cell.imgView addGestureRecognizer:tap];
    return cell;
}

- (void)TapToPersonal:(UITapGestureRecognizer *)tap
{
    CommenFriendModel *model = [dataArray objectAtIndex:tap.view.tag];
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    personalVC.account = model.account;
    personalVC.nickname = model.nickname;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)chatBtn:(ZZGoPayBtn *)chatBtn
{
    tempCommentModel = dataArray[chatBtn.indexpath.row];
//    UIActionSheet *chatActionSheet = [[UIActionSheet alloc] initWithTitle:@"是否发送信息链接" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送",@"不发送", nil];
//    [chatActionSheet showInView:self.view];
    
    MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
    
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = tempCommentModel.account;
    user.name = tempCommentModel.nickname;
    user.portraitUri = tempCommentModel.avatar;
    myChatVC.portraitStyle = RCUserAvatarCycle;
    myChatVC.currentTarget = user.userId;
    myChatVC.currentTargetName = user.name;
    myChatVC.conversationType = ConversationType_PRIVATE;
    myChatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myChatVC animated:YES];
    
}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if (buttonIndex == 0) {
//        [self chatRichContentMessage];
//    }if (buttonIndex == 1) {
//        [self chat];
//    }
//}
//
//
////单聊
//- (void)chat
//{
//    MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
//    
//    RCUserInfo *user = [[RCUserInfo alloc]init];
//    user.userId = tempCommentModel.account;
//    user.name = tempCommentModel.nickname;
//    user.portraitUri = tempCommentModel.avatar;
//    myChatVC.portraitStyle = RCUserAvatarCycle;
//    myChatVC.currentTarget = user.userId;
//    myChatVC.currentTargetName = user.name;
//    myChatVC.conversationType = ConversationType_PRIVATE;
//    myChatVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:myChatVC animated:YES];
//}
//
////图文聊天
//- (void)chatRichContentMessage
//{
//    
//    //图文单聊
//    
//    RichContentMessageViewController *temp = [[RichContentMessageViewController alloc]init];
//    
//    temp.title = self.title;
//    temp.content = self.content;
//    temp.imageUrl = self.imageUrl;
//    temp.idNumber = self.idNumber;
//    temp.currentTarget = tempCommentModel.account;
//    temp.currentTargetName = tempCommentModel.nickname;
//    temp.conversationType = ConversationType_PRIVATE;
//    temp.enableSettings = NO;
//    temp.photo = self.photo;
//    temp.portraitStyle = RCUserAvatarCycle;
//    temp.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:temp animated:YES];
//    [temp sendDebugRichMessage];
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

#pragma mark - post请求
- (void)urlRequest
{
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendCommon" parameters:@{ACCOUNT_PASSWORD,@"user":self.sellerAccount,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i< temparr.count; i++) {
                CommenFriendModel * commomFriendModel = [[CommenFriendModel alloc]init];
                NSDictionary * tempdic = temparr[i];
                [commomFriendModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:commomFriendModel];
            }
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            imageview.hidden = NO;
        }
        [tableview reloadData];
        [tableview headerEndRefreshing];
        page = 0;
    } andFailureBlock:^{
        page = 0;
        [dataArray removeAllObjects];
        imageview.hidden = NO;
        [tableview reloadData];
        [tableview headerEndRefreshing];
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
