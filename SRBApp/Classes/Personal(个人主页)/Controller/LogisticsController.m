//
//  LogisticsController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/26.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define HEADER_HEIGHT 173
#import "LogisticsController.h"
#import "LogisticsCell.h"
#import "LogisticsHeaderView.h"
#import "CommonView.h"
#import "NSString+CalculateSize.h"
#import "LogisticsModel.h"

@interface LogisticsController ()
{
    NSMutableArray *_dataArray;
    LogisticsHeaderView *_headerView;
    LogisticsCell *_propertyCell;
}
@end

@implementation LogisticsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"查看物流";
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    UINib *nib = [UINib nibWithNibName:@"LogisticsCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"LogisticsCell"];
    _propertyCell = [self.tableView dequeueReusableCellWithIdentifier:@"LogisticsCell"];
    
    LogisticsHeaderView *headerView = [[LogisticsHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    self.tableView.tableHeaderView = headerView;
    _headerView = headerView;
    
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
    
    [self loadLogisticsRequest];
}
#pragma mark- 页面
-(void)fillHeaderView:(NSDictionary *)dataDict {
    NSString *company = dataDict[@"company"] ? dataDict[@"company"] : @"";
    _headerView.companyLbl.text = [NSString stringWithFormat:@"承运来源：%@", company];
    NSString *code = dataDict[@"no"] ? dataDict[@"no"] : @"";
    _headerView.codeLbl.text = [NSString stringWithFormat:@"订单编号：%@", code];
    [_headerView.coverIV sd_setImageWithURL:[NSURL URLWithString:self.coverUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
}
#pragma mark- 事件
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogisticsCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_dataArray && _dataArray.count) {
       
            LogisticsModel *model = _dataArray[indexPath.row];
            cell.contentLbl.text = model.remark;
            cell.timeLbl.text = model.datetime;
        if (indexPath.row == 0) {
            cell.contentLbl.textColor = MAINCOLOR;
            cell.timeLbl.textColor = MAINCOLOR;
            [cell.circleBtn setImage:[UIImage imageNamed:@"logistics_sel"] forState:UIControlStateNormal];
        }
    
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogisticsModel *model = _dataArray[indexPath.row];
    return _propertyCell.height - _propertyCell.contentLbl.height + model.remarkHeight;
}

#pragma mark- 网络请求
//获取物流信息
-(void)loadLogisticsRequest {
    if (_invoiceName == nil || _invoiceNo == nil) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"刷新中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"getExpressState" parameters:@{ACCOUNT_PASSWORD, @"name": self.invoiceName, @"number": self.invoiceNo}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        [hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray *tmpArray = dic[@"data"][@"list"];
            if (tmpArray && tmpArray.count) {
                [self fillHeaderView:dic[@"data"]];
                _headerView.noLogisticsIV.hidden = YES;
                
                for (NSDictionary *tmpDic in dic[@"data"][@"list"]) {
                    LogisticsModel *model = [[LogisticsModel alloc] init];
                    [model setValuesForKeysWithDictionary:tmpDic];
                    model.remarkHeight = [model.remark calculateSize:CGSizeMake(CGRectGetWidth(_propertyCell.contentLbl.frame), 1000) font:_propertyCell.contentLbl.font].height;
                    [_dataArray addObject:model];
                }
                
                _dataArray = [NSMutableArray arrayWithArray:[[_dataArray reverseObjectEnumerator] allObjects]];
            }else {
                _headerView.noLogisticsIV.hidden = NO;
            }
            
            [self.tableView reloadData];
        }else{
            _headerView.noLogisticsIV.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
        }
    } andFailureBlock:^{
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
