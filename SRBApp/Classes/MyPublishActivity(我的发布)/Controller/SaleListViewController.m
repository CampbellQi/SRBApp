//
//  SaleListViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SaleListViewController.h"
#import "SaleListCell.h"
#import "SaleListViewController.h"
#import "SaleViewController.h"
#import "BuyViewController.h"
#import "RunViewController.h"
#import "SaleViewController.h"
#import "BuyViewController.h"
#import "CategoryModel.h"
#import <UIImageView+WebCache.h>

#import "ChangeSaleViewController.h"
#import "ChangeBuyViewController.h"

@interface SaleListViewController ()
{
    NSArray * arrimage;
    NSArray * arrlabel;
    NSMutableArray * listarr;
}
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation SaleListViewController

//- (void)popSwipe:(UIScreenEdgePanGestureRecognizer *)swipe
//{
//    [self.navigationController dismissViewController];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择分类";
    
//    UIScreenEdgePanGestureRecognizer * popSwipe = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(popSwipe:)];
//    [popSwipe setEdges:UIRectEdgeLeft];
//    [self.view addGestureRecognizer:popSwipe];
    
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    arrimage = @[@"fushi.png", @"xiangbao.png", @"xiemao.png", @"shipin.png", @"hufu.png", @"muying.png", @"shuma", @"qita"];
    arrlabel = @[@"服饰", @"箱包", @"鞋帽", @"食品", @"护肤", @"母婴", @"数码",@"其他"];
    listarr = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"获取分类中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    [self post];
    
}

- (void)post
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getCategoryList" parameters:@{@"type":@"123"}];
    
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        NSArray * arr = [[dic objectForKey:@"data"] objectForKey:@"list"];
        if ([result isEqualToString:@"0"]) {
            for (NSDictionary * dic1 in arr) {
                CategoryModel * model = [[CategoryModel alloc]init];
                [model setValuesForKeysWithDictionary:dic1];
                [listarr addObject:model];
            }
            [_tableView reloadData];
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        [HUD removeFromSuperview];
    }];
}



- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listarr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SaleListCell * cell = [[SaleListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.label.text = [listarr[indexPath.row]categoryName];
    [cell.theimage sd_setImageWithURL:[NSURL URLWithString:[listarr[indexPath.row]pic]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    cell.theimage.contentMode = UIViewContentModeScaleAspectFill;
    cell.theimage.clipsToBounds = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if ([_theSign isEqualToString:@"1"]) {
//        ChangeSaleViewController * vc = [[ChangeSaleViewController alloc]init];
//        vc.categoryID = [listarr[indexPath.row]categoryID];
//        [self.navigationController pushViewController:vc animated:YES];
//    }else {
//        ChangeBuyViewController * vc = [[ChangeBuyViewController alloc]init];
//        vc.categoryID = [listarr[indexPath.row]categoryID];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
     [self umengEvent:@"thingtype" attributes:@{@"buyOrSale" : _theSign,@"type" : [listarr[indexPath.row]categoryName]} number:@(0)];
        self.block([listarr[indexPath.row]categoryID], [listarr[indexPath.row]categoryName]);
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendMessage:(MyBlock1)jgx
{
    self.block = jgx;
}

-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
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
