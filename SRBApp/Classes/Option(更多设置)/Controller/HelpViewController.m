//
//  HelpViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"使用帮助";
    self.view.backgroundColor = [UIColor colorWithRed:0.87 green:0.87 blue:0.87 alpha:1];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(15,  15, SCREEN_WIDTH - 30, SCREEN_HEIGHT - 30 - 64)];
//    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 30, SCREEN_HEIGHT * 1.3);
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 100, 18)];
    _titleLabel.center = CGPointMake(_scrollView.frame.size.width / 2, 30);
    _titleLabel.font = [UIFont systemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    //[_scrollView addSubview:_titleLabel];
    
    
    _helpLabel = [[UILabel alloc]init];
    _helpLabel.font = [UIFont systemFontOfSize:12];
    _helpLabel.numberOfLines = 0;
    [_scrollView addSubview:_helpLabel];
    
    [self post];
    

    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

# pragma mark - 去掉HTML标签

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        html = [html stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
        html = [html stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“ "];
        html = [html stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"” "];
        html = [html stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        html = [html stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"-"];
        html = [html stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."];
    }
    return html;
}

#pragma mark - post请求
- (void)post
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getSystemInfo" parameters:@{@"type":@"2"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSDictionary * dic1 = [dic objectForKey:@"data"];
        _titleLabel.text = [dic1 objectForKey:@"title"];
        NSString * string = [self filterHTML:[dic1 objectForKey:@"content"]];
        if ([dic objectForKey:@"title"] == nil || [dic objectForKey:@"content"] == nil) {
            CGRect frame = [string boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 53, 40000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_12} context:nil];
            _helpLabel.frame = CGRectMake(18, 5, SCREEN_WIDTH - 53, frame.size.height + 5);
            _helpLabel.text = string;
            _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH - 30, _helpLabel.frame.origin.y + _helpLabel.frame.size.height);
        }else{
            [AutoDismissAlert autoDismissAlert:@"请求失败"];
        }
    }andFailureBlock:^{
        
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
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
