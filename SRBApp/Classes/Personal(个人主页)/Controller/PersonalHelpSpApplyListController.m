//
//  PersonalHelpSpApplyListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/21.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define CELL_HEIGHT 404
#import "PersonalHelpSpApplyListController.h"
#import "PersonalHelpSpApplyCell.h"
#import "MJRefresh.h"
#import "CommonView.h"
#import "LayoutFrame.h"
#import "DetailActivityViewController.h"
#import "NSString+CalculateSize.h"
#import "MyChatViewController.h"
#import "RCUserInfo.h"
#import "PersonalViewController.h"
#import "ImageViewController.h"
#import "CommonHandel.h"
#import "RechargeViewController.h"

static int page = 0;
static int count = NumOfItemsForZuji;

@interface PersonalHelpSpApplyListController ()
{
    PersonalHelpSpApplyCell *_propertyCell;
    int _spreadIndex;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation PersonalHelpSpApplyListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"代购申请";
    _spreadIndex = -1;
    self.dataArray = [NSMutableArray new];
    [self setUpBaseView];
    
    [self.tableView headerBeginRefreshing];
}
#pragma mark- 页面
-(void)setUpBaseView {
    //注册cell
    UINib *nib = [UINib nibWithNibName:@"PersonalHelpSpApplyCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PersonalHelpSpApplyCell"];
    _propertyCell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonalHelpSpApplyCell"];
    self.tableView.tableFooterView = [UIView new];
    //上下拉刷新
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    
    //左导航
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backClicked)];
}
#pragma mark- 事件
-(void)backClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)spreadWithSender:(UIButton *)sender SpreadModel:(BussinessModel *)aModel {
    if (sender.selected) {
        _spreadIndex = -1;
    }else {
        _spreadIndex = (int)[_dataArray indexOfObject:aModel];
    }
    [self.tableView reloadData];
}
#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalHelpSpApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalHelpSpApplyCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.currentVC = self;
    BussinessModel *model = _dataArray[indexPath.row];
    cell.sourceModel = _dataArray[indexPath.row];
    cell.spreadBlock = ^(UIButton *sender, BussinessModel *spreadModel) {
        if (model.sayHeight - _propertyCell.memoLbl.height > 0) {
            [self spreadWithSender:sender SpreadModel:spreadModel];
        }
    };
    cell.chatBlock = ^(BussinessModel *chatModel) {
        MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = chatModel.account;
        user.name = chatModel.nickname;
        user.portraitUri = chatModel.avatar;
        myChatVC.portraitStyle = RCUserAvatarCycle;
        myChatVC.currentTarget = user.userId;
        myChatVC.currentTargetName = user.name;
        myChatVC.type = @"personal";
        myChatVC.conversationType = ConversationType_PRIVATE;
        myChatVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myChatVC animated:YES];
    };
    //个人中心
    cell.avaterIVBlock = ^(NSString *account) {
        PersonalViewController * personVC = [[PersonalViewController alloc]init];
        personVC.account = account;
        personVC.myRun = @"2";
        [self.navigationController pushViewController:personVC animated:YES];
    };
    //图片放大
    cell.photoIVBlock = ^(long tapTag, BussinessModel *photoModel) {
        [self showImageControllerWithModel:photoModel Sender:tapTag];
    };
    //控制图片显示
    if (!cell.sourceModel.photos || cell.sourceModel.photos.length == 0) {
        [LayoutFrame showViewConstraint:cell.coverSV AttributeHeight:1.0];
        //cell.coverSV.hidden = YES;
    }else {
        [LayoutFrame showViewConstraint:cell.coverSV AttributeHeight:_propertyCell.coverSV.height];
        //cell.coverSV.hidden = NO;
    }
    
    if (_spreadIndex == indexPath.row) {
        cell.spreadBtn.selected = YES;
        [LayoutFrame showViewConstraint:cell.memoLbl AttributeHeight:model.sayHeight];
    }else {
        cell.spreadBtn.selected = NO;
        [LayoutFrame showViewConstraint:cell.memoLbl AttributeHeight:_propertyCell.memoLbl.height + 5];
        [cell resetCoversFrame];
    }
    
    if (model.sayHeight - _propertyCell.memoLbl.height > 0) {
        cell.spreadBtn.hidden = NO;
    }else {
        cell.spreadBtn.hidden = YES;
    }
    
    //隐藏操作栏
    if (_hiddenOperation) {
        [cell hideOperateView];
    }
    
    return cell;
}
-(void)showImageControllerWithModel:(BussinessModel *)model Sender:(long)sender {
    ImageViewController * vc = [[ImageViewController alloc]init];
    vc.isDownBtnHide = YES;
    NSMutableArray *tempPhotosArr = [NSMutableArray arrayWithCapacity:0];
    NSArray * photosArr = [model.photos componentsSeparatedByString:@","];
    for (NSString * string in photosArr) {
        NSMutableString *muString = [NSMutableString stringWithString:string];
        [CommonHandel handleScanBigPhoto:muString];
        [tempPhotosArr addObject:muString];
    }
    vc.imgIndex = sender-200+1;
    
    vc.imageUrl = [tempPhotosArr componentsJoinedByString:@","];
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    float height = 0.0;
    //控制图片显示
    BussinessModel *model = _dataArray[indexPath.row];
    if (!model.photos || model.photos.length == 0) {
        height = _propertyCell.height - _propertyCell.coverSV.height + 1;
    }else {
        height = _propertyCell.height;
    }
    
    
    if (_spreadIndex == indexPath.row) {
        
        height += model.sayHeight - _propertyCell.memoLbl.height;
    }
    
    return height;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
#pragma mark- PersonalOrderOperateButtonDelegate mehod
-(void)deleteWithBussinessModel:(BussinessModel *)bussinessModel {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_dataArray indexOfObject:bussinessModel] inSection:0];
    [_dataArray removeObject:bussinessModel];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
}
-(void)receiveWithBussinessModel:(BussinessModel *)bussinessModel {
    //发送通知滚动到待报价
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SPNavScrollToCalculateNF" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
//没钱，跳充值页面
-(void)noMoneyWithBussinessModel {
    RechargeViewController *vc = [[RechargeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 网络请求
-(void)headerRefresh {
    [self loadNewDataListRequest];
}

-(void)footerRefresh {
    [self loadMoreDataListRequest];
}
//最新话题列表
- (void)loadNewDataListRequest
{
    page = 0;
    
    NSDictionary * param = [self parametersForDic:@"getPostTaskByRelation" parameters:@{ACCOUNT_PASSWORD, @"id": _modelID, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                NSLog(@"frame = %@", NSStringFromCGRect(_propertyCell.memoLbl.frame));
                bussinessModel.sayHeight = [bussinessModel.message calculateSize:CGSizeMake(_propertyCell.memoLbl.frame.size.width + (SCREEN_WIDTH - 320), FLT_MAX) font:_propertyCell.memoLbl.font].height;
                NSLog(@"frame = %f", bussinessModel.sayHeight);
                [self.dataArray addObject:bussinessModel];
            }
            
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
    
}
//更多话题列表
- (void)loadMoreDataListRequest
{
    page += NumOfItemsForZuji;

    NSDictionary * param = [self parametersForDic:@"getPostTaskByRelation" parameters:@{ACCOUNT_PASSWORD, @"id": _modelID, @"start":[NSString stringWithFormat:@"%d", page], @"count":[NSString stringWithFormat:@"%d",count]}];
    
    //    NSDictionary * param = [self parametersForDic:@"getPostListByCategory" parameters:@{ACCOUNT_PASSWORD,@"type":@"1042",@"categoryID":categoryID, @"order": @"postid", @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                bussinessModel.sayHeight = [bussinessModel.message calculateSize:CGSizeMake(_propertyCell.frame.size.width + (SCREEN_WIDTH - 320), FLT_MAX) font:_propertyCell.memoLbl.font].height;
                [self.dataArray addObject:bussinessModel];
                if (self.dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [self.dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [self.tableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [self.tableView footerEndRefreshing];
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
