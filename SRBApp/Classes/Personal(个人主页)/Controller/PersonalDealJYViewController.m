//
//  PersonalDealJYViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/30.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalDealJYViewController.h"
#import "SecondSubclassDetailViewController.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface PersonalDealJYViewController ()

@end

@implementation PersonalDealJYViewController
{
    NoDataView * imageview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    imageview = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65 - 40 - 64)];
    imageview.hidden = YES;
    
    [self.tableView addSubview:imageview];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GoodsAssureTableViewCell * cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell1"];
    if (!cell) {
        cell = [[GoodsAssureTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
    }
    BussinessModel *bussinessModel = [dataArray objectAtIndex:indexPath.row];
    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row]cover]] placeholderImage:[UIImage imageNamed:@"wutu.png"]];
    cell.imageV.indexpath = indexPath;
    UITapGestureRecognizer * tapImg = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImg:)];
    [cell.imageV addGestureRecognizer:tapImg];
    
    cell.titleLabel.text = bussinessModel.title;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥ %@" ,bussinessModel.bangPrice];
    cell.sellRemarkNLabel.text = [NSString stringWithFormat:@"%@", bussinessModel.nickname];
    [cell.signLabelDown setTitle:@"取消担保" forState:UIControlStateNormal];
    cell.signLabelDown.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    CGRect rect = [bussinessModel.guarantorcontent boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 60, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]} context:nil];
    cell.reasonContentLabel.frame = CGRectMake(cell.assureLable.frame.origin.x, cell.assureLable.frame.origin.y + cell.assureLable.frame.size.height + 7, cell.assureReasonView.frame.size.width - 30, rect.size.height);
    cell.reasonContentLabel.text = bussinessModel.guarantorcontent;
    cell.assureReasonView.frame = CGRectMake(15, cell.sanjiaoImageV.frame.origin.y + cell.sanjiaoImageV.frame.size.height, SCREEN_WIDTH - 30, 40 + rect.size.height);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dateLabel.text = [CompareCurrentTime compareCurrentTime:bussinessModel.updatetimeLong];

    cell.sanjiaoImageV.hidden = NO;
    cell.reasonContentLabel.hidden = NO;
    cell.assureLable.hidden = NO;
    cell.assureReasonView.hidden = NO;
//    cell.dateLabel.hidden = NO;
    cell.assurePrice.hidden = YES;
    cell.signLabelDown.hidden = YES;
    cell.signLabelDown.enabled = NO;
    return cell;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        NSString * str = [dataArray[wantdown - 100]model_id];
        [dataArray removeObjectAtIndex:wantdown - 100];
        [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:publishbutton.indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountDeleteGuaranteePost" parameters:@{ACCOUNT_PASSWORD,@"id":str}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                [self.personVC urlRequestPostTAgain];
                [self urlRequestPost];
            }else{
                [AutoDismissAlert autoDismissAlert:@"请求失败"];
            }
        }];
    }
    
}

- (void)tapImg:(UITapGestureRecognizer *)tap
{
    MyImgView * tempImg = (MyImgView *)tap.view;
    BussinessModel *bussinessModel = [dataArray objectAtIndex:tempImg.indexpath.row];
    SecondSubclassDetailViewController * detailVC = [[SecondSubclassDetailViewController alloc]init];
    detailVC.idNumber = bussinessModel.model_id;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)deleteThing:(id)sender
{
    UIAlertView * alertViewdown = [[UIAlertView alloc] initWithTitle:@"是否放弃担保?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertViewdown show];
    
    publishbutton = sender;
    wantdown = (int)publishbutton.tag;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
    if (self.account == nil) {
        self.account = @"";
    }
    NSDictionary * dic = [self parametersForDic:@"getGuaranteeListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":self.account, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [dataArray removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            imageview.hidden = YES;
        }else if(result == 4){
            [dataArray removeAllObjects];
            [temTableView reloadData];
            [temTableView headerEndRefreshing];
            imageview.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView headerEndRefreshing];
        }
        page = 0;
    }];
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"getGuaranteeListByUser" parameters:@{ACCOUNT_PASSWORD,@"user":self.account, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
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
@end
