//
//  WebHelpViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/5/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "WebHelpViewController.h"

@interface WebHelpViewController ()<UIWebViewDelegate>
{
    BOOL isLoadingFinished;
    NSString * lHtml1;
}
@property(nonatomic) BOOL scalesPageToFit;
@property (nonatomic, strong)UIWebView * webView;
@end

@implementation WebHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"使用帮助";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.shurenbang.net/wt/index.html"]];
    
    //html是否加载完成
//    isLoadingFinished = NO;
    
    //这里一定要设置为NO
    [self.webView setScalesPageToFit:NO];
    [self.webView loadRequest:request];
//    lHtml1 = [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.innerHTML"];
    
    
    //第一次加载先隐藏webview
//    [self.webView setHidden:YES];
    
//    self.webView.delegate = self;
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.qq.com"]];
    [self.view addSubview: self.webView];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * url = request.URL.absoluteString;
    NSLog(@"%@",url);
    return YES;
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //若已经加载完成，则显示webView并return
    if(isLoadingFinished)
    {
        [self.webView setHidden:NO];
        return;
    }
    
    NSString *jsToGetHTMLSource = @"document.getElementsByTagName('html')[0].innerHTML";
    
    lHtml1 = [self.webView stringByEvaluatingJavaScriptFromString:jsToGetHTMLSource];
    [self.webView loadHTMLString:lHtml1 baseURL:nil];
    
    //js获取body宽度
    NSString *bodyWidth= [webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollWidth "];
    
    int widthOfBody = [bodyWidth intValue];
    
    //获取实际要显示的html
    NSString *html = [self htmlAdjustWithPageWidth:widthOfBody
                                              html:lHtml1
                                           webView:webView];
    
    //设置为已经加载完成
    isLoadingFinished = YES;
    //加载实际要现实的html
    [self.webView loadHTMLString:html baseURL:nil];
}

//获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
- (NSString *)htmlAdjustWithPageWidth:(CGFloat )pageWidth
                                 html:(NSString *)html
                              webView:(UIWebView *)webView
{
    NSMutableString *str = [NSMutableString stringWithString:html];
    //计算要缩放的比例
    CGFloat initialScale = webView.frame.size.width/pageWidth;
    //将</head>替换为meta+head
    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    
    NSRange range =  NSMakeRange(0, str.length);
    //替换
    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    return str;
}

- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    CGFloat webViewHeight=[webView.scrollView contentSize].height;
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = webViewHeight;
//    webView.frame = newFrame;
//}

//-(void)webViewDidFinishLoad:(UIWebView *)webView{
//    CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.offsetHeight"]floatValue];
//    // CGFloat webViewHeight= [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"]floatValue];
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = webViewHeight;
//    webView.frame = newFrame;
//}


@end
