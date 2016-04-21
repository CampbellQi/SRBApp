//
//  WelcomeView.m
//  testWelcomeView
//
//  Created by fengwanqi on 15/12/9.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "WelcomeView.h"

@interface WelcomeView()
{
    NSMutableArray *_webWiewArray;
    NSArray *_gifArray;
}
@end
@implementation WelcomeView

-(id)initWithFrame:(CGRect)frame GifArray:(NSArray *)gifArray {
    if (self = [super initWithFrame:frame]) {
        _webWiewArray = [NSMutableArray new];
        UIScrollView *sv = [[UIScrollView alloc] initWithFrame:self.bounds];
        sv.contentSize = CGSizeMake(CGRectGetWidth(frame) * gifArray.count, 0);
        sv.delegate = self;
        [sv setAlwaysBounceVertical:NO];
        [self addSubview:sv];
        //sv.backgroundColor = [UIColor redColor];
        sv.pagingEnabled = YES;
        
        for (int i=0; i<gifArray.count; i++) {
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(i*CGRectGetWidth(frame), 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
            //webView.backgroundColor = [UIColor redColor];
            webView.scalesPageToFit = YES;
            
            [sv addSubview:webView];
            
            [_webWiewArray addObject:webView];
            _gifArray = gifArray;
        }
        //load 第一个动画
        UIWebView *webView = [_webWiewArray objectAtIndex:0];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:_gifArray[0] ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        [_webWiewArray replaceObjectAtIndex:0 withObject:@"1"];
        
        //设置立即体验按钮
        float btnWidth = 100;
        float btnHeight = 30;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((CGRectGetWidth(frame) - btnWidth)/2, CGRectGetHeight(frame) - 70, btnWidth, btnHeight)];
        [btn setTitle:@"立即体验" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [btn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        UIWebView *wv = [_webWiewArray lastObject];
        [wv addSubview:btn];
        btn.layer.cornerRadius = 5.0f;
        btn.layer.borderColor = MAINCOLOR.CGColor;
        btn.layer.borderWidth = 1.0f;
        self.button = btn;
    }
    return self;
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    if (![[_webWiewArray objectAtIndex:index] isKindOfClass:[NSString class]]) {
        UIWebView *webView = [_webWiewArray objectAtIndex:index];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:_gifArray[index] ofType:@"gif"];
        NSData *gifData = [NSData dataWithContentsOfFile:path];
        [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
        
        [_webWiewArray replaceObjectAtIndex:index withObject:@"1"];
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
