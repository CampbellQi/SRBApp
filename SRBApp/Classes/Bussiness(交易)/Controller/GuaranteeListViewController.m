//
//  GuaranteeListViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GuaranteeListViewController.h"
#import "GuaranteeModel.h"
#import "CuarateeListTabelViewCell.h"
#import <UIImageView+WebCache.h>
#import "SubViewController.h"
#import "DetailActivityViewController.h"
#import "GoodsAssureTableViewCell.h"

@interface GuaranteeListViewController ()
{
    NSMutableArray * arr;
    int starta;
    NoDataView * nodataView;
}
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation GuaranteeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"熟人担保";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    starta = 0;
    arr = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    nodataView.hidden = YES;
    [self.tableView addSubview:nodataView];
    
    [self post];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:UIMenuControllerDidHideMenuNotification object:nil];

}

- (void)hidden
{
    NSArray * temparr = [self.tableView visibleCells];
    for (GoodsAssureTableViewCell * tempCell in temparr) {
        tempCell.reasonContentLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GuaranteeModel * bussinessModel = arr[indexPath.row];
    CGRect rect = [bussinessModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
        return 85 + rect.size.height + 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CuarateeListTabelViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[CuarateeListTabelViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    GuaranteeModel *guaranteeModel = [arr objectAtIndex:indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:guaranteeModel.avatar] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.imageV.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageV.clipsToBounds = YES;
    cell.imageV.layer.masksToBounds = YES;
    cell.imageV.layer.cornerRadius = 20;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.numberOfTapsRequired = 1;
    [cell.imageV addGestureRecognizer:tap];
    cell.imageV.indexpath = indexPath;
    cell.remarkLabel.text = guaranteeModel.nickname;


    cell.dateLabel.text = guaranteeModel.updatetime;
    CGRect rect = [guaranteeModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
    cell.reasonContentLabel.frame = CGRectMake(cell.assureLable.frame.origin.x, cell.assureLable.frame.origin.y + cell.assureLable.frame.size.height + 7, cell.assureReasonView.frame.size.width - 30, rect.size.height);
    cell.reasonContentLabel.text = guaranteeModel.content;
    cell.assureReasonView.frame = CGRectMake(15, cell.sanjiaoImageV.frame.origin.y + cell.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 40 + rect.size.height);
    cell.sanjiaoImageV.hidden = NO;
    cell.reasonContentLabel.hidden = NO;
    cell.assureLable.hidden = NO;
    cell.assureReasonView.hidden = NO;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tap:(UIGestureRecognizer *)tap
{
    MyImgView * img = (MyImgView *)tap.view;
    GuaranteeModel *model = [arr objectAtIndex:img.indexpath.row];
    SubViewController *detailAVC = [[SubViewController alloc] init];
    detailAVC.account = model.account;
    detailAVC.myRun = @"2";
    [self.navigationController pushViewController:detailAVC animated:YES];
}


//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    GuaranteeModel *model = [arr objectAtIndex:indexPath.row];
//    DetailActivityViewController *detailAVC = [[DetailActivityViewController alloc] init];
//    detailAVC.idNumber = model.model_id;
//    [self.navigationController pushViewController:detailAVC animated:YES];
//}

- (void)post
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostGuaranteeByRelation" parameters:@{ACCOUNT_PASSWORD,@"id":_idnumber, @"start": @"0", @"count":@"20"}
                          ];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            NSArray * array = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSLog(@"%@",[[dic objectForKey:@"data"] objectForKey:@"totalCount"]);
            for (NSDictionary * dic1 in array) {
                GuaranteeModel * model = [[GuaranteeModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [arr addObject:model];
                if (arr.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [arr removeLastObject];
                    break;
                }
                NSLog(@"%@",arr);
            }
            [_tableView reloadData];
            [nodataView setHidden:YES];
        }else if(result == 4)
        {
            [_tableView reloadData];
            [nodataView setHidden:NO];
        }
        else{
            NSLog(@"%@",[dic objectForKey:@"message"]);
            [AutoDismissAlert autoDismissAlert:@"提交失败"];
        }
    }andFailureBlock:^{
        
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
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
