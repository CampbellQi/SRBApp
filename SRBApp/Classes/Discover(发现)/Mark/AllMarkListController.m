//
//  AllMarkListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/6.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "AllMarkListController.h"
#import "CommonView.h"

@interface AllMarkListController ()

@end

@implementation AllMarkListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"全部标签";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    [self loadAllTagsListRequest];
}
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 网络请求
- (void)loadAllTagsListRequest
{
    NSDictionary * param = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"10", @"categoryID": @"-1"}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            self.dataArray = temparrs;
            self.noDataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.dataArray = [NSArray new];
            self.noDataView.hidden = NO;
            //[AutoDismissAlert autoDismissAlertSecond:@"没有搜索到相关数据"];
        }else{
            self.noDataView.hidden = NO;
        }
        [self.tableView reloadData];
        
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
