//
//  TuijianViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TuijianViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface TuijianViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UIButton *toTopBtn;//返回顶部
}
@end

@implementation TuijianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推 荐";
    dataArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    [self.view addSubview:self.tableView];
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    noData = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    //noData.center = self.tableView.center;
    noData.hidden = YES;
    [self.tableView addSubview:noData];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    
    //    [self toTop];
    
}
//返回顶部
- (void)toTop
{
    toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40, 45, 45);
    //    toTopBtn.backgroundColor = [UIColor redColor];
    [toTopBtn setImage:[UIImage imageNamed:@"pgup"] forState:UIControlStateNormal];
    [toTopBtn addTarget:self action:@selector(clickToTop) forControlEvents:UIControlEventTouchUpInside];
    //    [self.tableView addSubview:toTopBtn];
    //    [self.tableView bringSubviewToFront:toTopBtn];
}

- (void)clickToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}


- (void)reloadPost
{
    [dataArray removeAllObjects];
    [self.tableView reloadData];
    [self.tableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailActivityViewController * myAssureVC = [[DetailActivityViewController alloc]init];
    myAssureVC.idNumber = [dataArray[indexPath.row] model_id];
    [self.navigationController pushViewController:myAssureVC animated:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([[dataArray[indexPath.row] dealName] isEqualToString:@"想买"]) {
//        BuyCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
//        if (!cell) {
//            cell = [[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        }
//        [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
//        cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
//        cell.thingimage.clipsToBounds = YES;
//        cell.titleLabel.text = [dataArray[indexPath.row] title];
//        cell.detailLabel.text = [dataArray[indexPath.row] model_description];
//        cell.signImage.image = [UIImage imageNamed:@"maisignNew.png"];
//        cell.nameLabel.text = [NSString stringWithFormat:@"买家:%@", [dataArray[indexPath.row]nickname]];
//        cell.commentLabel.text = [dataArray[indexPath.row]commentCount];
//        return cell;
//    }
//    SellCell * cell = [[SellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
//    [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
//    cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
//    cell.thingimage.clipsToBounds = YES;
//    cell.titleLabel.text = [dataArray[indexPath.row] title];
//    cell.priceLabel.text = [NSString stringWithFormat:@"￥%@",[dataArray[indexPath.row] marketPrice]];
//    [cell.priceLabel sizeToFit];
//    double a = [[dataArray[indexPath.row]marketPrice] doubleValue];
//    double b = [[dataArray[indexPath.row]bangPrice] doubleValue];
//    cell.signImage.image = [UIImage imageNamed:@"SALEtag.png"];
//    cell.nameLabel.text = [NSString stringWithFormat:@"推荐人:%@", [dataArray[indexPath.row]nickname]];
//    cell.oldPrice.frame = CGRectMake(cell.priceLabel.frame.origin.x + cell.priceLabel.frame.size.width + 9, cell.priceLabel.frame.origin.y + 3, 120, 12);
//    cell.oldPrice.text = [NSString stringWithFormat:@"￥%@",[dataArray[indexPath.row]bangPrice]];
//    [cell.oldPrice sizeToFit];
//    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(cell.oldPrice.frame.origin.x, cell.oldPrice.frame.origin.y + 6, cell.oldPrice.frame.size.width, 1)];
//    view.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
//    [cell addSubview:view];
//    if (a >= b) {
//        cell.oldPrice.hidden = YES;
//        view.hidden = YES;
//        cell.zhekouLabel.hidden = YES;
//        cell.postLabel.frame = CGRectMake(cell.priceLabel.frame.origin.x, cell.priceLabel.frame.origin.y + cell.priceLabel.frame.size.height + 2, 30, 16);
//        cell.image.hidden = YES;
//    }else{
//        cell.zhekouLabel.text = [NSString stringWithFormat:@"%.1f折", a/b * 10];
//    }
//    
//    if ([[dataArray[indexPath.row]freeShipment] isEqualToString:@"1"]) {
//        cell.postLabel.text = @"包邮";
//    }
//    else
//    {
//        cell.postLabel.hidden = YES;
//    }
//    cell.commentLabel.text = [dataArray[indexPath.row]commentCount];
//    return cell;
    if ([[dataArray[indexPath.row] dealName] isEqualToString:@"想买"]) {
        BuyCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[BuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
        cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
        cell.thingimage.clipsToBounds = YES;
        cell.titleLabel.text = [dataArray[indexPath.row] title];
        cell.detailLabel.text = [dataArray[indexPath.row] model_description];
        cell.signImage.image = [UIImage imageNamed:@"maisignNew.png"];
        cell.nameLabel.text = [NSString stringWithFormat:@"买家:%@", [dataArray[indexPath.row]nickname]];
        cell.commentLabel.text = [dataArray[indexPath.row]commentCount];
        return cell;
    }
    SellCell * cell = [[SellCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    [cell.thingimage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.thingimage.contentMode = UIViewContentModeScaleAspectFill;
    cell.thingimage.clipsToBounds = YES;
    cell.titleLabel.text = [dataArray[indexPath.row] title];
    cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@",[dataArray[indexPath.row] bangPrice]];
    [cell.priceLabel sizeToFit];
    cell.signImage.image = [UIImage imageNamed:@"SALEtag.png"];
    cell.nameLabel.text = [NSString stringWithFormat:@"卖家:%@", [dataArray[indexPath.row]nickname]];
    if ([[dataArray[indexPath.row]freeShipment] isEqualToString:@"1"])
    {
        cell.postLabel.text = @"包邮";
        cell.postLabel.frame = CGRectMake(cell.priceLabel.frame.origin.x + cell.priceLabel.frame.size.width + 20, cell.priceLabel.frame.origin.y + 5, 30, 16);
    }
    else
    {
        cell.postLabel.hidden = YES;
    }
    cell.commentLabel.text = [dataArray[indexPath.row]commentCount];
    return cell;
}


#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}


- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"getPostHandByRelation" parameters:@{ACCOUNT_PASSWORD,@"id":_idNumber,@"start":@"0", @"count":[NSString stringWithFormat:@"%d",count], @"isFriended":@"1"}];
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        [dataArray removeAllObjects];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            [temTableView reloadData];
            noData.hidden = YES;
        }else if(result == 4){
            [temTableView reloadData];
            noData.hidden = NO;
        }else{
            noData.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView headerEndRefreshing];
    }andFailureBlock:^{
        
    }];
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += 10;
    NSDictionary * dic;
    
    dic = [self parametersForDic:@"getPostHandByRelation" parameters:@{ACCOUNT_PASSWORD,@"id":_idNumber,@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji],@"isFriended":@"1"}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= 20;
                    break;
                }
            }
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
            
        }else if(result == 4){
            page -= 20;
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
        }else{
            page -= 20;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView footerEndRefreshing];
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
