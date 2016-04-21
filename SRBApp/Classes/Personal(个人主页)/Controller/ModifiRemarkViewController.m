//
//  ModifiRemarkViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/12.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ModifiRemarkViewController.h"
#import "FriendFragmentModel.h"
#import "RCIM.h"

@interface ModifiRemarkViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *remarkTF;
@property (nonatomic, strong) NSMutableArray *array;

@end

@implementation ModifiRemarkViewController
{
    BOOL _canedit;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"修改备注";
    // Do any additional setup after loading the view.
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 110/2, 50/2);
    rightBtn.backgroundColor = [UIColor whiteColor];
    rightBtn.layer.masksToBounds = YES;
    rightBtn.layer.cornerRadius = CGRectGetHeight(rightBtn.frame)*0.5;
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[GetColor16 hexStringToColor:[NSString stringWithFormat:@"#e5005d"]] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(yes:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 50)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    self.remarkTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH - 20, 50)];
    self.remarkTF.placeholder = @"填写备注名";
    self.friendRemark != nil ? self.remarkTF.text = self.friendRemark : nil;
    self.remarkTF.autocorrectionType = UITextAutocorrectionTypeNo;
    self.remarkTF.delegate = self;
    [self.remarkTF addTarget:self action:@selector(xianzhi:) forControlEvents:UIControlEventEditingChanged];
    self.remarkTF.backgroundColor = [UIColor clearColor];
    self.remarkTF.returnKeyType = UIReturnKeyDone;
    [view addSubview:self.remarkTF];
    
}

- (void)xianzhi:(UITextField *)text
{
    NSString * toBeString = text.text;
    NSString * lang = [[UITextInputMode currentInputMode]primaryLanguage];
    if ([lang isEqualToString:@"zh-Hans"]) {
        UITextRange * selectedRange = [text markedTextRange];
        UITextPosition * position = [text positionFromPosition:selectedRange.start offset:0];
        __block int chNum = 0;
        
        [toBeString enumerateSubstringsInRange:NSMakeRange(0, toBeString.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            
            NSData * tempData = [substring dataUsingEncoding:NSUTF8StringEncoding];
            if ([tempData length] == 3) {
                chNum ++;
            }
        }];
        if (chNum >= 6) {
            _canedit = NO;
        }
        if (!position) {
            if ([ChangeSizeOfNSString convertToInts:toBeString] > 12) {
                NSInteger tempIndex = [ChangeSizeOfNSString returnIndexWithStr:toBeString];
                text.text = [toBeString substringToIndex:tempIndex];
                _canedit = YES;
            }
        }
    }
    else{
        if ([ChangeSizeOfNSString convertToInts:toBeString] > 12) {
            NSInteger tempIndex = [ChangeSizeOfNSString returnIndexWithStr:toBeString];
            text.text = [toBeString substringToIndex:tempIndex];
            _canedit = NO;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    const char * ch=[string cStringUsingEncoding:NSUTF8StringEncoding];
    if (*ch == 0)
        _canedit = YES;
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([ChangeSizeOfNSString convertToInts:toBeString] <= 12) {
        _canedit = YES;
    }
    if (_canedit == NO) {
        return NO;
    }
    return YES;
}

- (void)yes:(UIButton *)sender
{
    [self urlRequestPostT];
}

- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

//网络请求
- (void)urlRequestPostT
{
    if ([ChangeSizeOfNSString convertToInts:_remarkTF.text] > 12) {
        [AutoDismissAlert autoDismissAlert:@"备注过长，请控制字数"];
        return;
    }
    
    NSDictionary * dic = [self parametersForDic:@"accountMemoFriend" parameters:@{ACCOUNT_PASSWORD,@"friendId":self.friendId,@"memo":self.remarkTF.text}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            [self.personalVC urlRequestPostTAgain];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                AppDelegate *app = APPDELEGATE;
                [app getFriendArr];
            });
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
