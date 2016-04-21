//
//  AlreadyPublishViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "HadPublishViewController.h"
#import "SecondSubclassDetailViewController.h"
#import "MyImgView.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface HadPublishViewController ()<UIActionSheetDelegate>
{
    NoDataView * nodataView;
    MBProgressHUD * hud;
    UIActionSheet * actionsheet;
    NSIndexPath * tempIndexpath;
}
@end

@implementation HadPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    
    
    dataArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    nodataView.hidden = YES;
    [self.tableView addSubview:nodataView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wjj" object:nil];
}

- (void)refresh
{
    [self headerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-  (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [hud removeFromSuperview];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"处理中,请稍后";
        hud.dimBackground = YES;
        [hud show:YES];
        HadPublishModel * tempModel = dataArray[wantDown];
        NSString * str = tempModel.model_id;
        

        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountRevokePost" parameters:@{ACCOUNT_PASSWORD, @"id": str}];
        
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [dataArray removeObjectAtIndex:wantDown];
//                [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishibutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self urlRequestPost];
                //[AutoDismissAlert autoDismissAlert:@"撤销成功!"];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                [hud removeFromSuperview];
            }
        } andFailureBlock:^{
            [hud removeFromSuperview];
        }];
    }
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 145;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataArray.count;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
    //    detailAVC.idNumber = [dataArray[indexPath.row] model_id];
    //    detailAVC.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailAVC animated:YES];
}

- (void)tapToDetail:(UITapGestureRecognizer *)sender
{
    MyImgView *myImg = (MyImgView *)sender.view;
    SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
    HadPublishModel *model = dataArray[myImg.indexpath.row];
    detailAVC.idNumber = model.model_id;
    detailAVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailAVC animated:YES];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HadPublishCell * cell = [[HadPublishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.picIV.indexpath = indexPath;
    HadPublishModel * publishModel = dataArray[indexPath.row];
    
    [cell.picIV sd_setImageWithURL:[NSURL URLWithString:publishModel.cover]placeholderImage:[UIImage imageNamed:@"zanwu"]];
    cell.picIV.contentMode = UIViewContentModeScaleAspectFill;
    cell.picIV.clipsToBounds = YES;
    UITapGestureRecognizer *tapToDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDetail:)];
    [cell.picIV addGestureRecognizer:tapToDetail];
    
    if ([publishModel.dealType isEqualToString:@"1"]) {
        cell.priceLb.text = [NSString stringWithFormat:@"￥ %@", publishModel.bangPrice];
    }else {
        [cell.priceLb setHidden:YES];
    }
    
    cell.addLb.text = publishModel.model_position;
    
//    //时间间隔
//    NSTimeZone * zones = [NSTimeZone systemTimeZone];
    NSDateFormatter * comDateFormater = [[NSDateFormatter alloc]init];
    [comDateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * tempDate = [comDateFormater dateFromString:publishModel.endtime];
    [comDateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * dateStr = [comDateFormater stringFromDate:tempDate];
    cell.shengyuLabel.text = [NSString stringWithFormat:@"有效时间：%@",dateStr];
//
//    NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
//    [calendar setFirstWeekday:2];
//    NSDate * toDate = [NSDate date];
//    NSInteger interval = [zones secondsFromGMTForDate:toDate];
//    NSDate * newToDate = [toDate dateByAddingTimeInterval:interval];
//    
//    NSDate * fromDate = [comDateFormater dateFromString:publishModel.endtime];
//    NSInteger intervals = [zones secondsFromGMTForDate:fromDate];
//    NSDate * newFromDate = [fromDate dateByAddingTimeInterval:intervals];
//    
////    NSDate * date1 = [NSDate date];
////    NSDate * date2 = [comDateFormater dateFromString:publishModel.endtime];
//    
////    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&newFromDate interval:NULL forDate:newFromDate];
////    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&newToDate interval:NULL forDate:newToDate];
//    
//    NSDateComponents * dayComponents = [calendar components:NSDayCalendarUnit fromDate:newToDate toDate:newFromDate options:0];
//    
//    NSLog(@"--%lu",dayComponents.day);
    
    if ([publishModel.isStick isEqualToString:@"1"]) {
        cell.isStickImg.hidden = NO;
        cell.titleLb.text = [NSString stringWithFormat:@"         %@",publishModel.title];
    }else{
        cell.isStickImg.hidden = YES;
        cell.titleLb.text = publishModel.title;
    }
    
    
    
    //日期格式化
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:publishModel.updatetime];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString * str = [dateFormatter stringFromDate:date];
    cell.dateLb.text = [NSString stringWithFormat:@"%@",str];
    [cell.button addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchUpInside];
    [cell.button setTag:indexPath.row];
    cell.button.indexpath = indexPath;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)down:(id)sender
{
    publishibutton = sender;
    wantDown = (int)publishibutton.indexpath.row;
    HadPublishModel * tempModel = dataArray[wantDown];
    [actionsheet removeFromSuperview];
    NSString * isStickStr;
    if ([tempModel.isStick isEqualToString:@"1"]) {
        isStickStr = @"取消置顶";
    }else{
        isStickStr = @"置顶";
    }
    
    actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:isStickStr,@"刷新",@"撤回",nil];
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    
    tempIndexpath = publishibutton.indexpath;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self zhidingPost];
    }else if (buttonIndex == 1){
        [self shuaxinPost];
    }else if (buttonIndex == 2){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定撤回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)zhidingPost
{
    HadPublishModel * tempModel = dataArray[wantDown];
    NSString * isStick;
    if ([tempModel.isStick isEqualToString:@"1"]) {
        isStick = @"0";
    }else{
        isStick = @"1";
    }
    NSDictionary * dic = [self parametersForDic:@"accountStickPost" parameters:@{ACCOUNT_PASSWORD,@"id":tempModel.model_id, @"isStick":isStick}];
    MBProgressHUD * huds = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    huds.labelText = @"处理中,请稍后";
    huds.dimBackground = YES;
    [huds show:YES];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self urlRequestPost];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [huds hide:YES];
        [huds removeFromSuperview];
    } andFailureBlock:^{
        [huds hide:YES];
        [huds removeFromSuperview];
    }];
    
}

- (void)shuaxinPost
{
    MBProgressHUD * huds = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    huds.labelText = @"处理中,请稍后";
    huds.dimBackground = YES;
    [huds show:YES];
    HadPublishModel * tempModel = dataArray[wantDown];
    NSDictionary * dic = [self parametersForDic:@"accountPublishPost" parameters:@{ACCOUNT_PASSWORD,@"id":tempModel.model_id}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            
//            HadPublishModel * tempModel = dataArray[wantDown];
//            [self.tableView reloadRowsAtIndexPaths:@[tempIndexpath] withRowAnimation:UITableViewRowAnimationNone];
            HadPublishCell * tempCell = (HadPublishCell *)[self.tableView cellForRowAtIndexPath:tempIndexpath];
            __block CGRect doneRect = tempCell.doneLabel.frame;
            __block CGRect tempRect = tempCell.shengyuLabel.frame;
            doneRect.origin.y = 18;
            tempRect.origin.y = 0;
            
            NSDateFormatter * comDateFormater = [[NSDateFormatter alloc]init];
            [comDateFormater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate * tempDate = [comDateFormater dateFromString:[[dic objectForKey:@"data"] objectForKey:@"endtime"]];
            [comDateFormater setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSString * dateStr = [comDateFormater stringFromDate:tempDate];
            
            
            [UIView animateWithDuration:0.7 animations:^{
                tempCell.doneLabel.hidden = NO;
                tempCell.doneLabel.frame = doneRect;
                tempCell.shengyuLabel.frame = tempRect;
                tempCell.doneLabel.transform = CGAffineTransformMakeScale(1, 1);
                tempCell.shengyuLabel.transform = CGAffineTransformMakeScale(1, 0.1);
            } completion:^(BOOL finished) {
                tempCell.shengyuLabel.text = [NSString stringWithFormat:@"有效时间：%@",dateStr];
                tempCell.shengyuLabel.hidden = YES;
                doneRect.origin.y = 31;
                tempRect.origin.y = 13;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [UIView animateWithDuration:0.7 animations:^{
                        tempCell.doneLabel.transform = CGAffineTransformMakeScale(1, 0.1);
                        tempCell.shengyuLabel.hidden = NO;
                        tempCell.shengyuLabel.transform = CGAffineTransformMakeScale(1, 1);
                        tempCell.doneLabel.frame = doneRect;
                        tempCell.shengyuLabel.frame = tempRect;
                    } completion:^(BOOL finished) {
                        tempCell.doneLabel.hidden = YES;
                    }];
                });
            }];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [huds hide:YES];
        [huds removeFromSuperview];
    } andFailureBlock:^{
        [huds hide:YES];
        [huds removeFromSuperview];
    }];
    
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic;
    
    dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":_dealType,@"status":@"1", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                HadPublishModel * bussinessModel = [[HadPublishModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            nodataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            nodataView.hidden = NO;
        }else{
            nodataView.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [self.tableView reloadData];
        [hud removeFromSuperview];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        [hud removeFromSuperview];
        [dataArray removeAllObjects];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        nodataView.hidden = NO;
    }];
    
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
//    int tempCount = 0;
//    if (dataArray.count < 10) {
//        tempCount = (int)dataArray.count;
//    }else{
//        tempCount = NumOfItemsForZuji;
//    }
    page += NumOfItemsForZuji;
    NSDictionary * dic;
    dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":_dealType,@"status":@"1", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                HadPublishModel * bussinessModel = [[HadPublishModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            nodataView.hidden = YES;
            [temTableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            page -= NumOfItemsForZuji;
        }
        [temTableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [temTableView footerEndRefreshing];
    }];
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
