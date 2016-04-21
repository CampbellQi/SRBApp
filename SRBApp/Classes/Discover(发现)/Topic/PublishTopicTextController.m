//
//  PublishTopicTextController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#define PLACEHOLDER @"说点什么吧..."
#import "PublishTopicTextController.h"
#import "CommonView.h"
#import "StringHelper.h"

@interface PublishTopicTextController ()<UITextViewDelegate, UIAlertViewDelegate>

@end

@implementation PublishTopicTextController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
     self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.contentTV becomeFirstResponder];
    [self.view addTapAction:@selector(hideKeyboard) forTarget:self];
    if (_maxWordsCount) {
        if (_sourceText) {
            self.wordsCountLbl.text = [NSString stringWithFormat:@"%ld/%d", _sourceText.length,_maxWordsCount];
        }else {
            self.wordsCountLbl.text = [NSString stringWithFormat:@"%d/%d", 0,_maxWordsCount];
        }
        
    }
    [self setUpView];
}
#pragma mark- 页面
-(void)setUpView {
    if (_sourceText && _sourceText.length) {
        self.contentTV.text = _sourceText;
        self.contentTV.textColor = [UIColor blackColor];
    }
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"完 成" Target:self Action:@selector(completedBtnClicked)];
    //键盘监听
}
#pragma mark- 事件
-(void)backBtnClicked{
    NSString *content = [self.contentTV.text trim];
    if (![content isEqualToString:PLACEHOLDER] && content.length != 0) {
        if (down_IOS_8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1234;
            [alert show];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定放弃编辑?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)hideKeyboard {
    [self.view endEditing:YES];
}
-(void)completedBtnClicked {
    if (_maxWordsCount && [self.contentTV.text trim].length > _maxWordsCount) {
        [AutoDismissAlert autoDismissAlertSecond:@"字数超过限制了哦"];
        return;
    }
    if (![[self.contentTV.text trim] isEqualToString:PLACEHOLDER]) {
        if (self.completedBlock) {
            self.completedBlock(self.contentTV.text);
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark- textview delegate
-(void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:PLACEHOLDER]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text trim].length == 0) {
        textView.textColor = [UIColor lightGrayColor];
        textView.text = PLACEHOLDER;
    }
}
-(void)textViewDidChange:(UITextView *)textView {
    if (_maxWordsCount) {
        NSString  * nsTextContent=textView.text;
        if (nsTextContent.length > _maxWordsCount) {
            if (textView.text.length >= _maxWordsCount) {
                //NSLog(@"%d", textView.text.length);
                //textView.text = [textView.text substringToIndex:_maxWordsCount];
            }
            
        }
        self.wordsCountLbl.text = [NSString stringWithFormat:@"%ld/%d", textView.text.length,_maxWordsCount];
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
