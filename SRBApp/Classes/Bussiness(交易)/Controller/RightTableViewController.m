//
//  RightTableViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "RightTableViewController.h"
#import "BrowsingHistoryModel.h"
#import "RightLookCell.h"
#import <UIButton+WebCache.h>
#import "DetailActivityViewController.h"

@interface RightTableViewController ()

@end

@implementation RightTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray  = [[NSMutableArray alloc]init];
    self.tableView.frame = CGRectMake(0, 0, 120, SCREEN_HEIGHT);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.tableHeaderView = [self section];

    [self urlRequest];
}

- (UIView *)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 70, 30)];
    label.text = @"浏览历史";
    label.font = SIZE_FOR_14;
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [view addSubview:label];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width , label.frame.origin.y, 30, 30)];
//    [button setImage:[UIImage imageNamed:@"dustbin.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(deleteObject:) forControlEvents:UIControlEventTouchUpInside];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2;
    [button setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [button setTitle:@"删 除" forState:UIControlStateNormal];
    [view addSubview:button];
    
    return view;
}

- (void)deleteObject:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定清空浏览历史?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self delAllHistory];
    }
}

- (void)delAllHistory
{
    NSDictionary * dic = [self parametersForDic:@"accountClearPostHistory" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [_dataArray removeAllObjects];
            [self.tableView reloadData];
            [AutoDismissAlert autoDismissAlert:@"删除成功"];
        }else{
            NSLog(@"%d",result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}



#pragma mark - post请求
- (void)urlRequest
{
    NSDictionary * dic = [self parametersForDic:@"getPostListByHistory" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":@"20"}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
        if (result == 0) {
            for (int i = 0; i< temparr.count; i++) {
                BrowsingHistoryModel * browsingHistroyModel = [[BrowsingHistoryModel alloc]init];
                NSDictionary * tempdic = temparr[i];
                [browsingHistroyModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:browsingHistroyModel];
            }
            [self.tableView reloadData];
            //            [tableview headerEndRefreshing];
        }else if(result == 4){
            [self.tableView reloadData];
            //            [tableview headerEndRefreshing];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailActivityViewController * vc = [[DetailActivityViewController alloc]init];
    vc.idNumber = [_dataArray[indexPath.row] ID];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RightLookCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[RightLookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell.button sd_setBackgroundImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.row] cover]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.button.contentMode = UIViewContentModeScaleAspectFill;
    cell.button.clipsToBounds = YES;
    cell.label.text = [_dataArray[indexPath.row] title];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@", [_dataArray[indexPath.row]originalPrice]];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu",(unsigned long)_dataArray.count);
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 153;
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
