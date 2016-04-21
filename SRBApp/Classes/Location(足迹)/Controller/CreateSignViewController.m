//
//  CreateSignViewController.m
//  SRBApp
//
//  Created by zxk on 15/4/14.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
//最多添加标签数量
#define MAXSIGNCOUNT 3

static NSMutableArray *_footerSignArrs;
static NSMutableArray *_topicSignArrs;
static long _selectedSignCount = 0;
//static NSMutableDictionary *_titleDic;

#import "CreateSignViewController.h"
#import "SignBtn.h"
#import "SignCollectionViewCell.h"
#import "ChangeSizeOfNSString.h"
#import "SignModel.h"

@class RunViewController;

@interface CreateSignViewController ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>
{
    BOOL _canedit;
    MBProgressHUD * HUD;
    UICollectionView * collectionview;
    //选中标签数量
}
@property (nonatomic, strong)NSMutableArray *signArrs;
@end

@implementation CreateSignViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self customInit];

    self.title = @"标签";
    
    if (_isTopicMark) {
        if (!_topicSignArrs) {
            _topicSignArrs = [NSMutableArray array];
            [self loadTopicMarksListRequest];
        }
        _signArrs = _topicSignArrs;
    }else {
        if (!_footerSignArrs) {
            _footerSignArrs = [NSMutableArray array];
            [self loadFooterMarksRequest];
        }
         _signArrs = _footerSignArrs;
    }
    
    [self.signStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self.signStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) {
        _selectedSignCount = 0;
        for (SignModel *model in _signArrs) {
            model.isSelected = NO;
        }
    }
}
#pragma mark- 页面
- (void)customInit
{
    //返回
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //完成
    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [finishBtn setTitle:@"完 成" forState:UIControlStateNormal];
    finishBtn.frame = CGRectMake(0, 0, 60, 25);
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    finishBtn.layer.masksToBounds = YES;
    finishBtn.layer.cornerRadius = 2;
    [finishBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    finishBtn.backgroundColor = WHITE;
    [finishBtn addTarget:self action:@selector(finishBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:finishBtn];
    
    //输入标签内容
    UITextField * signText = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH - 10 - 70, 30)];
    self.signText = signText;
    signText.delegate = self;
    signText.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, signText.frame.size.height)];
    signText.leftViewMode = UITextFieldViewModeAlways;
    signText.backgroundColor = WHITE;
    signText.layer.borderColor = RGBCOLOR(206, 208, 208, 1).CGColor;
    signText.layer.borderWidth = 1;
    signText.layer.cornerRadius = 4;
    signText.layer.masksToBounds = YES;
    signText.font = SIZE_FOR_12;
    signText.returnKeyType = UIReturnKeyDone;
    signText.placeholder = @"添加标签字数请不要超过8个字";
    signText.autocorrectionType = UITextAutocorrectionTypeNo;
    [signText addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    signText.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:signText];
    
    //添加标签
    UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCREEN_WIDTH - 60, 12, 60, 25);
    [addBtn setTitle:@"添 加" forState:UIControlStateNormal];
    [addBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    addBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [addBtn addTarget:self action:@selector(addSign) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    
    //分割线
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = RGBCOLOR(206, 208, 208, 1);
    //[self.view addSubview:lineView];
    
    UILabel * wordLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 242)/2, 51, 242, 30)];
    if (_isTopicMark) {
        wordLabel.text = @"添加标签参与话题，把经验分享给更多人~\n标签最多可选三个";
    }else {
        wordLabel.text = @"添加标签，方便查找~\n标签最多可选三个";
    }
    
    wordLabel.textAlignment = NSTextAlignmentCenter;
    wordLabel.textColor = MAINCOLOR;
    wordLabel.font = SIZE_FOR_12;
    wordLabel.numberOfLines = 2.0;
    [self.view addSubview:wordLabel];
    
    //    UIScrollView * mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 51, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 51)];
    //    self.mainScroll = mainScroll;
    //    [self.view addSubview:mainScroll];
    
    UICollectionViewFlowLayout * fl = [[UICollectionViewFlowLayout alloc]init];
    [fl setScrollDirection:UICollectionViewScrollDirectionVertical];
    collectionview = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 91, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 91) collectionViewLayout:fl];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    collectionview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:collectionview];
    
}
#pragma mark- 事件
- (void)finishBtn:(UIButton *)sender
{
    //NSMutableString * titleStr = [NSMutableString string];
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
    for (SignModel *model in _signArrs) {
        if (model.isSelected) {
            [tempArray addObject:model.name];
        }
    }
    if (self.completeBlock) {
        self.completeBlock([tempArray componentsJoinedByString:@","]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)addSign
{
    //预防重复添加
    NSString * signStr = [self.signText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (signStr.length == 0) {
        return;
    }
    if (signStr.length > 7) {
        [AutoDismissAlert autoDismissAlertSecond:@"标签不能超过7个字"];
        return;
    }
    for (SignModel *model in _signArrs) {
        if ([model.name isEqualToString:signStr]) {
            [AutoDismissAlert autoDismissAlert:@"此标签已经存在"];
            return;
        }
    }
    [self.signText resignFirstResponder];
    SignModel *model = [[SignModel alloc] init];
    model.ID = @"-1";
    model.name = signStr;
    [_signArrs addObject:model];
    [collectionview reloadData];
    self.signText.text = @"";
    
}
- (void)operationSignBtn:(SignBtn *)sender
{
    NSLog(@"sender dic = %@",_signArrs[sender.indexpath.row]);
    SignModel *model = _signArrs[sender.indexpath.row];
    if (!sender.selected) {
        if (_selectedSignCount >= MAXSIGNCOUNT) {
            return;
        }
        //限制标签数量
        model.isSelected = YES;
        sender.layer.borderColor = [GetColor16 hexStringToColor:@"#e5005d"].CGColor;
        sender.selected = YES;
        _selectedSignCount ++;
    }else{
        model.isSelected = NO;
        sender.layer.borderColor = RGBCOLOR(206, 208, 208, 1).CGColor;
        sender.selected = NO;
        _selectedSignCount --;
    }
    
}
-(void)btnLong:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        SignBtn * btn = (SignBtn *)gestureRecognizer.view;
        [self urlRequestPostWithBtn:btn];
    }
}
- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- 数据
- (SignBtn *)createBtnWithSignModel:(SignModel *)model
{
    SignBtn * signBtn = [SignBtn buttonWithType:UIButtonTypeCustom];
    [signBtn setTitle:model.name forState:UIControlStateNormal];
    signBtn.titleLabel.font = SIZE_FOR_14;
    [signBtn setBackgroundColor:[GetColor16 hexStringToColor:@"#ffffff"]];
    [signBtn setTitleColor:RGBCOLOR(206, 208, 208, 1) forState:UIControlStateNormal];
    [signBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateSelected];
    signBtn.layer.borderColor = RGBCOLOR(206, 208, 208, 1).CGColor;
    signBtn.layer.cornerRadius = 2;
    signBtn.layer.masksToBounds = YES;
    signBtn.layer.borderWidth = 1;
    [signBtn addTarget:self action:@selector(operationSignBtn:) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLong:)];
    [signBtn addGestureRecognizer:longPress];
    if (model.isSelected) {
        signBtn.selected = YES;
        signBtn.layer.borderColor = [GetColor16 hexStringToColor:@"#e5005d"].CGColor;
    }
    return signBtn;
}
#pragma mark - collectionViewDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * ID = @"Cell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (_signArrs[indexPath.row]) {
        SignModel * model = _signArrs[indexPath.row];
        SignBtn * btn = nil;
        btn = [self createBtnWithSignModel:model];
        btn.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 60)/3, 25);
        btn.indexpath = indexPath;
        for (id subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        [cell.contentView addSubview:btn];
    }
    
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 60) / 3,25);
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _signArrs.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 15, 10);
}
#pragma mark- textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([[[UITextInputMode currentInputMode] primaryLanguage] isEqualToString:@"emoji"]) {
        return NO;
    }
    
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        _canedit = YES;
    if (*ch == 44 || *ch == 35 || *ch == 38) {
        return NO;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (toBeString.length <= 7) {
        _canedit = YES;
    }
    return YES;
}

- (void)textfieldDidChange:(UITextField *)textField
{
    NSString * toBeString = textField.text;
    
    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [textField markedTextRange];
        UITextPosition * position = [textField positionFromPosition:selectedRange.start offset:0];
        __block int chNum = 0;
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
            if ([tempData length] == 3) {
                chNum ++;
            }
        }];
        if (chNum >= 4) {
            _canedit = NO;
        }
        if (!position) {
            if (toBeString.length > 6) {
                textField.text = [toBeString substringToIndex:7];
                _canedit = YES;
            }
        }
    }
    else{
        if (toBeString.length > 6) {
            textField.text = [toBeString substringToIndex:7];
            _canedit = NO;
        }
    }
}
#pragma mark- 网络请求
- (void)loadFooterMarksRequest
{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"获取信息,请稍后";
    HUD.dimBackground = YES;
    [HUD show:YES];
    NSDictionary * param = [self parametersForDic:@"accountGetTagList" parameters:@{ACCOUNT_PASSWORD}];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray *dataArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary *dic in dataArray) {
                SignModel *model = [[SignModel alloc] init];
                model.name = dic[@"title"];
                model.ID = dic[@"id"];
                [_footerSignArrs addObject:model];
            }
            [collectionview reloadData];
            //            for (int i = 0; i < tagArr.count; i++) {
            //                [self addSignWithTitle:[tagArr[i] objectForKey:@"title"]];
            //            }
        }else if([result isEqualToString:@"4"]){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [HUD hide:YES];
    } andFailureBlock:^{
        [HUD hide:YES];
    }];
}
-(void)loadTopicMarksListRequest {
    NSDictionary * param = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"1000", @"categoryID": @"0"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray *dataArray = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (NSDictionary *dic in dataArray) {
                SignModel *model = [[SignModel alloc] init];
                model.name = dic[@"name"];
                model.ID = dic[@"id"];
                [_topicSignArrs addObject:model];
            }
            [collectionview reloadData];
        }
        
    } andFailureBlock:^{
        
    }];
}

- (void)urlRequestPostWithBtn:(SignBtn *)btn
{
    SignModel *model = _signArrs[btn.indexpath.row];
    //不是服务器返回
    if ([model.ID isEqualToString:@"-1"]) {
        [_signArrs removeObject:model];
        [collectionview reloadData];
    }else{
        //话题标签不支持删除功能
        if (_isTopicMark) {
            return;
        }
        NSDictionary * dic = [self parametersForDic:@"accountDeleteTag" parameters:@{ACCOUNT_PASSWORD,@"id":model.ID}];
        
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"删除中,请稍后";
        hud.dimBackground = YES;
        [hud show:YES];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                
                [_signArrs removeObject:model];
                [collectionview reloadData];
            }else if([result isEqualToString:@"4"]){
                
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
            [hud hide:YES];
            [hud removeFromSuperview];
        } andFailureBlock:^{
            [hud hide:YES];
            [hud removeFromSuperview];
        }];
    }
    
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
