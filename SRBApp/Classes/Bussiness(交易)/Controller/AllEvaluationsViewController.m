//
//  AllEvaluationsViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/4/30.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "AllEvaluationsViewController.h"
#import "ShaiXuanEvaluateViewController.h"
#import "NoDataView.h"
#import "BussinessModel.h"
#import "AllEvaluationsCell.h"
#import "MJRefresh.h"
#import "SubViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface AllEvaluationsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIView * topView;
    BOOL * isOK;
    UITableView * tableview;
    NoDataView * noData;
    BOOL isBack;
}
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong)NSMutableArray * personDataArray;
@end

@implementation AllEvaluationsViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self urlRequestPost];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    _signOfEvaluation = @"";
    _dataArray = [[NSMutableArray alloc]init];
    _personDataArray = [[NSMutableArray alloc]init];
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 90, 18)];
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 75, 18)];
    _titleLabel.text = @"全部评价";
    _titleLabel.textColor = [GetColor16 hexStringToColor:@"#ffffff"];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    
    _imgview = [[UIImageView alloc]initWithFrame:CGRectMake(_titleLabel.frame.size.width + _titleLabel.frame.origin.x, 7, 15, 7)];
    _imgview.image = [UIImage imageNamed:@"xiala"];
    [topView addSubview:_titleLabel];
    [topView addSubview:_imgview];
    UITapGestureRecognizer * commentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showComment:)];
    [topView addGestureRecognizer:commentTap];
    
    self.navigationItem.titleView = topView;
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.backgroundColor = [UIColor clearColor];
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableview];
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    noData.hidden = YES;
    [tableview addSubview:noData];
    
    [self urlRequestPost];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableview cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AllEvaluationsCell * cell = [[AllEvaluationsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    //    CGSize boundSize = CGSizeMake(216, CGFLOAT_MAX);
    //    cell.sayLabel.text = [dataArray[indexPath.row] content];
    //    cell.sayLabel.numberOfLines = 0;
    //    CGSize requiredSize = [cell.sayLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:boundSize lineBreakMode:0];
    
    cell.headImage.indexpath = indexPath;
    UITapGestureRecognizer *tapToPersonal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPersonal:)];
    [cell.headImage addGestureRecognizer:tapToPersonal];
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[_personDataArray[indexPath.row] avatar]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.headImage.clipsToBounds = YES;
    cell.titleLabel.text =[_personDataArray[indexPath.row] title];
    
    [cell setIntroductionText:[_dataArray[indexPath.row] content]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    BussinessModel * modfl = _dataArray[indexPath.row];
    double i = modfl.updatetimeLong;
    cell.dateLabel.text = [CompareCurrentTime compareCurrentTime:i];
    
    return cell;
}

- (void)tapToPersonal:(UITapGestureRecognizer *)sender
{
    MyImgView * myImg = (MyImgView *)sender.view;
    SubViewController * personVC = [[SubViewController alloc]init];
    personVC.account = [_personDataArray[myImg.indexpath.row] account];
    personVC.isFriend = [_personDataArray[myImg.indexpath.row] isFriended];
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}


- (void)showComment:(UITapGestureRecognizer *)tap
{
    if (isOK) {
        ShaiXuanEvaluateViewController * shaiXuanVC = [[ShaiXuanEvaluateViewController alloc]init];
        shaiXuanVC.dataArr = @[@"全部评价", @"求购方评价",@"代购方评价"];
        //        shaiXuanVC.fromSellerVC = self.fromSellerVC;
        shaiXuanVC.sign = @"1";
        [[UIApplication sharedApplication].windows.lastObject addSubview:shaiXuanVC.view];
        [self addChildViewController:shaiXuanVC];
    }else{
        [AutoDismissAlert autoDismissAlert:@"数据加载中,请稍后"];
    }
}

#pragma mark - 刷新
- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - post请求
- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getUserCommentListByGain" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count], @"user":_username,@"type": _signOfEvaluation}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
        [self.dataArray removeAllObjects];
        [self.personDataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            for (int i = 0; i< temparr.count; i++) {
                BussinessModel * browsingHistroyModel = [[BussinessModel alloc]init];
                NSDictionary * tempdic = temparr[i];
                [browsingHistroyModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:browsingHistroyModel];
                
                BussinessModel * a = [[BussinessModel alloc]init];
                a = self.dataArray[i];
                NSDictionary * dicc = a.user;
                [a setValuesForKeysWithDictionary:dicc];
                [self.personDataArray addObject:a];
            }
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
//        page = 0;
        isOK = YES;
        [tableview reloadData];
        [tableview headerEndRefreshing];
    } andFailureBlock:^{
//        page = 0;
        noData.hidden = NO;
        [self.dataArray removeAllObjects];
        [tableview reloadData];
        [tableview headerEndRefreshing];
    }];
    
}


//- (void)headerRefresh
//{
//    //__block NSString * tempStatus = status;
//    
//}
#pragma mark - 加载更多
- (void)footerRefresh
{
    int tempCount = 0;
    if (_dataArray.count < 10) {
        tempCount = (int)_dataArray.count;
    }else{
        tempCount = NumOfItemsForZuji;
    }
    page += 10;
    NSDictionary * dic = [self parametersForDic:@"getUserCommentListByGain" parameters:@{ACCOUNT_PASSWORD,@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji ], @"user":_username,@"type": _signOfEvaluation}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            for (int i = 0; i < temparrs.count; i++) {
//                
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                BussinessModel * browsingHistoryModel = [[BussinessModel alloc]init];
//                [browsingHistoryModel setValuesForKeysWithDictionary:tempdic];
//                [self.dataArray addObject:browsingHistoryModel];
//                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
//                    [self.dataArray removeLastObject];
//                    page -= tempCount;
//                    break;
//                }
//            }
            for (int i = 0; i< temparrs.count; i++) {
                BussinessModel * browsingHistroyModel = [[BussinessModel alloc]init];
                NSDictionary * tempdic = temparrs[i];
                [browsingHistroyModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:browsingHistroyModel];
                
                BussinessModel * a = [[BussinessModel alloc]init];
                a = self.dataArray[i];
                NSDictionary * dicc = a.user;
                [a setValuesForKeysWithDictionary:dicc];
                [self.personDataArray addObject:a];
                
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    page -= 20;
                    break;
                }
            }
            [tableview reloadData];
            noData.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            page -= tempCount;
        }else{
            page -= tempCount;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [tableview footerEndRefreshing];
    } andFailureBlock:^{
        page -= tempCount;
        [tableview footerEndRefreshing];
    }];
}


- (void)backBtn
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
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
