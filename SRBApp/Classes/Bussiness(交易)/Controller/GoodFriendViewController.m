//
//  GoodFriendViewController.m
//  SRBApp
//
//  Created by yujie on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GoodFriendViewController.h"
#import "NoDataView.h"
#import "SubViewController.h"
#import "BuyandSayCell.h"
#import "BuyandSayCellFrame.h"
#import "ImageViewController.h"
static int page = 0;

@interface GoodFriendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NoDataView * nodataView;
}
@end

@implementation GoodFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray = [NSMutableArray array];
    
    self.tableView.delegate =self;
    self.tableView.dataSource =self;
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [self.tableView headerBeginRefreshing];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    nodataView.hidden = YES;
    [self.tableView addSubview:nodataView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BuyandSayCellFrame *cellFrame = dataArray[indexPath.row];
    return cellFrame.cellHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    
    BuyandSayCell * cell = (BuyandSayCell *)[tableView dequeueReusableCellWithIdentifier :identifier];
    if (!cell) {
        cell = [[BuyandSayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.cellFrame = dataArray[indexPath.row];
    cell.headImage.indexpath = indexPath;
    cell.photosView.tag = indexPath.row;
    UITapGestureRecognizer *tapToPersonal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPersonal:)];
    [cell.headImage addGestureRecognizer:tapToPersonal];
    cell.photosView.delegate = self;
    return cell;
}
#pragma mark- wQOneToSixPhotosView delegate
-(void)wQOneToSixPhotosViewImageTap:(UIImageView *)sender {
    WQOneToSixPhotosView *pv = (WQOneToSixPhotosView *)sender.superview;
    ImageViewController * vc = [[ImageViewController alloc]init];
    BuyandSayCellFrame *frame = dataArray[pv.tag];
    MarkModel *model = frame.markModel;
    NSArray * photosArr = [model.photos componentsSeparatedByString:@","];
    NSMutableString * stringtotal = [[NSMutableString alloc]init];
    for (NSMutableString * string in photosArr) {
        NSArray * arr = [string componentsSeparatedByString:@"_"];
        NSMutableString * str = [[NSMutableString alloc] initWithString:[arr firstObject]];
        if ([arr[1] isEqualToString:@"sm.jpg"]) {
            [str appendFormat: @".jpg,"];
        }else{
            [str appendFormat: @".png,"];
        }
        
        [stringtotal appendString:str];
    }
    [stringtotal deleteCharactersInRange:NSMakeRange(stringtotal.length - 1, 1)];
    
    if (photosArr.count == 1) {
        vc.imgIndex = 1;
    }else{
        vc.imgIndex = sender.tag - 100 + 1;
    }
    //    imageVC.hidesBottomBarWhenPushed = YES;
    vc.imageUrl = stringtotal;
    //    for (NSMutableString * string in _model.photos) {
    //
    //    }
    //[vc showFromController:vc];
    //    UIWindow *window = (APPDELEGATE).window;
    //    CGRect rect = [window convertRect:button.frame fromView:button.superview];
    //    [window addSubview:vc.view];
    //    vc.view.frame = CGRectMake(0, 64, SCREEN_WIDTH, 100);
    //    [self addChildViewController:vc];
    //    [UIView animateWithDuration:1 animations:^{
    //        //vc.view.frame = window.frame;
    //    }];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)tapToPersonal:(UITapGestureRecognizer *)sender
{
    MyImgView * myImg = (MyImgView *)sender.view;
    SubViewController * personVC = [[SubViewController alloc]init];
    personVC.account = [dataArray[myImg.indexpath.row] account];
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}
#pragma mark - 网络请求
- (void)urlRequestPost
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostMarkByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"1",@"id":self.idNumber,@"start":@"0", @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        [dataArray removeAllObjects];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BuyandSayCellFrame *frame = [BuyandSayCellFrame new];
                MarkModel * bussinessModel = [[MarkModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                frame.markModel = bussinessModel;
                [dataArray addObject:frame];
            }
            [temTableView reloadData];
            nodataView.hidden = YES;
        }else if(result == 4){
            [temTableView reloadData];
            nodataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [temTableView headerEndRefreshing];
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

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostMarkByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"1",@"id":self.idNumber,@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MarkModel * bussinessModel = [[MarkModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                BuyandSayCellFrame *frame = [BuyandSayCellFrame new];
                frame.markModel = bussinessModel;
                [dataArray addObject:frame];
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
    }andFailureBlock:^{
        
    }];
}


@end
