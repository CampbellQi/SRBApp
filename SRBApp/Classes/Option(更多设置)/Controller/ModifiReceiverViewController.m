//
//  ModifiReceiverViewController.m
//  SRBApp
//
//  Created by lizhen on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ModifiReceiverViewController.h"

@interface ModifiReceiverViewController ()<UITextViewDelegate>
@property (nonatomic, strong) UIButton *Imagebtn;
@property (nonatomic, strong) UILabel *placeLabel;           //地址属性
@end

@implementation ModifiReceiverViewController

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改地址";
    self.view.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    //布局
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(0, 0, 120/2, 50/2);
    rightBtn.backgroundColor = [UIColor whiteColor];
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = CGRectGetHeight(rightBtn.frame)*0.5;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#e5005d"]] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(saveAddressMessage:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    
    //背景
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 263)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    
    UILabel *verticalLine1 = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 1, 30)];
    verticalLine1.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
    [backView addSubview:verticalLine1];
    UILabel *verticalLine2 = [[UILabel alloc] initWithFrame:CGRectMake(80, 61, 1, 30)];
    verticalLine2.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
    [backView addSubview:verticalLine2];
    UILabel *verticalLine3 = [[UILabel alloc] initWithFrame:CGRectMake(80, 112, 1, 90)];
    verticalLine3.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
    [backView addSubview:verticalLine3];
    UILabel *verticalLine4 = [[UILabel alloc] initWithFrame:CGRectMake(80, 222, 1, 30)];
    verticalLine4.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
    [backView addSubview:verticalLine4];
    
    UILabel *acrossLine1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 1)];
    acrossLine1.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
    [backView addSubview:acrossLine1];
    UILabel *acrossLine2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 101, SCREEN_WIDTH, 1)];
    acrossLine2.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
    [backView addSubview:acrossLine2];
    UILabel *acrossLine3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 212, SCREEN_WIDTH, 1)];
    acrossLine3.backgroundColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#eeeeee"]];
    [backView addSubview:acrossLine3];
    
    
    //收货人
    UILabel *receiveGoodsLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 65, 30)];
    receiveGoodsLB.text = @"收 货 人";
    receiveGoodsLB.textAlignment = NSTextAlignmentCenter;
    receiveGoodsLB.font = [UIFont systemFontOfSize:16];
    receiveGoodsLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
    [backView addSubview:receiveGoodsLB];
    
    //收货人姓名
    self.receiveGoodsTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 10, 200, 30)];
    self.receiveGoodsTF.placeholder = @"收货人姓名";
    self.receiveGoodsTF.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.receiveGoodsTF.delegate = self;
    self.receiveGoodsTF.text = self.receiver;
    self.receiveGoodsTF.font = [UIFont systemFontOfSize:16];
    [backView addSubview:self.receiveGoodsTF];
    
    //联系电话
    UILabel *phoneLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 65, 30)];
    phoneLB.text = @"联系电话";
    phoneLB.textAlignment = NSTextAlignmentCenter;
    phoneLB.font = [UIFont systemFontOfSize:16];
    phoneLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
    [backView addSubview:phoneLB];
    
    //电话
    self.phoneTF = [[UITextField alloc] initWithFrame:CGRectMake(90, 60, 200, 30)];
    self.phoneTF.placeholder = @"联系电话";
    self.phoneTF.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.phoneTF.delegate = self;
    self.phoneTF.text = self.phone;
    self.phoneTF.keyboardType = UIKeyboardTypeNamePhonePad;
    self.phoneTF.font = [UIFont systemFontOfSize:16];
    [backView addSubview:self.phoneTF];
    
    //详细地址
    UILabel *addressLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 110, 65, 90)];
    addressLB.text = @"详细地址";
    addressLB.textAlignment = NSTextAlignmentCenter;
    addressLB.font = [UIFont systemFontOfSize:16];
    addressLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
    [backView addSubview:addressLB];
    
    //地址
    self.addressTV = [[UITextView alloc] initWithFrame:CGRectMake(86, 110, SCREEN_WIDTH - 10 - 65 - 11 - 15, 90)];
    self.addressTV.delegate = self;
    self.addressTV.text = self.address;
    self.addressTV.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.addressTV.font = [UIFont systemFontOfSize:16];
    [backView addSubview:self.addressTV];
    //地址的placeHolder
    
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
//    self.placeLabel.text = @"详细地址";
    self.placeLabel.enabled = NO;
    self.placeLabel.textColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    self.placeLabel.font = [UIFont systemFontOfSize:16];
    [self.addressTV addSubview:self.placeLabel];
    
    //默认地址
    UILabel *defaultAddrLB = [[UILabel alloc] initWithFrame:CGRectMake(10, 222, 65, 30)];
    defaultAddrLB.text = @"默认地址";
    defaultAddrLB.textAlignment = NSTextAlignmentCenter;
    defaultAddrLB.font = [UIFont systemFontOfSize:16];
    defaultAddrLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
    [backView addSubview:defaultAddrLB];
    
    //按钮
    self.Imagebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.Imagebtn.frame = CGRectMake(88, 229, 17, 17);
    [self.Imagebtn setImage:[UIImage imageNamed:@"not_choose"] forState:UIControlStateNormal];
    [self.Imagebtn setImage:[UIImage imageNamed:@"had_choose"] forState:UIControlStateSelected];
    [self.Imagebtn addTarget:self action:@selector(setDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:self.Imagebtn];
    
    //设置默认地址
    UIButton *defaultAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    defaultAddressBtn.frame = CGRectMake(110, 222, 100, 30);
    [defaultAddressBtn setTitle:@"设置默认地址" forState:UIControlStateNormal];
    defaultAddressBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [defaultAddressBtn setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]] forState:UIControlStateNormal];
    [defaultAddressBtn addTarget:self action:@selector(setDefaultAddressToo:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:defaultAddressBtn];
    
    if ([self.isdefault isEqualToString:@"1"]) {
        [self.Imagebtn setImage:[UIImage imageNamed:@"had_choose"] forState:UIControlStateNormal];
    }
    UITapGestureRecognizer *tapToRentuenKB = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToRentuenKB:)];
    [self.view addGestureRecognizer:tapToRentuenKB];
    
}

- (void)tapToRentuenKB:(UITapGestureRecognizer *)tap
{
    [self.receiveGoodsTF resignFirstResponder];
    [self.phoneTF resignFirstResponder];
    [self.addressTV resignFirstResponder];
}
//按钮
- (void)setDefaultAddress:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
}

- (void)setDefaultAddressToo:(UIButton *)sender
{
    self.Imagebtn.selected = !self.Imagebtn.selected;
    
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeLabel.text = @"详细地址";
    }else{
        self.placeLabel.text = @"";
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        [textView resignFirstResponder];//释放键盘
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

- (void)saveAddressMessage:(UIButton *)sender
{
    
    if (self.receiveGoodsTF.text.length == 0 || [self.receiveGoodsTF.text isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"请填写收货人姓名"];
        [self.receiveGoodsTF becomeFirstResponder];
    }else if (self.phoneTF.text.length == 0 || [self.phoneTF.text isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"请填写联系电话"];
        [self.phoneTF becomeFirstResponder];
    }else if (self.addressTV.text.length == 0 || [self.addressTV.text isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"请填写详细地址"];
        [self.addressTV becomeFirstResponder];
    }else{
        //判断是否为默认地址
        NSString *isdefaulet;
        if (self.Imagebtn.selected) {
            isdefaulet = @"1";
        }else{
            isdefaulet = @"0";
        }
        
        NSDictionary * loginParam = @{@"method":@"accountModifyAddress",@"parameters":@{ACCOUNT_PASSWORD,@"id":[NSString stringWithFormat:@"%d",self.iD.intValue],@"receiver":self.receiveGoodsTF.text,@"mobile":self.phoneTF.text,@"address":self.addressTV.text,@"isdefault":isdefaulet}};
        [URLRequest postRequestssWith:iOS_POST_URL parameters:loginParam andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        } andFailureBlock:^{
            
        }];
    }
}

- (void)moveView:(float)move
{
    NSTimeInterval animationDuration = 0.3f;
    CGRect frame = self.view.frame;
    frame.origin.y += move;//view的x轴上移
    [UIView beginAnimations:@"ResizeView" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.view.frame = frame;
    [UIView commitAnimations];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self moveView:-80];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self moveView:80];
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
