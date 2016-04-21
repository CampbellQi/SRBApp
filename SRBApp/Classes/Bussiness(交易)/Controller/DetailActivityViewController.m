//
//  DetailActivityViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/27.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "DetailActivityViewController.h"
#import "DetailModel.h"
#import "DetailManyCell.h"
#import <UIButton+WebCache.h>
#import <UIImageView+WebCache.h>
#import <UIImageView+WebCache.h>
#import "ShareViewController.h"

#import "CDRTranslucentSideBar.h"
#import "BrowsingHistoryModel.h"
#import "RightLookCell.h"

#import "RichContentMessageViewController.h"
#import "RCIM.h"

#import "RightTableViewController.h"
#import "TransactionDetailViewController.h"
#import "AccountGuaranteeViewController.h"

#import "GuaranteeListViewController.h"
#import "EvaluateViewController.h"
#import "ConsultViewController.h"
#import "SubCommonFriendViewController.h"

#import "CommenFriendModel.h"
#import "GuaranteeModel.h"
#import "MarkModel.h"
#import "CommentsModel.h"

#import "GuaranteeCell.h"
#import "MarkOrCommentsCell.h"
#import "CommonFriendCell.h"

#import "PersonalViewController.h"
#import "ImageViewController.h"
#import "RCChatViewController.h"
#import "PersonalViewController.h"
#import "SubclassDetailViewController.h"
#import "SubclassAccountGuaranteeViewController.h"
#import "ReportViewController.h"
#import "ShareDetailViewController.h"
#import "SubOfChangeBuyViewController.h"
#import "SubOfChangeSaleViewController.h"
#import "SaleMineViewController.h"
#import "TuijianView.h"
#import "CopyLabel.h"
#import "FreeSaleViewController.h"

#import "TuijianViewController.h"
#import "DetailCommentCell.h"
#import "AllEvaluationsViewController.h"
#import "PWLoadMoreTableFooterView.h"
#import "DetailActivityBtn.h"
#import "ConsultViewController.h"

#import "AppDelegate.h"

#import "WQGuideView.h"


@interface DetailActivityViewController ()<ISSShareViewDelegate,UIActionSheetDelegate,HPGrowingTextViewDelegate, PWLoadMoreTableFooterDelegate>
{
    UILabel * collectnum;
    UILabel * buynum;
    UILabel * attendnum;
    
    CopyLabel * titleLabel;
    CopyLabel * brandLabel;
    CopyLabel * sizeLabel;
    
    UILabel * priceLabel;
    UILabel * postLabel;
    UILabel * totalLabel;
    CopyLabel * detailLabel;
    NSDictionary * dicAll;
    
    NSMutableArray * buttonArr;
    NSMutableDictionary * friendDic;
    NSMutableDictionary * contentDic;
    

    UIButton * shareButton;
    UIButton * collectButton;
    UIButton * payBuyButton;
    
    BOOL duration;
    
    UILabel * labeltext;
    NSString * photoUrl;
    NoDataView * imageview;
    
    //    RightTableViewController * tableViewRight;
    UITableView * tableViewRight;
    
    NSString * isCollect;
    
    CommenFriendModel * commenFModel;
   // GuaranteeModel * guaranteeModel;
    MarkModel * markModel;
    CommentsModel * commentModel;
    
    UITextView * downTextField;
    UIActionSheet * actionSheet1;
    UIActionSheet * actionSheet2;
    
    //UIScrollView * tuijianScroll;
    
    UIView * tishiView;     //提示
    
    UIImageView * imgview;
    UILabel * tishiLabel;
    UIButton * iKnowBtn;
    
    UIView * detailCommentView; //咨询view
    UIButton * submitBtn;
    
    UIScrollView * photoview;
    
    UIImageView * nodataimageView;

    float  scrollViewHeight;
    
    NSMutableArray * bigImageArr;
    NSString * bigImageSign;
}


@property(nonatomic, retain)UIScrollView * scrollView;
@property(nonatomic, retain)UIPageControl * page;
@property(nonatomic, retain)NSArray * imageArr;
@property(nonatomic, retain)UIScrollView * scroll;
@property(nonatomic, assign)int count;
@property(nonatomic, retain)UIButton * button1;
@property(nonatomic, retain)UIButton * button2;
@property(nonatomic, retain)UIButton * button3;
@property(nonatomic, retain)UIButton * button4;

@property(nonatomic, strong)NSString * guaranteeNumber;
@property(nonatomic, strong)NSString * markNumber;
@property(nonatomic, strong)NSString * contentNumber;
@property(nonatomic, strong)NSString * friendNumber;
@property(nonatomic, strong)NSMutableArray * guaranteeArr;
@property(nonatomic, strong)NSMutableArray * markArr;
@property(nonatomic, strong)NSMutableArray * contentArr;
@property(nonatomic, strong)NSMutableArray * friendArr;

@property(nonatomic, strong)NSMutableArray * tuijianArr;
@property (nonatomic,strong)HPGrowingTextView * hpTextView;

@property (nonatomic, strong)CDRTranslucentSideBar * leftSideBar;
@property (nonatomic, strong)NSMutableArray * dataArray;
@property (nonatomic, strong) UIButton * chatbutton;
//@property (nonatomic, strong) NSDictionary *userInfoDic;

@end

@implementation DetailActivityViewController
-(id)init {
    if (self = [super init]) {
        self.canBuy = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    _guaranteeArr = [[NSMutableArray alloc]init];
    _markArr = [[NSMutableArray alloc]init];
    _contentArr = [[NSMutableArray alloc]init];
    _friendArr = [[NSMutableArray alloc]init];
    _tuijianArr = [[NSMutableArray alloc]init];
    bigImageArr = [[NSMutableArray alloc]init];
    bigImageSign = @"0";
    //初始化用户信息字典
//    self.userInfoDic = [NSDictionary dictionary];
    
    // Do any additional setup after loading the view.
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.title = @"商品详情";

    [self post];
    
    _dataArray = [[NSMutableArray alloc]init];
    
//    UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    button1.frame = CGRectMake(0, 0, 25, 25);
//    [button1 addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
//    [button1 setImage:[UIImage imageNamed:@"wd_ls.png"] forState:UIControlStateNormal];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button1];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
    
    imageview = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageview.hidden = YES;
    [self.view addSubview:imageview];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refresh) name:@"asd" object:nil];
    [self tishiView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postTuijian) name:@"lrt" object:nil];
    
    self.leftSideBar = [[CDRTranslucentSideBar alloc]initWithDirection:YES];
    self.leftSideBar.sideBarWidth =  120;
    self.leftSideBar.animationDuration = 0.3f;
    self.leftSideBar.delegate = self;
    self.leftSideBar.tag = 1;
    self.leftSideBar.translucentAlpha = 1;
    self.leftSideBar.view.layer.shadowColor = [GetColor16 hexStringToColor:@"#434343"].CGColor;
    self.leftSideBar.view.layer.shadowOpacity = 0.6;
    self.leftSideBar.view.layer.shadowOffset = CGSizeMake(-4, 3);
    
    tableViewRight = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 120, SCREEN_HEIGHT)];
    //    tableViewRight.viewcontroller = self;
    //    tableViewRight.leftSideBar = self.leftSideBar;
    //    tableViewRight.nav = self.navigationController;
    [tableViewRight setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableViewRight.tableHeaderView = [self section];
    tableViewRight.delegate = self;
    tableViewRight.dataSource = self;
    
    nodataimageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 70, 100)];
    nodataimageView.center = CGPointMake(60, SCREEN_HEIGHT / 2);
    nodataimageView.image = [UIImage imageNamed:@"empty"];
    [tableViewRight addSubview:nodataimageView];
    nodataimageView.hidden = YES;
    
    
    [[WQGuideView share] showAtIndex:10 GuideViewRemoveBlock:nil];
}

#pragma mark - 提示不符合条件
- (void)tishiView
{
    tishiView = [[UIView alloc]initWithFrame:self.view.bounds];
    tishiView.backgroundColor = [UIColor clearColor];
    tishiView.hidden = YES;
    [self.view addSubview:tishiView];
    
    UIView * blackView = [[UIView alloc]initWithFrame:tishiView.frame];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.7;
    [tishiView addSubview:blackView];
    
    iKnowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [iKnowBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [iKnowBtn addTarget:self action:@selector(hiddenTishi:) forControlEvents:UIControlEventTouchUpInside];
    [iKnowBtn setBackgroundImage:[UIImage imageNamed:@"friends_find_empty_btn_nor"] forState:UIControlStateNormal];
    [iKnowBtn setBackgroundImage:[UIImage imageNamed:@"friends_find_empty_btn_pre"] forState:UIControlStateHighlighted];
    [tishiView addSubview:iKnowBtn];
    
    UIImage * image = [[UIImage imageNamed:@"notice_frame"]resizableImageWithCapInsets:UIEdgeInsetsMake(50, 70, 100, 40) resizingMode:UIImageResizingModeStretch];

    imgview = [[UIImageView alloc]init];
    imgview.image = image;
    [tishiView addSubview:imgview];
    
    tishiLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 40, 120, 30)];
    tishiLabel.font = SIZE_FOR_12;
    tishiLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    tishiLabel.numberOfLines = 0;
    tishiLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    [imgview addSubview:tishiLabel];
}


#pragma mark -
#pragma mark 底部按钮置灰原因
/**
 *  计算提示不能购买原因label的高度
 *  @param content 内容
 *  @return label的farme
 */
- (CGRect)rectForContent:(NSString *)content
{
    CGRect tempRect = [content boundingRectWithSize:CGSizeMake(120, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
    tishiLabel.height = tempRect.size.height;
    tishiLabel.y = (120 - tempRect.size.height)/2;
    imgview.frame = CGRectMake((SCREEN_WIDTH - 192)/2, 75, 192, 120);
    iKnowBtn.frame = CGRectMake((SCREEN_WIDTH - 180)/2, CGRectGetMaxY(imgview.frame) + 25, 180, 45);
    return tempRect;
}
/**
 *  不能购买
 */
- (void)setViewForBuy
{
    NSString * messageStr = @"您不能购买的原因是：\n";
    if ([ACCOUNT_SELF isEqualToString:_model.account]) {
        messageStr = [messageStr stringByAppendingString:@"该商品由您自己发布。"];
//    }else if( [_friendNumber isEqualToString:@"0"] && [_model.isFriended isEqualToString:@"0"]){
//        messageStr = [messageStr stringByAppendingString:@"您与卖家不是熟人关\n系且没有共同熟人。"];
    }else if ([ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound){
        messageStr = [messageStr stringByAppendingString:@"您还没有登录。"];
    }else if([_model.storage isEqualToString:@"0"]){
        messageStr = [messageStr stringByAppendingString:@"剩余库存为0。"];
    }else if (self.canBuy == NO) {
        messageStr = [messageStr stringByAppendingString:@"您已经购买过了。"];
    }else{
        messageStr = [messageStr stringByAppendingString:@"该订单状态不能购买。"];
    }
    tishiLabel.text = messageStr;
    [self rectForContent:messageStr];
}
/**
 *  隐藏提示框
 */
- (void)hiddenTishi:(UIButton *)sender
{
    tishiView.hidden = YES;
}

#pragma mark 获取信息
- (void)refresh
{
    for(UIView *view in [self.view subviews])
    {
        [view removeFromSuperview];
    }
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"获取信息中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    [self tishiView];
    [self post];
}

#pragma mark 右上角功能键
- (void)navigationButton
{

//    if ([ACCOUNT_SELF isEqualToString:_model.account]) {
//        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 25)];
//        UIButton * button1 = [UIButton buttonWithType:UIButtonTypeCustom];
//        button1.frame = CGRectMake(0, 0, 25, 25);
//        [button1 addTarget:self action:@selector(deleteAndChange:) forControlEvents:UIControlEventTouchUpInside];
//        [button1 setImage:[UIImage imageNamed:@"edit_w.png"] forState:UIControlStateNormal];
//        [view addSubview:button1];
//        
//        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
//        button2.frame = CGRectMake(50, 0, 25, 25);
//        [button2 addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
//        [button2 setImage:[UIImage imageNamed:@"wd_ls.png"] forState:UIControlStateNormal];
//        [view addSubview:button2];
//        
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
//    }else{
        UIButton * button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        button2.frame = CGRectMake(0, 0, 20, 20);
        [button2 addTarget:self action:@selector(regController:) forControlEvents:UIControlEventTouchUpInside];
        [button2 setImage:[UIImage imageNamed:@"wd_ls.png"] forState:UIControlStateNormal];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button2];
    }
//}

#pragma mark -
#pragma mark 撤销和修改功能
- (void)deleteAndChange:(id)sender
{
    actionSheet1 = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"修改",@"撤回", nil];//UIActionSheet初始化，并设置delegate
    actionSheet1.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet1 showFromRect:self.view.bounds inView:self.view animated:YES]; // actionSheet弹出位置
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet == actionSheet1) {
        switch (buttonIndex) {
            case 0:
                [self changePost];
                break;
            case 1:
                [self deletePost];
                break;
            default:
                break;
        }
    }else{
    if (buttonIndex == 0) {
        [self chatRichContentMessage];
    }if (buttonIndex == 1) {
        [self chat];
        
    }
    }
}

#pragma mark 撤回功能
- (void)deletePost
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定撤回?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 1;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            HUD.labelText = @"撤销中,请稍后";
            HUD.dimBackground = YES;
            [HUD show:YES];
            //拼接post参数
            NSDictionary * dic = [self parametersForDic:@"accountRevokePost" parameters:@{ACCOUNT_PASSWORD, @"id": _model.model_id}];
            
            //发送post请求
            [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//                NSLog(@"%@",[dic objectForKey:@"message"]);
                int result = [[dic objectForKey:@"result"]intValue];
                if (result == 0) {
                    //刷新个人主页话题数量
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPersonalPublishCountNF" object:nil];
                    [HUD removeFromSuperview];
                    isBack = YES;
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"wjj" object:nil];
                    [self.navigationController popViewControllerAnimated:YES];
                }else{
                    [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
                    [HUD removeFromSuperview];
                }
            }];
        }
    }
    else
    {
        if (buttonIndex == 1) {
            [self delAllHistory];
        }
    }
}

#pragma mark 修改
- (void)changePost
{
    if ([_model.bangPrice floatValue] > 0) {
        SubOfChangeSaleViewController * vc = [[SubOfChangeSaleViewController alloc]init];
        vc.model = _model;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        
    if ([_model.dealType isEqualToString: @"2"]){
        
        SubOfChangeBuyViewController * vc = [[SubOfChangeBuyViewController alloc]init];
        vc.model = _model;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        FreeSaleViewController * vc = [[FreeSaleViewController alloc]init];
        vc.model = _model;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    }
}

#pragma mark -
#pragma mark 手势下移
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [downTextField resignFirstResponder];
    NSTimeInterval animationDuration=0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard1" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,64,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}


#pragma mark -
#pragma mark 载入页面
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    app.zhedangView.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:UIMenuControllerDidHideMenuNotification object:nil];
}

#pragma mark 离开界面
- (void)viewWillDisappear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        //app.mainTab.tabBar.hidden = YES;
        //app.customTab.hidden = NO;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
    [self hidden];
}

#pragma mark 隐藏可复制Label的背景
- (void)hidden
{
    //detailLabel.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    titleLabel.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    brandLabel.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    sizeLabel.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
}

#pragma mark
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        [self.view endEditing:YES];
    }
}

#pragma mark 键盘弹出与收回的监听
- (void)keyboardWasShown:(NSNotification *)notification
{
    if (isCommentTextView == NO) {
        NSDictionary * userInfo = [notification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect = [aValue CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        
        // 根据老的 frame 设定新的 frame
        CGRect newTextViewFrame = detailCommentView.frame; // by michael
        newTextViewFrame.origin.y = keyboardRect.origin.y - detailCommentView.frame.size.height;
        
        NSNumber *durations = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[durations doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        detailCommentView.frame = newTextViewFrame;

        // commit animations
        [UIView commitAnimations];
    }
}
- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    if (isCommentTextView == NO) {
        NSNumber *durations = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // get a rect for the textView frame
        CGRect containerFrame = detailCommentView.frame;
        containerFrame.origin.y = SCREEN_HEIGHT - 64;
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[durations doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        detailCommentView.frame = containerFrame;
        // commit animations
        [UIView commitAnimations];
    }
}

#pragma mark growingTextView 代理
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    CGRect r = detailCommentView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    detailCommentView.frame = r;
    submitBtn.frame = CGRectMake(self.hpTextView.frame.size.width + self.hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 60, 25);
}


#pragma mark - 
#pragma mark
- (void)backBtn
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)regController:(id)sender
{
    [self.leftSideBar setContentViewInSideBar:tableViewRight];
    [self.leftSideBar show];
    
    [self urlRequest];
}

- (UIView *)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 40)];
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 70, 30)];
    label.text = @"浏览历史";
    label.font = SIZE_FOR_14;
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width , label.frame.origin.y + 10, 15, 15)];
    [image setImage:[UIImage imageNamed:@"saozhou.png"]];
    [view addSubview:image];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    [button addTarget:self action:@selector(deleteObject:) forControlEvents:UIControlEventTouchUpInside];
    button.center = image.center;
    [view addSubview:button];
    
    return view;
}

- (void)deleteObject:(id)sender
{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定清空浏览历史?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)delAllHistory
{
    NSDictionary * dic = [self parametersForDic:@"accountClearPostHistory" parameters:@{ACCOUNT_PASSWORD}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [_dataArray removeAllObjects];
            [tableViewRight reloadData];
            [nodataimageView setHidden:NO];
            //            [AutoDismissAlert autoDismissAlert:@"删除成功"];
        }else{
//            NSLog(@"%d",result);
//            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
        }
    }];
}



#pragma mark - post请求
- (void)urlRequest
{
    NSDictionary * dic = [self parametersForDic:@"getPostListByHistory" parameters:@{ACCOUNT_PASSWORD,@"start":@"0",@"count":@"20"}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [self.dataArray removeAllObjects];
        int result = [[dic objectForKey:@"result"] intValue];
        NSArray * temparr = [[dic objectForKey:@"data"] objectForKey:@"list"];
        if (result == 0) {
            for (int i = 0; i< temparr.count; i++) {
                BrowsingHistoryModel * browsingHistroyModel = [[BrowsingHistoryModel alloc]init];
                NSDictionary * tempdic = temparr[i];
                [browsingHistroyModel setValuesForKeysWithDictionary:tempdic];
                [self.dataArray addObject:browsingHistroyModel];
            }
            [tableViewRight reloadData];
            [nodataimageView setHidden:YES];
            //            [tableview headerEndRefreshing];
        }else if(result == 4){
            [tableViewRight reloadData];
            [nodataimageView setHidden:NO];
            //            [tableview headerEndRefreshing];
        }else{
//            [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
        }
    }];
}

- (void)shareRequest
{
    NSDictionary * dic = [self parametersForDic:@"getShortUrl" parameters:@{ACCOUNT_PASSWORD,@"url":_model.shareUrl}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [_model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            [self share:shareButton];

        }else if([result isEqualToString:@"4"]){
            NSLog(@"%@", result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }else{
            
        }
    }];
}

- (void)setTheView
{
    //修改悬浮框尺寸
//    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 140) style:UITableViewStylePlain];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 42) style:UITableViewStylePlain];
    _imageArr = [_model.photos componentsSeparatedByString:@","];
    UIView * view = [[UIView alloc] init];
//    UIView *upView = [self upView];
//    [view addSubview:upView];
    if (_model.photos.length < 92) {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [self otherView].frame.size.height + [self upView].frame.size.height);
        
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100000)];
        [view1 addSubview: [self upView]];
        [view addSubview:view1];
        
         UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 100000)];
        [view2 addSubview: [self otherView]];
        [view addSubview:view2];
//        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(upView.frame), SCREEN_WIDTH, 100000)];
//        [view1 addSubview: [self otherView]];
//        [view addSubview:view1];
//        
//        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [self otherView].frame.size.height + CGRectGetHeight(upView.frame));
        
        
    }
    else
    {
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [self upView].frame.size.height + [self photoView].frame.size.height + [self otherView].frame.size.height);
        
        
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100000)];
        [view1 addSubview: [self upView]];
        [view addSubview:view1];
        
        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 100000)];
        [view2 addSubview: [self photoView]];
        [view addSubview:view2];
        
        UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 60 + SCREEN_WIDTH/4*3, SCREEN_WIDTH, 100000)];
        [view3 addSubview:[self otherView]];
        [view addSubview:view3];
        
//        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(upView.frame), SCREEN_WIDTH, 100000)];
//        [view1 addSubview: [self photoView]];
//        [view addSubview:view1];
//        
//        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/4*3 + CGRectGetMaxY(upView.frame), SCREEN_WIDTH, 100000)];
//        [view2 addSubview:[self otherView]];
//        [view addSubview:view2];
//        
//        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, [self photoView].frame.size.height + [self otherView].frame.size.height + CGRectGetHeight(upView.frame));
        
        [_tableView addFooterWithTarget:self action:@selector(changePage)];
    }
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
//    _tableView.directionalLockEnabled = YES;
//    _tableView.bounces = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1];
    _tableView.tableHeaderView = view;
    _tableView.tableFooterView = [self downView];
//    [_tableView pwLoadMore];

    
    [self.view addSubview:_tableView];
    
   photoview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _tableView.frame.origin.y + _tableView.frame.size.height , SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 42)];
    
//     photoview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _tableView.frame.origin.y + _tableView.frame.size.height , SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 50)];
    [photoview addHeaderWithTarget:self action:@selector(changePageBack)];
    [self.view addSubview:photoview];
    
    for (int i = 0; i < _imageArr.count; i++) {
        UIImageView * iamgeVIew = [[UIImageView alloc]init];
        [iamgeVIew sd_setImageWithURL:[NSURL URLWithString:_imageArr[i]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                iamgeVIew.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH / image.size.width * image.size.height);
                iamgeVIew.image = image;
            }
//            [photoview addSubview:iamgeVIew];
//            scrollViewHeight = iamgeVIew.frame.size.height + iamgeVIew.frame.origin.y;
            [bigImageArr addObject:iamgeVIew];
            if (i == _imageArr.count - 1) {
                bigImageSign = @"1";
            }
        }];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:(0.1) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    
    //[self pianyi];
}

- (void)onTimer
{
    
    if ([bigImageSign  isEqual: @"1"]) {
        float aa = 0;
        for (int i = 0; i < bigImageArr.count; i++) {
            UIImageView * iamge = [[UIImageView alloc]init];
            iamge = bigImageArr[i];
            aa += iamge.frame.size.height;
        }
        photoview.contentSize = CGSizeMake(SCREEN_WIDTH, aa);
        for (int i = 0; i < bigImageArr.count; i++) {
            UIImageView * image = [[UIImageView alloc]init];
            image = bigImageArr[i];
            if (i == 0) {
                scrollViewHeight = 0;
                image.frame = CGRectMake(0, scrollViewHeight , image.frame.size.width, image.frame.size.height);
                scrollViewHeight = image.frame.size.height + image.frame.origin.y;
            }else{
                image.frame = CGRectMake(0, scrollViewHeight , image.frame.size.width, image.frame.size.height);
                scrollViewHeight = image.frame.size.height + image.frame.origin.y;
            }
            [photoview addSubview:image];
        }
    }
}


- (void)scrollViewByPageControlPage:(NSInteger)page
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.50];
//    [self.tableView setContentOffset:CGPointMake(0, (SCREEN_HEIGHT - 64 - OffsetHeight)*page)];
    _tableView.frame = CGRectMake(0, -100,SCREEN_WIDTH, SCREEN_HEIGHT - 64 -42);
    photoview.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64 -42);
//    _tableView.frame = CGRectMake(0, -100,SCREEN_WIDTH, SCREEN_HEIGHT - 64 -140);
//    photoview.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64 -140);
    [UIView commitAnimations];
}

- (void)changePage
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.40];
    _tableView.frame = CGRectMake(0, - _tableView.frame.size.height ,SCREEN_WIDTH, _tableView.frame.size.height);
    photoview.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT - 64 -42);
    [UIView commitAnimations];
    [_tableView footerEndRefreshing];
}

- (void)changePageBack
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.40];
    _tableView.frame = CGRectMake(0, 0 ,SCREEN_WIDTH, _tableView.frame.size.height);
    //photoview.frame = CGRectMake(0, _tableView.frame.size.height ,SCREEN_WIDTH, SCREEN_HEIGHT - 64 -140);
    photoview.frame = CGRectMake(0, _tableView.frame.size.height ,SCREEN_WIDTH, SCREEN_HEIGHT - 64 -42);
    [UIView commitAnimations];
    [photoview headerEndRefreshing];
}

//颜色转换成图像
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

- (UIView *)downView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 90)];
    view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    breakView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [view addSubview:breakView];
    
    
    //咨询的输入框
    detailCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40)];
    detailCommentView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    
    HPGrowingTextView * hpTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30 - 60 - 15, 30)];
    self.hpTextView = hpTextView;
    hpTextView.contentInset = UIEdgeInsetsMake(0, 4, 0, 5);
    hpTextView.isScrollable = NO;
    hpTextView.layer.borderColor = [UIColor clearColor].CGColor;
    hpTextView.delegate = self;
    hpTextView.minNumberOfLines = 1;
    hpTextView.maxNumberOfLines = 4;
    hpTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    hpTextView.textColor = [GetColor16 hexStringToColor:@"#434343"];
    hpTextView.layer.cornerRadius = 2;
    hpTextView.layer.masksToBounds = YES;
    //hpTextView.returnKeyType = UIReturnKeySend;
    hpTextView.font = SIZE_FOR_IPHONE;
    hpTextView.placeholder = @"我来说一句";
    [detailCommentView addSubview:hpTextView];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(self.hpTextView.frame.size.width + self.hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 55, 25);
    submitBtn.layer.cornerRadius = CGRectGetHeight(submitBtn.frame)*0.5;
    submitBtn.layer.masksToBounds = YES;

    [submitBtn addTarget:self action:@selector(submitZiXun) forControlEvents:UIControlEventTouchUpInside];
    
    [submitBtn setTitle:@"发 送" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[self imageWithColor:[GetColor16 hexStringToColor:@"#959595"] size:submitBtn.frame.size] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    submitBtn.enabled = NO;
    detailCommentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [detailCommentView addSubview:submitBtn];
    
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20, breakView.frame.origin.y + breakView.frame.size.height + 15, 90, 15)];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"信息不靠谱?";
    label.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [view addSubview:label];
    
    UIButton * reportBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75, label.frame.origin.y - 5, 60, 25)];
//    [button setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState: UIControlStateHighlighted];
//    //    button.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
//    button.center = CGPointMake(SCREEN_WIDTH / 2, detailLabel.frame.origin.y + detailLabel.frame.size.height + 10 + button.frame.size.height / 2);
    reportBtn.layer.borderWidth = 1;
    reportBtn.layer.borderColor = [[UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1] CGColor];
    [reportBtn setTitle:@"举 报" forState:UIControlStateNormal];
    [reportBtn setTitleColor:[UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1] forState:UIControlStateNormal];
    reportBtn.layer.cornerRadius = 2;
    reportBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    reportBtn.layer.masksToBounds = YES;
    [reportBtn addTarget:self action:@selector(jubao:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:reportBtn];
    
    UIView * photoview = [[UIView alloc]initWithFrame:CGRectMake(0, _tableView.frame.size.height + _tableView.frame.origin.y, SCREEN_WIDTH, SCREEN_HEIGHT)];
    photoview.backgroundColor = [UIColor blackColor];
    [view addSubview:photoview];
    //上下分割线
    UILabel * breakUpLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, view.width, 1)];
    breakUpLabel.backgroundColor = [UIColor whiteColor];
    [view addSubview:breakUpLabel];
    //上拉查看图文详情提示
    if (_model.photos.length < 92) {
        //没有图片
        view.height = 45;
    }else {
        UILabel * alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 46, view.width, 46)];
        alertLabel.font = [UIFont systemFontOfSize:12];
        alertLabel.text = @"上拉查看图文详情";
        alertLabel.textAlignment = NSTextAlignmentCenter;
        alertLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [view addSubview:alertLabel];
        
        float lineWidth = alertLabel.width /2 - 100;
        float lineLeftMargin = 30;
        UILabel * leftLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(lineLeftMargin, 22, lineWidth, 1)];
        leftLineLabel.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        [alertLabel addSubview:leftLineLabel];
        
        UILabel * rightLineLabel = [[UILabel alloc]initWithFrame:CGRectMake(alertLabel.width - lineWidth - lineLeftMargin, leftLineLabel.y, lineWidth, 1)];
        rightLineLabel.backgroundColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
        [alertLabel addSubview:rightLineLabel];
    }
    
    
    return view;
}

- (void)buttonFinish:(id)sender
{
    UIButton * button = sender;
    if (button.tag == 1) {
        [downTextField resignFirstResponder];
    }
}

- (UIImage*) createImageWithColor: (UIColor*) color
{
    UIImage * image = [[UIImage alloc]init];
    return image;
}

- (void)downButtonAction
{
    [self.hpTextView becomeFirstResponder];
    isCommentTextView = NO;
}

//发送咨询内容
- (void)submitZiXun
{
    NSString * tempStr = self.hpTextView.text;
    tempStr = [tempStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (tempStr.length == 0 || tempStr == nil || [tempStr isEqualToString:@"0"]) {
        [AutoDismissAlert autoDismissAlert:@"请填写咨询内容"];
        return;
    }else{
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountCommentPost" parameters:@{ACCOUNT_PASSWORD, @"content":self.hpTextView.text,@"id":_idNumber}];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                //                [AutoDismissAlert autoDismissAlert:@"咨询成功!"];
                [self postContent];
                [_tableView reloadData];
//                ConsultViewController * vc = [[ConsultViewController alloc]init];
//                vc.idNumber = _model.model_id;
//                [self.navigationController pushViewController:vc animated:YES];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        } andFailureBlock:^{
            
        }];
        [self.view endEditing:YES];
    }
}

- (UIView *)photoView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
    
    //view.backgroundColor = [UIColor yellowColor];
    view.backgroundColor = [UIColor whiteColor];
    _count = 0;
    
    if (_model.photos != nil) {
        
        if (_model.photos.length < 120) {
            
            UIImageView * photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
            UITapGestureRecognizer * photoTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(action:)];
            [photoImg addGestureRecognizer:photoTap];
            
            
            
            UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/4*3)];
//            NSString * str = _model.photos;
//            [str stringByReplacingOccurrencesOfString:@"_sm" withString:@""];
            [image sd_setImageWithURL:[NSURL URLWithString:_model.photos] placeholderImage:[UIImage imageNamed:@"zanwu.png"]];
            image.contentMode = UIViewContentModeScaleAspectFill;
            image.clipsToBounds = YES;
            [view addSubview:image];
            
            UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH ,SCREEN_WIDTH/4*3)];
            //            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.photos] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"zanwu.png"]];
            [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor = [UIColor clearColor];
            [view addSubview:button];
            
            photoUrl = _model.photos;
        }else{
            _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH , SCREEN_WIDTH/4*3)];
            //        _scrollView.backgroundColor = [UIColor grayColor];
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * _imageArr.count, SCREEN_WIDTH/4*3);
            _scrollView.pagingEnabled = YES;
            _scrollView.delegate = self;
            
            UIScreenEdgePanGestureRecognizer * screen = [self screenEdgePanGestureRecognizer];
            if (screen != nil) {
                [_scrollView.panGestureRecognizer requireGestureRecognizerToFail:[self screenEdgePanGestureRecognizer]];
            }
            
            [view addSubview:_scrollView];
            
            photoUrl = [_imageArr firstObject];
            
            for (int i = 0; i < _imageArr.count; i++) {
                UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH ,SCREEN_WIDTH/4*3)];
//                NSString * str = _imageArr[i];
//                [str stringByReplacingOccurrencesOfString:@"_sm" withString:@""];
                [image sd_setImageWithURL:[NSURL URLWithString:_imageArr[i]] placeholderImage:[UIImage imageNamed:@"zanwu.png"]];
                image.contentMode = UIViewContentModeScaleAspectFill;
                image.clipsToBounds = YES;
                [_scrollView addSubview:image];
                
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH  ,SCREEN_WIDTH/4*3)];
                //            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:_imageArr[i]] forState:UIControlStateNormal];
                button.tag = i + 100;
                //            button.contentMode = UIViewContentModeScaleAspectFill;
                //            button.clipsToBounds = YES;
                [button addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
                button.backgroundColor = [UIColor clearColor];
//                NSLog(@"%@",_imageArr[i]);
                [_scrollView addSubview:button];
            }
            
            _page = [[UIPageControl alloc]initWithFrame:CGRectMake(10, _scrollView.frame.origin.y + _scrollView.frame.size.height - 16, SCREEN_WIDTH , 8)];
            _page.currentPageIndicatorTintColor = [UIColor whiteColor];
            [_page setNumberOfPages:_imageArr.count];
            [_page addTarget:self action:@selector(pageControlAction:) forControlEvents:UIControlEventValueChanged];
            //        _page.currentPage = 0;
            [view addSubview:_page];
        }
        NSTimer * time = [[NSTimer alloc]init];
        time = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(function:) userInfo:nil repeats:YES];
        if ([_model.dealType isEqualToString: @"1"] && [_model.storage isEqualToString:@"0"]) {
            UIImageView * noimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 75)];
            noimage.center = CGPointMake(view.frame.size.width - 40, view.frame.size.height - 42);
            noimage.image = [UIImage imageNamed:@"qiangguanglaSmall.png"];
            [view addSubview:noimage];
        }
    }else {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH * 320, 0.01)];
        [view addSubview:_scrollView];
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.01);
    }
    
    return view;
}


//- (NSString *)kaisajiami:(NSString * )canshu
//{
//    NSArray * arr1 = [NSArray arrayWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z",nil];
//    NSArray * arr2 = [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z",nil];
//    for(int i = 0;i < 26; i++)
//    {
//        if ([canshu isEqualToString:arr1[i]] ) {
//            if (i < 23) {
//                return arr1[i + 3];
//            }else{
//                return arr1[i - 23];
//            }
//        }
//        if ([canshu isEqualToString:arr2[i]]) {
//            if (i < 23) {
//                return arr1[i + 3];
//            }else{
//                return arr1[i - 23];
//            }
//        }
//    }
//    return 0;
//}

- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer
{
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.navigationController.view.gestureRecognizers.count > 0)
    {
        for (UIGestureRecognizer *recognizer in self.navigationController.view.gestureRecognizers)
        {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]])
            {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    
    return screenEdgePanGestureRecognizer;
}

- (void)action:(id)sender
{
    UIButton * button = sender;
    ImageViewController * vc = [[ImageViewController alloc]init];
    
    NSArray * photosArr = [_model.photos componentsSeparatedByString:@","];
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
        vc.imgIndex = button.tag - 100 + 1;
    }
    //    imageVC.hidesBottomBarWhenPushed = YES;
    vc.imageUrl = stringtotal;
    //    for (NSMutableString * string in _model.photos) {
    //
    //    }
    //[vc showFromController:vc];

    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}
- (UIView *)upView
{
   
    UIView * view = [[UIView alloc]init];
    //UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIImageView * avatarIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    [avatarIV sd_setImageWithURL:[NSURL URLWithString:[_model avatar]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    avatarIV.contentMode = UIViewContentModeScaleAspectFill;
    avatarIV.layer.masksToBounds = YES;
    avatarIV.layer.cornerRadius = avatarIV.width * 0.5;
    avatarIV.clipsToBounds = YES;
    [view addSubview:avatarIV];
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aaaction:)];
    avatarIV.userInteractionEnabled = YES;
    [avatarIV addGestureRecognizer:imageTap];
    
    
    //UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(60, 0, SCREEN_WIDTH - 60, 60)];
    
    UILabel * accountLbl = [[UILabel alloc]initWithFrame:CGRectMake(avatarIV.frame.origin.x + avatarIV.frame.size.width + 10, avatarIV.frame.origin.y, 115, 19)];
    accountLbl.font = [UIFont systemFontOfSize:14];
    accountLbl.text = _model.nickname;
    accountLbl.textColor = [GetColor16 hexStringToColor:@"#000000"];
    [view addSubview:accountLbl];
    
    UILabel * timeLbl = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 120, avatarIV.frame.origin.y, 110, 19)];
    timeLbl.font = [UIFont systemFontOfSize:12];
    NSString * timeStr = [CompareCurrentTime compareCurrentDate:_model.updatetimeLong];
    timeLbl.text = timeStr;
    timeLbl.textAlignment = NSTextAlignmentRight;
    timeLbl.textColor = [UIColor lightGrayColor];
    [view addSubview:timeLbl];
    
    UILabel * kaopuLbl = [[UILabel alloc]initWithFrame:CGRectMake(accountLbl.frame.origin.x, accountLbl.frame.size.height + 13, 65, 19)];
    kaopuLbl.font = [UIFont systemFontOfSize:14];
    kaopuLbl.text = @"靠谱指数:";
    kaopuLbl.textColor = [UIColor lightGrayColor];
    [view addSubview:kaopuLbl];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allEvaluation:)];
    kaopuLbl.userInteractionEnabled = YES;
    [kaopuLbl addGestureRecognizer:tap];
    //[view2 addGestureRecognizer:tap];
    
    UILabel * percentLbl = [[UILabel alloc]initWithFrame:CGRectMake(kaopuLbl.frame.origin.x + kaopuLbl.frame.size.width, kaopuLbl.frame.origin.y, 70, 19)];
    percentLbl.font = [UIFont systemFontOfSize:14];
    percentLbl.text = [NSString stringWithFormat:@"%@", _model.evaluationper];
    percentLbl.textColor = [UIColor lightGrayColor];
    [view addSubview:percentLbl];
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(allEvaluation:)];
      percentLbl.userInteractionEnabled = YES;
        [percentLbl addGestureRecognizer:tap1];
    
//    [view addSubview:view1];
//    [view addSubview:view2];
   view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    return view;
}
- (UIView *)otherView
{
    //    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210)];
    UIView * view = [[UIView alloc]init];
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 42.5)];
    CGPoint view1Center = view1.center;
    view1.center = CGPointMake(SCREEN_WIDTH / 3 / 2, view1Center.y);

    
    
    UIImageView * protectButton = [[UIImageView alloc]initWithFrame:CGRectMake(20,15, 20, 20)];
    protectButton.image = [UIImage imageNamed:@"icon_browse_gray.png"];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 30, 12)];
    label1.font = [UIFont systemFontOfSize:12];
    label1.text = @"浏览";
    label1.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [view1 addSubview:label1];
    
    
    attendnum = [[UILabel alloc]initWithFrame:CGRectMake(protectButton.frame.origin.x + protectButton.frame.size.width + 10, protectButton.frame.origin.y + 3 , 30 , 12)];
    attendnum.font = [UIFont systemFontOfSize:12];
    [attendnum setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
    attendnum.text = _model.hitCount;
    //    attendnum.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
    [view1 addSubview:attendnum];
    
    UIView * lineView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3, 10, 1, 30)];
    lineView1.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [view addSubview:lineView1];
    
    UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 42.5)];
    view2.center = CGPointMake(SCREEN_WIDTH / 3 + (SCREEN_WIDTH /3 / 2), view1Center.y);
    
    UIImageView * attentButtons = [[UIImageView alloc]initWithFrame:CGRectMake(20,15, 20, 20)];
    attentButtons.image = [UIImage imageNamed:@"icon_trade_gray.png"];
    //    attentButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
//    [view2 addSubview:attentButtons];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 30, 12)];
    label2.font = [UIFont systemFontOfSize:12];
    label2.text = @"售出";
    label2.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [view2 addSubview:label2];
    
    UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/3 * 2, 10, 1, 30)];
    lineView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [view addSubview:lineView2];
    
    buynum = [[UILabel alloc]initWithFrame:CGRectMake(attentButtons.frame.origin.x + attentButtons.frame.size.width +10, attentButtons.frame.origin.y + 3, 30 , 12)];
    buynum.font = [UIFont systemFontOfSize:12];
    [buynum setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
    buynum.text = _model.salesCount;
    [view2 addSubview:buynum];
    
    
    UIView * view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 70, 42.5)];
    view3.center = CGPointMake(SCREEN_WIDTH / 3 * 2 + (SCREEN_WIDTH /3 / 2), view1Center.y);
    UIImageView * historyButton = [[UIImageView alloc]initWithFrame:CGRectMake(20,15, 20, 20)];
    //    historyButton.backgroundColor = [UIColor colorWithRed:0.66 green:0 blue:0.29 alpha:1];
    historyButton.image = [UIImage imageNamed:@"icon_attend_gray.png"];
//    [view3 addSubview:historyButton];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(20, 18, 30, 12)];
    label3.font = [UIFont systemFontOfSize:12];
    label3.text = @"收藏";
    label3.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [view3 addSubview:label3];
    
    collectnum = [[UILabel alloc]initWithFrame:CGRectMake(historyButton.frame.origin.x + historyButton.frame.size.width +10, historyButton.frame.origin.y + 3, 30 , 12)];
    collectnum.font = [UIFont systemFontOfSize:12];
    [collectnum setTextColor:[GetColor16 hexStringToColor:@"#959595"]];
    collectnum.text = _model.favCount;
    [view3 addSubview:collectnum];
    
    [view addSubview:view1];
    [view addSubview:view2];
    [view addSubview:view3];
    
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, view1.frame.origin.y + view1.frame.size.height + 7.5, SCREEN_WIDTH, 0.5)];
    breakView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    
    [view addSubview:breakView];
    //品牌
    brandLabel = [[CopyLabel alloc]initWithFrame:CGRectMake(10, breakView.frame.origin.y + 5, SCREEN_WIDTH - 85, 25)];
    brandLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    brandLabel.font = [UIFont systemFontOfSize:16];
    brandLabel.numberOfLines = 0;
    brandLabel.layer.borderColor = [GetColor16 hexStringToColor:@"#ffffff"].CGColor;
    brandLabel.text = _model.brand;
    //brandLabel.backgroundColor = [UIColor redColor];
    [view addSubview:brandLabel];
    
    //名称
    titleLabel = [[CopyLabel alloc]initWithFrame:CGRectMake(10, brandLabel.frame.origin.y + brandLabel.frame.size.height, SCREEN_WIDTH - 85, 45)];
    titleLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.numberOfLines = 0;
    titleLabel.layer.borderColor = [GetColor16 hexStringToColor:@"#ffffff"].CGColor;
    titleLabel.text = _model.title;
    //titleLabel.backgroundColor = [UIColor greenColor];
    [view addSubview:titleLabel];
    
//60
        UIButton * chatbutton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 42, brandLabel.frame.origin.y + 25, 25, 25)];
    //25
        //chatbutton.center = CGPointMake(SCREEN_WIDTH - 30, chatbutton.center.y);
        //[chatbutton setImage:[UIImage imageNamed:@"unonlineDetail"] forState:UIControlStateNormal];
        [chatbutton setImage:[UIImage imageNamed:@"detail_activity_comment_normal"] forState:UIControlStateNormal];
        [chatbutton addTarget:self action:@selector(toChatView:) forControlEvents:UIControlEventTouchUpInside];
        self.chatbutton = chatbutton;
        [view addSubview:chatbutton];
    //    [chatbutton setImage:[UIImage imageNamed:@"onlinDetail"] forState:UIControlStateNormal];
    
//        if ([_model.account isEqualToString:ACCOUNT_SELF]) {
//            [self.chatbutton setHidden:YES];
//        }
    UIView * theView = [[UIView alloc]initWithFrame:CGRectMake(chatbutton.frame.origin.x - 25, breakView.frame.origin.y + 10, 1, 60)];
    theView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [view addSubview:theView];
    
    
//    UIView * breakView1 = [[UIView alloc]initWithFrame:CGRectMake(0, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5 , SCREEN_WIDTH, 0.5)];
//    breakView1.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//    [view addSubview:breakView1];
    
    if ([_model.dealType isEqualToString:@"1"]) {
      priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5, 120 * WIDTH, 22)];
//        priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, breakView1.frame.origin.y + 5, 120 * WIDTH, 22)];
        priceLabel.textColor = [UIColor colorWithRed:0.9 green:0 blue:0.36 alpha:1];
        priceLabel.text = [NSString stringWithFormat:@"￥%@",_model.bangPrice];
        if (priceLabel.text.length <= 8) {
            priceLabel.font = [UIFont systemFontOfSize:22];
        }else{
            priceLabel.font = [UIFont systemFontOfSize:20];
        }
        
        [view addSubview:priceLabel];
        
        postLabel = [[UILabel alloc]initWithFrame:CGRectMake(buynum.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 5 + 3, 30, 16)];
        
//        postLabel = [[UILabel alloc]initWithFrame:CGRectMake(buynum.frame.origin.x, breakView1.frame.origin.y + 3, 30, 16)];
        //        _postLabel = [[UILabel alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x + _priceLabel.frame.size.width + 20, _priceLabel.frame.origin.y , 30, 16)];
        //        _postLabel.font = [UIFont systemFontOfSize:12];
        //        _postLabel.textAlignment = NSTextAlignmentCenter;
        postLabel.layer.cornerRadius = 2;
        postLabel.layer.masksToBounds = YES;
        postLabel.text = @"包邮";
        postLabel.backgroundColor = [UIColor colorWithRed:1 green:0.48 blue:0.67 alpha:1];
        postLabel.textColor = [UIColor whiteColor];
        //        [self.contentView addSubview:_postLabel];
        postLabel.font = [UIFont systemFontOfSize:12];
        
        postLabel.textAlignment = NSTextAlignmentCenter;
        postLabel.center = CGPointMake(SCREEN_WIDTH /2 , priceLabel.center.y);
//        if ([_model.freeShipment isEqualToString:@"1"]) {
//            postLabel.hidden = NO;
//        }else{
//            postLabel.hidden = YES;
//            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 5, 100, 16)];
//            label.text = [NSString stringWithFormat:@"运费￥%@",_model.transportPrice];
////            label.textAlignment = NSTextAlignmentCenter;
//            label.textColor = [GetColor16 hexStringToColor:@"#959595"];;
////            label.center = CGPointMake(SCREEN_WIDTH /2 , priceLabel.center.y);
//            label.backgroundColor = [UIColor whiteColor];
//            label.font = [UIFont systemFontOfSize:12];
//            [view addSubview:label];
//        }
//        [view addSubview:postLabel];
        UILabel * label;
        if ([_model.freeShipment isEqualToString:@"1"]) {

            postLabel.hidden = NO;
            label = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 5, 100, 1)];
        }else{
            postLabel.hidden = YES;
            label = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 5, 100, 16)];
            label.text = [NSString stringWithFormat:@"运费￥%@",_model.transportPrice];
            label.textColor = [GetColor16 hexStringToColor:@"#959595"];;
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            [view addSubview:label];
        }
        

        totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 100, postLabel.frame.origin.y + 2, 100, 12)];
        totalLabel.textAlignment = NSTextAlignmentRight;
        totalLabel.font = [UIFont systemFontOfSize:12];
        totalLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        totalLabel.text = [NSString stringWithFormat:@"商品仅剩%@件",_model.storage];
        [view addSubview:totalLabel];
    }
//    
//        detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(priceLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 20 , SCREEN_WIDTH - 30, 30)];
//商品详情
    detailLabel = [[CopyLabel alloc]init];
    detailLabel.font = [UIFont systemFontOfSize:14];
    detailLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
        detailLabel.numberOfLines = 0;
        detailLabel.text = _model.content;
    NSString * string = _model.content;
    //detailLabel.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor clearColor]);
    detailLabel.layer.borderColor = [GetColor16 hexStringToColor:@"#ffffff"].CGColor;
    CGSize frame = [string sizeWithFont:SIZE_FOR_14 constrainedToSize:CGSizeMake(SCREEN_WIDTH - 20, 10000) lineBreakMode:NSLineBreakByWordWrapping];
    if ([_model.freeShipment isEqualToString:@"1"]) {
        detailLabel.frame = CGRectMake(titleLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 5, frame.width, frame.height);
    }else{
        detailLabel.frame = CGRectMake(titleLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 20, frame.width, frame.height + 10);
    }
//    detailLabel.frame = CGRectMake(titleLabel.frame.origin.x, priceLabel.frame.origin.y + priceLabel.frame.size.height + 20, frame.width, frame.height + 15);
    detailLabel.text = string;
    [view addSubview:detailLabel];
    
    
//
//      UIView * breakView2 = [[UIView alloc]initWithFrame:CGRectMake(0, detailLabel.frame.origin.y + detailLabel.frame.size.height + 10, SCREEN_WIDTH, 20)];
//        breakView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//        [view addSubview:breakView2];
//
//        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 175 + detailLabel.frame.size.height);
    //间隔 有商品详情
          UIView * breakView2 = [[UIView alloc]initWithFrame:CGRectMake(0, detailLabel.frame.origin.y + detailLabel.frame.size.height + 10, SCREEN_WIDTH, 10)];
            breakView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
            [view addSubview:breakView2];
    //无商品详情
//              UIView * breakView2 = [[UIView alloc]initWithFrame:CGRectMake(0, priceLabel.frame.origin.y + priceLabel.frame.size.height + 21, SCREEN_WIDTH, 10)];
//                breakView2.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
//                [view addSubview:breakView2];
    //规格
    sizeLabel = [[CopyLabel alloc]initWithFrame:CGRectMake(10, breakView2.frame.origin.y + breakView2.frame.size.height, SCREEN_WIDTH - 20, 40)];
    sizeLabel.textAlignment = NSTextAlignmentLeft;
    sizeLabel.font = [UIFont systemFontOfSize:15];
    sizeLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    sizeLabel.layer.borderColor = [GetColor16 hexStringToColor:@"#ffffff"].CGColor;
    sizeLabel.text = [NSString stringWithFormat:@"规格  %@",_model.size];
    //sizeLabel.backgroundColor = [UIColor blueColor];
    [view addSubview:sizeLabel];
    
    UIView * breakView3 = [[UIView alloc]initWithFrame:CGRectMake(0, sizeLabel.frame.origin.y + sizeLabel.frame.size.height, SCREEN_WIDTH, 10)];
    breakView3.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [view addSubview:breakView3];
    if ([_model.freeShipment isEqualToString:@"1"]) {

        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 227 + detailLabel.frame.size.height);

    }else{
        view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 242 + detailLabel.frame.size.height);
    }
    //有详情时
    //view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 242 + detailLabel.frame.size.height);
    //无详情时
    //view.frame = CGRectMake(0, 0, SCREEN_WIDTH, 232);
    return view;
}


- (void)jumpTap:(UIGestureRecognizer *)tap
{
    DetailActivityViewController * vc = [[DetailActivityViewController alloc]init];
    vc.idNumber = [NSString stringWithFormat:@"%ld",tap.view.tag];
    [self.navigationController pushViewController: vc animated:YES];
}

- (void)jubao:(id)sender
{
    ReportViewController * vc = [[ReportViewController alloc]init];
    vc.idNumber = _model.model_id;
//    vc.imageArr = _imageArr;
//    vc.photos = _model.photos;
    [self umengEvent:@"jubao" attributes:@{@"state" : @"举报"} number:@(0)];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)share:(UIButton *)sender
{
    isCommentTextView = YES;
    
    NSString *content = [NSString stringWithFormat:@"%@ %@",_model.content, _model.shortUrl];
    //NSString *content = [NSString stringWithFormat:@"%@",_model.content];
    if (content.length > 140) {
        content = [content substringToIndex:140];
    }
    [ShareViewController shareToThirdPlatformWithUIViewController:self Account:_model.account Nickname:_model.nickname Avatar:_model.avatar Cover:_model.cover IdNumber:self.idNumber Title:_model.title Content:content Photo:_model.photo Btn:sender ShareUrl:_model.shareUrl];
}
#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType;
{
    viewController.navigationController.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"#e5005d"];
}

- (UIView *)setDownView
{
    
    
    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 106, SCREEN_WIDTH, 42)];
//    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 205, SCREEN_WIDTH, 200)];
    //    UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, -3, SCREEN_HEIGHT, 3)];
    //    view1.backgroundColor = [UIColor blackColor];
    //    view1.alpha = 0.1;
    //    [view addSubview:view1];
    view1.backgroundColor = [UIColor whiteColor];
    //    view1.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    //    view1.layer.shadowOpacity = 0.8;
    //    view1.layer.shadowOffset = CGSizeMake(4, -4);
    
    view1.layer.shadowColor = [GetColor16 hexStringToColor:@"#c9c9c9"].CGColor;
    view1.layer.shadowOpacity = 0.6;
    view1.layer.shadowOffset = CGSizeMake(4, -1);
    
    float kuan = SCREEN_WIDTH / 3;
    
    shareButton = [DetailActivityBtn buttonWithType:UIButtonTypeCustom];
    shareButton.frame = CGRectMake(0, 0, kuan, 42);
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    [shareButton setImage:[UIImage imageNamed:@"goods_detail_share"] forState:UIControlStateNormal];
    shareButton.titleLabel.font = SetFont(TitleFont);
    [shareButton addTarget:self action:@selector(shareRequest) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:shareButton];
    
    collectButton = [DetailActivityBtn buttonWithType:UIButtonTypeCustom];
    collectButton.frame = CGRectMake(kuan, 0, kuan, 42);
    collectButton.titleLabel.font = SetFont(TitleFont);
    [collectButton setTitle:@"收藏" forState:UIControlStateNormal];
    [collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([isCollect isEqualToString: @"1"]) {
        [collectButton setTitleColor:[GetColor16 hexStringToColor:@"#E34286"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"topic_detail_collect_selected"] forState:UIControlStateNormal];
    }else{
        [collectButton setTitleColor:[GetColor16 hexStringToColor:@"#666666"] forState:UIControlStateNormal];
        [collectButton setImage:[UIImage imageNamed:@"topic_detail_collect_normal"] forState:UIControlStateNormal];
    }
    //[view1 addSubview:collectButton];
    
    payBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    payBuyButton.frame = CGRectMake(kuan * 2, 0, kuan, 42);
    [payBuyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //payBuyButton.titleLabel.font = SetFont(TitleFont);
    payBuyButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [payBuyButton setTitle:@"我要买" forState:UIControlStateNormal];
    payBuyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        if([_model.dealType isEqualToString:@"1"]) {
            
            if ([ACCOUNT_SELF isEqualToString:_model.account] || [ACCOUNT_SELF rangeOfString:@"guest"].location !=NSNotFound ||[_model.storage isEqualToString:@"0"] || self.canBuy == NO) {
                payBuyButton.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
                [payBuyButton addTarget:self action:@selector(buy1:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                payBuyButton.backgroundColor = [UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1];
                                [payBuyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
                                //[payBuyButton setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1]] forState:UIControlStateNormal];
                                //[payBuyButton setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
            }
        }
//            }else if( [_friendNumber isEqualToString:@"0"] && [_model.isFriended isEqualToString:@"0"])
//            {
//                payBuyButton.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
//                [payBuyButton addTarget:self action:@selector(buy1:) forControlEvents:UIControlEventTouchUpInside];
//            }else if(![_friendNumber isEqualToString:@"0"])
//            {
//                payBuyButton.backgroundColor = [UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1];
//                [payBuyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
//                [payBuyButton setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1]] forState:UIControlStateNormal];
//                [payBuyButton setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
//            }else if([_model.isFriended isEqualToString:@"1"])
//            {
//                payBuyButton.backgroundColor =  [UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1];
//                [payBuyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
//                [payBuyButton setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1]] forState:UIControlStateNormal];
//                [payBuyButton setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
//            }else{
//                payBuyButton.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
//                [payBuyButton addTarget:self action:@selector(buy1:) forControlEvents:UIControlEventTouchUpInside];
//            }
//        }

    [view1 addSubview:payBuyButton];
    
    //验证我要买是否可以点击
    [self checkBuyTaskOrderRequest];
    
    return view1;
}

//- (void)attent:(id)sender{
    - (IBAction)collectAction:(id)sender {
    if ([isCollect isEqualToString:@"1"]) {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountDeleteCollectedPost" parameters:@{ACCOUNT_PASSWORD, @"id": _model.model_id}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                //[attentButton setTitle:@"+ 收藏" forState:UIControlStateNormal];
                [collectButton setTitleColor:[GetColor16 hexStringToColor:@"#666666"] forState:UIControlStateNormal];
                [collectButton setImage:[UIImage imageNamed:@"topic_detail_collect_normal"] forState:UIControlStateNormal];
                isCollect = @"0";
                NSString * str = collectnum.text;
                collectnum.text = [NSString stringWithFormat:@"%d",[str intValue] - 1];
                [self umengEvent:@"attent" attributes:@{@"state" : @"cancel"} number:@(0)];
            }
            if(result == 4){
                [_tableView reloadData];
            }
            if (result == 1 || result == 2 || result == 3) {
                //                NSLog(@"%@",[dic objectForKey:@"message"]);
                //                [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
            }
        }];
    } else {
        //拼接post参数
        NSDictionary * dic = [self parametersForDic:@"accountCollectPost" parameters:@{ACCOUNT_PASSWORD, @"id": _model.model_id}];
        //发送post请求
        [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            int result = [[dic objectForKey:@"result"]intValue];
            if (result == 0) {
                //                NSLog(@"%@",[dic objectForKey:@"message"]);
                //            [AutoDismissAlert autoDismissAlert:@"收藏成功"];
                //[attentButton setTitle:@"已收藏" forState:UIControlStateNormal];
                [collectButton setTitleColor:[GetColor16 hexStringToColor:@"#E34286"] forState:UIControlStateNormal];
                [collectButton setImage:[UIImage imageNamed:@"topic_detail_collect_selected"] forState:UIControlStateNormal];
                isCollect = @"1";
                NSString * str = collectnum.text;
                collectnum.text = [NSString stringWithFormat:@"%d",[str intValue] + 1];
                [self umengEvent:@"attent" attributes:@{@"state" : @"yes"} number:@(0)];
            }
            if(result == 4){
                [_tableView reloadData];
            }
            if (result == 1 || result == 2 || result == 3) {
                //                NSLog(@"%@",[dic objectForKey:@"message"]);
                //                [AutoDismissAlert autoDismissAlert:POST_FAILURE_AlERT];
            }
        }];
    }
}

#pragma mark - 点击靠谱指数进入评价列表
- (void)allEvaluation:(UITapGestureRecognizer *)tap
{
    AllEvaluationsViewController * vc = [[AllEvaluationsViewController alloc]init];
    vc.username = _model.account;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIImage *)buttonImageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 100, 42);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
#pragma mark - 点击头像进入个人主页
- (void)aaaction:(id)sender
{
    PersonalViewController * vc = [[PersonalViewController alloc]init];
    vc.account = _model.account;
    vc.isFriend = _model.isFriended;
    vc.nickname = _model.nickname;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)buy1:(id)sender
{
    [self.view bringSubviewToFront:tishiView];
    [self setViewForBuy];
    tishiView.hidden = NO;
    //[AutoDismissAlert autoDismissAlert:@"亲,不符合购买条件~"];
    return;
}

- (void)buy:(id)sender
{
    if ([_model.dealType isEqualToString:@"1"]) {
        TransactionDetailViewController * vc = [[TransactionDetailViewController alloc]init];
        vc.goodsID = _idNumber;
        vc.goodsNum = _model.storage;
        vc.shurenNum = _friendNumber;
        vc.danbaoNum = _guaranteeNumber;
        vc.account = _model.account;
        vc.friendsign = _model.isFriended;
        vc.spOrderID = self.spOrderID;
        if ([_model.freeShipment isEqualToString:@"1"]) {
            vc.postSign = @"1";
        }else{
            vc.postSign = @"0";
        }
        [self umengEvent:@"buy" attributes:@{@"state" : @"进入"} number:@(0)];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)toChatView:(UIButton *)sender
{
//    UIActionSheet *chatActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"是否发送信息链接" otherButtonTitles:@"发送",@"不发送", nil];
    actionSheet2 =  [[UIActionSheet alloc]initWithTitle:@"是否发送信息链接" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"发送",@"不发送", nil];
    [actionSheet2 showInView:self.view];
}


//单聊
- (void)chat
{
    MyChatViewController * myChatVC = [[MyChatViewController alloc]init];
    NSDictionary * tempDic = @{@"account": _model.account, @"nickname":_model.nickname, @"avatar":_model.avatar};
    
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = [tempDic objectForKey:@"account"];
    user.name = [tempDic objectForKey:@"nickname"];
    user.portraitUri = [tempDic objectForKey:@"avatar"];
    myChatVC.portraitStyle = RCUserAvatarCycle;
    myChatVC.currentTarget = user.userId;
    myChatVC.currentTargetName = user.name;
    myChatVC.conversationType = ConversationType_PRIVATE;
    myChatVC.hidesBottomBarWhenPushed = YES;
    [self umengEvent:@"chat" attributes:@{@"state" : @"不发送"} number:@(0)];
    [self.navigationController pushViewController:myChatVC animated:YES];
}

//图文聊天
- (void)chatRichContentMessage
{
    //图文单聊
    RichContentMessageViewController *temp = [[RichContentMessageViewController alloc]init];
    NSDictionary * tempDic = @{@"account": _model.account, @"nickname":_model.nickname, @"avatar":_model.avatar};
    
    temp.title = _model.title;
    temp.content = _model.content;
    temp.imageUrl = _model.cover;
    temp.photo = _model.photo;
    temp.idNumber = self.idNumber;
    temp.currentTarget = [tempDic objectForKey:@"account"];
    temp.currentTargetName = [tempDic objectForKey:@"nickname"];
    temp.conversationType = ConversationType_PRIVATE;
    temp.enableSettings = NO;
    temp.portraitStyle = RCUserAvatarCycle;
    temp.hidesBottomBarWhenPushed = YES;
    [self umengEvent:@"chat" attributes:@{@"state" : @"发送"} number:@(0)];
    [self.navigationController pushViewController:temp animated:YES];
    [temp sendDebugRichMessage];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        if ([_model.dealType isEqualToString:@"1"]) {
//            if (indexPath.section == 0) {
//                PersonalViewController * vc = [[PersonalViewController alloc]init];
//                vc.account = guaranteeModel.account;
//                vc.nickname = guaranteeModel.nickname;
//                [self.navigationController pushViewController:vc animated:YES];
//            }
            if (indexPath.section == 0) {
                PersonalViewController * vc = [[PersonalViewController alloc]init];
                vc.account = commenFModel.account;
                vc.nickname = commenFModel.nickname;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.section == 1) {
                PersonalViewController * vc = [[PersonalViewController alloc]init];
                vc.account = markModel.account;
                vc.nickname = markModel.nickname;
                [self.navigationController pushViewController:vc animated:YES];
            }
            if (indexPath.section == 2) {
            
                ConsultViewController * vc = [[ConsultViewController alloc]init];
                vc.idNumber = _idNumber;
                [self.navigationController pushViewController:vc animated:YES];
            }

        }
        else{
            PersonalViewController * vc = [[PersonalViewController alloc]init];
            vc.account = [_contentArr[indexPath.row] account];
            vc.nickname = [_contentArr[indexPath.row] nickname];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if (tableView == tableViewRight) {
        SubclassDetailViewController * vc = [[SubclassDetailViewController alloc]init];
        vc.idNumber = [_dataArray[indexPath.row] ID];
        [self.navigationController pushViewController:vc animated:YES];
        [self.leftSideBar dismissAnimated:YES];
    }
}

- (void)photoAction:(id)sender
{
    UIButton * button = sender;
    NSInteger i = button.tag - 100;
    SubclassDetailViewController * vc = [[SubclassDetailViewController alloc]init];
    vc.idNumber = [_dataArray[i] ID];
    [self.navigationController pushViewController:vc animated:YES];
    [self.leftSideBar dismissAnimated:YES];
}
//点击进入个人详情（咨询Item）
- (void)headImageTap:(UITapGestureRecognizer *)sender
{
    NSLog(@"sjfingoankdvoowr389798t752834752039752308794509238754");
    MyImgView *imgV = (MyImgView *)sender.view;
    BussinessModel *model = [_contentArr objectAtIndex:imgV.indexpath.row];
    PersonalViewController * vc = [[PersonalViewController alloc]init];
    vc.account = model.account;
    vc.nickname = model.nickname;
    [self.navigationController pushViewController:vc animated:YES];
}
- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewRight) {
        RightLookCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[RightLookCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        [cell.button sd_setBackgroundImageWithURL:[NSURL URLWithString:[_dataArray[indexPath.row] cover]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"wutu.png"]];
        cell.button.contentMode = UIViewContentModeScaleAspectFill;
        cell.button.clipsToBounds = YES;
        cell.button.tag = indexPath.row + 100;
        [cell.button addTarget:self action:@selector(photoAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.label.text = [_dataArray[indexPath.row] title];
        if ([[_dataArray[indexPath.row]dealType] isEqualToString:@"1"]) {
            [cell.priceLabel setHidden:NO];
            cell.priceLabel.text = [NSString stringWithFormat:@"￥ %@", [_dataArray[indexPath.row]bangPrice]];
        }else{
            [cell.priceLabel setHidden:YES];
        }
//        UISwipeGestureRecognizer * swipGes = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipCell:)];
//        swipGes.direction = UISwipeGestureRecognizerDirectionLeft;
//        [cell addGestureRecognizer:swipGes];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }

    if (indexPath.section == 0 && [_model.dealType isEqualToString:@"1"]) {
        if (_friendNumber.length != 0) {
            CommonFriendCell * cell = [[CommonFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
            cell.chatBtn.hidden = YES;
            [cell.imgView sd_setImageWithURL:[NSURL URLWithString:commenFModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            cell.imgView.contentMode = UIViewContentModeScaleAspectFill;
            cell.imgView.clipsToBounds = YES;
            cell.titleLabel.text = commenFModel.nickname;
            cell.signLabel.text = commenFModel.sign;
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell.chatBtn removeFromSuperview];
            return cell;
        }
    }
    if (indexPath.section == 1) {
        if (_markNumber.length != 0) {
            DetailCommentCell * cell = [[DetailCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[markModel avatar]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
            cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
            cell.headImage.clipsToBounds = YES;
            cell.titleLabel.text =[markModel nickname];
            cell.sayLabel.text = [markModel content];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate * date = [dateFormatter dateFromString:[markModel updatetime]];
            [dateFormatter setDateFormat:@"MM-dd"];
            NSString * str = [dateFormatter stringFromDate:date];
            cell.dateLabel.text = str;
            return cell;
        }
    }
    if (indexPath.section == 2) {
        if (_contentNumber.length != 0) {
            DetailCommentCell * cell = [[DetailCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
            
            if ([_contentArr[indexPath.row]touser] != nil) {
                NSDictionary * dic = (NSDictionary *) [_contentArr[indexPath.row] touser];
                cell.sayToWhoLabel.text = [dic objectForKey:@"nickname"];
                [cell.sayToWhoLabel sizeToFit];
            }else{
                cell.huifuLabel.hidden = YES;
                cell.sayLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x,cell.titleLabel.frame.origin.y + cell.titleLabel.frame.size.height + 12, SCREEN_WIDTH - 80, 17);
            }
            [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[_contentArr[indexPath.row] avatar]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
            UITapGestureRecognizer *headImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTap:)];
            [cell.headImage addGestureRecognizer:headImgTap];
            cell.headImage.indexpath = indexPath;

            cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
            cell.headImage.clipsToBounds = YES;
            cell.titleLabel.text =[_contentArr[indexPath.row] nickname];
            cell.sayLabel.text = [_contentArr[indexPath.row] content];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            BussinessModel * model = _contentArr[indexPath.row];
            double i = model.updatetimeLong;
            cell.dateLabel.text = [CompareCurrentTime compareCurrentTime:i];;
            return cell;
        }
    }
    else{
        DetailCommentCell * cell = [[DetailCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell3"];
        
        if ([_contentArr[indexPath.row]touser] != nil) {
            NSDictionary * dic = (NSDictionary *) [_contentArr[indexPath.row] touser];
            cell.sayToWhoLabel.text = [NSString stringWithFormat:@"%@:",[dic objectForKey:@"nickname"]];
            [cell.sayToWhoLabel sizeToFit];
        }else{
            cell.huifuLabel.hidden = YES;
            cell.sayLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x,cell.titleLabel.frame.origin.y + cell.titleLabel.frame.size.height + 12, SCREEN_WIDTH - 80, 19);
        }
        [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[_contentArr[indexPath.row] avatar]]placeholderImage:[UIImage imageNamed:@"zanwu"]];
        UITapGestureRecognizer *headImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageTap:)];
        [cell.headImage addGestureRecognizer:headImgTap];
        cell.headImage.indexpath = indexPath;

        cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
        cell.headImage.clipsToBounds = YES;
        cell.titleLabel.text =[_contentArr[indexPath.row] nickname];
        cell.sayLabel.text = [_contentArr[indexPath.row] content];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        BussinessModel * model = _contentArr[indexPath.row];
        double i = model.updatetimeLong;
        cell.dateLabel.text = [CompareCurrentTime compareCurrentTime:i];
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (tableView == tableViewRight) {
        return 0.01;
    }else if(tableView == _tableView){
        if ([_model.dealType isEqualToString:@"1"]) {
//            if ([ACCOUNT_SELF isEqualToString:GUEST] || [_model.account isEqualToString:ACCOUNT_SELF]) {
//                if (section == 1) {
//                    return 0.01;
//                }
//                return 40;
//            }
            return 40;
        }
        if ([_model.dealType isEqualToString:@"2"]) {
            return 40;
        }
        if ([_model.dealType isEqualToString:@"0"]) {
            return 40;
        }
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tableViewRight) {
        return 153;
    }
    if (tableView == _tableView) {
        if ([_model.dealType isEqualToString:@"1"]) {
//            if (indexPath.section == 0) {
//                if (_guaranteeNumber.length != 0) {
//                    return 70;
//                }
//            }
            if (indexPath.section == 0) {
                if (_friendNumber.length != 0) {
                    return 70;
                }
            }
            if (indexPath.section == 1) {
                if (_markNumber.length != 0) {
                    return 70;
                }
            }
            if (indexPath.section == 2) {
                if (_contentNumber.length != 0) {
                    return 70;
                }
            }
        }
    }
    return 70;
}

- (void)swipCell:(UISwipeGestureRecognizer *)swip
{
    RightLookCell * cell = (RightLookCell *)swip.view;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (tableView == tableViewRight) {
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            BrowsingHistoryModel * browsingHistory = self.dataArray[indexPath.row];
//            NSDictionary * dic = [self parametersForDic:@"accountDeletePostHistory" parameters:@{ACCOUNT_PASSWORD,@"id":browsingHistory.ID}];
//            [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//                [self urlRequest];
//            } andFailureBlock:^{
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//                
//            }];
//        }
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"dealtype = %@", _model.dealType);
    if (tableView == tableViewRight) {
        return _dataArray.count;
    }
    if (tableView == _tableView && [_model.dealType isEqualToString:@"1"]){
//            if (section == 0) {
//                if (_guaranteeNumber.length != 0) {
//                    return 0;
//                }
//            }
            if (section == 0) {
                if (_friendNumber.length != 0) {
                    return 0;
                }
            }
            if (section == 1) {
                if (_markNumber.length != 0) {
                    return 0;
                }
            }
            if (section == 2) {
                if (_contentNumber.length != 0) {
                    return _contentArr.count;
                }
            }
    }if (tableView == _tableView && [_model.dealType isEqualToString:@"2"] && section == 0) {
        return _contentArr.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _tableView && [_model.dealType isEqualToString:@"1"]) {
        return 3;
    }else if (tableView == _tableView && [_model.dealType isEqualToString:@"0"]) {
        return 2;
    }else if (tableView == tableViewRight) {
        return 1;
    }
    return 2;
}

- (void)function:(id)sender
{
    if (_scrollView.contentOffset.x/SCREEN_WIDTH <= 0) {
        duration = NO;
    }
    
    if (_scrollView.contentOffset.x/SCREEN_WIDTH < _imageArr.count - 1 && !duration) {
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x + SCREEN_WIDTH/2, 0);
            _page.currentPage = _scrollView.contentOffset.x / SCREEN_WIDTH ;
        }];
    }else {
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(_scrollView.contentOffset.x-SCREEN_WIDTH/2, 0);
            _page.currentPage = _scrollView.contentOffset.x / SCREEN_WIDTH ;
        }];
        duration = YES;
    }
}

- (void)pageControlAction:(UIPageControl *)page
{
    [_scrollView setContentOffset:CGPointMake(page.currentPage * SCREEN_WIDTH, 0) animated:YES];
}

- (UIView *)peopleView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 120)];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        UIView *v_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];//创建一个视图（v_headerView）
        v_headerView.backgroundColor = [UIColor whiteColor];
        
        UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, v_headerView.frame.origin.y , SCREEN_WIDTH, 0.5)];
        breakView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
        [v_headerView addSubview:breakView];
        
        UIImageView * image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 20, 20)];
        image.backgroundColor = [UIColor clearColor];
        [v_headerView addSubview:image];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(image.frame.origin.x + image.frame.size.width + 25,  10, 150, 20)];
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = [GetColor16 hexStringToColor:@"#434343"];
        [v_headerView addSubview:label];
        
        UILabel * moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 80, label.frame.origin.y + 1.5, 40, 16)];
        moreLabel.text = @"更多 >";
        moreLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
        moreLabel.font = [UIFont systemFontOfSize:12];
        moreLabel.center = CGPointMake(SCREEN_WIDTH - 35, label.center.y);
        [v_headerView addSubview:moreLabel];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [v_headerView addSubview:button];
        
        //[v_headerView addSubview:button];
        if ([_model.dealType isEqualToString:@"1"]) {

            if (section == 0) {
                if (_friendNumber.length == 0) {
                    label.text = [NSString stringWithFormat:@"共同熟人(0)人"];
                }else{
                    label.text = [NSString stringWithFormat:@"共同熟人(%@)人",_friendNumber];
                }
                [label sizeToFit];
                image.image = [UIImage imageNamed:@"detail_section_commonfriend.png"];
                button.tag = 101;
                for (int i = 0 ; i < _friendArr.count; i++) {
                    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
                    imageV.center = CGPointMake(label.frame.origin.x + label.frame.size.width + 15 + i * 32, 20);
                    [imageV sd_setImageWithURL:[NSURL URLWithString:[_friendArr[i] avatar] ]placeholderImage:[UIImage imageNamed:@"wutu"]];
                    imageV.contentMode = UIViewContentModeScaleAspectFill;
                    imageV.clipsToBounds = YES;
                    imageV.layer.cornerRadius = 12.5;
                    imageV.layer.masksToBounds = YES;
                    [v_headerView addSubview:imageV];
                }
            }
            if (section == 1) {
                if (_markNumber.length == 0) {
                    label.text = [NSString stringWithFormat:@"交易评价(0)条"];
                }else{
                    label.text = [NSString stringWithFormat:@"交易评价(%@)条",_markNumber];
                }
                [label sizeToFit];
                image.image = [UIImage imageNamed:@"detail_section_comment.png"];
                button.tag = 102;

            }
            if (section == 2) {
                if (_contentNumber.length == 0) {
                    label.text = [NSString stringWithFormat:@"咨询留言(0)条"];
                }else{
                    label.text = [NSString stringWithFormat:@"咨询留言(%@)条",_contentNumber];
                }
                [label sizeToFit];
                moreLabel.hidden = YES;
                UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 75,7.5, 60, 25)];
                [button setTitle:@"咨 询" forState:UIControlStateNormal];
                [button setTitleColor:WHITE forState:UIControlStateNormal];
                button.layer.masksToBounds = YES;
                button.layer.cornerRadius = 2;
                button.titleLabel.font = [UIFont systemFontOfSize:14];
                [button addTarget:self action:@selector(downButtonAction) forControlEvents:UIControlEventTouchUpInside];
                [button setBackgroundImage:[UIImage imageNamed:@"qianfen"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"fenhong"] forState:UIControlStateHighlighted];
                [v_headerView addSubview:button];
                image.image = [UIImage imageNamed:@"detail_section_ask.png"];
                button.tag = 103;
                
                UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, v_headerView.frame.size.height - 1, SCREEN_WIDTH, 0.5)];
                breakView.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
                [v_headerView addSubview:breakView];
                                //}
                            }
                
                       }
                 return v_headerView;//将视图（v_headerView）返回
                    }
                    return nil;
                }




#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

- (void)buttonAction:(id)sender
{
    UIButton * button = sender;
//    if (button.tag == 100) {
//        GuaranteeListViewController * vc = [[GuaranteeListViewController alloc]init];
//        vc.idnumber = _idNumber;
//        [self.navigationController pushViewController:vc animated:YES];
//    }else
        if (button.tag == 101) {
            SubCommonFriendViewController * vc = [[SubCommonFriendViewController alloc]init];
            vc.sellerAccount = _model.account;
            vc.title = _model.title;
            vc.idNumber = self.idNumber;
            vc.content = _model.content;
            vc.imageUrl = _model.cover;
            vc.photo = _model.photo;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
            if (button.tag == 102) {
                EvaluateViewController * vc = [[EvaluateViewController alloc]init];
                vc.idNumber = _idNumber;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else{
                ConsultViewController * vc = [[ConsultViewController alloc]init];
                vc.idNumber = _idNumber;
                [self.navigationController pushViewController:vc animated:YES];
            }
}

- (void)post
{
    if (self.idNumber == nil || [self.idNumber isEqualToString:@""] || self.idNumber .length == 0) {
        [AutoDismissAlert autoDismissAlert:@"商品已下架"];
        [loadImg removeFromSuperview];
        return;
    }
    
    
    [loadImg removeFromSuperview];
    loadImg = [[LoadImg alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    loadImg.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [self.view addSubview:loadImg];
    [loadImg imgStart];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostDetail" parameters:@{ACCOUNT_PASSWORD, @"id": _idNumber}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
//            NSLog(@"%@",[dic objectForKey:@"message"]);
            _model = [[DetailModel alloc]init];
            [_model setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            NSLog(@"detail data == %@",[dic objectForKey:@"data"]);
            //[self navigationButton];
            isCollect = _model.isCollected;
            //[self setTheView];
//            UIView * view = [[UIView alloc]init];
//            view = [self setDownView];
//            [self.view addSubview:view];
            //[self protectPost];
            [self postContent];
            imageview.hidden = YES;
        }else{
            [loadImg imgStop];
            [loadImg removeFromSuperview];
            imageview.hidden = NO;
        }
    }andFailureBlock:^{
        
    }];
}


#pragma mark -
- (void)postCommonFriend
{
    if (_model.account == nil) {
        [AutoDismissAlert autoDismissAlert:@"用户不存在"];
        [loadImg imgStop];
        [loadImg removeFromSuperview];
        return;
    }
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendCommon" parameters:@{ACCOUNT_PASSWORD,@"user":_model.account,@"start":@"0",@"count":@"20"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [_friendArr removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            _friendNumber = [[dic objectForKey:@"data"] objectForKey:@"totalCount"];
//            commenFModel = [[CommenFriendModel alloc]init];
//            [commenFModel setValuesForKeysWithDictionary:temparrs.firstObject];
            NSInteger j = 3 < temparrs.count ? 3:temparrs.count;
            for (int i = 0; i < j; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [_friendArr addObject:bussinessModel];
            }
        }else if (result == 4){
            //没有找到数据
            _friendNumber = @"0";
        }else{
            NSLog(@"%@",[dic objectForKey:@"message"]);
        }
        [self postTuijian];
    }andFailureBlock:^{
        
    }];
}

- (void)postTuijian
{
    NSDictionary * dic = [self parametersForDic:@"getPostHandByRelation" parameters:@{ACCOUNT_PASSWORD,@"id":_model.model_id,@"start":@"0",@"count":@"10", @"isFriended":@"0"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            [_tuijianArr removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSInteger j = 5 < temparrs.count ? 5:temparrs.count;
            for (int i = 0; i < j; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                [_tuijianArr addObject:tempdic];
            }
        }else{
//            NSLog(@"%@",[dic objectForKey:@"message"]);
        }
        [self checkOnline];
        [_tableView reloadData];
        //[self navigationButton];
        [self setTheView];
        
        [self delayMethod];
        
        [loadImg imgStop];
        [loadImg removeFromSuperview];
        [self.view addSubview:detailCommentView];
    } andFailureBlock:^{
        
    }];
}

- (void)delayMethod
{
    UIView * view = [[UIView alloc]init];
    view = [self setDownView];
    [self.view addSubview:view];
    [HUD removeFromSuperview];
    
}

//post请求
- (void)postMark
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostMarkByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0",@"id":_idNumber,@"start":@"0", @"count":@"10"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic){
//        NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [_markArr removeAllObjects];
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            _markNumber = [[dic objectForKey:@"data"] objectForKey:@"totalCount"];
            NSInteger j = 3 < temparrs.count ? 3:temparrs.count;
            for (int i = 0; i < j; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [_markArr addObject:bussinessModel];
            }
        }else{
//            NSLog(@"%@",[dic objectForKeyedSubscript:@"message"]);
        }
        [self postCommonFriend];
    }andFailureBlock:^{
        
    }];
}

- (void)postContent
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriend": _model.isFriended, @"id":_idNumber, @"start":@"0", @"count":@"100"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [_contentArr removeAllObjects];
//            NSLog(@"%@",[dic objectForKey:@"message"]);
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            _contentNumber = [[dic objectForKey:@"data"] objectForKey:@"totalCount"];
//            commentModel = [[CommentsModel alloc]init];
//            [commentModel setValuesForKeysWithDictionary:temparrs.firstObject];
//            NSMutableArray * arr = [[NSMutableArray alloc]init];
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                if ([tempdic objectForKey:@"touser"] != nil) {
//                    
//                }else{
//                    [arr addObject:temparrs[i]];
//                }
//            }
//            NSInteger j = 3 < arr.count ? 3:arr.count;
//            for (int i = 0; i < j; i++) {
//                NSDictionary * tempdic = [arr objectAtIndex:i];
//                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
//                [bussinessModel setValuesForKeysWithDictionary:tempdic];
//                [_contentArr addObject:bussinessModel];
//            }
            NSInteger j = 3 < temparrs.count ? 3:temparrs.count;
            for (int i = 0; i < j; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                BussinessModel * bussinessModel = [[BussinessModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [_contentArr addObject:bussinessModel];
            }
        }
        else{
//            NSLog(@"%@",[dic objectForKey:@"message"]);
        }
        [self postMark];
    }andFailureBlock:^{
        
    }];
}
//检查是否在线
- (void)checkOnline
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"checkRongcloudOnline" parameters:@{@"user":_model.account}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *status = [[dic objectForKey:@"data"]objectForKey:@"status"];
        NSLog(@"status == %@",status);
        if ([status isEqualToString:@"1"]) {
            [self.chatbutton setImage:[UIImage imageNamed:@"detail_activity_comment_selected"] forState:UIControlStateNormal];
        }else if ([status isEqualToString:@"0"]){
            [self.chatbutton setImage:[UIImage imageNamed:@"detail_activity_comment_normal"] forState:UIControlStateNormal];
        }
    } andFailureBlock:^{
        
    }];
}
//验证我要买是否可以点击
-(void)checkBuyTaskOrderRequest {
    if (!self.spOrderID) {
        return;
    }
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountCheckBuyTaskOrder" parameters:@{ACCOUNT_PASSWORD, @"id": self.spOrderID, @"goodsId": self.idNumber}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *status = [dic objectForKey:@"result"];
        
        if ([status isEqualToString:@"0"]){
            
        }else {
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
            //不可购买
            //payBuyButton.backgroundColor = [UIColor yellowColor];
            payBuyButton.backgroundColor = [UIColor colorWithRed:0.58 green:0.58 blue:0.58 alpha:1];
            [payBuyButton removeTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
            [payBuyButton addTarget:self action:@selector(buy1:) forControlEvents:UIControlEventTouchUpInside];
        }
    } andFailureBlock:^{
        
    }];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration=0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard1" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,64,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSTimeInterval animationDuration=0.10f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-120,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    return YES;
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length == 0 ) {
        //self.placeHolderLabel.hidden = NO;
        submitBtn.enabled = NO;
        [submitBtn setBackgroundImage:[self imageWithColor:[GetColor16 hexStringToColor:@"#959595"] size:submitBtn.frame.size] forState:UIControlStateNormal];
    }else{
        //self.placeHolderLabel.hidden = YES;
        submitBtn.enabled = YES;
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    }
}
//#pragma mark growingTextView 代理
//- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
//{
//    float diff = (growingTextView.frame.size.height - height);
//    
//    CGRect r = detailCommentView.frame;
//    r.size.height -= diff;
//    r.origin.y += diff;
//    detailCommentView.frame = r;
//    
//    if (isKeyboardHidden == NO) {
//        CGRect viewRect = self.view.frame;
//        viewRect.origin.y += diff;
//        self.view.frame = viewRect;
//    }
//    
//    submitBtn.frame = CGRectMake(self.hpTextView.frame.size.width + self.hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 60, 25);
//}

-(void)umengEvent:(NSString *)eventId attributes:(NSDictionary *)attributes number:(NSNumber *)number{
    NSString *numberKey = @"__ct__";
    NSMutableDictionary *mutableDictionary = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [mutableDictionary setObject:[number stringValue] forKey:numberKey];
    [MobClick event:eventId attributes:mutableDictionary];
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
