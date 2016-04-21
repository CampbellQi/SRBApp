//
//  ShopCircleFromRelationViewController.m
//  SRBApp
//
//  Created by zxk on 15/3/26.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ShopCircleFromRelationViewController.h"
#import "ShoppingViewController.h"
#import "SquareViewController.h"
#import "ZZAlertView.h"

/*! @brief 筛选类型隐藏的时候向上按钮
 */
#define btnHeightForListWhenHide SCREEN_HEIGHT - 49 - 60 - 64 - 40 - 40
/*! @brief 筛选类型隐藏的时候View
 */
#define viewHeightForListWhenHide SCREEN_HEIGHT - 64 - 39 - 49 - 40
/*! @brief 筛选类型显示的时候View
 */
#define viewHeightForListWhenShow SCREEN_HEIGHT - 64 - 39 - 40 - 40 - 49
/*! @brief 筛选类型显示的时候向上按钮
 */
#define btnHeightForListWhenShow SCREEN_HEIGHT - 49 - 60 - 64 - 40 - 40 - 40
static int page = 0;
static int count = NumOfItemsForZuji;

@interface ShopCircleFromRelationViewController ()
@property (nonatomic,weak)ZZAlertView * alertView;
@end

@implementation ShopCircleFromRelationViewController
{
    int _lastPosition;
    BOOL isHidden;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)seeSomething
{
    [self.alertView dismiss];
    SquareViewController * squareVC = [[SquareViewController alloc]init];
    [self.navigationController pushViewController:squareVC animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (isHidden == YES) {
        [self huanYuan];
    }
}

//- (void)moreBtn:(ZZGoPayBtn *)sender
//{
//    SquareMoreViewController * vc = [[SquareMoreViewController alloc]init];
//    GroupModel * groupModel = self.groupArray[sender.indexpath.section];
//    vc.keyStr = groupModel.categoryID;
//    vc.titleStr = groupModel.categoryName;
//    vc.team = @"circle";
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - 网络请求
//- (void)urlRequestPosts
//{
//    NSDictionary * dic = [self parametersForDic:@"getPostListByType" parameters:@{@"type":@"123",@"count":@"6",ACCOUNT_PASSWORD,@"team":@"circle"}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        [self.groupArray removeAllObjects];
//        if ([result isEqualToString:@"0"]) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                GroupModel * groupModel = [[GroupModel alloc]init];
//                [groupModel setValuesForKeysWithDictionary:tempdic];
//                [self.groupArray addObject:groupModel];
//            }
//            if ([self.tableState isEqualToString:@"square"]) {
//                self.noData.hidden = YES;
//                self.listNoDataView.hidden = YES;
//            }
//            [self adUrlPostRequest];
//            self.isSquareNoDataHidden = YES;
//            [self setHeader];
//        }else if([result isEqualToString:@"4"]){
//            if ([self.tableState isEqualToString:@"square"]) {
//                self.noData.hidden = NO;
//                self.toTopBtn.hidden = YES;
//                self.listNoDataView.hidden = YES;
//            }
//            self.isSquareNoDataHidden = NO;
//        }else{
//            if ([self.tableState isEqualToString:@"square"]) {
//                self.noData.hidden = NO;
//                self.listNoDataView.hidden = YES;
//                self.toTopBtn.hidden = YES;
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//            self.isSquareNoDataHidden = NO;
//        }
//        if ([self.tableState isEqualToString:@"square"]) {
//            [self.tabelView reloadData];
//        }
//    } andFailureBlock:^{
//        [self.groupArray removeAllObjects];
//        self.isSquareNoDataHidden = NO;
//        if ([self.tableState isEqualToString:@"square"]) {
//            self.listNoDataView.hidden = YES;
//            self.noData.hidden = NO;
//            self.tabelView.tableHeaderView = nil;
//            self.toTopBtn.hidden = YES;
//            [self.tabelView reloadData];
//        }
//    }];
//}

- (void)start
{
    [activity startAnimating];
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    if (self.saleAndBuyType == nil || self.saleAndBuyType.length == 0) {
        self.saleAndBuyType = @"0";
    }
    if (self.categoryID == nil || self.categoryID.length == 0) {
        self.categoryID = @"0";
    }
    if (self.order == nil) {
        self.order = @"";
    }
    if (self.groupID == nil) {
        self.groupID = @"";
    }
    NSDictionary * dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"groupId":self.groupID,@"categoryID":self.categoryID,@"dealType":self.saleAndBuyType,@"order":self.order, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tabelView;

    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
            }
//            if ([self.tableState isEqualToString:@"list"]) {
//                self.noData.hidden = YES;
//                self.listNoDataView.hidden = YES;
//            }
//            self.isNoDataHidden = YES;
//            self.isNoData = NO;
            
            self.listNoDataView.hidden = YES;
            self.noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
//            self.isNoData = YES;
//            if ([self.tableState isEqualToString:@"list"]) {
//                self.noData.hidden = YES;
//                self.listNoDataView.hidden = NO;
//                self.toTopBtn.hidden = YES;
//                
//                if (self.shoppingVC.sv.contentOffset.x == SCREEN_WIDTH) {
//                    //提示框
//                    ZZAlertView * alertView = [ZZAlertView zzAlertView];
//                    [alertView setAlertWord:@"还没有买卖消息耶"];
//                    self.alertView = alertView;
//                    [alertView setSureBtnEvent:self action:@selector(seeSomething)];
//                    [alertView showAlert];
//                }
//
//            }
//            self.isNoDataHidden = NO;
            
//            if (self.shoppingVC.sv.contentOffset.x == SCREEN_WIDTH) {
//                //提示框
//                ZZAlertView * alertView = [ZZAlertView zzAlertView];
//                [alertView setAlertWord:@"还没有买卖消息耶"];
//                self.alertView = alertView;
//                [alertView setSureBtnEvent:self action:@selector(seeSomething)];
//                [alertView showAlert];
//            }
            self.listNoDataView.hidden = NO;
            self.noData.hidden = YES;
        }else{
//            self.isNoData = NO;
//            if ([self.tableState isEqualToString:@"list"]) {
//                self.noData.hidden = NO;
//                self.toTopBtn.hidden = YES;
//                self.listNoDataView.hidden = YES;
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//            self.isNoDataHidden = NO;
            self.listNoDataView.hidden = YES;
            self.noData.hidden = NO;
        }
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.shoppingVC.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        page = 0;
        [activity stopAnimating];
//        if ([self.tableState isEqualToString:@"list"]) {
//            [temTableView reloadData];
//        }
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        for (int i = 0 ; i < 5; i++) {
            UIButton * btn = (UIButton *)[self.shoppingVC.view viewWithTag:i + 10000];
            btn.userInteractionEnabled = YES;
        }
        page = 0;
        [self.dataArray removeAllObjects];
//        self.isNoDataHidden = NO;
//        self.isNoData = NO;
        [activity stopAnimating];
//        if ([self.tableState isEqualToString:@"list"]) {
//            self.noData.hidden = NO;
//            self.toTopBtn.hidden = YES;
//            self.listNoDataView.hidden = YES;
//            [temTableView reloadData];
//        }
        self.listNoDataView.hidden = YES;
        self.noData.hidden = NO;
        [temTableView headerEndRefreshing];
    }];
}
#pragma mark - 加载更多
- (void)footerRefresh
{
//    if ([self.tableState isEqualToString:@"list"]) {
        if (self.saleAndBuyType == nil || self.saleAndBuyType.length == 0) {
            self.saleAndBuyType = @"0";
        }
        if (self.categoryID == nil || self.categoryID.length == 0) {
            self.categoryID = @"0";
        }
        if (self.order == nil) {
            self.order = @"";
        }
        if (self.groupID == nil) {
            self.groupID = @"";
        }
        page += NumOfItemsForZuji;
        NSDictionary * dic;
        
        dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"groupId":self.groupID,@"categoryID":self.categoryID,@"dealType":self.saleAndBuyType,@"order":self.order, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
        
        __block UITableView *temTableView = self.tabelView;
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (int i = 0; i < temparrs.count; i++) {
                    NSDictionary * tempdic = [temparrs objectAtIndex:i];
                    BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                    [bussinessModel setValuesForKeysWithDictionary:tempdic];
                    [self.dataArray addObject:bussinessModel];
                    if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                        [self.dataArray removeLastObject];
                        page -= NumOfItemsForZuji;
                        break;
                    }
                }
//                if ([self.tableState isEqualToString:@"list"]) {
//                    [temTableView reloadData];
//                    self.noData.hidden = YES;
//                    self.listNoDataView.hidden = YES;
//                }
                [temTableView reloadData];
                self.noData.hidden = YES;
                self.listNoDataView.hidden = YES;
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
//    }else{
//        [self.tabelView footerEndRefreshing];
//    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (self.shoppingVC.shaixuanView.hidden == NO) {
        if (velocity.y > 0) {
            isHidden = YES;
            //_lastPosition = currentPostion;
            self.shoppingVC.sv.scrollEnabled = NO;
            self.shoppingVC.topBGView.hidden = YES;
            self.shoppingVC.typeView.hidden = YES;
            CGRect tempRect = self.shoppingVC.shaixuanView.frame;
            tempRect.origin.y = 0;
            self.shoppingVC.shaixuanView.frame = tempRect;
            self.shoppingVC.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 40 - 49);
            self.shoppingVC.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 40);
            self.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 39 - 40);
            self.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 39 - 40);
            self.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 40, 45, 45);
            [self.shoppingVC.navigationController setNavigationBarHidden:YES animated:YES];
            AppDelegate * app = APPDELEGATE;
            [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        }else if(velocity.y < 0){
            isHidden = NO;
            [self huanYuan];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y >= 130 * 5){
        self.toTopBtn.hidden = NO;
    }else if(scrollView.contentOffset.y < 130 * 5){
        self.toTopBtn.hidden = YES;
    }
//    if ([self.tableState isEqualToString:@"square"]) {
//        CGFloat sectionHeaderHeight = 20;
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
    
    
//    int currentPostion = scrollView.contentOffset.y;
//    if (self.shoppingVC.shaixuanView.hidden == NO) {
//        if (currentPostion - _lastPosition > 250) {
//            isHidden = YES;
//            _lastPosition = currentPostion;
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.4];
//            self.shoppingVC.sv.scrollEnabled = NO;
//            self.shoppingVC.topBGView.hidden = YES;
//            self.shoppingVC.typeView.hidden = YES;
//            CGRect tempRect = self.shoppingVC.shaixuanView.frame;
//            tempRect.origin.y = 0;
//            self.shoppingVC.shaixuanView.frame = tempRect;
//            self.shoppingVC.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT - 40 - 49);
//            self.shoppingVC.sv.frame = CGRectMake(0, 39, SCREEN_WIDTH, SCREEN_HEIGHT - 49 - 40);
//            self.shoppingVC.shopCircleTVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 39 - 40);
//            self.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 39 - 40);
//            self.shoppingVC.shopCircleTVC.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 40, 45, 45);
//            [UIView commitAnimations];
//            [self.shoppingVC.navigationController setNavigationBarHidden:YES animated:YES];
//            AppDelegate * app = APPDELEGATE;
//            [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//        }else if(_lastPosition - currentPostion > 250){
//            _lastPosition = currentPostion;
//            isHidden = NO;
//            [self huanYuan];
//        }
//    }
}

- (void)huanYuan
{
    self.shoppingVC.sv.scrollEnabled = YES;
    self.shoppingVC.topBGView.hidden = NO;
    self.shoppingVC.typeView.hidden = NO;
    CGRect tempRect = self.shoppingVC.shaixuanView.frame;
    NSInteger tempRectY;
    NSInteger tempSvHeight;
    NSInteger tempBtnY;
    NSInteger tempSvY;
    if (self.shoppingVC.isTypeShow == NO) {
        tempRectY = 39;
        tempSvY = 79;
        tempSvHeight = viewHeightForListWhenHide;
        tempBtnY = btnHeightForListWhenHide;
    }else{
        tempRectY = 79;
        tempSvY = 119;
        tempSvHeight = viewHeightForListWhenShow;
        tempBtnY = btnHeightForListWhenShow;
    }
    tempRect.origin.y = tempRectY;
    self.shoppingVC.shaixuanView.frame = tempRect;
    [UIView animateWithDuration:0.3 animations:^{
    self.shoppingVC.sv.contentSize = CGSizeMake(SCREEN_WIDTH * 2, tempSvHeight);
    self.shoppingVC.sv.frame = CGRectMake(0, tempSvY, SCREEN_WIDTH, tempSvHeight);
    self.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, tempSvHeight);
    self.tabelView.frame = CGRectMake(0, 0, SCREEN_WIDTH, tempSvHeight);
    self.toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, tempBtnY, 45, 45);
    }];
    [self.shoppingVC.navigationController setNavigationBarHidden:NO animated:YES];
    AppDelegate * app = APPDELEGATE;
    [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
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
