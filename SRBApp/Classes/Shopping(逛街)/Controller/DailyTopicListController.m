//
//  DailyTopicListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//


#define Service_Type 1
#define Users_Type 2

#import "DailyTopicListController.h"
#import "AppDelegate.h"


@interface DailyTopicListController ()
{
    int _type;
}
@end

@implementation DailyTopicListController
-(id)initWithService {
    if (self = [super init]) {
        _type = Service_Type;
    }
    return self;
}
-(id)initWithUsers {
    if (self = [super init]) {
        _type = Users_Type;
    }
    return self;
}
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
    self.title = @"每日话题";

    //左导航
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    // Do any additional setup after loading the view from its nib.
    [self.tableView headerBeginRefreshing];
}
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- 网络请求
//最新话题列表
- (void)loadNewDataListRequest
{
    page = 0;
    NSString *categoryID = @"250";
    if (_type == Users_Type) {
        categoryID = @"251";
    }
    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":categoryID, @"order": @"postid", @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
            }
            
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
    
}
//更多话题列表
- (void)loadMoreDataListRequest
{
    page += NumOfItemsForZuji;
    NSString *categoryID = @"250";
    if (_type == Users_Type) {
        categoryID = @"251";
    }
    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":categoryID, @"order": @"postid", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
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
