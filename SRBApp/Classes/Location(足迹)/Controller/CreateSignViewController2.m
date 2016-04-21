//
//  CreateSignViewController2.m
//  SRBApp
//
//  Created by fengwanqi on 15/12/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define FOOTERPRINT_TYPE 1
#define TOPIC_TYPE 2
#define MAX_WORDS_COUNT 8

#import "CreateSignViewController2.h"
#import "FootPrintDWTagList.h"
#import "CommonView.h"

@interface CreateSignViewController2 ()
{
    NSMutableArray *_dataArray;
    NSMutableArray *_selectedSignArray;
    int _type;
    
    NSDictionary *_deleteSignDict;
    NSString *_deleteMethod;
    
    BOOL _isAlertShow;
}
@end

@implementation CreateSignViewController2
-(id)initWithFooterPrint {
    if (self = [super init]) {
        _type = FOOTERPRINT_TYPE;
    }
    return self;
}
-(id)initWithTopic {
    if (self = [super init]) {
        _type = TOPIC_TYPE;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isAlertShow = NO;
    // Do any additional setup after loading the view from its nib.
    if (!_selectedSignArray) {
        _selectedSignArray = [NSMutableArray new];
    }
    
    if (_type == TOPIC_TYPE) {
        self.msgLbl.text = @"添加标签参与话题，把经验分享给更多人~\n标签最多可选三个";
    }else {
        self.msgLbl.text = @"添加标签，方便查找~\n标签最多可选三个";
    }
    
    
    self.title = @"标签";
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"完 成" Target:self Action:@selector(completedBtnClicked)];
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    self.tableView.tableHeaderView = [UIView new];
    
    [self loadData];
    
}
#pragma mark- 事件
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)completedBtnClicked {
    if (self.completeBlock) {
        self.completeBlock(_selectedSignArray);
    }
    [self backBtnClicked];
}
- (IBAction)addBtnClicked:(id)sender {
    //预防重复添加
    NSString * signStr = [self.signTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (signStr.length == 0) {
        return;
    }
    if (signStr.length > MAX_WORDS_COUNT) {
        [AutoDismissAlert autoDismissAlertSecond:[NSString stringWithFormat:@"标签不能超过%d个字", MAX_WORDS_COUNT]];
        return;
    }else {
        [self addSignRequest:signStr];
    }
}
#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    FootPrintDWTagList *tagList = [cell.contentView viewWithTag:100];
    return [tagList fittedSize].height + 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dict = _dataArray[section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 30)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, view.width - 20, view.height)];
    lbl.text = dict[@"title"];
    lbl.font = [UIFont systemFontOfSize:14.0];
    //lbl.textColor = [UIColor lightGrayColor];
    lbl.textColor = [GetColor16 hexStringToColor:@"#646464"];
    [view addSubview:lbl];
    //view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    view.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    return view;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        FootPrintDWTagList *tagList = [[FootPrintDWTagList alloc] initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH - 20, 1)];
        tagList.tag = 100;
        [cell.contentView addSubview:tagList];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    FootPrintDWTagList *tagList = [cell.contentView viewWithTag:100];
    tagList.backgroundColor = [UIColor clearColor];
    NSDictionary *dict = _dataArray[indexPath.section];
    tagList.maxSelectedCount = 3;
    tagList.selectedTextArray = _selectedSignArray;
    
    [tagList setTags:dict[@"tags"]];
    tagList.height = [tagList fittedSize].height;
    tagList.tagSelectedBlock = ^(NSDictionary *selectedTag) {
        if (![_selectedSignArray containsObject:selectedTag]) {
            [_selectedSignArray addObject:selectedTag];
        }
    };
    tagList.tagNormalBlock = ^(NSDictionary *normalTag) {
        if ([_selectedSignArray containsObject:normalTag]) {
            [_selectedSignArray removeObject:normalTag];
        }
    };
    //长按删除
    tagList.tagLongPressBlock = ^(NSDictionary *longPressTag, NSString *deleteMethod) {
        [self showDeleteAlert];
        _deleteSignDict = longPressTag;
        _deleteMethod = deleteMethod;
    };
    //判断是否可以删除
    if (((NSString *)dict[@"method"]).length == 0) {
        tagList.canDelete = NO;
    }else {
        tagList.canDelete = YES;
    }
    tagList.deleteMethod = dict[@"method"];
    return cell;
}
-(void)showDeleteAlert {
    NSString *message = @"确定要删除？";
    if (down_IOS_8) {
        if (!_isAlertShow) {
            _isAlertShow = YES;
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1001;
            [alert show];
            
        }
        
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteSignRequest];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _isAlertShow = NO;
    if (buttonIndex == 1) {
        [self deleteSignRequest];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}
#pragma mark- 网络请求
-(void)loadData {
    if (_type == FOOTERPRINT_TYPE) {
        [self loadFooterMarksRequest];
    }else {
        [self loadTopicMarksListRequest];
    }
}
- (void)loadFooterMarksRequest
{
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"获取信息,请稍后";
//    HUD.dimBackground = YES;
//    [HUD show:YES];
    
    NSDictionary * param = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"1000", @"type": @"position"}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _dataArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            [self.tableView reloadData];
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        //[HUD hide:YES];
    } andFailureBlock:^{
        //[HUD hide:YES];
    }];
}
-(void)loadTopicMarksListRequest {
//    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"获取信息,请稍后";
//    HUD.dimBackground = YES;
//    [HUD show:YES];
    
    NSDictionary * param = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"1000", @"type": @"topic"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        //[HUD removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            _dataArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            [self.tableView reloadData];
        }else {
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
        }
        
    } andFailureBlock:^{
       // [HUD removeFromSuperview];
    }];
}
-(void)addSignRequest:(NSString *)sign {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"添加中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    
    NSString *type = @"usertopic";
    if (_type == FOOTERPRINT_TYPE) {
        type = @"userposition";
    }
    
    NSDictionary * param = [self parametersForDic:@"accountCreateTag" parameters:@{ACCOUNT_PASSWORD, @"title": sign, @"type": type}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [HUD removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            self.signTF.text = @"";
            [self loadData];
        }else {
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
        }
        
    } andFailureBlock:^{
        [HUD removeFromSuperview];
    }];
}
-(void)deleteSignRequest {
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"删除中,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    
    NSDictionary * param = [self parametersForDic:_deleteMethod parameters:@{ACCOUNT_PASSWORD, @"id": _deleteSignDict[@"id"]}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [HUD removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            if ([_selectedSignArray containsObject:_deleteSignDict]) {
                [_selectedSignArray removeObject:_deleteSignDict];
            }
            [self loadData];
        }else {
            [AutoDismissAlert autoDismissAlertSecond:dic[@"message"]];
        }
        
    } andFailureBlock:^{
        [HUD removeFromSuperview];
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
