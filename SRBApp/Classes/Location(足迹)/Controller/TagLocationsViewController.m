//
//  TagLocationsViewController.m
//  SRBApp
//
//  Created by zxk on 15/4/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TagLocationsViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface TagLocationsViewController ()

@end

@implementation TagLocationsViewController
{
    BOOL isBack;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.tagStr == nil) {
        self.tagStr = @"";
    }
    self.title = self.tagStr;
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    //toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 60 - 64, 45, 45);
    
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)backBtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}
//
//#pragma mark 键盘弹出与收回的通知
//- (void)keyboardWasShown:(NSNotification *)notification
//{
//    //        submitBtn.enabled = NO;
//    //        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateNormal];
//    //
//    if (tempHpTextView == self.hpTextView) {
//        isKeyboardHidden = NO;
//        NSDictionary * userInfo = [notification userInfo];
//        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        
//        CGRect keyboardRect = [aValue CGRectValue];
//        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
//        
//        // 根据老的 frame 设定新的 frame
//        CGRect newTextViewFrame = commentTextBGView.frame; // by michael
//        newTextViewFrame.origin.y = keyboardRect.origin.y - commentTextBGView.frame.size.height;
//        
//        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//        
//        // animations settings
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:[duration doubleValue]];
//        [UIView setAnimationCurve:[curve intValue]];
//        
//        commentTextBGView.frame = newTextViewFrame;
//        if (tapPoint.y > commentTextBGView.frame.origin.y - 14) {
//            CGRect tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
//            tableRect.origin.y -= tapPoint.y - commentTextBGView.frame.origin.y + 14;
//            self.tableview.frame = tableRect;
//        }
//        
//        // commit animations
//        [UIView commitAnimations];
//    }
//}
//- (void)keyboardWillBeHidden:(NSNotification *)notification
//{
//    if (tempHpTextView == self.hpTextView) {
//        isKeyboardHidden = YES;
//        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
//        
//        // get a rect for the textView frame
//        CGRect containerFrame = commentTextBGView.frame;
//        containerFrame.origin.y = SCREEN_HEIGHT - commentTextBGView.frame.size.height;
//        
//        // animations settings
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        [UIView setAnimationDuration:[duration doubleValue]];
//        [UIView setAnimationCurve:[curve intValue]];
//        
//        // set views with new info
//        commentTextBGView.frame = containerFrame;
//        self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
//        // commit animations
//        [UIView commitAnimations];
//    }
//}

- (void)pushToLocationTagView:(NSString *)tag withLocationTextView:(LocationTextView *)locationTextView
{
    
}
#pragma mark - 网络请求
- (void)urlRequestPost
{
    if (self.tagStr == nil) {
        
        return;
    }
    NSDictionary * param = [self parametersForDic:@"getDynamicLocationByTags" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count],@"tags":self.tagStr}];
    
    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
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
                CGRect rect = [[self appendStrWithLocationModel:locationModel] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
                if (locationModel.content.length == 0) {
                    rect.size.height = 0.0;
                }
                locationModel.contentFrame = rect;
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
            //_toTopBtn.hidden = YES;
        }else{
            noData.hidden = NO;
            //_toTopBtn.hidden = YES;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView reloadData];
        page = 0;
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        //_toTopBtn.hidden = YES;
        [dataArray removeAllObjects];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        noData.hidden = NO;
    }];
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary *param = [self parametersForDic:@"getDynamicLocationByTags"parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"tags":self.tagStr}];
    
    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                locationModel.zanCount = locationModel.likeCount;
                CGRect rect = [[self appendStrWithLocationModel:locationModel] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
                if (locationModel.content.length == 0) {
                    rect.size.height = 0.0;
                }
                locationModel.contentFrame = rect;
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
//
//#pragma mark - 网络请求
//- (void)urlRequestPost
//{
//    if (self.tagStr == nil) {
//        
//        return;
//    }
//    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByTags" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count],@"tags":self.tagStr}];
//    NSLog(@"%@",dic);
//    NSLog(@"%@",[[dic objectForKey:@"parameters"] objectForKey:@"tags"]);
//    __block UITableView *temTableView = self.tableview;
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        [dataArray removeAllObjects];
//        if ([result isEqualToString:@"0"]) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                LocationModel * locationModel = [[LocationModel alloc]init];
//                [locationModel setValuesForKeysWithDictionary:tempdic];
//                locationModel.zanCount = locationModel.likeCount;
//                [dataArray addObject:locationModel];
//            }
//            noData.hidden = YES;
//        }else if([result isEqualToString:@"4"]){
//            noData.hidden = NO;
//            self.toTopBtn.hidden = YES;
//        }else if ([result isEqualToString:@"10100"]){
//            Singleton * singleton = [Singleton sharedInstance];
//            if (singleton.isShow == NO) {
//                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请登录" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
//                [alert show];
//                singleton.isShow = YES;
//            }
//            noData.hidden = NO;
//            self.toTopBtn.hidden = YES;
//        }else{
//            noData.hidden = NO;
//            self.toTopBtn.hidden = YES;
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//        [temTableView reloadData];
//        page = 0;
//        [temTableView headerEndRefreshing];
//    } andFailureBlock:^{
//        page = 0;
//        self.toTopBtn.hidden = YES;
//        [temTableView headerEndRefreshing];
//        [dataArray removeAllObjects];
//        [temTableView reloadData];
//        noData.hidden = NO;
//    }];
//}
//#pragma mark - 加载更多
//- (void)footerRefresh
//{
//    page += NumOfItemsForZuji;
//    NSDictionary * dic;
//    dic = [self parametersForDic:@"getDynamicLocationByTags"parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"tags":self.tagStr}];
//    
//    
//    __block UITableView *temTableView = self.tableview;
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                LocationModel * locationModel = [[LocationModel alloc]init];
//                [locationModel setValuesForKeysWithDictionary:tempdic];
//                locationModel.zanCount = locationModel.likeCount;
//                [dataArray addObject:locationModel];
//                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
//                    [dataArray removeLastObject];
//                    page -= NumOfItemsForZuji;
//                    break;
//                }
//            }
//            noData.hidden = YES;
//            [temTableView reloadData];
//        }else if([result isEqualToString:@"4"]){
//            page -= NumOfItemsForZuji;
//        }else{
//            page -= NumOfItemsForZuji;
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//        [temTableView footerEndRefreshing];
//    } andFailureBlock:^{
//        page -= NumOfItemsForZuji;
//        [temTableView footerEndRefreshing];
//    }];
//}

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
