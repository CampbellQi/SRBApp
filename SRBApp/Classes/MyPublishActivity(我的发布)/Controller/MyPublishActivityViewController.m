//
//  MyPublishActivityViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/23.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "MyPublishActivityViewController.h"
#import "MJRefresh.h"
#import "HadPublishCell.h"
#import "WaitPublishCell.h"
#import "NoDataView.h"
#import "HadPublishModel.h"
#import "WaitPublishModel.h"
#import "NotPublishModel.h"
#import "WaitPublishCell.h"
#import "NotPublishModel.h"
#import <UIImageView+WebCache.h>
#import "RealPosition.h"
#import "EndCell.h"
#import "ModifGoodsInfoViewController.h"
#import "SaleListViewController.h"

@interface MyPublishActivityViewController ()
{
    UIButton * hadPushBtn;
    UIButton * waitPushBtn;
    UIButton * notPushBtn;
    UIView * view1;
    UIView * view2;
    UIView * view3;
    UITableView * tableView1;
    UITableView * tableView2;
    UITableView * tableView3;
    NSMutableArray * arr1;
    NSMutableArray * arr2;
    NSMutableArray * arr3;
    int start1;
    int start2;
    int start3;
    NoDataView * imageview;
    int total1;
    int total2;
    int total3;
    
    int wantDown;
    UIAlertView * alertViewdown;
    UIAlertView * alertViewDelete;
    UIAlertView * alertViewDelete1;
    PublishButton * publishibutton;
}
@end

@implementation MyPublishActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.title = @"我的发布";
    arr1 = [[NSMutableArray alloc]init];
    arr2 = [[NSMutableArray alloc]init];
    arr3 = [[NSMutableArray alloc]init];
    
    start1 = 0;
    start2 = 0;
    start3 = 0;
    wantDown = 0;
    
//    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    regBtn.frame = CGRectMake(0, 15, 80, 35);
//    [regBtn setTitle:@"发布" forState:UIControlStateNormal];
//    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
//    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
//    regBtn.backgroundColor = WHITE;
//    regBtn.layer.cornerRadius = 4;
//    regBtn.layer.masksToBounds = YES;
//    [regBtn addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//    [theView.layer setShadowOffset:CGSizeMake(10, 10)];
//    [theView.layer setShadowColor:[[UIColor redColor] CGColor]];
//    [theView.layer setShadowOpacity:0.7];
//    [theView.layer setBorderColor:[[UIColor blackColor] CGColor]];
//    [theView.layer setBorderWidth:2.0f];
    theView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self.view addSubview:theView];
    
    hadPushBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 38)];
    [hadPushBtn setTitle:@"已发布" forState:UIControlStateNormal];
    hadPushBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [hadPushBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [hadPushBtn addTarget:self action:@selector(hadPushAction) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:hadPushBtn];
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(hadPushBtn.frame.origin.x, hadPushBtn.frame.origin.y + hadPushBtn.frame.size.height, hadPushBtn.frame.size.width, 2)];
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    [theView addSubview:view1];
    
    waitPushBtn = [[UIButton alloc]initWithFrame:CGRectMake(hadPushBtn.frame.origin.x + hadPushBtn.frame.size.width, 0, SCREEN_WIDTH / 3, 38)];
    [waitPushBtn setTitle:@"未发布" forState:UIControlStateNormal];
    [waitPushBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    waitPushBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [waitPushBtn addTarget:self action:@selector(waitPushAction) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:waitPushBtn];
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(waitPushBtn.frame.origin.x, waitPushBtn.frame.origin.y + waitPushBtn.frame.size.height, waitPushBtn.frame.size.width, 2)];
    view2.backgroundColor = [UIColor clearColor];
    [theView addSubview:view2];
    
    notPushBtn = [[UIButton alloc]initWithFrame:CGRectMake(waitPushBtn.frame.origin.x + waitPushBtn.frame.size.width, 0, SCREEN_WIDTH / 3, 38)];
    [notPushBtn setTitle:@"未通过" forState:UIControlStateNormal];
    notPushBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [notPushBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [notPushBtn addTarget:self action:@selector(noPushAction) forControlEvents:UIControlEventTouchUpInside];
    [theView addSubview:notPushBtn];
    
    view3 = [[UIView alloc]initWithFrame:CGRectMake(notPushBtn.frame.origin.x, notPushBtn.frame.origin.y + notPushBtn.frame.size.height, notPushBtn.frame.size.width, 2)];
    view3.backgroundColor = [UIColor clearColor];
    [theView addSubview:view3];
    
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, theView.frame.origin.y + theView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) style:UITableViewStylePlain];
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView1.backgroundColor = [UIColor whiteColor];
    tableView1.tableFooterView = [[UIView alloc]init];
    tableView1.tableFooterView = [[UIView alloc]init];
    tableView1.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self.view addSubview:tableView1];
    
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, tableView1.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 64) style:UITableViewStylePlain];
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView2.backgroundColor = [UIColor whiteColor];
    tableView2.tableFooterView = [[UIView alloc]init];
    tableView2.tableFooterView = [[UIView alloc]init];
    tableView2.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self.view addSubview:tableView2];
    
    tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, tableView1.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40) style:UITableViewStylePlain];
    tableView3.delegate = self;
    tableView3.dataSource = self;
    tableView3.backgroundColor = [UIColor whiteColor];
    tableView3.tableFooterView = [[UIView alloc]init];
    tableView3.tableFooterView = [[UIView alloc]init];
    tableView3.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    [self.view addSubview:tableView3];
    
    imageview = [[NoDataView alloc]initWithFrame:tableView2.frame];
    //    imageview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:imageview];
    
    [self setupRefresh1];
    [self setupRefresh2];
    [self setupRefresh3];
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)regController:(id)sender
{
    SaleListViewController * vc = [[SaleListViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)hadPushAction
{
    tableView1.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 64);
    tableView2.center= CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT - tableView1.frame.size.height / 2);
    tableView3.center= CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT - tableView1.frame.size.height / 2);
    view1.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    view2.backgroundColor = [UIColor clearColor];
    view3.backgroundColor = [UIColor clearColor];
    [hadPushBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [waitPushBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [notPushBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [self setupRefresh1];
    imageview.center = tableView2.center;
}

- (void)waitPushAction
{
    tableView1.center= CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT - tableView1.frame.size.height / 2);
    tableView2.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 64);
    tableView3.center= CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT - tableView1.frame.size.height / 2);
    view2.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    view1.backgroundColor = [UIColor clearColor];
    view3.backgroundColor = [UIColor clearColor];
    [waitPushBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [hadPushBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [notPushBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [self setupRefresh2];
    imageview.center = tableView1.center;
}

- (void)noPushAction
{
    tableView1.center= CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT - tableView1.frame.size.height / 2);
    tableView2.center= CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT - tableView1.frame.size.height / 2);
    tableView3.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT - 40 - 64);
    view3.backgroundColor = [UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1];
    view1.backgroundColor = [UIColor clearColor];
    view2.backgroundColor = [UIColor clearColor];
    [notPushBtn setTitleColor:[UIColor colorWithRed:0.9 green:0.02 blue:0.43 alpha:1] forState:UIControlStateNormal];
    [waitPushBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [hadPushBtn setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
    [self setupRefresh3];
    imageview.center = tableView2.center;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == tableView1) {
        return arr1.count;
    }
    if (tableView == tableView2) {
        return arr2.count;
    }
    if (tableView == tableView3) {
        return arr3.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView1) {
        HadPublishCell * cell = [[HadPublishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.picIV sd_setImageWithURL:[NSURL URLWithString:[arr1[indexPath.row] cover]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
        cell.picIV.contentMode = UIViewContentModeScaleAspectFill;
        cell.picIV.clipsToBounds = YES;
        cell.titleLb.text = [arr1[indexPath.row]title];
        cell.priceLb.text = [NSString stringWithFormat:@"￥ %@", [arr1[indexPath.row] originalPrice]];
        cell.addLb.text = [arr1[indexPath.row] cityName];
        //日期格式化
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [dateFormatter dateFromString:[arr1[indexPath.row] updatetime]];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * str = [dateFormatter stringFromDate:date];
        cell.dateLb.text = [NSString stringWithFormat:@"%@",str];
        [cell.button addTarget:self action:@selector(down:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button setTag:indexPath.row];
        cell.button.indexpath = indexPath;
        return cell;
    }
    if (tableView == tableView2) {
        WaitPublishCell * cell = [[WaitPublishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.picIV sd_setImageWithURL:[NSURL URLWithString:[arr2[indexPath.row] cover]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
        cell.picIV.contentMode = UIViewContentModeScaleAspectFill;
        cell.picIV.clipsToBounds = YES;
        cell.titleLb.text = [arr2[indexPath.row]title];
        cell.priceLb.text = [NSString stringWithFormat:@"￥ %@", [arr2[indexPath.row] originalPrice]];
        cell.addLb.text = [arr2[indexPath.row] cityName];
        //日期格式化
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [dateFormatter dateFromString:[arr2[indexPath.row] updatetime]];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * str = [dateFormatter stringFromDate:date];
        cell.dateLb.text = [NSString stringWithFormat:@"%@",str];;
        [cell.button addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        cell.button.indexpath = indexPath;
        return cell;
    }
    if (tableView == tableView3) {
        WaitPublishCell * cell = [[WaitPublishCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.picIV sd_setImageWithURL:[NSURL URLWithString:[arr3[indexPath.row] cover]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
        cell.picIV.contentMode = UIViewContentModeScaleAspectFill;
        cell.picIV.clipsToBounds = YES;
        cell.titleLb.text = [arr3[indexPath.row]title];
        cell.priceLb.text = [NSString stringWithFormat:@"￥ %@", [arr3[indexPath.row] originalPrice]];
        cell.addLb.text = [arr3[indexPath.row] cityName];
        //日期格式化
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate * date = [dateFormatter dateFromString:[arr3[indexPath.row] updatetime]];
        [dateFormatter setDateFormat:@"MM-dd"];
        NSString * str = [dateFormatter stringFromDate:date];
        cell.dateLb.text = [NSString stringWithFormat:@"%@",str];;
        [cell.button addTarget:self action:@selector(delete1:) forControlEvents:UIControlEventTouchUpInside];
        cell.button.indexpath = indexPath;
        return cell;
    }
    return nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == alertViewdown) {
        if (buttonIndex == 1) {
            //拼接post参数
            NSDictionary * dic = [self parametersForDic:@"accountRevokePost" parameters:@{ACCOUNT_PASSWORD, @"id": [arr1[wantDown] model_id]}];
            
            //发送post请求
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                NSLog(@"%@",[dic objectForKey:@"message"]);
                int result = [[dic objectForKey:@"result"]intValue];
                if (result == 0) {
                    [arr1 removeObjectAtIndex:wantDown];
                    [tableView1 deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishibutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [AutoDismissAlert autoDismissAlert:@"撤回成功!"];
                }else{
                    NSLog(@"%d", result);
                    NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
                    [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                }
            }];
        }
    }
    if (alertView == alertViewDelete) {
        if (buttonIndex == 1) {
            //拼接post参数
            NSDictionary * dic = [self parametersForDic:@"accountDeletePost" parameters:@{ACCOUNT_PASSWORD, @"id": [arr2[wantDown] model_id]}];
            //发送post请求
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                NSLog(@"%@",[dic objectForKey:@"message"]);
                int result = [[dic objectForKey:@"result"]intValue];
                if (result == 0) {
                    [arr2 removeObjectAtIndex:wantDown];
                    [tableView2 deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishibutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [AutoDismissAlert autoDismissAlert:@"删除成功!"];
                }else{
                    NSLog(@"%d", result);
                    NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
                    [AutoDismissAlert autoDismissAlert:@"删除失败,请检查网络连接!"];
                }
            }];
        }
    }
    if (alertView == alertViewDelete1) {
        if (buttonIndex == 1) {
            //拼接post参数
            NSDictionary * dic = [self parametersForDic:@"accountDeletePost" parameters:@{ACCOUNT_PASSWORD, @"id": [arr3[wantDown] model_id]}];
            //发送post请求
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                NSLog(@"%@",[dic objectForKey:@"message"]);
                int result = [[dic objectForKey:@"result"]intValue];
                if (result == 0) {
                    [arr3 removeObjectAtIndex:wantDown];
                    [tableView3 deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishibutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [AutoDismissAlert autoDismissAlert:@"删除成功!"];
                }else{
                    NSLog(@"%d", result);
                    NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
                    [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                }
            }];
        }
    }

    
}

- (void)down:(id)sender
{
    alertViewdown = [[UIAlertView alloc] initWithTitle:@"是否要撤回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertViewdown show];
    
    publishibutton = sender;
    wantDown = (int)publishibutton.tag;
}

- (void)delete:(id)sender
{
    alertViewDelete = [[UIAlertView alloc] initWithTitle:@"是否要撤回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertViewDelete show];
    publishibutton = sender;
    wantDown = (int)publishibutton.tag;
    
}

- (void)delete1:(id)sender
{
    alertViewDelete1 = [[UIAlertView alloc] initWithTitle:@"是否要撤回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertViewDelete1 show];
    publishibutton = sender;
    wantDown = (int)publishibutton.tag;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableView1) {
        return 90;
    }
    if (tableView == tableView2) {
        return 90;
    }
    if (tableView == tableView3 ) {
        return 90;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

//post请求
- (void)post1
{
    NSString * start = [NSString stringWithFormat:@"%d", start1];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":@"0",@"status":@"1", @"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            total1 = [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue];
            for (NSDictionary * dic1 in arr) {
                HadPublishModel * model = [[HadPublishModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [arr1 addObject:model];
                if (arr1.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [arr1 removeLastObject];
                    break;
                }
            }
            [tableView1 reloadData];
            imageview.center = CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT);
            start1 += 10;
            
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
//            [AutoDismissAlert autoDismissAlert:@"请求失败"];
            imageview.center = tableView1.center;
        }
    }];
}

//post请求
- (void)post2
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":@"0",@"status":@"0", @"start":@"0", @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        total2 = [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue];
        
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary * dic1 in arr) {
                WaitPublishModel * model = [[WaitPublishModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [arr2 addObject:model];
                if (arr2.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [arr2 removeLastObject];
                    break;
                }
            }
            [tableView2 reloadData];
            imageview.center = CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT);
            start2 += 10;
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
//            [AutoDismissAlert autoDismissAlert:@"请求失败"];
            imageview.center = tableView2.center;
        }
    }];
}

//post请求
- (void)post3
{
    NSString * start = [NSString stringWithFormat:@"%d", start3];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":ACCOUNT_SELF, @"type":@"0", @"dealType":@"0",@"status":@"-1", @"start":start, @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        total3 = [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue];
        
        if (result == 0) {
            NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary * dic1 in arr) {
                NotPublishModel * model = [[NotPublishModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [arr3 addObject:model];
                if (arr3.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [arr3 removeLastObject];
                    break;
                }
            }
            [tableView3 reloadData];
            imageview.center = CGPointMake(SCREEN_WIDTH * 1.5, SCREEN_HEIGHT);
            start3 += 10;
        }else{
            NSLog(@"%d", result);
            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
//            [AutoDismissAlert autoDismissAlert:@"请求失败"];
            imageview.center = tableView3.center;
        }
    }];
}

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

#pragma mark -
#pragma mark 刷新
- (void)setupRefresh1
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView1 addHeaderWithTarget:self action:@selector(headerRereshing1)];
    [tableView1 headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView1 addFooterWithTarget:self action:@selector(footerRereshing1)];
    [tableView1 footerEndRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView1.headerPullToRefreshText = @"下拉可以刷新了";
    tableView1.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView1.headerRefreshingText = @"正在刷新中";
    
    tableView1.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableView1.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableView1.footerRefreshingText = @"加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing1
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (arr1.count == 0) {
            [self post1];
        } else
        {
            [tableView1 reloadData];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView1 headerEndRefreshing];
    });
    
}

- (void)footerRereshing1
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        [self post1];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView1 footerEndRefreshing];
    });
}

- (void)setupRefresh2
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView2 addHeaderWithTarget:self action:@selector(headerRereshing2)];
    [tableView2 headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView2 addFooterWithTarget:self action:@selector(footerRereshing2)];
    [tableView2 footerEndRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView2.headerPullToRefreshText = @"下拉可以刷新了";
    tableView2.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView2.headerRefreshingText = @"正在刷新中";
    
    tableView2.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableView2.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableView2.footerRefreshingText = @"加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing2
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (arr2.count == 0) {
            [self post2];
        } else
        {
            [tableView2 reloadData];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView2 headerEndRefreshing];
    });
    
}

- (void)footerRereshing2
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        [self post2];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView2 footerEndRefreshing];
    });
}

- (void)setupRefresh3
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [tableView3 addHeaderWithTarget:self action:@selector(headerRereshing3)];
    [tableView3 headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [tableView3 addFooterWithTarget:self action:@selector(footerRereshing3)];
    [tableView3 footerEndRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    tableView3.headerPullToRefreshText = @"下拉可以刷新了";
    tableView3.headerReleaseToRefreshText = @"松开马上刷新了";
    tableView3.headerRefreshingText = @"正在刷新中";
    
    tableView3.footerPullToRefreshText = @"上拉可以加载更多数据了";
    tableView3.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    tableView3.footerRefreshingText = @"加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing3
{
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        if (arr3.count == 0) {
            [self post3];
        } else
        {
            [tableView3 reloadData];
        }
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView3 headerEndRefreshing];
    });
    
}

- (void)footerRereshing3
{
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        
        [self post3];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [tableView3 footerEndRefreshing];
    });
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
