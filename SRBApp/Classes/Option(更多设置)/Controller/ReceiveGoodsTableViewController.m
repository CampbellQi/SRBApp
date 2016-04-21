//
//  ReceiveGoodsTableViewController.m
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ReceiveGoodsTableViewController.h"
#import "BuildNewReceiveViewController.h"
#import "ReceiveGoodsTableViewCell.h"
#import "ModifiReceiverViewController.h"
#import "GetColor16.h"

#import "AutoDismissAlert.h"
#import "SGActionView.h"
#import "MJRefresh.h"

@interface ReceiveGoodsTableViewController ()
{
    NoDataView * nodata;
    MBProgressHUD * hud;
}

@property (nonatomic, strong) NSString *iD;         //城市id
@property (nonatomic, strong) NSString *isdefault;  //判断是否是默认地址

@end

@implementation ReceiveGoodsTableViewController

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    self.receiveAddrArray = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.tableFooterView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.navigationItem.title = @"收货地址";
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 110/2, 50/2);
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = CGRectGetHeight(rightBtn.frame) * 0.5;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"新 建" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#ffffff"]];
    [rightBtn addTarget:self action:@selector(toBuildNewReceiveAddr:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    nodata = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    CGRect tempRect = nodata.imageV.frame;
    tempRect.size.width = 90;
    nodata.imageV.frame = tempRect;
    nodata.imageV.image = [UIImage imageNamed:@"empty_add"];
    nodata.hidden = YES;
    [self.view addSubview:nodata];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self netWorkRequest];
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self netWorkRequest];
    });
}

- (void)netWorkRequest
{
    __block NSMutableArray *temArray = self.receiveAddrArray;
    NSDictionary * loginParam = @{@"method":@"accountGetAddressList",@"parameters":@{ACCOUNT_PASSWORD}};
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [temArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSArray *array = [dataDic objectForKey:@"list"];
            for (NSDictionary *receDic in array) {
                ReceiveModel *receiveModel = [[ReceiveModel alloc] init];
                [receiveModel setValuesForKeysWithDictionary:receDic];
                [temArray addObject:receiveModel];
            }
            
            nodata.hidden = YES;
        }else{
            nodata.hidden = NO;
            if (![result isEqualToString:@"4"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        [hud removeFromSuperview];
    } andFailureBlock:^{
        [temArray removeAllObjects];
        [hud removeFromSuperview];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

//长按手势
//- (void)modifiOrDelete:(UILongPressGestureRecognizer *)sender{
//    
//    //sheet
//    [SGActionView showSheetWithTitle:@"温馨提示" itemTitles:@[@"修改",@"删除"] itemSubTitles:nil selectedIndex:0 selectedHandle:^(NSInteger index) {
//        if (index == 0) {
//            ReceiveModel *model = [self.receiveAddrArray objectAtIndex:sender.view.tag];
//            
//            ModifiReceiverViewController *modifiRVC = [[ModifiReceiverViewController alloc] init];
//            modifiRVC.receiver = model.receiver;
//            modifiRVC.phone = model.mobile;
//            modifiRVC.address = model.address;
//            modifiRVC.iD = model.iD;
//            [self.navigationController pushViewController:modifiRVC animated:YES];
//            [[SGActionView sharedActionView] removeFromSuperview];
//        }
//        if (index == 1) {
//            ReceiveModel *model = [self.receiveAddrArray objectAtIndex:sender.view.tag];
//
//            NSDictionary * loginParam = @{@"method":@"accountDeleteAddress",@"parameters":@{@"account":[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],@"password":[[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"],@"id":[NSString stringWithFormat:@"%d",model.iD.intValue]}};
//            [URLRequest postRequestWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }];
//            [[SGActionView sharedActionView] removeFromSuperview];
//            [self netWorkRequest];
//        }
//    }];
//
//}

- (void)toBuildNewReceiveAddr:(UIButton *)sender
{
    BuildNewReceiveViewController *buildNewRVC = [[BuildNewReceiveViewController alloc] init];
    [self.navigationController pushViewController:buildNewRVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.receiveAddrArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *receiveCell = @"reuseIdentifier";
    ReceiveGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:receiveCell];
    if (!cell) {
        cell = [[ReceiveGoodsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:receiveCell];
        
    }
//    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(modifiOrDelete:)];
//    [cell addGestureRecognizer:longPressGR];
    //设置tag值
    cell.tag = indexPath.row;
    ReceiveModel *receiveModel = [self.receiveAddrArray objectAtIndex:indexPath.row];
    
    cell.receivePeople.text = receiveModel.receiver;
    cell.mobile.text = receiveModel.mobile;
    cell.receiveAddress.text = receiveModel.address;
    cell.indexpath = indexPath;
    if ([receiveModel.isdefault isEqualToString:@"1"]) {
        cell.backgroundColor = [GetColor16 hexStringToColor:@"#909eb3"];
        cell.receivePeople.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        cell.mobile.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        cell.receiveAddress.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        cell.receivePeopleLB.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        cell.phoneLB.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
        cell.receiveAddrLB.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    }else{
        cell.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        cell.receivePeople.textColor = [GetColor16 hexStringToColor:@"#434343"];
        cell.mobile.textColor = [GetColor16 hexStringToColor:@"#434343"];
        cell.receiveAddress.textColor = [GetColor16 hexStringToColor:@"#434343"];
        cell.receivePeopleLB.textColor = [GetColor16 hexStringToColor:@"#434343"];
        cell.phoneLB.textColor = [GetColor16 hexStringToColor:@"#434343"];
        cell.receiveAddrLB.textColor = [GetColor16 hexStringToColor:@"#434343"];
    }
//    NSLog(@"cell.receivePeople.text == %@",cell.receivePeople.text);
    //编辑
    cell.editBlock = ^(NSIndexPath *editIndexPath) {
        BuildNewReceiveViewController *vc = [[BuildNewReceiveViewController alloc] init];
        vc.sourceModel = [self.receiveAddrArray objectAtIndex:editIndexPath.row];
        vc.navTitle = @"修改地址";
        vc.backBlock = ^(void){
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ReceiveModel *model = [self.receiveAddrArray objectAtIndex:indexPath.row];
    
    ModifiReceiverViewController *modifiRVC = [[ModifiReceiverViewController alloc] init];
    modifiRVC.receiver = model.receiver;
    modifiRVC.phone = model.mobile;
    modifiRVC.address = model.address;
    modifiRVC.iD = model.iD;
    modifiRVC.isdefault =  model.isdefault;
    [self.navigationController pushViewController:modifiRVC animated:YES];

}


// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        hud.labelText = @"处理中,请稍后";
//        hud.dimBackground = YES;
//        [hud show:YES];
//        ReceiveModel *model = [self.receiveAddrArray objectAtIndex:indexPath.row];
//        NSDictionary * loginParam = @{@"method":@"accountDeleteAddress",@"parameters":@{ACCOUNT_PASSWORD,@"id":[NSString stringWithFormat:@"%d",model.iD.intValue]}};
//        [URLRequest postRequestssWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
//            NSString * result = [dic objectForKey:@"result"];
//            if ([result isEqualToString:@"0"]) {
//                [self netWorkRequest];
//                [self.receiveAddrArray removeObjectAtIndex:indexPath.row];
//                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }else{
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//                [hud removeFromSuperview];
//            }
//        } andFailureBlock:^{
//            [hud removeFromSuperview];
//        }];
//        
//        
////        [self.tableView reloadData];
//
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
