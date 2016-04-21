//
//  TotalConsultViewController.m
//  SRBApp
//
//  Created by yujie on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TotalConsultViewController.h"
#import "MarkOrCommentsCell.h"
#import "SubViewController.h"
static int page = NumOfItemsForZuji;
@interface TotalConsultViewController ()
{
    NoDataView * nodataView;
}
@end

@implementation TotalConsultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    nodataView.hidden = YES;
    [self.tableView addSubview:nodataView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"shuaxin" object:nil];
}

- (void)refresh
{
    [self headerRefresh];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarkOrCommentsCell * cell = [[MarkOrCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    //    CGSize boundSize = CGSizeMake(216, CGFLOAT_MAX);
    //    cell.sayLabel.text = [dataArray[indexPath.row] content];
    //    cell.sayLabel.numberOfLines = 0;
    //    CGSize requiredSize = [cell.sayLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:boundSize lineBreakMode:0];
    
    cell.headImage.indexpath = indexPath;
    UITapGestureRecognizer *tapToPersonal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPersonal:)];
    [cell.headImage addGestureRecognizer:tapToPersonal];
    
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row] avatar]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.headImage.clipsToBounds = YES;
    cell.titleLabel.text =[dataArray[indexPath.row] nickname];
    
    if ([dataArray[indexPath.row]touser] != nil) {
        NSDictionary * dic = (NSDictionary *) [dataArray[indexPath.row] touser];
        cell.sayToWhoLabel.text = [dic objectForKey:@"nickname"];
        [cell.sayToWhoLabel sizeToFit];
    }else{
        cell.huifuLabel.hidden = YES;
    }
    
    if ([[dataArray[indexPath.row] grade] isEqualToString:@"1"]) {
        cell.commentImg.image = [UIImage imageNamed:@"s_good"];
        cell.goodComment.text = @"商品评分：好评";
    }else if([[dataArray[indexPath.row] grade] isEqualToString:@"0"]){
        cell.commentImg.image = [UIImage imageNamed:@"s_middle"];
        cell.goodComment.text = @"商品评分：中评";
    }else if([[dataArray[indexPath.row] grade] isEqualToString:@"-1"]){
        cell.commentImg.image = [UIImage imageNamed:@"s_negative"];
        cell.goodComment.text = @"商品评分：差评";
    }else
    {
        cell.commentImg.image = [UIImage imageNamed:@"s_fake"];
        cell.goodComment.text = @"商品评分：假货";
    }
    [cell setIntroductionText:[dataArray[indexPath.row] content]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate * date = [dateFormatter dateFromString:[dataArray[indexPath.row] updatetime]];
    //    [dateFormatter setDateFormat:@"MM-dd"];
    //    NSString * str = [dateFormatter stringFromDate:date];
    cell.dateLabel.text = [dataArray[indexPath.row] updatetime];
    //    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    //    CGRect rect = cell.frame;
    //    rect.size.height = requiredSize.height + 100;
    //    cell.frame = rect;
    
    return cell;
}

- (void)tapToPersonal:(UITapGestureRecognizer *)sender
{
    MyImgView * myImg = (MyImgView *)sender.view;
    SubViewController * personVC = [[SubViewController alloc]init];
    personVC.account = [dataArray[myImg.indexpath.row] account];
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}


- (void)urlRequestPost
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0",@"id":self.idNumber,@"start":@"0", @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MarkModel * bussinessModel = [[MarkModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            nodataView.hidden = YES;
        }else if(result == 4){
            [dataArray removeAllObjects];
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            nodataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView headerEndRefreshing];
            
        }
        page = 0;
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
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0",@"id":self.idNumber,@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MarkModel * bussinessModel = [[MarkModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
            
        }else if(result == 4){
            page -= NumOfItemsForZuji;
            [temTableView reloadData];
            [temTableView footerEndRefreshing];
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView footerEndRefreshing];
        }
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
