//
//  MyGuaranteeGiveYouViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
static int page = 0;
static int count = NumOfItemsForZuji;
#import "MyGuaranteeGiveYouViewController.h"
#import "MJRefresh.h"
#import "SaleMineCell.h"
#import "DetailActivityViewController.h"
#import "RichContentMessageViewController.h"

@interface MyGuaranteeGiveYouViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    MBProgressHUD * hud;
}
@end

@implementation MyGuaranteeGiveYouViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    _nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    _nodataView.hidden = YES;
    [self.tableView addSubview:_nodataView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"wjj" object:nil];
}

- (void)refresh
{
    [self headerRefresh];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailActivityViewController * vc = [[DetailActivityViewController alloc]init];
    vc.idNumber = [_dataArray[indexPath.row] model_id];
    [self.navigationController pushViewController:vc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _dataArray.count;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
//    detailAVC.idNumber = [dataArray[indexPath.row] model_id];
//    detailAVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailAVC animated:YES];
//}

//- (void)tapToDetail:(UITapGestureRecognizer *)sender
//{
//    MyImgView *myImg = (MyImgView *)sender.view;
//    SecondSubclassDetailViewController *detailAVC = [[SecondSubclassDetailViewController alloc] init];
//    HadPublishModel *model = dataArray[myImg.indexpath.row];
//    detailAVC.idNumber = model.model_id;
//    detailAVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:detailAVC animated:YES];
//}

//- (void)down:(id)sender
//{
//    alertViewdown = [[UIAlertView alloc] initWithTitle:@"确定撤回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertViewdown show];
//
//    publishibutton = sender;
//    wantDown = (int)publishibutton.tag;
//}


#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}



- (void)urlRequestPost
{
    NSDictionary * dic;
    
    dic = [self parametersForDic:@"accountGetGuaranteeList" parameters:@{ACCOUNT_PASSWORD,@"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [_dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                DetailModel * bussinessModel = [[DetailModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                if ([bussinessModel.dealType isEqualToString:@"1"]) {
                    [_dataArray addObject:bussinessModel];
                }
            }
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            _nodataView.hidden = YES;
            
        }else if(result == 4){
            [_dataArray removeAllObjects];
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            _nodataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView headerEndRefreshing];
            _nodataView.hidden = NO;
        }
        page = 0;
        [hud removeFromSuperview];
    }andFailureBlock:^{
        
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SaleMineCell * cell = [[SaleMineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
    cell.thingimage.clipsToBounds = YES;
    cell.titleLabel.text = [_dataArray[indexPath.row] title];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[_dataArray[indexPath.row] bangPrice]];
    [cell.priceLabel sizeToFit];
    cell.nameLabel.text = [NSString stringWithFormat:@"卖家:%@", [_dataArray[indexPath.row]nickname]];
    if ([self.dealType isEqualToString:@"2"]) {
        [cell.signLabelDown setTitle:@"传送门" forState:UIControlStateNormal];
        [cell.signLabelDown addTarget:self action:@selector(doAction1:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [cell.signLabelDown setTitle:@"我要推荐" forState:UIControlStateNormal];
        [cell.signLabelDown addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cell.signLabelDown.indexpath = indexPath;
    if ([[_dataArray[indexPath.row]freeShipment] isEqualToString:@"1"]) {
        cell.postLabel.text = @"包邮";
        cell.postLabel.frame = CGRectMake(cell.priceLabel.frame.origin.x + cell.priceLabel.frame.size.width + 20, cell.priceLabel.frame.origin.y , 30, 16);
    }
    else
    {
        cell.postLabel.hidden = YES;
    }
    cell.commentLabel.text = [_dataArray[indexPath.row]commentCount];
    return cell;
}

- (void)doAction1:(PublishButton *)sender
{
//    PublishButton *button = sender;
    DetailModel *detailModel = [_dataArray objectAtIndex:sender.indexpath.row];
    //图文单聊
    RichContentMessageViewController *temp = [[RichContentMessageViewController alloc]init];
    
    temp.title = detailModel.title;
    temp.content = detailModel.content;
    temp.imageUrl = detailModel.cover;
    temp.photo = detailModel.photo;
    temp.idNumber = detailModel.model_id;
    temp.currentTarget = _model.account;
    temp.currentTargetName = _model.nickname;
    temp.conversationType = ConversationType_PRIVATE;
    temp.enableSettings = NO;
    temp.portraitStyle = RCUserAvatarCycle;
    temp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    [temp sendDebugRichMessage];
}

- (void)doAction:(PublishButton *)sender
{
//    PublishButton * button = sender;
    NSDictionary * dic;
    dic = [self parametersForDic:@"accountHandPost" parameters:@{ACCOUNT_PASSWORD,
                                                                 @"id":_model.model_id,
                                                                 @"goodsId": [_dataArray[sender.indexpath.row]model_id],
                                                                 @"content": @"此书不错，很不错"
                                                                 }];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"lrt" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else if(result == 4){
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }andFailureBlock:^{
        
    }];
}


#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic;
    
    dic = [self parametersForDic:@"accountGetGuaranteeList" parameters:@{ACCOUNT_PASSWORD, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                DetailModel * bussinessModel = [[DetailModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                if ([bussinessModel.dealType isEqualToString:@"1"]) {
                    [_dataArray addObject:bussinessModel];
                }
                if (_dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [_dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
            _nodataView.hidden = YES;
        }else if(result == 4){
            [temTableView reloadData];
            page -= NumOfItemsForZuji;
            [temTableView footerEndRefreshing];
            _nodataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            page -= NumOfItemsForZuji;
            [temTableView footerEndRefreshing];
            _nodataView.hidden = NO;
        }
    }andFailureBlock:^{
        
    }];
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
