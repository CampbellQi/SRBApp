//
//  BaseSPListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/19.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "BaseSPListController.h"
#import "MapViewController.h"
#import "TopicDetailListController.h"
#import "ShareViewController.h"
#import "TopicCommentListController.h"
#import "PublishSPController.h"
#import "TakingOrdersController.h"
#import "HelpPurchasingController.h"
#import "SpotGoodsController.h"
#import "AppDelegate.h"
#import "PersonalViewController.h"
#import "LayoutFrame.h"
#import "NSString+CalculateSize.h"
#import "ImageViewController.h"
#import "CommonHandel.h"
#import "ConsultViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"

@interface BaseSPListController ()<ISSShareViewDelegate>
{
    NSMutableDictionary *_offscreenCells;
    //展开行
    long _spreadIndex;
     //MBProgressHUD *hud;
    BussinessModel * _deleteBussinessModel;
}
@end

@implementation BaseSPListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 0;
    _count = NumOfItemsForZuji;
    _spreadIndex = -1;
    self.dataArray = [NSMutableArray array];
    _offscreenCells = [NSMutableDictionary dictionaryWithCapacity:0];
    [self setUpView];
}

#pragma mark- 页面
-(void)setUpView {
    //上下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    UINib *nib = [UINib nibWithNibName:@"BaseSPListCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BaseSPListCell"];
    _propertyCell = [self.tableView dequeueReusableCellWithIdentifier:@"BaseSPListCell"];
//    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.tableView.estimatedRowHeight = 421.0;
    //无数据图
    _noDataView = [[NoDataView alloc]initWithFrame:self.tableView.bounds];
    _noDataView.width = SCREEN_WIDTH;
    _noDataView.center = CGPointMake(SCREEN_WIDTH/2, self.tableView.height/2);
    _noDataView.hidden = YES;
    [self.tableView addSubview:_noDataView];

}
#pragma mark-跳转
-(void)showImageControllerWithModel:(BussinessModel *)model Sender:(UIImageView *)sender {
    ImageViewController * vc = [[ImageViewController alloc]init];
    vc.isDownBtnHide = YES;
    NSMutableArray *tempPhotosArr = [NSMutableArray arrayWithCapacity:0];
    NSArray * photosArr = [model.cover componentsSeparatedByString:@","];
    for (NSString * string in photosArr) {
        NSMutableString *muString = [NSMutableString stringWithString:string];
        [CommonHandel handleScanBigPhoto:muString];
        [tempPhotosArr addObject:muString];
    }
    vc.imgIndex = 1;
    
    vc.imageUrl = [tempPhotosArr componentsJoinedByString:@","];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
//展开
-(void)spreadMemoWithModel:(BussinessModel *)model Sender:(UIButton *)sender {
    if (sender.selected) {
        _spreadIndex = -1;
    }else {
        _spreadIndex = [_dataArray indexOfObject:model];
    }
    [self.tableView reloadData];
}
//个人中心
-(void)showPersonalVCWithModel:(BussinessModel *)model {
    PersonalViewController * personVC = [[PersonalViewController alloc]init];
    personVC.account = model.account;
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}
//位置
-(void)goMapViewControllerWithModel:(BussinessModel *)model {
    MapViewController *mapVC = [[MapViewController alloc] init];
    if (![model.positionxyz isEqualToString:@"0"] && ![model.positionxyz isEqualToString:@""] && model.positionxyz != nil) {
        NSArray *positionArr = [model.positionxyz componentsSeparatedByString:@","];
        if (positionArr.count >= 2) {
            mapVC.lat = [[positionArr objectAtIndex:0] doubleValue];
            mapVC.lon = [[positionArr objectAtIndex:1]doubleValue];
        }
        
        mapVC.address = model.location;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}
//原文链接
-(void)goTopicDetailControllerWithModel:(BussinessModel *)model {
    TopicDetailListController *vc = [[TopicDetailListController alloc] init];
    vc.modelId = model.parentId;
    [self.navigationController pushViewController:vc animated:YES];
}
//分享
-(void)showShareWithModel:(BussinessModel *)model Sender:(UIButton *)sender{
    if (!model) {
        return;
    }
    NSString *name = @"";
    NSString *brand = @"";
    if (model.labels.count > 0) {
        name = model.labels[0][@"name"];
        brand = model.labels[0][@"brand"];
    }

    NSString *sharetitle = [NSString stringWithFormat:@"%@正在求购",model.nickname];
    NSString *content = [NSString stringWithFormat:@"%@\n%@（来自@熟人邦）\n%@",brand,name,model.shortUrl];
    //NSString *content = [NSString stringWithFormat:@"%@",_model.content];
    if (content.length > 140) {
        content = [content substringToIndex:140];
    }
    [ShareViewController shareToThirdPlatformWithUIViewController:self Title:sharetitle SecondTitle:model.content Content:content ImageUrl:model.cover SencondImgUrl:nil Btn:sender ShareUrl:model.shareUrl];
}

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType;
{
    viewController.navigationController.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"#e5005d"];
}
//长草
-(void)showGrassViewWithModel:(BussinessModel *)model {
    [self grassRequest:model];
}
//咨询
-(void)goCommentControllerWithModel:(BussinessModel *)model {
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location != NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
        
    }else{
    TopicCommentListController *vc = [[TopicCommentListController alloc] init];
    vc.navTitle = @"求购咨询";
    vc.backBlock = ^(void) {
        [self.tableView reloadData];
    };
    vc.sourceModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
//同求
-(void)goPublishSPControllerWithModel:(BussinessModel *)model {
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
        PublishSPController *vc = sb.instantiateInitialViewController;
        if (model.labels.count > 0) {
            TPMarkModel *tPMarkModel = [[TPMarkModel alloc] init];
            [tPMarkModel setValuesForKeysWithDictionary:model.labels[0]];
            vc.soureMarkModel = tPMarkModel;
        }
        vc.coverImageUrl = model.cover;
        vc.parentId = model.model_id;
        vc.causeId = model.causeId;
        vc.isFromPublish = NO;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
//接单
-(void)showTakingOrderControllerWithModel:(BussinessModel *)model {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
    TakingOrdersController *vc = [sb instantiateViewControllerWithIdentifier:@"TakingOrdersController"];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window addSubview:vc.view];
    vc.view.frame = app.window.bounds;
    [vc.view addTapAction:@selector(takingPurchasingRemove:) forTarget:self];
    __block typeof(TakingOrdersController *)unSelfTakingOrderVC = vc;
    vc.takingTypeBlock = ^(enum StyleType styleType) {
        [unSelfTakingOrderVC.view removeFromSuperview];
        if (styleType == HelpPurchasing) {
            //if (down_IOS_8) {
                //在iOS8一下不支持push
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
                HelpPurchasingController *vc = [sb instantiateViewControllerWithIdentifier:@"HelpPurchasingController"];
                vc.sourceModel = model;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            //}else {
                //[self performSegueWithIdentifier:@"showHelpPurchasingController" sender:model];
            //}
            
        }else if (styleType == SpotGoods) {
            //if (down_IOS_8) {
                //在iOS8一下不支持push
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
                SpotGoodsController *vc = [sb instantiateViewControllerWithIdentifier:@"SpotGoodsController"];
                vc.sourceModel = model;
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            //}else {
               // [self performSegueWithIdentifier:@"showSpotGoodsController" sender:model];
            //}
            
        }else {
        
        }
    };
}
//删除求购单
-(void)showDeleteViewWithModel:(BussinessModel *)model {
    _deleteBussinessModel = model;
    [self showDeleteAlertView];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showHelpPurchasingController"]) {
        id vc = segue.destinationViewController;
        [vc setValue:sender forKey:@"sourceModel"];
    }else if ([segue.identifier isEqualToString:@"showSpotGoodsController"]) {
        id vc = segue.destinationViewController;
        [vc setValue:sender forKey:@"sourceModel"];
    }
}
#pragma mark- 事件
//长草
-(void)showGrassAlertView {
    //先取消选择栏目
    [AutoDismissAlert autoDismissAlertSecond:@"已经加入草单了哦"];
    return;
    
    if (down_IOS_8) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"已将宝贝加入草单" message:nil delegate:self cancelButtonTitle:@"继续逛" otherButtonTitles:@"去我的草草", nil];
        alert.tag = 1000;
        [alert show];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"已将宝贝加入草单" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"去我的草草" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //[self.navigationController dismissViewController];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"继续逛" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

//删除
-(void)showDeleteAlertView {
    if (down_IOS_8) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除该求购订单？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1001;
        [alert show];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除该求购订单？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteReuqest];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
//接单页面移除
-(void)takingPurchasingRemove:(UIGestureRecognizer *)gr {
    [gr.view removeFromSuperview];
}

//cell 各个btn点击
-(void)cellBtnAction:(enum ActionBtnType) actionBtnType Model:(BussinessModel *)model {
    switch (actionBtnType) {
        case PostionBtn:
        {
            [self goMapViewControllerWithModel:model];
            break;
        }
        case OriginalTextBtn:
        {
            [self goTopicDetailControllerWithModel:model];
            break;
        }
        case ShareBtn:
        {
            
            break;
        }
        case GrassBtn:
        {
            [self showGrassViewWithModel:model];
            break;
        }
        case ConsultBtn:
        {
            [self goCommentControllerWithModel:model];
            break;
        }
        case SameBtn:
        {
            [self goPublishSPControllerWithModel:model];
            break;
        }
        case TakingOrderBtn:
        {
            [self showTakingOrderControllerWithModel:model];
            break;
        }
        case DeleteOrderBtn:
        {
            [self showDeleteViewWithModel:model];
            break;
        }
        case AvaterIV:
        {
            [self showPersonalVCWithModel:model];
            break;
        }
        default:
            break;
    }
}


#pragma mark- alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            //去我的草草
        }
    }else if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self deleteReuqest];
        }
    }
  
}
#pragma mark- tableview delegate
- (BaseSPListCell*)getCellFromIndexPath:(NSIndexPath*)indexPath
{
    //static NSString *CellIdentifier = @"BaseSPListCell";
    //注意在heightForRowAtIndexPath:indexPath无法使用dequeueReusableCellWithIdentifier:forIndexPath:
    BaseSPListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BaseSPListCell"];
    //用dequeueReusableCellWithIdentifier:就得判断Cell为nil的情况
//    if (!cell)
//    {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"BaseSPListCell" owner:self options:nil] lastObject];
//    }
//    
    //这里把数据设置给Cell
    //cell.titleLabel.text = [_dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseSPListCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"BaseSPListCell"];
    //事件
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    __block typeof(BaseSPListCell *)unCell = cell;
    cell.actionBlock = ^(enum ActionBtnType actionBtnType, BussinessModel *model) {
        if (actionBtnType == ShareBtn) {
            [self shareRequest:model Sender:unCell.shareBtn];
            //[self showShareWithModel:model Sender:unCell.shareBtn];
        }else if (actionBtnType == CoverIV){
            [self showImageControllerWithModel:model Sender:unCell.coverIV];
        }else if (actionBtnType == SpreadBtn) {
            //留言高度大于本来高度的时候才支持展开
            if (model.sayHeight - 1.5 * _propertyCell.memoLbl.height > 0) {
            [self spreadMemoWithModel:model Sender:unCell.spreadBtn];
            }
        }
        else {
            [self cellBtnAction:actionBtnType Model:model];
        }
        
    };
    
    BussinessModel *model = _dataArray[indexPath.row];
    cell.sourceModel = model;
    if (_spreadIndex == indexPath.row) {
        cell.spreadBtn.selected = YES;
        [LayoutFrame showViewConstraint:cell.memoLbl AttributeHeight:model.sayHeight];
    }else {
        cell.spreadBtn.selected = NO;
        [LayoutFrame showViewConstraint:cell.memoLbl AttributeHeight:_propertyCell.memoLbl.height];
    }
    
    if (model.sayHeight - 1.5 * _propertyCell.memoLbl.height > 0) {
        cell.spreadBtn.hidden = NO;
    }else {
        cell.spreadBtn.hidden = YES;
    }
    [LayoutFrame showViewConstraint:cell.coverSuperView AttributeHeight:(SCREEN_WIDTH / 320) * _propertyCell.coverSuperView.height];
    
    [cell showMarksView];
    
    //隐藏求购按钮
    if (self.hiddenSPBtn) {
        cell.ordersBtn.hidden = YES;
    }else {
        cell.ordersBtn.hidden = NO;
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 0;
    if (_spreadIndex == indexPath.row) {
        BussinessModel *model = _dataArray[indexPath.row];
        height = model.sayHeight - _propertyCell.memoLbl.height;
    }
    return _propertyCell.height + ((SCREEN_WIDTH / 320.0) - 1) * _propertyCell.coverIV.height + height + 5;
    //获取Cell
//    BaseSPListCell *cell = [self getCellFromIndexPath:indexPath];
//    
//    //更新UIView的layout过程和Autolayout
//    [cell setNeedsUpdateConstraints];
//    [cell updateConstraintsIfNeeded];
//    [cell.contentView setNeedsLayout];
//    [cell.contentView layoutIfNeeded];
//    
//    //通过systemLayoutSizeFittingSize返回最低高度
//    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//    return height;
}
//-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 421.0f;
//}

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
//删除
-(void)deleteReuqest {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:_deleteBussinessModel] inSection:0];
    [_dataArray removeObject:_deleteBussinessModel];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
    
//    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"删除中,请稍后";
//    hud.dimBackground = YES;
//    [hud show:YES];
    // NSString * str = [dataArray[wantDown] model_id];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountDeletePost" parameters:@{ACCOUNT_PASSWORD, @"id": _deleteBussinessModel.model_id}];
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
//长草
-(void)grassRequest:(BussinessModel *)model {
    NSDictionary * param = [self parametersForDic:@"accountCollectPost" parameters:@{ACCOUNT_PASSWORD,@"id":model.causeId}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[AutoDismissAlert autoDismissAlert:@"点赞成功"];
            //长草完成修改数量
            model.favCount = [NSString stringWithFormat:@"%d", [model.favCount intValue] + 1];
            [self.tableView reloadData];
            [self showGrassAlertView];
        }else{
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
        }
    } andFailureBlock:^{
    }];
    
}

- (void)shareRequest:(BussinessModel *)model Sender:(UIButton *)sender
{

    NSDictionary * dic = [self parametersForDic:@"getShortUrl" parameters:@{ACCOUNT_PASSWORD,@"url":model.shareUrl}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            [self showShareWithModel:(BussinessModel *)model Sender:(UIButton *)sender];

        }else if([result isEqualToString:@"4"]){
            NSLog(@"%@", result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }else{

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
