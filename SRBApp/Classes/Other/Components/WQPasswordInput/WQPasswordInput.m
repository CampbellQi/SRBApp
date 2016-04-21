//
//  WQPasswordInput.m
//  testPwdInput
//
//  Created by fengwanqi on 16/1/20.
//  Copyright © 2016年 fengwanqi. All rights reserved.
//
#define PWDTF_COUNT 6
#import "WQPasswordInput.h"

@implementation WQPasswordInput

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"WQPasswordInput" owner:self options:nil][0];
        self.topView.frame = self.bounds;
        [self addSubview:self.topView];
        
        [self.inputPwdTF addTarget:self action:@selector(inputPwdTFChanged:) forControlEvents:UIControlEventEditingChanged];
        //添加输入框
        float margin = 20;
        float width = CGRectGetWidth(self.frame) - margin * 2;
        float height = width / PWDTF_COUNT;
        UIView *tfSuperView = [[UIView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.inputPwdTF.frame), width, height)];
        tfSuperView.layer.cornerRadius = 5.0f;
        tfSuperView.layer.borderColor = self.lineLbl.backgroundColor.CGColor;
        tfSuperView.layer.borderWidth = 1.0f;
        [self addSubview:tfSuperView];
        
        for (int i=0; i<PWDTF_COUNT; i++) {
            UITextField *pwdTF = [[UITextField alloc] initWithFrame:CGRectMake(i * height, 0, height, height)];
            pwdTF.enabled = NO;
            pwdTF.textAlignment = NSTextAlignmentCenter;//居中
            pwdTF.secureTextEntry = YES;//设置密码模式
            [tfSuperView addSubview:pwdTF];
            pwdTF.tag = 100 + i;
            pwdTF.backgroundColor = [UIColor clearColor];
            
            //分割线
            if (i != 0) {
                UILabel *lineLbl = [[UILabel alloc] initWithFrame:CGRectMake(i * height, 0, 1, CGRectGetHeight(pwdTF.frame))];
                lineLbl.backgroundColor = self.lineLbl.backgroundColor;
                [tfSuperView addSubview:lineLbl];
            }
            
            
            
        }
    }
    return self;
}
#pragma mark 文本框内容改变
- (void)inputPwdTFChanged:(UITextField *)tx
{
    NSString *password = tx.text;
    
    if (password.length == PWDTF_COUNT)
    {

    }
    
    for (int i = 0; i < PWDTF_COUNT; i++)
    {
        UITextField *pwdtx = [self viewWithTag:100 + i];
        if (i < password.length)
        {
            NSString *pwd = [password substringWithRange:NSMakeRange(i, 1)];
            pwdtx.text = pwd;
        }else {
            pwdtx.text = @"";
        }
        
    }
}
- (IBAction)confirmClicked:(id)sender {
}

- (IBAction)cancelClicked:(id)sender {
}
@end
