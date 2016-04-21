//
//  GoodAssureViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GoodAssureViewController.h"
#import "PublishButton.h"
#import "WantAssureCell.h"
#import "GoodsAssureTableViewCell.h"
#import "BussinessModel.h"
#import "MJRefresh.h"
#import "NoDataView.h"
#import "AppDelegate.h"
#import "AccountGuaranteeViewController.h"
#import <UIImageView+WebCache.h>
#import "GuaranteeListModel.h"
#import "NoDataView.h"
#import "DetailActivityViewController.h"
#import "HelpViewController.h"
#import "WebHelpViewController.h"

static int page = 0;
@interface GoodAssureViewController ()
@property (nonatomic,assign) CGRect rect;
@end

@implementation GoodAssureViewController
{
    NSMutableArray * dataArray;
    UIView * imageview;
    
    PublishButton * publishbutton;
    int wantdown;
}

- (void)backBtn:(UIButton *)sender
{
    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = NO;
    [self.navigationController dismissViewController];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"担保挣钱";
    dataArray = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
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
    noticeLabel.text = @"还没有熟人发布宝贝。";
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(urlRequestPost) name:@"asd" object:nil];

}

- (void)seeHelpBtn
{
    HelpViewController * vc = [[HelpViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
    if ([bussinessModel.isGuarantee isEqualToString:@"0"]) {
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


- (void)tapToDetail:(UITapGestureRecognizer *)sender
{
    MyImgView *myImg = (MyImgView *)sender.view;
    DetailActivityViewController *detailAVC = [[DetailActivityViewController alloc] init];
    BussinessModel *model = dataArray[myImg.indexpath.row];
    detailAVC.idNumber = model.model_id;
    detailAVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailAVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsAssureTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[GoodsAssureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BussinessModel *bussinessModel = [dataArray objectAtIndex:indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.imageV.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageV.clipsToBounds = YES;
    cell.imageV.indexpath = indexPath;
    UITapGestureRecognizer *tapToDetail = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToDetail:)];
    [cell.imageV addGestureRecognizer:tapToDetail];
    cell.titleLabel.text = bussinessModel.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"赏金:￥ %@", bussinessModel.guaranteePrice];
    cell.reasonContentLabel.text = bussinessModel.guaranteeNote;
    cell.dateLabel.text = bussinessModel.guaranteeTime;
    cell.sellRemarkNLabel.text = [NSString stringWithFormat:@"%@", bussinessModel.nickname];
    if ([bussinessModel.isGuarantee isEqualToString:@"1"]) {
        [cell.signLabelDown setTitle:@"已担保" forState:UIControlStateNormal];
        [cell.signLabelDown setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        [cell.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_btn_graygray"] forState:UIControlStateNormal];
        CGRect rect = [bussinessModel.guaranteeNote boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
        cell.reasonContentLabel.frame = CGRectMake(cell.assureLable.frame.origin.x, cell.assureLable.frame.origin.y + cell.assureLable.frame.size.height + 7, cell.assureReasonView.frame.size.width - 30, rect.size.height);
        cell.assureReasonView.frame = CGRectMake(15, cell.sanjiaoImageV.frame.origin.y + cell.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 40 + rect.size.height);
        cell.signLabelDown.enabled = NO;
        cell.sanjiaoImageV.hidden = NO;
        cell.reasonContentLabel.hidden = NO;
        cell.assureLable.hidden = NO;
        cell.assureReasonView.hidden = NO;
        cell.dateLabel.hidden = NO;
        cell.assurePrice.hidden = NO;
    }else{
        [cell.signLabelDown setTitle:@"我要担保" forState:UIControlStateNormal];
        [cell.signLabelDown setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
        [cell.signLabelDown setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
        cell.signLabelDown.enabled = YES;
        cell.assureReasonView.hidden = YES;
        cell.sanjiaoImageV.hidden = YES;
    }
    
//    if ([[dataArray[indexPath.row]freeShipment] isEqualToString:@"1"]) {
////        cell.postLabel.text = @"包邮";
//    }
//    else
//    {
////        cell.postLabel.text = @"不包邮";
//    }
    [cell.signLabelDown addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    cell.signLabelDown.tag = indexPath.row + 100;
    return cell;
}

- (void)action:(id)sender
{
    UIButton * button = sender;
    if ([[dataArray[button.tag - 100]isGuarantee] isEqualToString:@"1"]) {
    }else{
        AccountGuaranteeViewController * vc = [[AccountGuaranteeViewController alloc]init];
        vc.account = [dataArray[button.tag - 100] account];
        vc.idNumber = [dataArray[button.tag - 100]model_id];
        vc.thetitle = [dataArray[button.tag - 100]title];
        vc.nickname = [dataArray[button.tag - 100]nickname];
        vc.bangPrice = [dataArray[button.tag - 100]bangPrice];
        vc.photoUrl = [[[dataArray[button.tag - 100] photos] componentsSeparatedByString:@","]firstObject];
        vc.guaranteePrice = [dataArray[button.tag - 100]guaranteePrice];
        vc.freeShipment = [dataArray[button.tag - 100]freeShipment];
        vc.postPrice = [dataArray[button.tag - 100]transportPrice];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        NSString * str = [dataArray[wantdown - 100]model_id];
        [dataArray removeObjectAtIndex:wantdown - 100];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishbutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountDeleteGuaranteePost" parameters:@{ACCOUNT_PASSWORD,@"id":str}];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                [self urlRequestPost];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                imageview.center = self.tableView.center;
            }
        } andFailureBlock:^{
            
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

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}
#pragma mark - 网络请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getGuaranteePostRecords" parameters:@{ACCOUNT_PASSWORD, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
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
    } andFailureBlock:^{
        page = 0;
        imageview.hidden = NO;
        [dataArray removeAllObjects];
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
    NSDictionary * dic = [self parametersForDic:@"getGuaranteePostRecords" parameters:@{ACCOUNT_PASSWORD, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];

    
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
            imageview.hidden = YES;
            [temTableView reloadData];
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
