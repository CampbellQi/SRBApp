//
//  BussinessViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "BussinessViewController.h"
#import "BuyCell.h"
#import "SellCell.h"
#import "BussinessModel.h"
#import "MJRefresh.h"
#import <UIImageView+WebCache.h>
#import "DetailActivityViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "ZZNavigationController.h"

@interface BussinessViewController ()
{
    UIButton * giveAndNeedBt;
    UIButton * relationBt;
    
    UIView * view1;
    UIView * view2;
    
    UITableView * _tableView;
    
    NSMutableArray * array;
    
    int starta;
    
    int v11;
    int v12;
    
    int v21;
    int v22;
    int v23;
    
    int time1;
    int time2;
}
@property (nonatomic, strong)UIButton * relationbt;
@property (nonatomic, strong)UIButton * circlebt;
@property (nonatomic, strong)UIButton * allbt;
@property (nonatomic, strong)UIButton * buybt;
@property (nonatomic, strong)UIButton * sellbt;
@end

@implementation BussinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"交易";
    //self.delegate = self;
    array = [NSMutableArray array];
    
    v11 = 1;
    v12 = 0;
    v21 = 1;
    v22 = 0;
    v23 = 0;
    
    time1 = 0;
    time2 = 0;
    

    
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    theView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    theView.layer.masksToBounds = NO;
    theView.layer.cornerRadius = 2;
    theView.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
    theView.layer.shadowOffset = CGSizeMake(2, 2);
    theView.layer.shadowOpacity = 0.3;
    theView.layer.shadowRadius = 2;
    [self.view addSubview:theView];
    
    giveAndNeedBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 2, 40)];
    [giveAndNeedBt setTitle:@"圈子" forState:UIControlStateNormal];
    giveAndNeedBt.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    giveAndNeedBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [giveAndNeedBt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [giveAndNeedBt addTarget:self action:@selector(giveandneed) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:giveAndNeedBt];
    
    
    
    relationBt = [[UIButton alloc]initWithFrame:CGRectMake(giveAndNeedBt.frame.origin.x + giveAndNeedBt.frame.size.width, 0, SCREEN_WIDTH / 2, 38)];
    [relationBt setTitle:@"供需" forState:UIControlStateNormal];
    relationBt.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    [relationBt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    relationBt.titleLabel.font = [UIFont systemFontOfSize:15];
    [relationBt addTarget:self action:@selector(relation) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:relationBt];
    
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, theView.frame.origin.y + theView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 64 - 49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, -60, 100, 60)];
    view1.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    view1.alpha = 0.9;
    [self.view addSubview:view1];
    
    _relationbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_relationbt setTitle:@"熟人圈" forState:UIControlStateNormal];
    _relationbt.titleLabel.font = [UIFont systemFontOfSize:15];
    [_relationbt addTarget:self action:@selector(relationAction:) forControlEvents:UIControlEventTouchUpInside];
    [_relationbt setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [view1 addSubview:_relationbt];
    
    UIView * breakLb1 = [[UIView alloc]initWithFrame:CGRectMake(0, _relationbt.frame.origin.y + _relationbt.frame.size.height, 100, 1)];
    breakLb1.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
    [view1 addSubview:breakLb1];

    _circlebt = [[UIButton alloc]initWithFrame:CGRectMake(0, breakLb1.frame.origin.y + breakLb1.frame.size.height , 100, 30)];
    _circlebt.titleLabel.font = [UIFont systemFontOfSize:15];
    [_circlebt addTarget:self action:@selector(circleAction:) forControlEvents:UIControlEventTouchUpInside];
    [_circlebt setTitle:@"关系圈" forState:UIControlStateNormal];
    [_circlebt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [view1 addSubview:_circlebt];
    
    
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, -90, 100, 90)];
    view2.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    view2.alpha = 0.9;
    [self.view addSubview:view2];
    
    _allbt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    [_allbt setTitle:@"全部" forState:UIControlStateNormal];
    _allbt.titleLabel.font = [UIFont systemFontOfSize:15];
    [_allbt addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
    [_allbt setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [view2 addSubview:_allbt];
    
    UIView * breakLb2 = [[UIView alloc]initWithFrame:CGRectMake(0, _allbt.frame.origin.y + _allbt.frame.size.height, 100, 1)];
    breakLb2.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
    [view2 addSubview:breakLb2];
    
    _buybt = [[UIButton alloc]initWithFrame:CGRectMake(0, breakLb2.frame.origin.y + breakLb2.frame.size.height , 100, 30)];
    [_buybt setTitle:@"我要买" forState:UIControlStateNormal];
    [_buybt addTarget:self action:@selector(buyAction:) forControlEvents:UIControlEventTouchUpInside];
    _buybt.titleLabel.font = [UIFont systemFontOfSize:15];
    [_buybt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [view2 addSubview:_buybt];
    
    UIView * breakLb3 = [[UIView alloc]initWithFrame:CGRectMake(0, _buybt.frame.origin.y + _buybt.frame.size.height, 100, 1)];
    breakLb3.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
    [view2 addSubview:breakLb3];
    
    _sellbt = [[UIButton alloc]initWithFrame:CGRectMake(0, breakLb3.frame.origin.y + breakLb3.frame.size.height , 100, 30)];
    [_sellbt setTitle:@"我要卖" forState:UIControlStateNormal];
    [_sellbt addTarget:self action:@selector(sellAction:) forControlEvents:UIControlEventTouchUpInside];
    _sellbt.titleLabel.font = [UIFont systemFontOfSize:15];
    [_sellbt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [view2 addSubview:_sellbt];
    
    [self setupRefresh1];
    
}


- (void)relationAction:(id)sender
{
    v11 = 1;
    v12 = 0;
    view1.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    view2.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    [_relationbt setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [_circlebt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [array removeAllObjects];
    time1 = 0;
    time2 = 0;
    starta = 0;
    [self setupRefresh1];
}

- (void)circleAction:(id)sender
{
    v12 = 1;
    v11 = 0;
    view1.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    view2.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    [_relationbt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [_circlebt setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [array removeAllObjects];
    time1 = 0;
    time2 = 0;
    starta = 0;
    [self setupRefresh1];
}

- (void)allAction:(id)sender
{
    v21 = 1;
    v22 = 0;
    v23 = 0;
    view1.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    view2.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    [_allbt setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [_buybt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [_sellbt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [array removeAllObjects];
    time1 = 0;
    time2 = 0;
    starta = 0;
    [self setupRefresh1];
    
}
- (void)buyAction:(id)sender
{
    v21 = 0;
    v22 = 1;
    v23 = 0;
    view1.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    view2.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    [_buybt setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [_allbt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [_sellbt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [array removeAllObjects];
    time1 = 0;
    time2 = 0;
    starta = 0;
    [self setupRefresh1];
}

- (void)sellAction:(id)sender
{
    v21 = 0;
    v22 = 0;
    v23 = 1;
    view1.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    view2.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 90);
    [_sellbt setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [_buybt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [_allbt setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [array removeAllObjects];
    time1 = 0;
    time2 = 0;
    starta = 0;
    [self setupRefresh1];
}

- (void)giveandneed
{
    if (time1 == 0) {
        view1.frame = CGRectMake(giveAndNeedBt.center.x - 50, 40, 100, 60);
        view2.frame = CGRectMake(SCREEN_WIDTH, -90, 100, 90);
        time1 = 1;
        time2 = 0;
    }else{
        view1.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 60);
        view2.frame = CGRectMake(SCREEN_WIDTH, -90, 100, 90);
        time1 = 0;
        time2 = 0;
    }
}

- (void)relation
{
    if (time2 == 0) {
        view1.frame = CGRectMake(SCREEN_WIDTH, -90, 100, 90);
        view2.frame = CGRectMake(relationBt.center.x - 50, 40, 100, 90);
        time2 = 1;
        time1 = 0;
    }else{
        view1.frame = CGRectMake(SCREEN_WIDTH, 0, 100, 60);
        view2.frame = CGRectMake(SCREEN_WIDTH, -90, 100, 90);
        time2 = 0;
        time1 = 0;
    }
}

- (void)post
{

    NSString * start = [NSString stringWithFormat:@"%d", starta];
    if (v11 == 1 && v21 == 1) {
    //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"dealType":@"0", @"start":start, @"count":@"20"
      }];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (NSDictionary * dic1 in arr) {
                    BussinessModel * model = [[BussinessModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [array addObject:model];
                    if (array.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                        [array removeLastObject];
                        break;
                    }
                    [_tableView reloadData];
                    starta += 10;
                }
            }
            else  if(result == 4){
                [_tableView reloadData];
                [_tableView headerEndRefreshing];
            }
            else {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }andFailureBlock:^{
            
        }];
    }
    if (v11 == 1 && v22 == 1) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"dealType":@"2", @"start":start, @"count":@"20"
                                                                                          }];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (NSDictionary * dic1 in arr) {
                    BussinessModel * model = [[BussinessModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [array addObject:model];
                    if (array.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                        [array removeLastObject];
                        break;
                    }
                    [_tableView reloadData];
                    starta += 10;
                }
            }
            else  if(result == 4){
                [_tableView reloadData];
                [_tableView headerEndRefreshing];
            }
            else {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }andFailureBlock:^{
            
        }];
    }
    if (v11 == 1 && v23 == 1) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"getPostListByRelation" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"dealType":@"1", @"start":start, @"count":@"20"
                                                                                          }];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (NSDictionary * dic1 in arr) {
                    BussinessModel * model = [[BussinessModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [array addObject:model];
                    if (array.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                        [array removeLastObject];
                        break;
                    }
                    [_tableView reloadData];
                    starta += 10;
                }
            }
            else  if(result == 4){
                [_tableView reloadData];
                [_tableView headerEndRefreshing];
            }
            else {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }andFailureBlock:^{
            
        }];
    }
    if (v12 == 1 && v21 == 1) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"dealType":@"0", @"start":start, @"count":@"20"
                                                                                          }];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (NSDictionary * dic1 in arr) {
                    BussinessModel * model = [[BussinessModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [array addObject:model];
                    if (array.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                        [array removeLastObject];
                        break;
                    }
                    [_tableView reloadData];
                    starta += 10;
                }
            }
            else  if(result == 4){
                [_tableView reloadData];
                [_tableView headerEndRefreshing];
            }
            else {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }andFailureBlock:^{
            
        }];
    }
    if (v12 == 1 && v22 == 1) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"dealType":@"2", @"start":start, @"count":@"20"
                                                                                          }];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (NSDictionary * dic1 in arr) {
                    BussinessModel * model = [[BussinessModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [array addObject:model];
                    if (array.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                        [array removeLastObject];
                        break;
                    }
                    [_tableView reloadData];
                    starta += 10;
                }
            }
            else  if(result == 4){
                [_tableView reloadData];
                [_tableView headerEndRefreshing];
            }
            else {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }andFailureBlock:^{
            
        }];
    }
    if (v12 == 1 && v23 == 1) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"getPostListByCircle" parameters:@{ACCOUNT_PASSWORD, @"type":@"0",@"dealType":@"1", @"start":start, @"count":@"20"
                                                                                          }];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
                for (NSDictionary * dic1 in arr) {
                    BussinessModel * model = [[BussinessModel alloc]init];
                    [model setValuesForKeysWithDictionary:dic1];
                    [array addObject:model];
                    if (array.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                        [array removeLastObject];
                        break;
                    }
                    [_tableView reloadData];
                    starta += 10;
                }
            }
            else  if(result == 4){
                [_tableView reloadData];
                [_tableView headerEndRefreshing];
            }
            else {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }andFailureBlock:^{
            
        }];
    }
}

- (void)setupRefresh1
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing1)];
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing1)];
    [_tableView footerEndRefreshing];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing1
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (array.count == 0) {
            [self post];
        } else
        {
            [_tableView reloadData];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
    
}

- (void)footerRereshing1
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        [self post];

        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
    });
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AppDelegate * ddMenu = ((AppDelegate *)[[UIApplication sharedApplication]delegate]);
    DetailActivityViewController * vc = [[DetailActivityViewController alloc]init];
    vc.idNumber = [array[indexPath.row] model_id];
//    vc.hidesBottomBarWhenPushed = YES;
    ZZNavigationController * nac = [[ZZNavigationController alloc]initWithRootViewController:vc];
    ddMenu.window.rootViewController = nac;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (v21 == 1) {
        if ([[array[indexPath.row] dealName] isEqualToString:@"想买"]) {
            BuyCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[array[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
            cell.titleLabel.text = [array[indexPath.row] title];
            cell.detailLabel.text = [array[indexPath.row] model_description];
            cell.signImage.image = [UIImage imageNamed:@"BUYtag.png"];
            cell.nameLabel.text = [NSString stringWithFormat:@"买家:%@", [array[indexPath.row]nickname]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
        SellCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[SellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[array[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
        cell.titleLabel.text = [array[indexPath.row] title];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[array[indexPath.row] bangPrice]];
        cell.signImage.image = [UIImage imageNamed:@"SALEtag.png"];
        cell.nameLabel.text = [NSString stringWithFormat:@"卖家:%@", [array[indexPath.row]nickname]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([[array[indexPath.row]freeShipment] isEqualToString:@"1"]) {
            cell.postLabel.text = @"包邮";
        }
        else
        {
            cell.postLabel.text = @"不包邮";
        }
        return cell;
    }
    if (v22 == 1) {
        BuyCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[array[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
        cell.titleLabel.text = [array[indexPath.row] title];
        cell.detailLabel.text = [array[indexPath.row] model_description];
        cell.signImage.image = [UIImage imageNamed:@"买tag.png"];
        cell.nameLabel.text = [NSString stringWithFormat:@"买家:%@", [array[indexPath.row]nickname]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    if (v23 == 1) {
        SellCell * cell = [_tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (!cell) {
            cell = [[SellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        }
        [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[array[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
        cell.titleLabel.text = [array[indexPath.row] title];
        cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[array[indexPath.row] bangPrice]];
        cell.signImage.image = [UIImage imageNamed:@"卖tag.png"];
        cell.nameLabel.text = [NSString stringWithFormat:@"卖家:%@", [array[indexPath.row]nickname]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if ([[array[indexPath.row]freeShipment] isEqualToString:@"1"]) {
            cell.postLabel.text = @"包邮";
        }
        else
        {
            cell.postLabel.text = @"不包邮";
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
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
