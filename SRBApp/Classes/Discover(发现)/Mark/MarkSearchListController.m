//
//  MarkSearchListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MarkSearchListController.h"
#import "pinyin.h"
#import "MarkTopicListController.h"

@interface MarkSearchListController ()
{
    UITextField *_searchTF;
}

@end

@implementation MarkSearchListController
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchTF becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setUpView];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_searchTF resignFirstResponder];
}
#pragma mark-页面
-(void)setUpView {
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(0, 0, 30, 44);
    cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:cancelBtn];
    
    //导航栏
    float xSpace = 25;
    float height = 28;
    UIView *searchBgView = [[UIView alloc] initWithFrame:CGRectMake(xSpace, (44 - height)/2, SCREEN_WIDTH - xSpace * 5, height)];
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, searchBgView.width - 20, height)];
    [searchBgView addSubview:tf];
    searchBgView.layer.cornerRadius = height /2 ;
    //searchBgView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1];
    searchBgView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    
    _searchTF = tf;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    tf.placeholder = @"搜索标签";
    tf.textAlignment = NSTextAlignmentLeft;
    tf.returnKeyType = UIReturnKeySearch;
    tf.delegate = self;
    tf.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = searchBgView;
    tf.backgroundColor = [UIColor clearColor];
    
    tf.font = [UIFont systemFontOfSize:14];
    //隐藏键盘
    //[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)]];
    //无数据
}
#pragma mark- 事件
-(void)hideKeyboard {
    [_searchTF resignFirstResponder];
}
- (void)cancelBtnClicked:(UIButton *)sender
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark- textfiled delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchTagsListRequest];
    return YES;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_searchTF resignFirstResponder];
}
#pragma mark- 网络请求
- (void)searchTagsListRequest
{
    NSString *keyWords = _searchTF.text;
    if (keyWords.length == 0) {
        return;
    }
    [_searchTF resignFirstResponder];
    NSDictionary * param = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"100", @"type": @"1042", @"name": keyWords}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            self.dataArray = temparrs;
            self.noDataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            self.dataArray = [NSArray new];
            self.noDataView.hidden = NO;
            //[AutoDismissAlert autoDismissAlertSecond:@"没有搜索到相关数据"];
        }else{
            self.noDataView.hidden = NO;
        }
        [self.tableView reloadData];
        
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

@end
