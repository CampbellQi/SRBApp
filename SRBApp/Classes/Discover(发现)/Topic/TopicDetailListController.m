//
//  TopicDetailListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define CELL_HEIGHT 410 + SCREEN_WIDTH / 320.0 * 228  - 228

#define MAINCELL @"maincell"
#define ATTACHCELL @"attachcell"

#import "TopicDetailListController.h"
#import "TopicDetailListImageCell.h"
#import "TopicDetailListTextCell.h"
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
#import "TopicDetailHeaderView.h"
#import "TopicDetailToolbarCell.h"
#import "TopicDetailSPListController.h"
#import "PublishSPController.h"
#import "WQGuideView.h"
#import "NSString+CalculateSize.h"

@interface TopicDetailListController ()<ISSShareViewDelegate>
{
    TopicListCell *_headerView;
    TopicDetailListFooterView *_footerView;
    BussinessModel *_bussinessModel;
    UIButton * sharebtn;
    
    NSMutableArray *_tagsArray;
    NSDictionary *_commentsDict;
    NSDictionary *_praiseDict;
    //检测点赞评论数量是否发生变化来刷新首页
    BOOL _isSourceModelUpdate;
    MBProgressHUD *HUD;
    int i;
    
    TopicDetailSPListController *_spList;
    
    TopicDetailListImageCell *_proertyImageCell;
    TopicDetailListTextCell *_propertyTextCell;
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
    if (_sourceModel) {
        _modelId = _sourceModel.model_id;
    }
    [self loadTopicDetailListRequest];

    [[WQGuideView share] showAtIndex:9 GuideViewRemoveBlock:nil];
}

#pragma mark- 页面
-(void)setUpView {
    //注册cell
    UINib *imageNib = [UINib nibWithNibName:@"TopicDetailListImageCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:imageNib forCellReuseIdentifier:@"TopicDetailListImageCell"];
    _proertyImageCell = [self.tableView dequeueReusableCellWithIdentifier:@"TopicDetailListImageCell"];
    
    UINib *textNib = [UINib nibWithNibName:@"TopicDetailListTextCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:textNib forCellReuseIdentifier:@"TopicDetailListTextCell"];
    _propertyTextCell = [self.tableView dequeueReusableCellWithIdentifier:@"TopicDetailListTextCell"];
    
    UINib *toolbarNib = [UINib nibWithNibName:@"TopicDetailToolbarCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:toolbarNib forCellReuseIdentifier:@"TopicDetailToolbarCell"];
    
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
        
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 65, 25)];
        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        button1.frame = CGRectMake(0, 0, 25, 25);
        [button1 addTarget:self action:@selector(deleteAndChange:) forControlEvents:UIControlEventTouchUpInside];
        [button1 setImage:[UIImage imageNamed:@"topic_detail_delete"] forState:UIControlStateNormal];
        [view addSubview:button1];
        
        //UIButton * sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebtn.frame = CGRectMake(40, 0, 25, 25);
        [sharebtn addTarget:self action:@selector(shareRequest) forControlEvents:UIControlEventTouchUpInside];
        [sharebtn setImage:[UIImage imageNamed:@"topic_detail_share"] forState:UIControlStateNormal];
        [view addSubview:sharebtn];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];

    }else{

        //UIButton * sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sharebtn.frame = CGRectMake(0, 0, 25, 25);
        [sharebtn addTarget:self action:@selector(shareRequest) forControlEvents:UIControlEventTouchUpInside];
        [sharebtn setImage:[UIImage imageNamed:@"topic_detail_share"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:sharebtn];
    }
}

-(void)setTableHeaderView {
    TopicDetailHeaderView *header = [[TopicDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104)];
    header.bussinessModel = _bussinessModel;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [paragraphStyle setLineSpacing:4];
    [paragraphStyle setParagraphSpacing:10];
    NSDictionary *attriDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName: paragraphStyle};
    _bussinessModel.attr_title = [[NSAttributedString alloc] initWithString:_bussinessModel.title attributes:attriDict];
    
    CGSize sizeTitle = [header.titleLbl sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000)];

    header.height = [header.markView fittedSize].height + sizeTitle.height + header.height - header.markView.height - header.timeLbl.height;
    [LayoutFrame showViewConstraint:header.titleLbl AttributeHeight:sizeTitle.height];
    [LayoutFrame showViewConstraint:header.markView AttributeHeight:[header.markView fittedSize].height];
    
    self.tableView.tableHeaderView = header;
    
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
        model.cell = MAINCELL;
        [model setValuesForKeysWithDictionary:dict];
        
        if ([model.photo isEqualToString:@"1"] && model.content.length) {
            //有图，有文字
            TopicDetailModel *newModel1 = [[TopicDetailModel alloc] init];
            newModel1.cell = MAINCELL;
            [newModel1 setValuesForKeysWithDictionary:dict];
            newModel1.content = @"";
            [_dataArray addObject:newModel1];
            
            TopicDetailModel *newModel2 = [[TopicDetailModel alloc] init];
            newModel2.cell = MAINCELL;
            [newModel2 setValuesForKeysWithDictionary:dict];
            newModel2.photo = @"0";
            [self calcuateAttributeString:newModel2];
            [_dataArray addObject:newModel2];
        }else if ([model.photo isEqualToString:@"1"]){
            //只有图
            [_dataArray addObject:model];
        }else if (model.content.length){
            //只文字
            [self calcuateAttributeString:model];
            [_dataArray addObject:model];
        }
    }
    //判断是否是老话题，做兼容
    if (_bussinessModel.content.length) {
        //原来的主话题
        TopicDetailModel *model0 = [[TopicDetailModel alloc] init];
        model0.content = _bussinessModel.content;
        model0.cover = _bussinessModel.cover;
        model0.cell = MAINCELL;
        model0.model_description = _bussinessModel.model_description;
        model0.model_id = model0.model_id;
        model0.tags = _bussinessModel.tags;
        model0.labels = _bussinessModel.labels;
        [self calcuateAttributeString:model0];
        model0.photo = @"0";
        [_dataArray insertObject:model0 atIndex:0];
        
        TopicDetailModel *model = [[TopicDetailModel alloc] init];
        model.content = _bussinessModel.content;
        model.cover = _bussinessModel.cover;
        model.cell = MAINCELL;
        model.model_description = _bussinessModel.model_description;
        model.model_id = model.model_id;
        model.tags = _bussinessModel.tags;
        model.labels = _bussinessModel.labels;
        model.photo = @"1";
        [_dataArray insertObject:model atIndex:0];
    }
}
-(void)calcuateAttributeString:(TopicDetailModel *)model {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [paragraphStyle setLineSpacing:4];
    [paragraphStyle setParagraphSpacing:10];
    NSDictionary *attriDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName: paragraphStyle};
    CGSize size = [model.content calculateSize:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000) Attributes:attriDict];
//    CGSize size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attriDict context:nil].size;
    
    model.attrContentHeight = size.height;
    
    model.attrContent = [[NSAttributedString alloc] initWithString:model.content attributes:attriDict];
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
        self.sourceModel.consultCount = _bussinessModel.consultCount;
        header.bussinessModel = _bussinessModel;
        _isSourceModelUpdate = YES;
        [self loadCommentsListRequest];
    };
    vc.sourceModel = _bussinessModel;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)goTopicCommentListVCWithCommen {
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
    TopicCommentListController *vc = [[TopicCommentListController alloc] init];
    vc.isCommon = YES;
    vc.backBlock = ^(void){
        TopicListCell *header = (TopicListCell *)self.tableView.tableHeaderView;
        self.sourceModel.consultCount = _bussinessModel.consultCount;
        header.bussinessModel = _bussinessModel;
        _isSourceModelUpdate = YES;
        [self loadCommentsListRequest];
    };
    vc.sourceModel = _bussinessModel;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
//举报按钮
-(void)reportBtnClicked:(UIButton *)sender {
        ReportViewController * vc = [[ReportViewController alloc]init];
        vc.idNumber = _sourceModel.model_id;
        //    vc.imageArr = _imageArr;
        //    vc.photos = _model.photos;
        [self umengEvent:@"jubao" attributes:@{@"state" : @"举报"} number:@(0)];
        [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareBtn:(id)sender
{
        if (!_bussinessModel) {
            return;
        }
    NSArray *marksArray = [_bussinessModel.tags componentsSeparatedByString:@","];
    NSMutableArray * attribuArr = [NSMutableArray array];
    NSString *newString;
    for (NSString * str in marksArray) {
        if (![str isEqualToString:@""] && str.length != 0) {
            NSString * tempStr = [NSString stringWithFormat:@"#%@#",str];
            [attribuArr addObject:tempStr];
            newString = [attribuArr componentsJoinedByString:@" "];
        }
    }
   
    NSString *content = [NSString stringWithFormat:@"%@ %@（来自@熟人邦）%@",newString,_bussinessModel.title, _bussinessModel.shortUrl];
    //NSString *content = [NSString stringWithFormat:@"%@",_model.content];
    if (content.length > 140) {
        content = [content substringToIndex:140];
    }
        [ShareViewController shareToThirdPlatformWithUIViewController:self Title:_bussinessModel.title SecondTitle:_bussinessModel.content Content:content ImageUrl:_bussinessModel.cover SencondImgUrl:nil Btn:sender ShareUrl:_bussinessModel.shareUrl];
    
//    [ShareViewController shareToThirdPlatformWithUIViewController:self Account:_bussinessModel.account Nickname:_bussinessModel.nickname Avatar:_bussinessModel.avatar Cover:_bussinessModel.cover IdNumber:nil Title:_bussinessModel.title Content:content Photo:_bussinessModel.photo Btn:sender ShareUrl:_bussinessModel.shareUrl];
}

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType;
{
    viewController.navigationController.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"#e5005d"];
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
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
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
}

//- (IBAction)collectBtnClicked:(id)sender {
//    if (!_bussinessModel) {
//        return;
//    }
//    [self collectRequest];
//}
//- (IBAction)shareBtnClicked:(id)sender {
//    if (!_bussinessModel) {
//        return;
//    }
//    [ShareViewController shareToThirdPlatformWithUIViewController:self Title:_bussinessModel.title SecondTitle:_bussinessModel.content Content:_bussinessModel.model_description ImageUrl:_bussinessModel.cover SencondImgUrl:nil Btn:sender ShareUrl:_bussinessModel.shareUrl];
//}
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
//菜单栏点击
-(void)toolBarClicked:(enum BtnType)btnType Model:(TopicDetailModel *)model{
    switch (btnType) {
        case purchiseBtn:
            [self purchiseBtnClicked:model];
            break;
        case usedBtn:
            [self usedBtnClicked:model];
            break;
        case grassBtn:
            [self grassBtnClicked:model];
            break;
        case turnBtn:
            [self turnBtnClicked:model];
            break;
        default:
            break;
    }
}
//求购
-(void)purchiseBtnClicked:(TopicDetailModel *)model {
    if (model.labels.count == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"没有标签的话题不能求购哦"];
    }else if (model.labels.count == 1) {
        TPMarkModel *markModel = [[TPMarkModel alloc] init];
        [markModel setValuesForKeysWithDictionary:model.labels[0]];
        [self showPublishSPControllerWithTopicDetailModel:model TPMarkModel:markModel];
    }else {
        TopicDetailSPListController *vc = [[TopicDetailSPListController alloc] init];
        vc.topicDetailModel = model;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:vc.view];
        vc.view.frame = app.window.bounds;
        [vc.backBtn addTarget:self action:@selector(spListRemoveClicked) forControlEvents:UIControlEventTouchUpInside];
        [vc.completeBtn addTarget:self action:@selector(spListCompleteClicked) forControlEvents:UIControlEventTouchUpInside];
        _spList = vc;
    }
    
}
//移除求购
-(void)spListRemoveClicked {
    [_spList.view removeFromSuperview];
}
//求购选择标签完成
-(void)spListCompleteClicked {
    if (!_spList.selectedMarkModel) {
        [AutoDismissAlert autoDismissAlertSecond:@"请选择一个标签"];
        return;
    }
    [self showPublishSPControllerWithTopicDetailModel:_spList.topicDetailModel TPMarkModel:_spList.selectedMarkModel];
    [self spListRemoveClicked];
}
//长草选择标签完成
-(void)spListCompleteClicked2 {
    if (!_spList.selectedMarkModel) {
        [AutoDismissAlert autoDismissAlertSecond:@"请选择一个标签"];
        return;
    }
    
    [self spListRemoveClicked];
    [self grassRequestGoodsId:_spList.selectedMarkModel.goodsId TopicDetailModel:_spList.topicDetailModel];
}
-(void)showPublishSPControllerWithTopicDetailModel:(TopicDetailModel *)topicDetailModel TPMarkModel:(TPMarkModel *)tPMarkModel {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"SeekingPurchasing" bundle:[NSBundle mainBundle]];
    PublishSPController * vc = sb.instantiateInitialViewController;
    vc.soureMarkModel = tPMarkModel;
    vc.coverImageUrl = topicDetailModel.cover;
    vc.parentId = _bussinessModel.model_id;
    vc.causeId = tPMarkModel.goodsId;
    vc.isFromPublish = NO;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//用过
-(void)usedBtnClicked:(TopicDetailModel *)model{
    
}
//长草
-(void)grassBtnClicked:(TopicDetailModel *)model{
    if (model.labels.count == 1) {
        TPMarkModel *markModel = [[TPMarkModel alloc] init];
        [markModel setValuesForKeysWithDictionary:model.labels[0]];
        [self grassRequestGoodsId:markModel.goodsId TopicDetailModel:model];
    }else if (model.labels.count > 1) {
        TopicDetailSPListController *vc = [[TopicDetailSPListController alloc] init];
        vc.topicDetailModel = model;
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app.window addSubview:vc.view];
        vc.view.frame = app.window.bounds;
        [vc.backBtn addTarget:self action:@selector(spListRemoveClicked) forControlEvents:UIControlEventTouchUpInside];
        [vc.completeBtn addTarget:self action:@selector(spListCompleteClicked2) forControlEvents:UIControlEventTouchUpInside];
        _spList = vc;
    }
    
}
//转需
-(void)turnBtnClicked:(TopicDetailModel *)model{
    
}
//长草完成显示
-(void)showGrassAlertView {
    //先取消选择栏目
    [AutoDismissAlert autoDismissAlertSecond:@"已经加入草单了哦"];
    return;
    
    if (down_IOS_8) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"已将宝贝加入草单" message:nil delegate:self cancelButtonTitle:@"继续逛" otherButtonTitles:@"去我的草草", nil];
        alert.tag = 1001;
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
#pragma mark- alert view delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            //去我的草草
        }
    }else if (alertView.tag == 1000) {
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
                        self.deleteBlock(self.sourceModel);
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                }
            }];
        }
    }
    
}
#pragma mark- textfiled delegate
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailModel *model = [_dataArray objectAtIndex:indexPath.row];
    if ([model.cell isEqualToString:ATTACHCELL]) {
        NSString *cellID = @"TopicDetailToolbarCell";
        TopicDetailToolbarCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        cell.sourceModel = _dataArray[indexPath.row + 1];
        cell.btnClickedBlock = ^(enum BtnType btnType, TopicDetailModel *model){
            if ([ACCOUNT_SELF rangeOfString:@"guest"].location != NSNotFound) {
                AppDelegate *app = APPDELEGATE;
                [app showLoginAlertView];
            }else{
            [self toolBarClicked:btnType Model:model];
            }
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }else {
        if ([model.photo isEqualToString:@"1"]) {
            NSString *cellID = @"TopicDetailListImageCell";
            TopicDetailListImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.sourceData = model;
            [cell.coverIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cvoerTapAction:)]];
            [cell showMarksView];
            cell.coverIV.tag = 100 + indexPath.row;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else {
            NSString *cellID = @"TopicDetailListTextCell";
            TopicDetailListTextCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            cell.contentLbl.attributedText = model.attrContent;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicDetailModel *model = _dataArray[indexPath.row];
    if ([model.cell isEqualToString:ATTACHCELL]) {
        return 44.0f;
    }else {
        if ([model.photo isEqualToString:@"1"]) {
            float height = CGRectGetHeight(_proertyImageCell.frame) * (SCREEN_WIDTH / 320.0f);
            NSLog(@"height = %f", height);
            return height;
        }else if(model.content.length != 0) {
            return CGRectGetHeight(_propertyTextCell.frame) + model.attrContentHeight - CGRectGetHeight(_propertyTextCell.contentLbl.frame);
        }else {
            return 1;
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSIndexPath *path = indexPath;
    TopicDetailModel *model = [self.dataArray objectAtIndex:indexPath.row];
    if (model.labels.count == 0) {
        return;
    }
    
    if (model.isAttached) {
        //_isToolbarOpen = NO;
        //TopicDetailModel *tempModel = self.dataArray[path.row-1];
        model.isAttached = NO;
        //tempModel.cell = MAINCELL;
        
        
        [self.dataArray removeObjectAtIndex:path.row-1];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:(indexPath.row-1) inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
    }else {
        //_isToolbarOpen = YES;
        TopicDetailModel *tempModel = [[TopicDetailModel alloc] init];
        tempModel.quotes = model.quotes;
        tempModel.favCount = model.favCount;
        tempModel.isAttached = YES;
        tempModel.cell = ATTACHCELL;
        
        model.isAttached = YES;
        [self.dataArray insertObject:tempModel atIndex:path.row];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationMiddle];
        [self.tableView endUpdates];
    }
    
    //[self.tableView reloadData];
}
#pragma mark- 网络请求
//标签
- (void)deleteRequest
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1000;
    [alert show];
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
//分享网址转换成短网址
- (void)shareRequest
{
    NSDictionary * dic = [self parametersForDic:@"getShortUrl" parameters:@{ACCOUNT_PASSWORD,@"url":_bussinessModel.shareUrl}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [_bussinessModel setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            [self shareBtn:sharebtn];
            
        }else if([result isEqualToString:@"4"]){
            NSLog(@"%@", result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }else{
            
        }
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
    NSDictionary *param = [self parametersForDic:@"getPostDetail" parameters:@{ACCOUNT_PASSWORD, @"id": _modelId, @"isCopy": @"0"}];
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
                if (self.sourceModel) {
                    self.sourceModel.likeCount = [NSString stringWithFormat:@"%d", [self.sourceModel.likeCount intValue] > 0 ? [self.sourceModel.likeCount intValue] - 1 : 0];
                }
                
                
            }else {
                model.likeCount = [NSString stringWithFormat:@"%d", [model.likeCount intValue] + 1];
                //非话题列表页面进入
                if (self.sourceModel) {
                    self.sourceModel.likeCount = [NSString stringWithFormat:@"%d", [self.sourceModel.likeCount intValue] + 1];
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
//长草
-(void)grassRequestGoodsId:(NSString *)goodsId TopicDetailModel:(TopicDetailModel *)model {
    NSDictionary * param = [self parametersForDic:@"accountCollectPost" parameters:@{ACCOUNT_PASSWORD,@"id":goodsId}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            //[AutoDismissAlert autoDismissAlert:@"点赞成功"];
            //长草完成数量发生变化
            [[NSNotificationCenter defaultCenter] postNotificationName:@"grass" object:nil];
            model.favCount = [NSString stringWithFormat:@"%d", [model.favCount intValue] + 1];
            [self.tableView reloadData];
            [self showGrassAlertView];
        }else{
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
        }
    } andFailureBlock:^{
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

- (IBAction)collectBtnClicked:(id)sender {
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
        if (!_bussinessModel) {
            return;
        }
        [self collectRequest];
    }
}

- (IBAction)commentBtnClicked:(id)sender {
    if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound) {
        AppDelegate *app = APPDELEGATE;
        [app showLoginAlertView];
    }else{
    TopicCommentListController *vc = [[TopicCommentListController alloc] init];
    vc.isCommon = YES;
    vc.backBlock = ^(void){
        TopicListCell *header = (TopicListCell *)self.tableView.tableHeaderView;
        self.sourceModel.consultCount = _bussinessModel.consultCount;
        header.bussinessModel = _bussinessModel;
        _isSourceModelUpdate = YES;
        [self loadCommentsListRequest];
    };
    vc.sourceModel = _bussinessModel;
    [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
