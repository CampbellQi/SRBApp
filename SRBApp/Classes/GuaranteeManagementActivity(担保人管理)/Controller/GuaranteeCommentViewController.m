//
//  GuaranteeCommentViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/21.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GuaranteeCommentViewController.h"
#import "MyEvaluateListCell.h"
#import "TosellerModel.h"
#import "MineEvaluateViewController.h"
#import "NoDataView.h"
#import "SecondSubclassDetailViewController.h"

static int page = 0;
static int count = NumOfItemsForZuji;
@interface GuaranteeCommentViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray * dataArray;
    NSMutableArray * allArray;
    NoDataView * noData;
}
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation GuaranteeCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"担保评价";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    dataArray = [[NSMutableArray alloc]init];
    allArray = [NSMutableArray array];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    noData.hidden = YES;
    [self.tableView addSubview:noData];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TosellerModel * sellerModel = dataArray[indexPath.row];
    if ([sellerModel.isCommented isEqualToString:@"1"]) {
        CGRect rect = [sellerModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 50, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
        NSArray * imageArr = [sellerModel.photos componentsSeparatedByString:@","];
        if (imageArr.count < 4 && imageArr.count >= 1) {
            return rect.size.height + 149 + 20 + (SCREEN_WIDTH - 30 - 20) / 3;
        }else if (imageArr.count >= 4){
            return rect.size.height + 149 + 20 + (SCREEN_WIDTH - 30 - 20) / 3 * 2 + 5;
        }
        return rect.size.height + 149;
    }else{
        return 149;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //创建一个cell
    MyEvaluateListCell * cell = [MyEvaluateListCell sellerCellWithTableView:tableView];
    TosellerModel * sellerModel = dataArray[indexPath.row];
    cell.goodsImg.indexpath = indexPath;
    UITapGestureRecognizer * tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    [cell.goodsImg addGestureRecognizer:tapImg];
    cell.commentType = @"toseller";
    cell.toSellerModel = sellerModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tapImg:(UITapGestureRecognizer *)tap
{
    MyImgView * tempImg = (MyImgView *)tap.view;
    TosellerModel * tosellerModel = [dataArray objectAtIndex:tempImg.indexpath.row];
    SecondSubclassDetailViewController * detailVC = [[SecondSubclassDetailViewController alloc]init];
    detailVC.idNumber = tosellerModel.ID;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountGetGuaranteeOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"type":@"frombuyer",@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [dataArray removeAllObjects];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TosellerModel * commentModel = [[TosellerModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:commentModel];
            }
            if (dataArray.count == 0) {
                noData.hidden = NO;
            }else{
                noData.hidden = YES;
            }
        }else if([result isEqualToString:@"4"]){
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [dataArray removeAllObjects];
        page = 0;
        noData.hidden = NO;
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    }];
}

#pragma mark - 下拉刷新
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
    NSDictionary * dic = [self parametersForDic:@"accountGetGuaranteeOrderCommentList" parameters:@{ACCOUNT_PASSWORD,@"type":@"frombuyer",@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TosellerModel * commentModel = [[TosellerModel alloc]init];
                [commentModel setValuesForKeysWithDictionary:tempdic];
                [allArray addObject:commentModel];
                if (allArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [allArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
                if ([commentModel.isCommented isEqualToString:@"1"]) {
                    [dataArray addObject:commentModel];
                }
            }
            noData.hidden = YES;
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            page -= NumOfItemsForZuji;
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


@end
