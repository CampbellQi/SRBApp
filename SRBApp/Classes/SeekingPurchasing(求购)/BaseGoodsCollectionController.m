//
//  BaseGoodsCollectionController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseGoodsCollectionController.h"

@interface BaseGoodsCollectionController ()
@end

@implementation BaseGoodsCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    _page = 0;
    _count = NumOfItemsForZuji;
    
    UINib *nib = [UINib nibWithNibName:@"BaseGoodsCollectionCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"BaseGoodsCollectionCell"];
    //上下拉刷新
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.collectionView addFooterWithTarget:self action:@selector(footerRefresh)];
    //无数据图
    _noDataView = [[NoDataView alloc]initWithFrame:self.collectionView.bounds];
    _noDataView.width = SCREEN_WIDTH;
    _noDataView.center = CGPointMake(SCREEN_WIDTH/2, self.collectionView.height/2);
    _noDataView.hidden = YES;
    [self.collectionView addSubview:_noDataView];
    
    
}
#pragma mark- 网络请求
-(void)headerRefresh {
    [self loadNewDataListRequest];
}
-(void)loadNewDataListRequest {
    
}
-(void)footerRefresh {
    [self loadMoreDataListRequest];
}
-(void)loadMoreDataListRequest {

}
#pragma mark- collectionview delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"BaseGoodsCollectionCell";
    BaseGoodsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.sourceModel = _dataArray[indexPath.row];
    cell.selected = NO;
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = SCREEN_WIDTH/2 - 15;
    float ratio = width / 145;
    return CGSizeMake(SCREEN_WIDTH/2 - 15,245 * ratio);
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DetailActivityViewController * myAssureVC = [[DetailActivityViewController alloc]init];
    myAssureVC.idNumber = [self.dataArray[indexPath.row] model_id];
    [self.navigationController pushViewController:myAssureVC animated:YES];
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
