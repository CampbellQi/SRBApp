//
//  SPDetailListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/12/18.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SPDetailListController.h"
#import "NSString+CalculateSize.h"
#import "CommonView.h"
#import "AppDelegate.h"

@interface SPDetailListController ()

@end

@implementation SPDetailListController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView headerBeginRefreshing];
    
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    
    self.title = @"求购单详情";
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
}
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 网络请求
-(void)loadNewDataListRequest {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"获取中,请稍后";
//    hud.dimBackground = YES;
//    [hud show:YES];
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"getPostDetail" parameters:@{ACCOUNT_PASSWORD, @"id": self.modelId}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        //[hud removeFromSuperview];
        _noDataView.hidden = YES;
        [self.tableView headerEndRefreshing];
        
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            BussinessModel *model = [[BussinessModel alloc] init];
            [model setValuesForKeysWithDictionary:dic[@"data"]];
            model.sayHeight = [model.say calculateSize:CGSizeMake(_propertyCell.memoLbl.frame.size.width + (SCREEN_WIDTH - 320), FLT_MAX) font:_propertyCell.memoLbl.font].height;
            [self.dataArray addObject:model];
            [self.tableView reloadData];
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
            _noDataView.hidden = NO;
            
        }
    } andFailureBlock:^{
        // [hud removeFromSuperview];
    }];
}
-(void)loadMoreDataListRequest {
    [self.tableView footerEndRefreshing];
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
