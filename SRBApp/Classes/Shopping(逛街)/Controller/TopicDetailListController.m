//
//  TopicDetailListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define CELL_HEIGHT 410 + SCREEN_WIDTH / 320.0 * 228  - 228

#import "TopicDetailListController.h"
#import "TopicDetailListCell.h"
#import "TopicListCell.h"
#import "AppDelegate.h"
#import "TopicDetailListGoodsCell.h"
#import "TopicDetailListFooterView.h"
#import "TopicCommentListController.h"
#import "LayoutFrame.h"
#import "TopicCommentModel.h"
#import "MarkTopicListController.h"
#import "ShareViewController.h"
#import "LayoutFrame.h"
#import "ImageViewController.h"
#import "PersonalViewController.h"
#import "ReportViewController.h"
#import "TopicDetailModel.h"
#import "CommonHandel.h"
#import "MapViewController.h"

@interface TopicDetailListController ()
{
    TopicListCell *_headerView;
    TopicDetailListFooterView *_footerView;
    BussinessModel *_bussinessModel;
    
    NSMutableArray *_tagsArray;
    NSDictionary *_commentsDict;
    NSDictionary *_praiseDict;
    //检测点赞评论数量是否发生变化来刷新首页
    BOOL _isSourceModelUpdate;
    MBProgressHUD *HUD;
    int i;
}
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation TopicDetailListController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpView];
    _isSourceModelUpdate = NO;
    if (_sourceModal) {
        _modelId = _sourceModal.model_id;
    }
    [self loadTopicDetailListRequest];
    
}

#pragma mark- 页面
-(void)setUpView {
    //左导航
    self.title = @"话题详情";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
}
//右导航
-(void)setRightNavbar {
    if ([ACCOUNT_SELF isEqualToString:_bussinessModel.account]) {
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 0, 25, 25);
        [button1 addTarget:self action:@selector(deleteAndChange:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setImage:[UIImage imageNamed:@"topic_detail_delete"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    }
}

-(void)setTableHeaderView {
    TopicListCell *header = [[[NSBundle mainBundle] loadNibNamed:@"TopicListCell" owner:self options:nil] objectAtIndex:0];
    header.coverIV.userInteractionEnabled = YES;
    [header.coverIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headerCvoerTapAction:)]];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [paragraphStyle setLineSpacing:4];
    [paragraphStyle setParagraphSpacing:10];
    NSDictionary *attriDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName: paragraphStyle};
    _bussinessModel.attr_content = [[NSAttributedString alloc] initWithString:_bussinessModel.content attributes:attriDict];
    _bussinessModel.attr_title = [[NSAttributedString alloc] initWithString:_bussinessModel.title attributes:attriDict];
    
    header.bussinessModel = _bussinessModel;
    header.contentLbl.attributedText = _bussinessModel.attr_content;
    header.contentView.backgroundColor = [UIColor whiteColor];
    header.lineIV.hidden = NO;
    
    CGSize sizeTitle = [header.titleLbl sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000)];
    //CGSize sizeTitle = [_bussinessModel.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    CGSize size = [header.contentLbl sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000)];
    //CGSize size = [_bussinessModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:13]} context:nil].size;
    float ivHeight = header.coverIV.height * (SCREEN_WIDTH / 320);
    
    header.height = [header.markView fittedSize].height - 47 + 10 + CELL_HEIGHT + size.height + sizeTitle.height -header.titleLbl.height - header.contentLbl.height + 10;
    [LayoutFrame showViewConstraint:header.contentLbl AttributeHeight:size.height];
    [LayoutFrame showViewConstraint:header.titleLbl AttributeHeight:sizeTitle.height];
    [LayoutFrame showViewConstraint:header.coverIV AttributeHeight:ivHeight];
    [LayoutFrame showViewConstraint:header.markView AttributeHeight:[header.markView fittedSize].height];
    
    //header.frame = CGRectMake(0, 0, SCREEN_WIDTH, CELL_HEIGHT + size.height + sizeTitle.height -header.titleLbl.height - header.contentLbl.height);
    
    [self.tableView setTableHeaderView:header];
    //标签点击
    __block typeof(self) unself = self;
    header.tagClickedBlock = ^(NSString *aTag) {
        MarkTopicListController *vc = [[MarkTopicListController alloc] init];
        vc.tagName = aTag;
        [unself.navigationController pushViewController:vc animated:YES];
    };
    //头像点击
    header.avaterClickedBlock = ^(NSString *account) {
        PersonalViewController * personVC = [[PersonalViewController alloc]init];
        personVC.account = account;
        personVC.myRun = @"2";
        [unself.navigationController pushViewController:personVC animated:YES];
    };
    
    
    _headerView = header;
}
-(void)setTableFooterView {
    TopicDetailListFooterView *footer = [[TopicDetailListFooterView alloc] init];
    footer.marksArray = _tagsArray;
    footer.commentsDict = _commentsDict;
    footer.praiseDict = _praiseDict;
    footer.sourceModel = _bussinessModel;
    footer.view.height = footer.height;
    [self.tableView setTableFooterView:footer.view];
    [self addChildViewController:footer];
    [footer.loadMoreCommentBtn addTarget:self action:@selector(goTopicCommentListVC) forControlEvents:UIControlEventTouchUpInside];
    [footer.commentSuperView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goTopicCommentListVC)]];
    footer.commentTF.delegate = self;
    _footerView = footer;
    __block typeof(self) unself = self;
    
    //标签
    _footerView.markViewTapBlock = ^(NSDictionary *dataDict) {
        MarkTopicListController *vc = [[MarkTopicListController alloc] init];
        vc.tagName = dataDict[@"name"];
        [unself.navigationController pushViewController:vc animated:YES];
    };
    //头像点击
    _footerView.avaterClickedBlock = ^(NSString *account) {
        PersonalViewController * personVC = [[PersonalViewController alloc]init];
        personVC.account = account;
        personVC.myRun = @"2";
        [unself.navigationController pushViewController:personVC animated:YES];
    };
    //举报
    [_footerView.reportBtn addTarget:self action:@selector(reportBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //位置
    [_footerView.locationView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(locationClicked:)]];
}
#pragma mark- 数据
-(void)fillData {
    if ([_bussinessModel.isLike isEqualToString:@"1"]) {
        self.praiseBtn.selected = YES;
        [self.praiseBtn setImage:[UIImage imageNamed:@"topic_detail_praise_selected"] forState:UIControlStateNormal];
    }else {
        self.praiseBtn.selected = NO;
        [self.praiseBtn setImage:[UIImage imageNamed:@"topic_detail_praise_normal"] forState:UIControlStateNormal];
    }
    if ([_bussinessModel.isCollected isEqualToString:@"1"]) {
        self.collectBtn.selected = YES;
    }else {
        self.collectBtn.selected = NO;
    }
}
-(void)setDataArray:(NSArray *)dataArray {
    _dataArray = [NSMutableArray array];
    
    for (NSDictionary *dict in dataArray) {
        TopicDetailModel *model = [[TopicDetailModel alloc] init];
        [model setValuesForKeysWithDictionary:dict];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
        [paragraphStyle setLineSpacing:4];
        [paragraphStyle setParagraphSpacing:10];
        NSDictionary *attriDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName: paragraphStyle};
        CGSize size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attriDict context:nil].size;
        
        if (size.height > 18 + 4) {
            model.attrContentHeight = size.height + 18 + 2 * 4;
        }else {
            model.attrContentHeight = size.height;
        }
        
        model.attrContent = [[NSAttributedString alloc] initWithString:model.content attributes:attriDict];
        [_dataArray addObject:model];
    }
}
-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
}
#pragma mark- 跳转
-(void)goTopicCommentListVC {
    TopicCommentListController *vc = [[TopicCommentListController alloc] init];
    vc.backBlock = ^(void){
        TopicListCell *header = (TopicListCell *)self.tableView.tableHeaderView;
        self.sourceModal.consultCount = _bussinessModel.consultCount;
        header.bussinessModel = _bussinessModel;
        _isSourceModelUpdate = YES;
        [self loadCommentsListRequest];
    };
    vc.sourceModel = _bussinessModel;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)goTopicCommentListVCWithCommen {
    TopicCommentListController *vc = [[TopicCommentListController alloc] init];
    vc.isCommon = YES;
    vc.backBlock = ^(void){
        TopicListCell *header = (TopicListCell *)self.tableView.tableHeaderView;
        self.sourceModal.consultCount = _bussinessModel.consultCount;
        header.bussinessModel = _bussinessModel;
        _isSourceModelUpdate = YES;
        [self loadCommentsListRequest];
    };
    vc.sourceModel = _bussinessModel;
    [self.navigationController pushViewController:vc animated:YES];
}
//举报按钮
-(void)reportBtnClicked:(UIButton *)sender {
        ReportViewController * vc = [[ReportViewController alloc]init];
        vc.idNumber = _sourceModal.model_id;
        //    vc.imageArr = _imageArr;
        //    vc.photos = _model.photos;
        [self umengEvent:@"jubao" attributes:@{@"state" : @"举报"} number:@(0)];
        [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 事件
- (void)locationClicked:(UITapGestureRecognizer *)tap
{

    MapViewController *mapVC = [[MapViewController alloc] init];
    if (![_bussinessModel.positionxyz isEqualToString:@"0"] && ![_bussinessModel.positionxyz isEqualToString:@""] && _bussinessModel.positionxyz != nil) {
        NSArray *positionArr = [_bussinessModel.positionxyz componentsSeparatedByString:@","];
        if (positionArr.count >= 2) {
            mapVC.lat = [[positionArr objectAtIndex:0] doubleValue];
            mapVC.lon = [[positionArr objectAtIndex:1]doubleValue];
        }
        
        mapVC.address = _bussinessModel.location;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}
- (void)deleteAndChange:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];//UIActionSheet初始化，并设置delegate
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
}
-(void)backBtnClicked:(UIButton *)sender {
    if (_isSourceModelUpdate && self.backBlock) {
        self.backBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)praiseBtnClicked:(id)sender {
    if (!_bussinessModel) {
        return;
    }
//    [self.praiseBtn setImage:[UIImage imageNamed:(i%2==0?@"topic_detail_praise_selected":@"topic_detail_praise_normal")] forState:UIControlStateNormal];
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
   // i++;
    [self.praiseBtn.layer addAnimation:k forKey:@"SHOW"];
    [self praiseRequest];
}

- (IBAction)collectBtnClicked:(id)sender {
    if (!_bussinessModel) {
        return;
    }
    [self collectRequest];
}
- (IBAction)shareBtnClicked:(id)sender {
    if (!_bussinessModel) {
        return;
    }
    [ShareViewController shareToThirdPlatformWithUIViewController:self Title:_bussinessModel.title SecondTitle:_bussinessModel.content Content:_bussinessModel.model_description ImageUrl:_bussinessModel.cover SencondImgUrl:nil Btn:sender ShareUrl:_bussinessModel.shareUrl];
}
- (void)headerCvoerTapAction:(UIGestureRecognizer *)gr
{
    NSString *photos = [_bussinessModel.photos stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (photos.length == 0) {
        photos = _bussinessModel.cover;
    }
    [self showImageControllerWithPhotos:photos];
}

- (void)cvoerTapAction:(UIGestureRecognizer *)gr
{
    TopicDetailModel *model = _dataArray[gr.view.tag - 100];
    NSString *photos = [model.photos stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (photos.length == 0) {
        photos = model.cover;
    }
    [self showImageControllerWithPhotos:photos];
}
-(void)showImageControllerWithPhotos:(NSString *)photos {
    ImageViewController * vc = [[ImageViewController alloc]init];
    vc.isDownBtnHide = YES;
    NSMutableArray *tempPhotosArr = [NSMutableArray arrayWithCapacity:0];
    NSArray * photosArr = [photos componentsSeparatedByString:@","];
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
#pragma textfiled delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _footerView.commentTF) {
        [self goTopicCommentListVCWithCommen];
        return NO;
    }
    return YES;
}
#pragma actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
            
        case 0:
            [self deleteRequest];
            break;
        default:
            break;
    }
}

#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        static NSString *cellID = @"TopicDetailListCell";
        TopicDetailListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        TopicDetailModel *model = [_dataArray objectAtIndex:indexPath.row];
        cell.sourceData = model;
        [cell.coverIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cvoerTapAction:)]];
        
        [LayoutFrame showViewConstraint:cell.contentLbl AttributeHeight:model.attrContentHeight];
        [LayoutFrame showViewConstraint:cell.coverIV AttributeHeight:SCREEN_WIDTH / 320.0 * 228];
        cell.coverIV.tag = 100 + indexPath.row;
        return cell;
    }else {
        static NSString *cellID = @"TopicDetailListGoodsCell";
        TopicDetailListGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
        }
        //cell.bussinessModel = [_dataArray objectAtIndex:indexPath.row];
        return cell;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.dataArray.count) {
        TopicDetailModel *model = _dataArray[indexPath.row];
        return SCREEN_WIDTH / 320.0 * 262 + model.attrContentHeight - 17.0;
    }else {
        return 104;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark- 网络请求
//标签
- (void)deleteRequest
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex == 1) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"删除中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            //拼接post参数
            NSDictionary * dic = [self parametersForDic:@"accountDeletePost" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
            
            //发送post请求
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
                [HUD removeFromSuperview];
                //                NSLog(@"%@",[dic objectForKey:@"message"]);
                int result = [[dic objectForKey:@"result"]intValue];
                if (result == 0) {
                    //刷新个人主页话题数量
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPersonalPublishCountNF" object:nil];
                    if (self.deleteBlock) {
                        self.deleteBlock(self.sourceModal);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                }
            }];
        }

}
- (void)loadTagListRequest {
    if (!_bussinessModel) {
        return;
    }
    NSDictionary * param = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"10", @"type": @"1042", @"tags": _bussinessModel.tags}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _tagsArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
        }else if ([result isEqualToString:@"0"]) {
            _tagsArray = nil;
        }
        //标签加载完成
        [self loadPraiseListRequest];
    } andFailureBlock:^{
        
    }];
    
    
}
//赞
- (void)loadPraiseListRequest {
    if (!_bussinessModel) {
        return;
    }
    NSDictionary * param = [self parametersForDic:@"getPostCollectedByRelation" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"50", @"id": _bussinessModel.model_id}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _praiseDict = [dic objectForKey:@"data"];
        }else if ([result isEqualToString:@"4"]) {
            _praiseDict = nil;
        }
        //标签加载完成
        [self setTableFooterView];
    } andFailureBlock:^{
        
    }];
    
    
}
//评论
- (void)loadCommentsListRequest
{
    if (!_bussinessModel) {
        return;
    }
    NSDictionary * param = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD,@"isFriended":@"0",@"id":_bussinessModel.model_id, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",3]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _commentsDict = dic;
        }else if([result isEqualToString:@"4"]){
                _commentsDict = nil;
        }else{
            
        }
        [self loadTagListRequest];
    } andFailureBlock:^{

    }];
    
}

//话题详情
-(void)loadTopicDetailListRequest {
    NSDictionary *param = [self parametersForDic:@"getPostDetail" parameters:@{ACCOUNT_PASSWORD, @"id": _modelId}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString *result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            BussinessModel *model = [[BussinessModel alloc] init];
            [model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            _bussinessModel = model;
            [self fillData];
            [self setTableHeaderView];
            [self setRightNavbar];
            self.dataArray = [NSMutableArray arrayWithArray:model.goods];
            [self.tableView reloadData];
        }else {
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
        }
        
        [self loadCommentsListRequest];
    } andFailureBlock:^{
        
    }];
}
//点赞
-(void)praiseRequest {
    if (!_bussinessModel) {
        return;
    }
    BussinessModel *model = _bussinessModel;
    NSString *url = @"accountLikePost";
    if ([model.isLike isEqualToString:@"1"]) {
        //已经点过赞，取消点赞
        url = @"accountDeleteLikedPost";
    }
    NSDictionary * param = [self parametersForDic:url parameters:@{ACCOUNT_PASSWORD,@"id":model.model_id, @"order": @"postid"}];
    _praiseBtn.userInteractionEnabled = NO;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[AutoDismissAlert autoDismissAlert:@"点赞成功"];
            if ([model.isLike isEqualToString:@"1"]) {
                model.likeCount = [NSString stringWithFormat:@"%d", [model.likeCount intValue] > 0 ? [model.likeCount intValue] - 1 : 0];
                model.isLike = @"0";
                //非话题列表页面进入
                if (self.sourceModal) {
                    self.sourceModal.likeCount = [NSString stringWithFormat:@"%d", [self.sourceModal.likeCount intValue] > 0 ? [self.sourceModal.likeCount intValue] - 1 : 0];
                }
                
                
            }else {
                model.likeCount = [NSString stringWithFormat:@"%d", [model.likeCount intValue] + 1];
                //非话题列表页面进入
                if (self.sourceModal) {
                    self.sourceModal.likeCount = [NSString stringWithFormat:@"%d", [self.sourceModal.likeCount intValue] + 1];
                }
                
                model.isLike = @"1";
            }
            _isSourceModelUpdate = YES;
            [self loadPraiseListRequest];
            [self fillData];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }
        _praiseBtn.userInteractionEnabled = YES;
    } andFailureBlock:^{
        _praiseBtn.userInteractionEnabled = YES;
    }];
}
//收藏
-(void)collectRequest {
    if (!_bussinessModel) {
        return;
    }
    BussinessModel *model = _bussinessModel;
    NSString *url = @"accountCollectPost";
    if ([model.isCollected isEqualToString:@"1"]) {
        //已经点过赞，取消点赞
        url = @"accountDeleteCollectedPost";
    }
    NSDictionary * param = [self parametersForDic:url parameters:@{ACCOUNT_PASSWORD,@"id":model.model_id}];
    _collectBtn.userInteractionEnabled = NO;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[AutoDismissAlert autoDismissAlert:@"点赞成功"];
            if ([model.isCollected isEqualToString:@"1"]) {
                model.isCollected = @"0";
            }else {
                model.isCollected = @"1";
            }
            [self fillData];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }
        _collectBtn.userInteractionEnabled = YES;
    } andFailureBlock:^{
        _collectBtn.userInteractionEnabled = YES;
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
