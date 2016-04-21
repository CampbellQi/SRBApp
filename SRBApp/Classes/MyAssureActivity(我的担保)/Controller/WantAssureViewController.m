//
//  WantAssureViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WantAssureViewController.h"
#import "AccountGuaranteeViewController.h"
#import "WantAssureCell.h"
#import <UIImageView+WebCache.h>
#import "BussinessModel.h"
#import "GuaranteeListModel.h"
#import "NoDataView.h"
#import "MJRefresh.h"
#import "DetailActivityViewController.h"
static int page = 0;
@interface WantAssureViewController ()
{
    NSMutableArray * dataArray;
    NoDataView * noData;
}
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation WantAssureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.title = @"担保赚钱";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65) style:UITableViewStylePlain];
    _tableView.delegate =self;
    _tableView.dataSource =self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    [self urlRequestPost];
}

- (void)backBtn:(id)sender
{
    [self.navigationController dismissViewController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailActivityViewController * myAssureVC = [[DetailActivityViewController alloc]init];
    myAssureVC.idNumber = [dataArray[indexPath.row] model_id];
    [self.navigationController pushViewController:myAssureVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WantAssureCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[WantAssureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
    cell.thingimage.clipsToBounds = YES;
    cell.titleLabel.text = [dataArray[indexPath.row] title];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[dataArray[indexPath.row] bangPrice]];
    cell.signImage.image = [UIImage imageNamed:@"SALEtag.png"];
    cell.nameLabel.text = [NSString stringWithFormat:@"卖家:%@", [dataArray[indexPath.row]nickname]];
    if ([[dataArray[indexPath.row]freeShipment] isEqualToString:@"1"]) {
        cell.postLabel.text = @"包邮";
    }
    else
    {
        cell.postLabel.text = @"不包邮";
    }
    [cell.danbaoButton addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    cell.danbaoButton.tag = indexPath.row + 100;
    return cell;
}

- (void)action:(id)sender
{
    UIButton * button = sender;
    if ([[dataArray[button.tag - 100]isGuarantee] isEqualToString:@"1"]) {
    }else{
        AccountGuaranteeViewController * vc = [[AccountGuaranteeViewController alloc]init];
        vc.idNumber = [dataArray[button.tag - 100]model_id];
        vc.thetitle = [dataArray[button.tag - 100]title];
        vc.nickname = [dataArray[button.tag - 100]nickname];
        vc.bangPrice = [dataArray[button.tag - 100]bangPrice];
        vc.photoUrl = [[[dataArray[button.tag - 100] photos] componentsSeparatedByString:@","]firstObject];
        vc.postPrice = [dataArray[button.tag - 100] transportPrice];
        [self.navigationController pushViewController:vc animated:YES];
    }
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
    NSDictionary * dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD,@"dealType":@"1", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"type": @"0"}];
    
//    __block UITableView *TA = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            [_tableView reloadData];
        }else if(result == 4){
            [_tableView reloadData];
            noData.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [_tableView headerEndRefreshing];
    }];
}


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
    
    dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD,@"dealType":@"1", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"type": @"0"}];
    
//    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
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
            [_tableView reloadData];
            [_tableView footerEndRefreshing];
            
        }else if(result == 4){
            page -= NumOfItemsForZuji;
            [_tableView reloadData];
            [_tableView footerEndRefreshing];
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [_tableView footerEndRefreshing];
        }
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
