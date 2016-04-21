//
//  PersonalSpotGoodsListController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/26.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PersonalSpotGoodsListController.h"
#import "ChangeSaleViewController2.h"
#import "SpotGoodsAddCell.h"
#import "SpotGoodsCell.h"
#import "CommonView.h"
#import "AppDelegate.h"
#import "WQAlertView.h"

@interface PersonalSpotGoodsListController ()<UIActionSheetDelegate>
{
    BussinessModel *_editModel;
    NSIndexPath *_selIndexPath;
}
@end

@implementation PersonalSpotGoodsListController
- (void)viewWillAppear:(BOOL)animated
{
    //[self urlRequestPost];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我的商品库";
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
    
    UINib *nib = [UINib nibWithNibName:@"SpotGoodsCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"SpotGoodsCell"];
    UINib *nib1 = [UINib nibWithNibName:@"SpotGoodsAddCell" bundle:[NSBundle mainBundle]];
    [self.collectionView registerNib:nib1 forCellWithReuseIdentifier:@"SpotGoodsAddCell"];
    
    [self.collectionView headerBeginRefreshing];
}
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clearBtnClicked {
    
}
#pragma mark- 事件
//商品详情
-(void)showDetailActivityVC {
    DetailActivityViewController *vc = [[DetailActivityViewController alloc] init];
    vc.idNumber = _editModel.model_id;
    [self.navigationController pushViewController:vc animated:YES];
}
//修改商品
-(void)showChangeSellVC {
    ChangeSaleViewController2 *vc = [[ChangeSaleViewController2 alloc] init];
    vc.goodsID = _editModel.model_id;
    vc.title = @"修改商品";
    vc.backBlock = ^(void){
        _selIndexPath = nil;
        [self.collectionView headerBeginRefreshing];
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//修改商品sheet
-(void)showGoodsAlertSheet {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"修改" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self alertButtonAtIndex:0];
        }]];
        
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self alertButtonAtIndex:1];
        }]];
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
        [self presentViewController:alertSheet animated:YES completion:nil];
    }else {
        UIActionSheet *alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改",@"删除", nil];
        [alertSheet showInView:self.view];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self alertButtonAtIndex:(int)buttonIndex];
}
-(void)alertButtonAtIndex:(int)index {
    if (index == 0) {
        [self showChangeSellVC];
    }else if (index == 1) {
        [self showDeleteAlertView];
    }
}
//删除
-(void)showDeleteAlertView {
    [[WQAlertView alloc] showAlertWithCurrentViewController:self Title:@"确定删除该商品？" Message:nil ConfirmName:@"确定" CancelName:@"取消" ConfirmBlock:^{
        [self deleteReuqest];
    } CancelBlock:^{
        
    }];
}
#pragma mark- tableview delegate
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataArray[indexPath.row] isKindOfClass:[NSString class]]) {
        SpotGoodsAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SpotGoodsAddCell" forIndexPath:indexPath];
        return cell;
    }else {
        static NSString *cellID = @"SpotGoodsCell";
        SpotGoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.sourceModel = self.dataArray[indexPath.row];
        
        cell.editBlock = ^(BussinessModel *editModel) {
            _editModel = editModel;
            //[self showChangeSellVC];
            [self showGoodsAlertSheet];
            
        };
        if ([indexPath isEqual:_selIndexPath]) {
            cell.selectedIV.hidden = NO;
        }else {
            cell.selectedIV.hidden = YES;
        }
        cell.editBtn.hidden = NO;
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChangeSaleViewController2 *vc = [[ChangeSaleViewController2 alloc] init];
        vc.title = @"添加商品";
        [self.navigationController pushViewController:vc animated:YES];
        vc.backBlock = ^(void){
            _selIndexPath = nil;
            [self.collectionView headerBeginRefreshing];
        };
    }else {
        _editModel = self.dataArray[indexPath.row];
        [self showDetailActivityVC];
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    float width = SCREEN_WIDTH/2 - 15;
    float ratio = width / 145;
    return CGSizeMake(SCREEN_WIDTH/2 - 15,191 * ratio);
}
#pragma mark- 网络请求
//最新商品列表
- (void)loadNewDataListRequest
{
    _page = 0;
    
    NSString *brand = @"";
    NSString *name = @"";

    NSDictionary * param = [self parametersForDic:@"getPostListBySearchKeyword" parameters:@{@"user": ACCOUNT_SELF,@"type":@"123", @"dealType": @"1", @"start":[NSString stringWithFormat:@"%d",_page], @"count":[NSString stringWithFormat:@"%d",_count], @"keyword": [NSString stringWithFormat:@"%@,%@",brand, name]}];
    
    
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        [self.dataArray addObject:@"a"];
        if ([result isEqualToString:@"0"]) {
            
            
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
            }
            
        }else if([result isEqualToString:@"4"]){
        }else{
        }
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
    } andFailureBlock:^{
        [self.collectionView headerEndRefreshing];
    }];
    
}
//更多商品列表
- (void)loadMoreDataListRequest
{
    NSString *brand = @"";
    NSString *name = @"";
    
    _page += NumOfItemsForZuji;
    NSDictionary * param = [self parametersForDic:@"getPostListBySearchKeyword" parameters:@{@"user": ACCOUNT_SELF,@"type":@"123", @"dealType": @"1", @"start":[NSString stringWithFormat:@"%d",_page], @"count":[NSString stringWithFormat:@"%d",_count], @"keyword": [NSString stringWithFormat:@"%@,%@",brand, name]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:bussinessModel];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue] + 1) {
                    [self.dataArray removeLastObject];
                    _page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.collectionView reloadData];
        }else if([result isEqualToString:@"4"]){
            _page -= NumOfItemsForZuji;
        }else{
            _page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        
        [self.collectionView footerEndRefreshing];
    } andFailureBlock:^{
        _page -= NumOfItemsForZuji;
        [self.collectionView footerEndRefreshing];
    }];
}
-(void)deleteReuqest{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.dataArray indexOfObject:_editModel] inSection:0];
    [self.dataArray removeObject:_editModel];
    //[self.collectionView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
   
    NSDictionary * dic = [self parametersForDic:@"accountDeletePost" parameters:@{ACCOUNT_PASSWORD, @"id": _editModel.model_id}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
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
