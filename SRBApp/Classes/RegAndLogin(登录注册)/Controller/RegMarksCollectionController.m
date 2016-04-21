//
//  SRBRegMarksCollectionController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/6.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "RegMarksCollectionController.h"
#import "RegMarksCollectionCell.h"
#import "MJRefresh.h"

@interface RegMarksCollectionController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *_dataArray;
    NSMutableArray *_selectedArray;
}
@end

@implementation RegMarksCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册成功啦";
    [_countLbl addTapAction:@selector(beginClicked) forTarget:self];
    _selectedArray = [NSMutableArray new];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    //[self loadMarksRequset];
    UINib *nib = [UINib nibWithNibName:@"RegMarksCollectionCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"RegMarksCollectionCell"];
    
    [self.collectionView addHeaderWithTarget:self action:@selector(headerRefresh)];
    
    [self.collectionView headerBeginRefreshing];
}
#pragma mark- collectionview delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RegMarksCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RegMarksCollectionCell" forIndexPath:indexPath];
    cell.dataDict = _dataArray[indexPath.row];
    if ([_selectedArray containsObject:_dataArray[indexPath.row]]) {
        cell.selectIV.hidden = NO;
    }else {
        cell.selectIV.hidden = YES;
    }
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //RegMarksCollectionCell *cell = (RegMarksCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    float width = (SCREEN_WIDTH-40-60)/4.0;
    //cell.width = width;
    //[cell.contentView layoutIfNeeded];
    float height = width * (148.0/100.0);
    //float height = cell.height;
    return CGSizeMake(width, height);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RegMarksCollectionCell *cell = (RegMarksCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSDictionary *dict = _dataArray[indexPath.row];
    if (!cell.selectIV.hidden) {
        if ([_selectedArray containsObject:dict]) {
            [_selectedArray removeObject:dict];
        }
        cell.selectIV.hidden = YES;
    }else {
        cell.selectIV.hidden = NO;
        if (![_selectedArray containsObject:dict]) {
            [_selectedArray addObject:dict];
        }
    }
    
    [self showCountLbl];
}
-(void)showCountLbl {
    UIColor *normalColor = DICECOLOR(170, 170, 170, 0.8);
    if (_selectedArray.count == 0) {
        _countLbl.text = @"请选择感兴趣的标签(至少5个)";
        _countLbl.backgroundColor = normalColor;
    }else if (_selectedArray.count < 5) {
        _countLbl.text = [NSString stringWithFormat:@"请选择感兴趣的标签(%ld)", _selectedArray.count];
        _countLbl.backgroundColor = normalColor;
    }else if (_selectedArray.count >= 5) {
        _countLbl.text = @"开始一起发现好东西吧";
        _countLbl.backgroundColor = DICECOLOR(228, 0, 85, 0.8);
    }
}
-(void)beginClicked {
    if (_selectedArray.count >= 5) {
        [self selectCompletedRequest];
    }
}
#pragma mark- 网络请求
-(void)headerRefresh {
    [self loadMarksRequset];
}
-(void)loadMarksRequset {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"获取数据中...";
//    hud.dimBackground = YES;
//    [hud show:YES];
    
    NSDictionary * param = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"50", @"categoryID": @"0"}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        [self.collectionView headerEndRefreshing];
        NSString * result = [dic objectForKey:@"result"];
        //[hud removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            _dataArray = temparrs;
        }else{
        }
        [self.collectionView reloadData];
        
    } andFailureBlock:^{
        //[hud removeFromSuperview];
        [self.collectionView headerEndRefreshing];
    }];
    
}
//标签选择完成
-(void)selectCompletedRequest {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"提交数据中...";
    hud.dimBackground = YES;
    [hud show:YES];
    
    //拼接选择后的id
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSDictionary *dict in _selectedArray) {
        [tempArray addObject:dict[@"id"]];
    }
    NSDictionary * param = [self parametersForDic:@"accountCollectTag" parameters:@{ACCOUNT_PASSWORD, @"id": [tempArray componentsJoinedByString:@","]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [hud removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [AutoDismissAlert autoDismissAlert:dic[@"message"]];
        }
        
    } andFailureBlock:^{
        [hud removeFromSuperview];
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

- (IBAction)countBtnClicked:(id)sender {
}
@end
