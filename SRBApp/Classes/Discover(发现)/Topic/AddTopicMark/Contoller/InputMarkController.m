//
//  InputController.m
//  testMark
//
//  Created by fengwanqi on 15/10/14.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "InputMarkController.h"
#import "SearchController.h"
#import "StringHelper.h"

@interface InputMarkController ()<UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField *_activeTF;
    SearchController *_searchVC;
}
@end

@implementation InputMarkController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    
    if (_sourceMarkView) {
        [self fillData];
    }
    
    [self.brandTF becomeFirstResponder];
    _activeTF = self.brandTF;
    self.inputTF.delegate = self;
    
    [self listenKeyboard];
    
    //[self.view addTapAction:@selector(hideKeyboard) forTarget:self];
    
    //键盘监听
    [_inputTF addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark- 页面
-(void)setUpView {
    for (int i=100; i<109; i++) {
        UIView *view = [self.view viewWithTag:i];
        view.layer.borderColor = [UIColor whiteColor].CGColor;
        view.layer.borderWidth = 1.0f;
        view.layer.cornerRadius = CGRectGetHeight(view.frame) * 0.5;
        view.layer.masksToBounds = YES;
    }
    //设置placeholder 颜色,监听
    NSArray *tempArray = @[self.nameTF, self.brandTF, self.countryTF, self.addressTF, self.currencyTF, self.priceTF];
    for (UITextField *tf in tempArray) {
        [tf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
//        NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc]initWithString:tf.placeholder];
//        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributedStr.length)];
//        tf.attributedPlaceholder = attributedStr;
    }
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AddTopicMark" bundle:[NSBundle mainBundle]];
    _searchVC = [sb instantiateViewControllerWithIdentifier:@"SearchController"];
    [self.view addSubview:_searchVC.view];
    [self addChildViewController:_searchVC];
    _searchVC.view.hidden = YES;
    _searchVC.type = Brand;
    _searchVC.keyWords = @"a";
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _searchVC.view.frame = self.superSV.frame;
}
#pragma mark - UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- 跳转
-(void)showSearchVC:(NSString *)keyWords Type:(enum Type)type {
    if (keyWords.length == 0) {
        _searchVC.view.hidden = YES;
        _activeTF.text = keyWords;
        return;
    }
    
    if (_searchVC) {
        _searchVC.type = type;
        _searchVC.keyWords = keyWords;
        //_searchVC.view.hidden = NO;
    }
    
    if (type == Brand) {
        //_searchVC.view.hidden = NO;
        _activeTF.text = _searchVC.keyWords;
    }else {
        if (_searchVC.dataArray.count == 0) {
            _searchVC.view.hidden = YES;
            _activeTF.text = _searchVC.keyWords;
        }else {
            _searchVC.view.hidden = NO;
        }
    }
    __block typeof(UITextField *)unActiveTF = _activeTF;
    __block typeof(SearchController *)unSearchVC = _searchVC;
    __block typeof(UITextField *)unInputTF = self.inputTF;
    _searchVC.selectedBlock = ^(NSString *item) {
        unActiveTF.text = item;
        unSearchVC.view.hidden = YES;
    };
    
    
    _searchVC.hideKeboardBlock = ^(void){
        [unInputTF resignFirstResponder];
    };
    _searchVC.hideBlock = ^(void){
        unSearchVC.view.hidden = YES;
    };
    _searchVC.showBlock = ^(void){
        unSearchVC.view.hidden = NO;
    };
}
#pragma mark- 数据
-(void)fillData {
    TPMarkModel *model = _sourceMarkView.sourceModel;
    self.deleteBtn.hidden = NO;
    self.nameTF.text = model.name;
    self.brandTF.text = model.brand;
    self.countryTF.text = model.origin;
    self.addressTF.text = model.shopland;
    self.currencyTF.text = model.unit;
    self.priceTF.text = model.shopprice;
}

#pragma mark- 事件
-(void)textFieldEditChanged:(UITextField *)tf {
    NSString *keyWords = tf.text;
    if (_activeTF == self.countryTF) {
        [self showSearchVC:keyWords Type:Country];
    }else if (_activeTF == self.currencyTF){
        [self showSearchVC:keyWords Type:Currency];
    }else if (_activeTF == self.brandTF) {
        [self showSearchVC:keyWords Type:Brand];
    }else if (_activeTF == self.priceTF){
        if (![self isPureInt:keyWords] && keyWords.length != 0) {
            [AutoDismissAlert autoDismissAlert:@"价格只能输入数字哦"];
            tf.text = _activeTF.text;
        }else {
            _activeTF.text = keyWords;
        }
    }else {
        _activeTF.text = keyWords;
    }
}
//判断一个字符是不是数字
- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}
- (IBAction)comleteClicked:(id)sender {
    NSString *brand = self.brandTF.text;
    NSString *name = self.nameTF.text;
    
    NSString *address = self.addressTF.text;
    NSString *country = self.countryTF.text;
    
    NSString *price = self.priceTF.text;
    NSString *currency = self.currencyTF.text;

    if ([brand trim].length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写品牌"];
        return;
    }
    if ([name trim].length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写名称"];
        return;
    }
    
    
    if (brand.length == 0 && name.length == 0 && address.length == 0 && country.length == 0 && price.length == 0 && currency.length == 0) {
        
    }else {
        TPMarkModel *model = [[TPMarkModel alloc] init];
        model.brand = brand;
        model.name = name;
        model.shopland = address;
        model.origin = country;
        model.shopprice = price;
        model.unit = currency;
        
        if (price.length == 0) {
            model.unit = @"";
        }
        
        if (self.completeBlock) {
            self.completeBlock(model);
        }
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelClicked:(id)sender {
    if (_searchVC.view.hidden == NO) {
        _searchVC.view.hidden = YES;
    }else {
        NSString *brand = self.brandTF.text;
        NSString *name = self.nameTF.text;
        
        NSString *address = self.addressTF.text;
        NSString *country = self.countryTF.text;
        
        NSString *price = self.priceTF.text;

        if (brand.length == 0 && name.length == 0 && address.length == 0 && country.length == 0 && price.length == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self showCancelAlert];
        }
        
    }
}

- (IBAction)deleteBtnClicked:(id)sender {
    if (self.completeBlock) {
        self.completeBlock(nil);
    }
    [self cancelClicked:nil];
}
#pragma mark- alertview
-(void)showCancelAlert{
    NSString *msg = @"确认退出编辑？";
    if (down_IOS_8) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:msg message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:msg message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark- textfiled delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField != self.inputTF) {
        _activeTF.superview.backgroundColor = [UIColor clearColor];
        _activeTF = textField;
        _activeTF.superview.backgroundColor = [UIColor lightGrayColor];
        if (textField == self.currencyTF) {
            [self showSearchVC:@"币种" Type:Currency];
            [self hideKeyboard];
            _inputTF.text = @"";
        }else {
            [_inputTF becomeFirstResponder];
            _inputTF.text = _activeTF.text;
        }
        _inputTF.placeholder = _activeTF.placeholder;
        
        return NO;
        
    }else {
        return YES;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideKeyboard];
}

#pragma mark - Keyboard NSNotification
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
        self.superSV.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)keyboardDidHidden:(NSNotification *)notification
{
    CGFloat duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.superSV.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideKeyboard
{
    [self.view endEditing:YES];
}

@end
