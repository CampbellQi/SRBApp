//
//  PersonalLocationTable.m
//  SRBApp
//
//  Created by zxk on 15/1/20.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalLocationTable.h"
static int page = 0;
static int count = NumOfItemsForZuji;
@interface PersonalLocationTable ()
{
    NoDataView * imageview;
}
@end

@implementation PersonalLocationTable
{
    NSIndexPath * indexpath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    toTopBtn.hidden = YES;
    imageview = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 65 - 40 - 64)];
    imageview.hidden = YES;
    
    [self.tableview addSubview:imageview];
    // Do any additional setup after loading the view.
}

- (void)hidden
{
    NSArray * temparr = [self.tableview visibleCells];
    for (LocationCell * tempCell in temparr) {
        tempCell.descriptionLabel.backgroundColor = [UIColor clearColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapToLPersonal:(UITapGestureRecognizer *)tap
{
    
}

- (void)delLocation:(ZZGoPayBtn *)sender
{
    indexpath = sender.indexpath;
    UIAlertView *delLocationAlert = [[UIAlertView alloc] initWithTitle:@"确定删除该足迹？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [delLocationAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex == 1) {
        LocationModel * locationModel = dataArray[indexpath.row];
        
        [dataArray removeObjectAtIndex:indexpath.row];
        [self.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        NSDictionary * tempdic = [self parametersForDic:@"accountDeletePosition" parameters:@{ACCOUNT_PASSWORD,@"id":locationModel.ID}];
        [URLRequest postRequestWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"] intValue];
            if (result == 0) {
                [self urlRequestPost];
                [self.personVC urlRequestPostTAgain];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        }];
    }
}



#pragma mark - 网络请求
- (void)urlRequestPost
{
    if (self.account == nil) {
        self.account = @"";
    }
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByUser"parameters:@{ACCOUNT_PASSWORD,@"user":self.account,@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
    
    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:locationModel];
            }
            imageview.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            imageview.hidden = NO;
        }else{
            imageview.hidden = NO;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        [dataArray removeAllObjects];
        page = 0;
        imageview.hidden = NO;
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

- (void)saveImageToPhotos{
    
    if (imgArr.count != 0 && imgArr != nil) {
        if (currentIndex > imgArr.count) {
            UIImageWriteToSavedPhotosAlbum([imgArr objectAtIndex:imgArr.count - 1], nil, nil, nil);
        }else{
            UIImageWriteToSavedPhotosAlbum([imgArr objectAtIndex:currentIndex], nil, nil, nil);
        }
        [AutoDismissAlert autoDismissAlert:@"保存成功"];
    }else{
        [AutoDismissAlert autoDismissAlert:@"保存失败"];
    }
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationByUser"parameters:@{@"user":self.account,@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableview;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                LocationModel * locationModel = [[LocationModel alloc]init];
                [locationModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:locationModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            imageview.hidden = YES;
            [temTableView reloadData];
        }else if(result == 4){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [temTableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [temTableView footerEndRefreshing];
    }];
}
#pragma mark UIScrollView 代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray * temparr = [self.tableview visibleCells];
    for (LocationCell * tempCell in temparr) {
        CGRect rect = tempCell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
        rect.size.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            tempCell.twoButtonView.frame = rect;
        } completion:^(BOOL finished) {
            tempCell.twoButtonView.hidden = YES;
        }];
        tempCell.locationModel.isClick = NO;
    }
    if (![scrollView isEqual:self.hpTextView]) {
        [self.hpTextView resignFirstResponder];
        self.hpTextView.text = @"";
        self.markID = @"";
        self.locationID = @"";
    }
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
