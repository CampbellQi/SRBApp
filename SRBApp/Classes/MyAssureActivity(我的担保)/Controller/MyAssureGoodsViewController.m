//
//  MyAssureGoodsViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyAssureGoodsViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface MyAssureGoodsViewController ()
@end

@implementation MyAssureGoodsViewController
{
    MBProgressHUD * hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.nodataView = [[NoDataView alloc]initWithFrame:self.tableView.frame];
    [self.view addSubview:self.nodataView];
    self.nodataView.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:UIMenuControllerDidHideMenuNotification object:nil];
    
}

- (void)hidden
{
    NSArray * temparr = [self.tableView visibleCells];
    for (GoodsAssureTableViewCell * tempCell in temparr) {
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
    CGRect rect = [bussinessModel.guarantorcontent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
    if ([bussinessModel.isGuarantee isEqualToString:@"1"]) {
        return 105;
    }else{
        return 105 + rect.size.height + 60;
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

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
//    detailAVC.idNumber = [dataArray[indexPath.row] model_id];
//    detailAVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailAVC animated:YES];
//}

- (void)tapToDetail:(UIGestureRecognizer *)sender
{
    MyImgView *myImg = (MyImgView *)sender.view;
    [self.tableView deselectRowAtIndexPath:myImg.indexpath animated:YES];
    SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
    detailAVC.idNumber = [dataArray[myImg.indexpath.row] model_id];
    detailAVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailAVC animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    MyAssureThingsCell * cell = [[MyAssureThingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    //    [cell.thingImv sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row] cover]]];
    //    cell.titleLb.text =[dataArray[indexPath.row] title];
    //
    //    cell.detailLb.text = [dataArray[indexPath.row] content];
    //    MyAssureThingModel * myAssureModel = dataArray[indexPath.row];
    //
    //    CGRect rect = [myAssureModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60 - 12 - 50 - 10, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
    //    cell.detailLb.frame = CGRectMake(cell.titleLb.frame.origin.x, cell.titleLb.frame.origin.y + cell.titleLb.frame.size.height + 3, cell.titleLb.frame.size.width, rect.size.height);
    //
    //    cell.deleteBtn.frame  = CGRectMake(SCREEN_WIDTH - 95, cell.detailLb.frame.origin.y + cell.detailLb.frame.size.height + 2, 80, 25);
    //
    //    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate * date = [dateFormatter dateFromString:[dataArray[indexPath.row] updatetime]];
    //    [dateFormatter setDateFormat:@"MM-dd"];
    //    NSString * str = [dateFormatter stringFromDate:date];
    //    cell.dateLb.text = str;
    //    [cell.deleteBtn addTarget:self action:@selector(deleteThing:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell.deleteBtn setTag:100 + indexPath.row];
    //    cell.deleteBtn.indexpath = indexPath;
    GoodsAssureTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[GoodsAssureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    BussinessModel *bussinessModel = [dataArray objectAtIndex:indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.imageV.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageV.clipsToBounds = YES;
    cell.imageV.indexpath = indexPath;
    UITapGestureRecognizer *tapToDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDetail:)];
    [cell.imageV addGestureRecognizer:tapToDetail];
    cell.titleLabel.text = bussinessModel.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"赏金:￥ %@" ,bussinessModel.guaranteePrice];
    cell.sellRemarkNLabel.text = [NSString stringWithFormat:@"%@", bussinessModel.nickname];
    //    if ([bussinessModel.isGuarantee isEqualToString:@"0"]) {
    [cell.signLabelDown setTitle:@"取消担保" forState:UIControlStateNormal];
    cell.signLabelDown.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    cell.dateLabel.text = bussinessModel.guarantortime;
    CGRect rect = [bussinessModel.guarantorcontent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_12} context:nil];
    cell.reasonContentLabel.frame = CGRectMake(cell.assureLable.frame.origin.x, cell.assureLable.frame.origin.y + cell.assureLable.frame.size.height + 7, cell.assureReasonView.frame.size.width - 30, rect.size.height);
    cell.reasonContentLabel.text = bussinessModel.guarantorcontent;
    cell.assureReasonView.frame = CGRectMake(15, cell.sanjiaoImageV.frame.origin.y + cell.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 40 + rect.size.height);
//    cell.assurePrice.text = [NSString stringWithFormat:@"￥ %@",bussinessModel.guaranteePrice];
    //        cell.signLabelDown.enabled = NO;
    cell.sanjiaoImageV.hidden = NO;
    cell.reasonContentLabel.hidden = NO;
    cell.assureLable.hidden = NO;
    cell.assureReasonView.hidden = NO;
    cell.dateLabel.hidden = NO;
    cell.assurePrice.hidden = NO;
    //    }
    //    if ([bussinessModel.isGuarantee isEqualToString:@"1"]) {
    //        [cell.signLabelDown setTitle:@"取消担保" forState:UIControlStateNormal];
    //        cell.signLabelDown.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    //    }
    //    if ([[dataArray[indexPath.row]freeShipment] isEqualToString:@"1"]) {
    ////        cell.postLabel.text = @"包邮";
    //    }
    //    else
    //    {
    ////        cell.postLabel.text = @"不包邮";
    //    }
    [cell.signLabelDown addTarget:self action:@selector(deleteThing:) forControlEvents:UIControlEventTouchUpInside];
    cell.signLabelDown.indexpath = indexPath;
    cell.signLabelDown.tag = indexPath.row + 100;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        NSString * str = [dataArray[wantdown - 100]model_id];
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"处理中,请稍后";
        hud.dimBackground = YES;
        [hud show:YES];
        [dataArray removeObjectAtIndex:wantdown - 100];

        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountDeleteGuaranteePost" parameters:@{ACCOUNT_PASSWORD,@"id":str}];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishbutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self urlRequestPost];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                [hud removeFromSuperview];
            }
        } andFailureBlock:^{
            [hud removeFromSuperview];
        }];
    }
}

- (void)deleteThing:(id)sender
{
    UIAlertView * alertViewdown = [[UIAlertView alloc] initWithTitle:@"是否放弃担保?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
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
    
    dic = [self parametersForDic:@"accountGetGuaranteeList" parameters:@{ACCOUNT_PASSWORD, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            self.nodataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            self.nodataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            self.nodataView.hidden = NO;
        }
        page = 0;
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
        [hud removeFromSuperview];
    } andFailureBlock:^{
        page = 0;
        [hud removeFromSuperview];
        [dataArray removeAllObjects];
        self.nodataView.hidden = NO;
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
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
    NSDictionary * dic  = [self parametersForDic:@"accountGetGuaranteeList" parameters:@{ACCOUNT_PASSWORD, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [temTableView reloadData];
            self.nodataView.hidden = YES;
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
@end
