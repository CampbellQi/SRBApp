//
//  TopicCommentListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
static int page = 0;
static int count = NumOfItems;

#import "TopicCommentListController.h"
#import "TopicCommentListCell.h"
#import "UIScrollView+MJRefresh.h"
#import "LayoutFrame.h"
#import "StringHelper.h"
#import "TopicCommentModel.h"
#import "CommentsModel.h"
#import "AppDelegate.h"
#import "PersonalViewController.h"

@interface TopicCommentListController ()
@property (nonatomic, strong)NSMutableArray *dataArray;
//@property (nonatomic, strong)NSMutableArray *cellContentHeightArray;
@end

@implementation TopicCommentListController
{
    BOOL _isComment;
    TopicCommentModel *_editModel;
    BOOL _isReplay;
}
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
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    _isReplay = NO;
    
    [self setUpView];
    
    [self.tableView headerBeginRefreshing];
    [self listenKeyboard];
    if (self.isCommon) {
        [self.commentTextView becomeFirstResponder];
    }
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
#pragma mark- 页面
-(void)setUpView {
    self.tableView.tableFooterView = [UIView new];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [self.tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    //左导航
    self.title = @"话题评论";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}
#pragma mark- 事件
-(void)backBtnClicked:(UIButton *)sender {
    if (_isComment && self.backBlock) {
        self.backBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 数据
-(void)addDataArray:(TopicCommentModel *)topicCommentModel {
    [self.dataArray addObject:topicCommentModel];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    [paragraphStyle setLineSpacing:4];
    NSDictionary *attriDict = @{NSFontAttributeName:[UIFont systemFontOfSize:14.0], NSParagraphStyleAttributeName: paragraphStyle};
    if (topicCommentModel.touser) {
        topicCommentModel.content = [NSString stringWithFormat:@"回复%@：%@", topicCommentModel.touser[@"nickname"],topicCommentModel.content];
    }
    CGSize size = [topicCommentModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attriDict context:nil].size;
    
    if (size.height > 18 + 4) {
        topicCommentModel.attrContentHeight = size.height + 18 + 2 * 4;
    }else {
        topicCommentModel.attrContentHeight = size.height;
    }
    
    topicCommentModel.attrContent = [[NSAttributedString alloc] initWithString:topicCommentModel.content attributes:attriDict];
    //[self.cellContentHeightArray addObject:[NSString stringWithFormat:@"%f", size.height]];
}

#pragma mark- 监听键盘
-(void)listenKeyboard {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardDidShow:(NSNotification *)notification
{
    CGRect keyBoardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSValue *animationDurationValue = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        if (self.commentTF.isFirstResponder) {
            [LayoutFrame showViewConstraint:self.commentTF AttributeBottom:keyBoardRect.size.height + 9];
            //键盘弹出来就取消评论状态
            _isReplay = NO;
        }else {
            [LayoutFrame showViewConstraint:self.commentView AttributeBottom:keyBoardRect.size.height];
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHidden:(NSNotification *)notification
{
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        if (self.commentTF.isFirstResponder) {
            [LayoutFrame showViewConstraint:self.commentTF AttributeBottom:9];
            self.commentTF.placeholder = @"添加一条评论...";
        }else {
            [LayoutFrame showViewConstraint:self.commentView AttributeBottom:-self.commentView.height];
        }
        
        
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark- 控件点击事件
-(void)hideKeyboard {
    [self.commentTF resignFirstResponder];
}
- (IBAction)cancelClicked:(id)sender {
    [self.commentTextView resignFirstResponder];
}

- (IBAction)sendClicked:(id)sender {
    NSString *content = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    [self commentRequest:content];
}
-(void)praiseClicked:(UIButton *)sender {

}
#pragma mark- textfiled delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (_isReplay) {
        return YES;
    }else{
        self.commentTF.placeholder = @"添加一条评论...";
        [self.commentTextView becomeFirstResponder];
        return NO;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *content = [textField.text trim];
    [self commentRequest:content];
    return YES;
}
#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = @"TopicCommentListCell";
    TopicCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
    }
    cell.sourceModel = [_dataArray objectAtIndex:indexPath.row];
    
    //标签点击
    __block typeof(self) unself = self;
    //头像点击
    cell.avaterClickedBlock = ^(NSString *account) {
        PersonalViewController * personVC = [[PersonalViewController alloc]init];
        personVC.account = account;
        personVC.myRun = @"2";
        [unself.navigationController pushViewController:personVC animated:YES];
    };
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TopicCommentModel *model = _dataArray[indexPath.row];
    return 81 + model.attrContentHeight - 18;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     TopicCommentModel * model = [_dataArray objectAtIndex:indexPath.row];
    _editModel = model;
    if ([model.account isEqualToString:ACCOUNT_SELF]) {
        [self deleteComment];
    }else {
        _isReplay = YES;
        [self.commentTextView resignFirstResponder];
        self.commentTF.placeholder = [NSString stringWithFormat:@"回复 %@", model.nickname];
        [self.commentTF becomeFirstResponder];
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyboard];
}
#pragma mark- 网络请求 
-(void)commentRequest:(NSString *)content {
    if (!content || content.length == 0) {
        return;
    }
    NSString *markId = @"0";
    if ([_commentTF isFirstResponder] && _editModel) {
        markId = _editModel.markId;
    }
    NSDictionary * param = [self parametersForDic:@"accountCommentPost" parameters:@{ACCOUNT_PASSWORD,@"markId":markId, @"id":_sourceModel.model_id, @"content":content}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        [self hideKeyboard];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self.commentTextView resignFirstResponder];
            self.commentTextView.text = @"";
            self.commentTF.text = @"";
            [self.tableView headerBeginRefreshing];
            self.sourceModel.consultCount = [NSString stringWithFormat:@"%d", [self.sourceModel.consultCount intValue] + 1];
            _isComment = YES;
        }else if([result isEqualToString:@"4"]){
            
        }else{
            
        }

    } andFailureBlock:^{

    }];
}
-(void)headerRefresh {
    [self loadNewDataListRequest];
}
-(void)footerRefresh {
    [self loadMoreDataListRequest];
}
//最评评论列表
- (void)loadNewDataListRequest
{
    page = 0;
    NSDictionary * param = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD,@"isFriended":@"0",@"id":_sourceModel.model_id, @"start":@"0", @"count":[NSString stringWithFormat:@"%d",count]}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [self.dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TopicCommentModel * topicCommentModel = [[TopicCommentModel alloc]init];
                [topicCommentModel setValuesForKeysWithDictionary:tempdic];
                [self addDataArray:topicCommentModel];
                self.nodataIV.hidden = YES;
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                //[self.dataArray addObject:topicCommentModel];
            }
            
        }else if([result isEqualToString:@"4"]){
            self.nodataIV.hidden = NO;
        }else{
            
        }
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
    } andFailureBlock:^{
        [self.tableView headerEndRefreshing];
    }];
    
}
//更多评论列表
- (void)loadMoreDataListRequest
{
    page += NumOfItems;
    NSDictionary * param = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0", @"id":_sourceModel.model_id, @"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",count]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                TopicCommentModel * topicCommentModel = [[TopicCommentModel alloc]init];
                [topicCommentModel setValuesForKeysWithDictionary:tempdic];
                //[self.dataArray addObject:topicCommentModel];
                [self addDataArray:topicCommentModel];
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
//标签
- (void)deleteComment
{
    if (down_IOS_8) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1;
        [alert show];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定删除?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteCommentRequest];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteCommentRequest];
    }
    
}
-(void)deleteCommentRequest {
    MBProgressHUD * HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"删除中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountDeleteCommentPost" parameters:@{ACCOUNT_PASSWORD, @"markId": _editModel.markId}];
    
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        [HUD removeFromSuperview];
        //                NSLog(@"%@",[dic objectForKey:@"message"]);
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [self.dataArray removeObject:_editModel];
            [self.tableView reloadData];
            _isComment = YES;
        }else{
            [AutoDismissAlert autoDismissAlertSecond:[dic objectForKeyedSubscript:@"message"]];
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
