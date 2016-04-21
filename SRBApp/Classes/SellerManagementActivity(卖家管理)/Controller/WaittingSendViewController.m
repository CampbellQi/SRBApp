//
//  WaittingSendViewController.m
//  SRBApp
//
//  Created by zxk on 15/1/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WaittingSendViewController.h"
#import "WQPickerView.h"

@interface WaittingSendViewController ()
{
    WQPickerView *_pickerView;
    NSMutableArray *_dataArray;
    NSArray *_sourceDataArray;
    UIView *_idView;
}
@property (strong, nonatomic)UITextField *sendCompanyText;
@property (strong, nonatomic)UITextField *sendNumText;
@property (strong, nonatomic)UILabel *bringYourself;
@property (nonatomic, strong) UIButton *isBringBtn;
@end

@implementation WaittingSendViewController
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadSendCompany];
    self.title = @"发货";
    _dataArray = [NSMutableArray arrayWithCapacity:0];
    UIView * nameView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    nameView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    self.sendCompanyText = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 30)];
    self.sendCompanyText.returnKeyType = UIReturnKeyDone;
    self.sendCompanyText.placeholder = @"配送公司名称";
    self.sendCompanyText.font = SIZE_FOR_14;
    self.sendCompanyText.borderStyle = UITextBorderStyleNone;
    [nameView addSubview:self.sendCompanyText];
    self.sendCompanyText.delegate = self;
    
    UIView * idView = [[UIView alloc]initWithFrame:CGRectMake(0, 61, SCREEN_WIDTH, 40)];
    idView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    self.sendNumText = [[UITextField alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH -30, 30)];
    self.sendNumText.returnKeyType = UIReturnKeyDone;
    self.sendNumText.placeholder = @"配送单号";
    self.sendNumText.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.sendNumText.font = SIZE_FOR_14;
    self.sendNumText.borderStyle = UITextBorderStyleNone;
    self.sendNumText.delegate = self;
    [idView addSubview:self.sendNumText];
    _idView = idView;
    
    UIView *bringView = [[UIView alloc]initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 40)];
    bringView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    self.bringYourself = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH -30, 30)];
    self.bringYourself.text = @"自提";
    self.bringYourself.font = SIZE_FOR_14;
    self.bringYourself.textColor = [GetColor16 hexStringToColor:@"#2b2b2b"];
    [bringView  addSubview:self.bringYourself];
    
    self.isBringBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.isBringBtn.frame = CGRectMake(SCREEN_WIDTH - 40, 5, 30, 30);
    [self.isBringBtn setImage:[UIImage imageNamed:@"no_bringyourself_normal"] forState:UIControlStateNormal];
    [self.isBringBtn setImage:[UIImage imageNamed:@"yes_bringyourself_selected"] forState:UIControlStateSelected];
    [self.isBringBtn addTarget:self action:@selector(isBringBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [bringView addSubview:self.isBringBtn];
    
    [self.view addSubview:nameView];
    [self.view addSubview:idView];
    [self.view addSubview:bringView];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    submitBtn.frame = CGRectMake(0, 0, 55, 25);
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = CGRectGetHeight(submitBtn.frame)*0.5;
    [submitBtn setTitle:@"发 货" forState:UIControlStateNormal];

    [submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //[submitBtn addTarget:self action:@selector(submitBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:submitBtn];
    
    if (self.invoiceName && ![self.invoiceNo isEqualToString:@"0"]) {
        self.sendCompanyText.text = self.invoiceName;
    }
    if (self.invoiceNo && ![self.invoiceNo isEqualToString:@"0"]) {
        self.sendNumText.text = self.invoiceNo;
    }
}
-(void)isBringBtnClicked:(UIButton *)sender{
     self.isBringBtn.selected = !self.isBringBtn.selected;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.sendCompanyText) {
        [self showPickerView];
        return NO;
    }
    return YES;
}
#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)showPickerView{
    [self.view endEditing:YES];
    if (!_dataArray) {
        [AutoDismissAlert autoDismissAlertSecond:@"快递公司获取中，请稍后..."];
        return;
    }
    if (!_pickerView) {
        //NSString *s = @"申通,商品信息严重不符合,商品报价严重不合理,上传信息虚假,图片盗用侵权,怀疑是假货,就是不想要了，任性";
        WQPickerView *pickerView = [[WQPickerView alloc] initWithFrame:CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT) DataArray:_dataArray];
        _pickerView = pickerView;
        pickerView.confirmBlock = ^(NSString *selectedItem) {
            self.sendCompanyText.text = selectedItem;
            for (NSDictionary *dic in _sourceDataArray) {
                if ([selectedItem isEqualToString:dic[@"name"]] && [dic[@"code"] isEqualToString:@"0"]) {
                    _idView.hidden = YES;
                    break;
                }else {
                    _idView.hidden = NO;
                }
            }
        };
    }
    
    _pickerView.frame = CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT);
    [self.view addSubview:_pickerView];
    [UIView animateWithDuration:0.3 animations:^{
        _pickerView.y = MAIN_NAV_HEIGHT - PICKERVIEW_HEIGHT;
    }];
}


- (void)submitBtn:(UIButton *)sender
{
    NSString *invoiceNo = self.sendNumText.text;
    if (self.isBringBtn.selected) {
        invoiceNo = @"0";
    }else{
    if (self.sendCompanyText.text.length == 0) {
        [AutoDismissAlert autoDismissAlert:@"请输入配送公司"];
        [self.sendCompanyText becomeFirstResponder];
        return;
    }
//    if (self.sendNumText.text.length == 0) {
//        [AutoDismissAlert autoDismissAlert:@"请输入配送单号"];
//        [self.sendNumText becomeFirstResponder];
//        return;
//    }
    //NSString *invoiceNo = self.sendNumText.text;
    for (NSDictionary *dic in _sourceDataArray) {
        if ([self.sendCompanyText.text isEqualToString:dic[@"name"]] && [dic[@"code"] isEqualToString:@"0"]) {
            invoiceNo = @"0";
            break;
        }else {
        }
    }
    }
    NSDictionary * dic = [self parametersForDic:@"sellerSetOrderTake" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderId,@"invoiceName":self.sendCompanyText.text,@"invoiceNo":invoiceNo}];
    if (_isModify) {
        dic = [self parametersForDic:@"sellerModifyOrderTake" parameters:@{ACCOUNT_PASSWORD,@"orderId":self.orderId,@"invoiceName":self.sendCompanyText.text,@"invoiceNo":invoiceNo}];
    }
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self.navigationController popViewControllerAnimated:YES];
            if (self.backBlock) {
                self.backBlock();
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SPOrderDeliveryCompletedNF" object:nil];
            //[self.sellerOrderVC urlRequest];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        
    }];
    
}
#pragma mark- 网络请求
-(void)loadSendCompany {
    NSDictionary * param = [self parametersForDic:@"getExpressList" parameters:@{ACCOUNT_PASSWORD,@"keyword":@""}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _sourceDataArray = dic[@"data"][@"list"];
            for (NSDictionary *d in dic[@"data"][@"list"]) {
                [_dataArray addObject:d[@"name"]];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
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

@end
