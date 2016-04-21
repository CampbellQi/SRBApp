//
//  MyAssureOrdersViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyAssureOrdersViewController.h"
#import "MyAssureOrderCell.h"
#import "MyAssureOrderModel.h"
#import "BussinessModel.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "DetailActivityViewController.h"
#import "NoDataView.h"
#import "AppDelegate.h"
#import "OrderAssureTableViewCell.h"
#import "GoodsModel.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface MyAssureOrdersViewController ()

@end

@implementation MyAssureOrdersViewController
{
    NSMutableArray * dataArray;
    NSMutableArray * goodsArray;
    NoDataView * imageview;
    PublishButton * publishbutton;
    int wantdown;
    MBProgressHUD * hud;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    goodsArray = [NSMutableArray array];
    publishbutton = [[PublishButton alloc]init];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];

    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    imageview = [[NoDataView alloc]initWithFrame:self.tableView.frame];
    imageview.hidden = YES;
    [self.tableView addSubview:imageview];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:UIMenuControllerDidHideMenuNotification object:nil];
    
}

- (void)hidden
{
    NSArray * temparr = [self.tableView visibleCells];
    for (OrderAssureTableViewCell * tempCell in temparr) {
        tempCell.reasonContentLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BussinessModel * bussinessModel = dataArray[indexPath.row];
    CGRect rect = [bussinessModel.guaranteeNote boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
    if ([bussinessModel.statusName isEqualToString:@"完成"]) {
        return 125 + 22;
    }else{
        return 125 + 22 + rect.size.height + 60;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    OrderAssureTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[OrderAssureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    GoodsModel *goodsModel = [goodsArray objectAtIndex:indexPath.row];
    BussinessModel *bussinessModel = [dataArray objectAtIndex:indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:goodsModel.cover] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.imageV.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageV.clipsToBounds = YES;
    cell.imageV.indexpath = indexPath;
    UITapGestureRecognizer *tapToDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDetail:)];
    [cell.imageV addGestureRecognizer:tapToDetail];
    cell.titleLabel.text = goodsModel.title;
    cell.orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@",bussinessModel.orderNum];
    cell.priceLabel.text = [NSString stringWithFormat:@"赏金:￥ %@",bussinessModel.guaranteeAmount];
    cell.buyRemarkNLabel.text = bussinessModel.buyernick;
    cell.sellRemarkNLabel.text = bussinessModel.sellernick;
    cell.dateLabel.text = bussinessModel.guaranteeTime;
    cell.signLabelUp.text = bussinessModel.statusName;
    if (bussinessModel.guaranteeNote.length < 1) {
        cell.reasonContentLabel.text = @"无";
    }else{
        cell.reasonContentLabel.text = bussinessModel.guaranteeNote;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (![cell.signLabelUp.text isEqualToString:@"完成"]) {
        CGRect rect = [bussinessModel.guaranteeNote boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
        cell.signLabelDown.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, cell.imageV.frame.origin.y + cell.imageV.frame.size.height - 25, 60, 25);
        cell.reasonContentLabel.frame = CGRectMake(cell.assureLable.frame.origin.x, cell.assureLable.frame.origin.y + cell.assureLable.frame.size.height + 7, cell.assureReasonView.frame.size.width - 30, rect.size.height + 2);
        cell.assureReasonView.frame = CGRectMake(15, cell.sanjiaoImageV.frame.origin.y + cell.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 40 + rect.size.height);
//        cell.assurePrice.text = [NSString stringWithFormat:@"￥ %@",bussinessModel.guaranteeAmount];
        cell.sanjiaoImageV.hidden = NO;
        cell.assureLable.hidden = NO;
        cell.assurePrice.hidden = NO;
        cell.dateLabel.hidden = NO;
        cell.reasonContentLabel.hidden = NO;
        cell.assureReasonView.hidden = NO;
    }else{
        cell.sanjiaoImageV.hidden = YES;
        cell.assureReasonView.hidden = YES;

    }
    if ([cell.signLabelUp.text isEqualToString:@"订单取消"]) {
        [cell.signLabelDown setTitle:@"删 除" forState:UIControlStateNormal];
        cell.signLabelDown.hidden = NO;
        [cell.signLabelDown addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        cell.signLabelDown.tag = indexPath.row + 100;
        cell.signLabelDown.indexpath = indexPath;
        
    }else{
        cell.signLabelDown.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)action:(PublishButton *)sender
{
    UIAlertView *orderAlert = [[UIAlertView alloc] initWithTitle:@"确定删除订单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [orderAlert show];
    
    publishbutton = sender;
    wantdown = (int)publishbutton.tag;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"处理中,请稍后";
        hud.dimBackground = YES;
        [hud show:YES];
        NSString * str = [dataArray[wantdown - 100]orderId];
        [dataArray removeObjectAtIndex:wantdown - 100];
        [goodsArray removeObjectAtIndex:wantdown - 100];
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountSetGuaranteeOrderDelete" parameters:@{ACCOUNT_PASSWORD,@"orderId":str}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishbutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self urlRequestPost];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                [hud removeFromSuperview];
            }
        }];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    DetailActivityViewController * vc = [[DetailActivityViewController alloc]init];
//    vc.idNumber = [goodsArray[indexPath.row]Id];
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)tapToDetail:(UIGestureRecognizer *)sender
{
    MyImgView *myImg = (MyImgView *)sender.view;
    [self.tableView deselectRowAtIndexPath:myImg.indexpath animated:YES];
    DetailActivityViewController *detailAVC = [[DetailActivityViewController alloc] init];
    detailAVC.idNumber = [goodsArray[myImg.indexpath.row] Id];
    detailAVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailAVC animated:YES];
}

- (void)deleteList:(id)sender
{
    UIAlertView * alertViewdown = [[UIAlertView alloc] initWithTitle:@"是否删除订单?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertViewdown show];
    
    publishbutton = sender;
    wantdown = (int)publishbutton.tag;
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
    
    dic = [self parametersForDic:@"accountGetGuaranteeOrderList" parameters:@{ACCOUNT_PASSWORD, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        //        [dataArray removeAllObjects];
        [dataArray removeAllObjects];
        [goodsArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSArray *goodsArr;
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                NSLog(@"bussinessModel.guarantorname == %@",bussinessModel.guarantorname);
                
                goodsArr = [tempdic objectForKey:@"goods"];
                for (int i = 0; i < goodsArr.count; i ++) {
                    NSDictionary *goodsDic = [goodsArr objectAtIndex:i];
                    GoodsModel *goodsModel = [[GoodsModel alloc] init];
                    [goodsModel setValuesForKeysWithDictionary:goodsDic];
                    [goodsArray addObject:goodsModel];
                }
            }
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            imageview.hidden = NO;
        }
        page = 0;
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        [hud removeFromSuperview];
    } andFailureBlock:^{
        imageview.hidden = NO;
        page = 0;
        [dataArray removeAllObjects];
        [goodsArray removeAllObjects];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        [hud removeFromSuperview];
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic;
    
    dic = [self parametersForDic:@"accountGetGuaranteeOrderList" parameters:@{ACCOUNT_PASSWORD, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            imageview.hidden = YES;
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                NSArray *goodsArr;
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
                goodsArr = [tempdic objectForKey:@"goods"];
                for (int i = 0; i < goodsArr.count; i ++) {
                    NSDictionary *goodsDic = [goodsArr objectAtIndex:i];
                    GoodsModel *goodsModel = [[GoodsModel alloc] init];
                    [goodsModel setValuesForKeysWithDictionary:goodsDic];
                    [goodsArray addObject:goodsModel];
                }
            }
            [temTableView reloadData];
            imageview.hidden = YES;
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

@end
