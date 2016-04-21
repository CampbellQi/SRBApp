//
//  AboutUsViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "AboutUsViewController.h"
#import "WelcomeFirstView.h"
#import "AppDelegate.h"

@interface AboutUsViewController ()<UIScrollViewDelegate>
{
    WelcomeFirstView * welcomeView;
    UIImageView * flakeView;
    NSTimer * timer;
}

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    // Do any additional setup after loading the view.
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 70)/2, 40, 70, 70)];
    _imageView.backgroundColor = [GetColor16 hexStringToColor:@"#434343"];
    [_imageView setImage:[UIImage imageNamed:@"ic_launcher.png"]];
    _imageView.layer.cornerRadius = 10;
    _imageView.layer.masksToBounds = YES;
    _imageView.userInteractionEnabled = YES;
    [self.view addSubview:_imageView];
    
    UITapGestureRecognizer *pLongPress4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(welcome)];
    pLongPress4.numberOfTapsRequired = 1;
    [_imageView addGestureRecognizer:pLongPress4];
    
//    _firstLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 16)];
//    _firstLabel.center = CGPointMake(SCREEN_WIDTH / 2, _imageView.frame.origin.y + _imageView.frame.size.height + 68);
////    _firstLabel.text = @"熟人帮iOS版";
//    _firstLabel.font = [UIFont systemFontOfSize:16];
//    _firstLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:_firstLabel];
    
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    
    //获取版本号
    NSString * key = @"CFBundleShortVersionString";
    NSString * currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    _secondLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageView.frame.size.height + _imageView.frame.origin.y + 30, SCREEN_WIDTH, 14)];
    _secondLabel.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
    _secondLabel.font = [UIFont systemFontOfSize:14];
//    _secondLabel.text = [NSString stringWithFormat:@"熟人邦iOS版%@",[dic objectForKey:@"version"]];
    _secondLabel.text = [NSString stringWithFormat:@"熟人邦iOS版%@",currentVersion?currentVersion : @"1.3.3"];
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_secondLabel];
    
    _thirdLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _secondLabel.frame.size.height + _secondLabel.frame.origin.y + 18, SCREEN_WIDTH , 12)];
    _thirdLabel.font = [UIFont systemFontOfSize:12];
    _thirdLabel.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
    _thirdLabel.text = @"北京熟人帮科技有限公司保留所有版权";
    _thirdLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_thirdLabel];
    
    UILabel * fourLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 120)/2,_thirdLabel.frame.size.height + _thirdLabel.frame.origin.y + 18,120,14)];
    fourLabel.font = SIZE_FOR_12;
    fourLabel.textColor = [UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1];
    fourLabel.textAlignment = NSTextAlignmentCenter;
    fourLabel.text = @"www.shurenbang.net";
    [self.view addSubview:fourLabel];
    
    _attentButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 12)];
//    [_attentButton setTitle:@"关注熟人帮" forState:UIControlStateNormal];
//    [_attentButton setTitleColor:[UIColor colorWithRed:0.56 green:0.56 blue:0.56 alpha:1] forState:UIControlStateNormal];
    _attentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _attentButton.center = CGPointMake(SCREEN_WIDTH / 2, _thirdLabel.frame.origin.y + _thirdLabel.frame.size.height + 24);
    [self.view addSubview:_attentButton];
    
//    _smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_attentButton.frame.origin.x - 10, _attentButton.frame.origin.y - 5 , 20, 20)];
//    [_smallImageView setImage:[UIImage imageNamed:@"weibo_logo.png"]];
//    _smallImageView.backgroundColor = [UIColor whiteColor];
//    _smallImageView.hidden = YES;
//    [self.view addSubview:_smallImageView];

    _smallImageView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 624/3)/2, fourLabel.frame.size.height + fourLabel.frame.origin.y + 15 , 624/3, 554/3)];
    [_smallImageView setImage:[UIImage imageNamed:@"gywm"]];
    [self.view addSubview:_smallImageView];
    
/*
    _editionButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, 40)];
    _editionButton.backgroundColor = [UIColor colorWithRed:0.89 green:0 blue:0.36 alpha:1];
    _editionButton.center = CGPointMake(SCREEN_WIDTH / 2, _smallImageView.frame.origin.y + _smallImageView.frame.size.height + 70);
    [_editionButton addTarget:self action:@selector(updateApp) forControlEvents:UIControlEventTouchUpInside];
    if (self.isNewVersion == 1) {
        [_editionButton setTitle:@"有新版本可以下载" forState:UIControlStateNormal];
        _editionButton.enabled = YES;
    }else{
        [_editionButton setTitle:@"已是最新版本" forState:UIControlStateNormal];
        _editionButton.enabled = NO;
    }

    [_editionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:_editionButton];
*/
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
}

- (void)welcome
{
    AppDelegate *app = APPDELEGATE;
    
    welcomeView = [[WelcomeFirstView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    welcomeView.scrollView.delegate = self;
//    [self.view addSubview:welcomeView];
    [app.window.rootViewController.view addSubview:welcomeView];
    [welcomeView.button addTarget:self action:@selector(firstuse) forControlEvents:UIControlEventTouchUpInside];
    [WelcomeFirstView animation:welcomeView.image1];
}

- (void)onTimer
{
    // build a view from our flake image
    flakeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flake.png"]];
    
    // use the random() function to randomize up our flake attributes
    int startX = round(random() % 320);
    int leftorright = (1 + (arc4random() % (2 - 1 + 1)));
    double rounda = (50 + (arc4random() % (100 - 50 + 1))) * 0.01;
    double ronddb = -1.0 * rounda;
    double scale = 1 / round(random() % 100) + 1.0;
    double speed = 1 / round(random() % 100) + 1.0;
    NSLog(@"%d",leftorright);
    // set the flake start position
    flakeView.frame = CGRectMake(startX, -100.0, 25.0 * scale, 25.0 * scale);
    flakeView.alpha = 1;
    
    // put the flake in our main view
    [welcomeView.view3 addSubview:flakeView];
    
    
    
    [UIView beginAnimations:nil context:(__bridge void *)(flakeView)];
    
    // set up how fast the flake will fall
    [UIView setAnimationDuration:5 * speed];
    
    
    // set the postion where flake will move to
    flakeView.frame = CGRectMake(startX, SCREEN_HEIGHT, 25.0 * scale, 25.0 * scale);
    if (leftorright == 1) {
        CGAffineTransform newTransform = CGAffineTransformMakeRotation(M_PI * rounda);
        [flakeView setTransform:newTransform];
    }else{
        CGAffineTransform newTransform = CGAffineTransformMakeRotation(M_PI * ronddb);
        [flakeView setTransform:newTransform];
    }
    // set a stop callback so we can cleanup the flake when it reaches the
    // end of its animation
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (void)onAnimationComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    
    flakeView = (__bridge UIImageView *)(context);
    [flakeView removeFromSuperview];
    // open the debug log and you will see that all flakes have a retain count
    // of 1 at this point so we know the release below will keep our memory
    // usage in check
    //    NSLog([NSString stringWithFormat:@"[flakeView retainCount] = %d", [flakeView retainCount]]);
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    if (scrollView.contentOffset.x == 0) {
        [WelcomeFirstView animation:welcomeView.image1];
        welcomeView.image2.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image2.frame.size.height);
        welcomeView.image3.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image3.frame.size.height);
        [timer setFireDate:[NSDate distantFuture]];
        welcomeView.page.currentPage = 0;
    }
    if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        [WelcomeFirstView animation:welcomeView.image2];
        welcomeView.image1.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image1.frame.size.height);
        welcomeView.image3.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image3.frame.size.height);
        [timer setFireDate:[NSDate distantFuture]];
        welcomeView.page.currentPage = 1;
    }
    if (scrollView.contentOffset.x == SCREEN_WIDTH * 2) {
        [WelcomeFirstView animation:welcomeView.image3];
        welcomeView.image2.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image2.frame.size.height);
        welcomeView.image3.center = CGPointMake(SCREEN_WIDTH / 2, - welcomeView.image1.frame.size.height);
        timer = [NSTimer scheduledTimerWithTimeInterval:(0.15) target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
        [timer setFireDate:[NSDate distantPast]];
        welcomeView.page.currentPage = 2;
    }
}

- (void)firstuse
{
    NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithContentsOfFile:USER_CONFIG_PATH];
    if (dataDic == nil) {
        dataDic = [NSMutableDictionary dictionary];
    }
    [dataDic setObject:@"1" forKey:@"welcome"];
    
    //将登录状态写入配置文件
    [dataDic writeToFile:USER_CONFIG_PATH atomically:YES];
    //[WelcomeFirstView closeView:welcomeView];
    [welcomeView removeFromSuperview];
    [timer invalidate];
    timer = nil;
}


- (void)updateApp{
    //跳转到AppStore
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=%d",APP_ID];
    NSURL *url = [NSURL URLWithString:str];
    [[UIApplication sharedApplication]openURL:url];
}

- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//JSON字符串转换成字典
- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败:%@",err);
        return nil;
    }
    return dic;
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
