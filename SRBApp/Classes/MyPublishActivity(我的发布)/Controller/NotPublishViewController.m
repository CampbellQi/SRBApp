//
//  NotPublishViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NotPublishViewController.h"
#import "ChangeSaleViewController.h"
#import "ChangeBuyViewController.h"
#import "MyImgView.h"
#import "SubOfChangeSaleViewController.h"
#import "SubOfChangeBuyViewController.h"
#import "FreeSaleViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface NotPublishViewController ()<UIActionSheetDelegate>
{
    NoDataView * nodataView;
    MBProgressHUD * hud;
    NSIndexPath * tempIndexpath;
    UIActionSheet * actionsheet;
}
@end

@implementation NotPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    nodataView.hidden = YES;
    [self.tableView addSubview:nodataView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改",@"删除", nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"asd" object:nil];
}


- (void)refresh
{
    [self headerRefresh];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-  (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"处理中,请稍后";
        hud.dimBackground = YES;
        [hud show:YES];
        NSString * str = [dataArray[wantDown] model_id];
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountDeletePost" parameters:@{ACCOUNT_PASSWORD, @"id": str}];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [dataArray removeObjectAtIndex:wantDown];
//                [self.tableView deleteRowsAtIndexPaths:@[tempIndexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self urlRequestPost];
                //                [AutoDismissAlert autoDismissAlert:@"删除成功!"];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                [hud removeFromSuperview];
            }
        } andFailureBlock:^{
            [hud removeFromSuperview];
        }];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WaitPublishCell * cell = [[WaitPublishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    cell.picIV.indexpath = indexPath;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //    UITapGestureRecognizer *tapToDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDetail:)];
    //    [cell.picIV addGestureRecognizer:tapToDetail];
    
    [cell.picIV sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row] cover]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
    cell.picIV.contentMode = UIViewContentModeScaleAspectFill;
    cell.picIV.clipsToBounds = YES;
    cell.titleLb.text = [dataArray[indexPath.row]title];
    if ([[dataArray[indexPath.row] dealType] isEqualToString:@"1"]) {
        cell.priceLb.text = [NSString stringWithFormat:@"￥ %@", [dataArray[indexPath.row] bangPrice] ];
    }else {
        [cell.priceLb setHidden:YES];
    }
    DetailModel * mod = dataArray[indexPath.row];
    cell.addLb.text = mod.position;
    //日期格式化
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [dateFormatter dateFromString:[dataArray[indexPath.row] updatetime]];
    [dateFormatter setDateFormat:@"MM-dd"];
    NSString * str = [dateFormatter stringFromDate:date];
    cell.dateLb.text = [NSString stringWithFormat:@"%@",str];;
    [cell.button addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.button.indexpath = indexPath;
    cell.button.tag = indexPath.row;
    return cell;
    
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    WaitPublishModel *model = dataArray[indexPath.row];
//    if ([model.dealType isEqualToString:@"1"]) {
//        ChangeSaleViewController * vc = [[ChangeSaleViewController alloc]init];
//        vc.model = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else {
//        ChangeBuyViewController * vc = [[ChangeBuyViewController alloc]init];
//        vc.model = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//
//}

//- (void)tapToDetail:(UITapGestureRecognizer *)sender
//{
//    MyImgView *myImg = (MyImgView *)sender.view;
//    WaitPublishModel *model = dataArray[myImg.indexpath.row];
//
//    if ([model.bangPrice floatValue] > 0) {
//        ChangeSaleViewController * vc = [[ChangeSaleViewController alloc]init];
//        vc.model = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else {
//        ChangeBuyViewController * vc = [[ChangeBuyViewController alloc]init];
//        vc.model = model;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//
//}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        DetailModel *model = dataArray[tempIndexpath.row];
//        if ([model.bangPrice floatValue] > 0) {
//            SubOfChangeSaleViewController * vc = [[SubOfChangeSaleViewController alloc]init];
//            vc.model = model;
//            [self.navigationController pushViewController:vc animated:YES];
//        }else {
//            SubOfChangeBuyViewController * vc = [[SubOfChangeBuyViewController alloc]init];
//            vc.model = model;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        if ([model.bangPrice floatValue] > 0) {
            SubOfChangeSaleViewController * vc = [[SubOfChangeSaleViewController alloc]init];
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            
            if ([model.dealType isEqualToString: @"2"]){
                
                SubOfChangeBuyViewController * vc = [[SubOfChangeBuyViewController alloc]init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                FreeSaleViewController * vc = [[FreeSaleViewController alloc]init];
                vc.model = model;
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }
    }else if (buttonIndex == 1){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)down:(PublishButton *)sender
{
    
    [actionsheet showInView:[UIApplication sharedApplication].keyWindow];
    
    publishibutton = sender;
    tempIndexpath = sender.indexpath;
    
    wantDown = (int)tempIndexpath.row;
}



#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic;
    NSString * dealType = [super dealType];
    
    dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":dealType,@"status":@"0", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableView;
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                DetailModel * bussinessModel = [[DetailModel alloc]init];
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
        [hud removeFromSuperview];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        [hud removeFromSuperview];
        nodataView.hidden = NO;
        [dataArray removeAllObjects];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
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
    NSString * dealType = [super dealType];
    dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":dealType,@"status":@"0", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                DetailModel * bussinessModel = [[DetailModel alloc]init];
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
