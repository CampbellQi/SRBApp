//
//  OrderAssureViewController.m
//  SRBApp
//
//  Created by zxk on 15/3/27.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "OrderAssureViewController.h"
#import "PublishButton.h"
#import "WantAssureCell.h"
#import "BussinessModel.h"
#import "GoodsModel.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "AppDelegate.h"
#import "OrderGuaeanteeViewController.h"
#import <UIImageView+WebCache.h>
#import "GuaranteeListModel.h"
#import "NoDataView.h"
#import "SecondSubclassDetailViewController.h"
#import "OrderAssureTableViewCell.h"
#import "HelpViewController.h"
#import "WebHelpViewController.h"

static int page = 0;
@interface OrderAssureViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) CGRect rect;
@end

@implementation OrderAssureViewController
{
    NSMutableArray * dataArray;
    NSMutableArray *goodsArray;
    UIView * imageview;
    
    PublishButton * publishbutton;
    int wantdown;
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInit
{
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    dataArray = [NSMutableArray array];
    goodsArray = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    imageview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 30)];
    imageview.hidden = YES;
    [self.tableView addSubview:imageview];
    
    UIImageView * renImg = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 240) / 2, 75, 60, 100)];
    renImg.image = [UIImage imageNamed:@"xiaoren"];
    [imageview addSubview:renImg];
    
    UIImageView * noticeImg = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(renImg.frame) + 10, 75, 170, 70)];
    noticeImg.image = [UIImage imageNamed:@"WantToAssure_empty_notice"];
    noticeImg.userInteractionEnabled = YES;
    [imageview addSubview:noticeImg];
    
    UILabel * noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 18, 150, 30)];
    noticeLabel.numberOfLines = 0;
    noticeLabel.font = [UIFont systemFontOfSize:13];
    //noticeLabel.textAlignment = NSTextAlignmentCenter;
    noticeLabel.text = @"还没有熟人下订单。";
    noticeLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [noticeLabel sizeToFit];
    [noticeImg addSubview:noticeLabel];
    
    UIButton * seeHelpBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [seeHelpBtn setTitle:@"查看更多帮助>>" forState:UIControlStateNormal];
    seeHelpBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [seeHelpBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [seeHelpBtn addTarget:self action:@selector(seeHelpBtn) forControlEvents:UIControlEventTouchUpInside];
    seeHelpBtn.frame = CGRectMake(25, 38, 95, 16);
    [noticeImg addSubview:seeHelpBtn];
}

- (void)seeHelpBtn
{
    HelpViewController * vc = [[HelpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"抢单挣钱";
    [self customInit];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BussinessModel * bussinessModel = dataArray[indexPath.row];
    CGRect rect = [bussinessModel.guaranteeNote boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
    if ([bussinessModel.guarantorname isEqualToString:@""] || !bussinessModel.guarantorname || bussinessModel.guarantorname.length == 0) {
        return 125 + 22;
    }else if(bussinessModel.guarantorname.length != 0 && ![bussinessModel.guarantorname isEqualToString:@""] && ![bussinessModel.guarantorname isEqualToString:ACCOUNT_SELF]){
        return 125 + 22;
    }else{
        return 125 + 22 + rect.size.height + 50;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"dataArray.count = %lu",(unsigned long)dataArray.count);
    return dataArray.count;
}
- (void)tapToDetail:(UITapGestureRecognizer *)sender
{
    MyImgView *myImg = (MyImgView *)sender.view;
    SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
    GoodsModel *model = goodsArray[myImg.indexpath.row];
    detailAVC.idNumber = model.Id;
    //detailAVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailAVC animated:YES];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    cell.reasonContentLabel.text = bussinessModel.guaranteeNote;
    NSString *guarantorname = bussinessModel.guarantorname;
    if (!guarantorname || [guarantorname isEqualToString:@""] || guarantorname.length == 0 ) {
        [cell.signLabelDown setTitle:@"我要担保" forState:UIControlStateNormal];
        [cell.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [cell.signLabelDown setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        cell.signLabelDown.enabled = YES;
        cell.sanjiaoImageV.hidden = YES;
        cell.assureReasonView.hidden = YES;
    }
    if (guarantorname.length != 0  && ![guarantorname isEqualToString:ACCOUNT_SELF]) {
        [cell.signLabelDown setTitleColor:[GetColor16 hexStringToColor:@"#959595"] forState:UIControlStateNormal];
        [cell.signLabelDown setTitle:@"已被抢了" forState:UIControlStateNormal];
        [cell.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_btn_gray"] forState:UIControlStateNormal];
        cell.signLabelDown.enabled = NO;
        cell.sanjiaoImageV.hidden = YES;
        cell.assureReasonView.hidden = YES;
    }
    if (guarantorname.length != 0 && [guarantorname isEqualToString:ACCOUNT_SELF]) {
        [cell.signLabelDown setTitle:@"担保成功" forState:UIControlStateNormal];
        [cell.signLabelDown setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        [cell.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_btn_graygray"] forState:UIControlStateNormal];
        CGRect rect = [bussinessModel.guaranteeNote boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: SIZE_FOR_12} context:nil];
        cell.reasonContentLabel.frame = CGRectMake(cell.assureLable.frame.origin.x, cell.assureLable.frame.origin.y + cell.assureLable.frame.size.height + 7, cell.assureReasonView.frame.size.width - 30, rect.size.height);
        cell.assureReasonView.frame = CGRectMake(15, cell.sanjiaoImageV.frame.origin.y + cell.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 40 + rect.size.height);
        //        cell.assurePrice.text = [NSString stringWithFormat:@"￥ %@",bussinessModel.guaranteeAmount];
        cell.signLabelDown.enabled = NO;
        cell.sanjiaoImageV.hidden = NO;
        cell.reasonContentLabel.hidden = NO;
        cell.assureLable.hidden = NO;
        cell.assureReasonView.hidden = NO;
        cell.dateLabel.hidden = NO;
        cell.assurePrice.hidden = NO;
    }
    
    [cell.signLabelDown addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    cell.signLabelDown.tag = indexPath.row + 100;
    return cell;
}

- (void)action:(id)sender
{
    UIButton * button = sender;
    if ([[dataArray[button.tag - 100]isGuarantee] isEqualToString:@"1"]) {
    }else{
        OrderGuaeanteeViewController * vc = [[OrderGuaeanteeViewController alloc]init];
        vc.idNumber = [dataArray[button.tag - 100]orderId];
        vc.thetitle = [goodsArray[button.tag - 100]title];
        vc.sellernick = [dataArray[button.tag - 100]sellernick];
        vc.buyernick = [dataArray[button.tag - 100]buyernick];
        vc.bangPrice = [dataArray[button.tag - 100]orderAmount];
        vc.photoUrl = [goodsArray[button.tag - 100]cover];
        vc.guaranteePrice = [dataArray[button.tag - 100]guaranteeAmount];
        vc.freeShipment = [dataArray[button.tag - 100]freeShipment];
        vc.orderAssureVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        NSString * str = [dataArray[wantdown - 100]model_id];
        [dataArray removeObjectAtIndex:wantdown - 100];
        [goodsArray removeObjectAtIndex:wantdown - 100];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishbutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"getGuaranteeOrderRecords" parameters:@{ACCOUNT_PASSWORD,@"id":str}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                [self urlRequestPost];
                [AutoDismissAlert autoDismissAlert:@"取消成功"];
            }else{
                [AutoDismissAlert autoDismissAlert:@"请求失败"];
                imageview.center = self.tableView.center;
            }
        }];
    }
}

- (void)deleteThing:(id)sender
{
    UIAlertView * alertViewdown = [[UIAlertView alloc] initWithTitle:@"是否取消担保?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertViewdown show];
    
    publishbutton = sender;
    wantdown = (int)publishbutton.tag;
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getGuaranteeOrderRecords" parameters:@{ACCOUNT_PASSWORD, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            [goodsArray removeAllObjects];
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
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            imageview.hidden = YES;
        }else if(result == 4){
            [dataArray removeAllObjects];
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            imageview.hidden = NO;
        }else{
            imageview.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView headerEndRefreshing];
        }
        page = 0;
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
    NSDictionary * dic = [self parametersForDic:@"getGuaranteeOrderRecords" parameters:@{ACCOUNT_PASSWORD, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSArray *goodsArr;
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
                goodsArr = [tempdic objectForKey:@"goods"];
                for (int i = 0; i < goodsArr.count; i ++) {
                    NSDictionary *goodsDic = [goodsArr objectAtIndex:i];
                    GoodsModel *goodsModel = [[GoodsModel alloc] init];
                    [goodsModel setValuesForKeysWithDictionary:goodsDic];
                    [goodsArray addObject:goodsModel];
                    NSLog(@"goodsModel.bangPrice == %@",goodsModel.bangPrice);
                }
            }
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
            
        }else if(result == 4){
            page -= NumOfItemsForZuji;
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView footerEndRefreshing];
        }
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
