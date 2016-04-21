//
//  BaseGoodsCollectionController.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"
#import "BaseGoodsCollectionCell.h"
#import "UIScrollView+MJRefresh.h"
#import "BussinessModel.h"
#import "DetailActivityViewController.h"

@interface BaseGoodsCollectionController : ZZViewController<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NoDataView *_noDataView;
    int _page;
    int _count;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong)NSMutableArray *dataArray;

-(void)loadNewDataListRequest;
-(void)loadMoreDataListRequest;
@end
