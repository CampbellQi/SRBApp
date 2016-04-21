//
//  TotalViewController.m
//  SRBApp
//
//  Created by zxk on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TotalViewController.h"
#import "LoginViewController.h"
#import "TagLocationsViewController.h"
#import "Emotion.h"
#import "EmotionAttachment.h"
#import "LocationModel.h"

//上拉加载的起始页
//static int page = 0;
//请求数据的条数
//static int count = NumOfItemsForZuji;
@interface TotalViewController ()<ISSShareViewDelegate>

@property (nonatomic, strong)UILabel * pageLabel;
@end

@implementation TotalViewController
#pragma mark - 懒加载
- (EmotionKeyboard *)emotionKeyboard
{
    if (!_emotionKeyboard) {
        self.emotionKeyboard = [[EmotionKeyboard alloc]init];
        self.emotionKeyboard.width = SCREEN_WIDTH;
        self.emotionKeyboard.height = 216;
    }
    return _emotionKeyboard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    //初始化控件
    [self customInit];
    //设置向上按钮
    [self toTop];
    //初始化用户信息字典
    self.userInfoDic = [NSDictionary dictionary];
    //获取分享logo及信息
    [self getSahreInfo];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //友盟统计
    [MobClick beginLogPageView:@"positionFind"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:UIMenuControllerDidHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelect:) name:@"EmotionDidSelectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDelete) name:@"EmotionDidDeleteNotification" object:nil];
}

#pragma mark - 监听表情键盘输入
- (void)emotionDidSelect:(NSNotification *)notification
{
    Emotion * emotion = notification.userInfo[@"selectedEmotion"];
    
    //将文字插入到光标所在的位置
    if (emotion.png) {
        [self.hpTextView.internalTextView insertText:@" W"];
        //加载图片
        EmotionAttachment * attch = [[EmotionAttachment alloc]init];
        attch.emotion = emotion;
        
        //设置图片的尺寸
        CGFloat attchWH = self.hpTextView.internalTextView.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        NSAttributedString * imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc]init];
        //拼接之前的文字(图片和文字)
        [attributedText appendAttributedString:self.hpTextView.internalTextView.attributedText];
        
        //拼接图片
//        [attributedText appendAttributedString:imageStr];
        NSUInteger loc = self.hpTextView.internalTextView.selectedRange.location;
        NSRange tempRange = NSMakeRange(self.hpTextView.internalTextView.selectedRange.location - 2, 2);
        [attributedText replaceCharactersInRange:tempRange withAttributedString:imageStr];
//        [attributedText insertAttributedString:imageStr atIndex:loc];
        
        //设置字体
        [attributedText addAttribute:NSFontAttributeName value:self.hpTextView.internalTextView.font range:NSMakeRange(0, attributedText.length)];
        
        self.hpTextView.internalTextView.attributedText = attributedText;
        
        //移动光标
        self.hpTextView.internalTextView.selectedRange = NSMakeRange(loc - 1, 0);
    }
//    else if (emotion.code){
//        [self.hpTextView.internalTextView insertText:emotion.code.emoji];
//    }
    
}

- (void)noDataView
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39 - 49)];
    self.listNoDataView = view;
    view.hidden = YES;
    view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    [self.tableview addSubview:view];
    
    UIImageView * imageV = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, 55, 200, 170)];
    [imageV setImage:[UIImage imageNamed:@"suibianguang"]];
    [view addSubview:imageV];
    
    //    UIButton * noDataBtn = [[UIButton alloc]init];
    //    [noDataBtn setTitle:@"随便逛逛" forState:UIControlStateNormal];
    //    [noDataBtn setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal];
    //    noDataBtn.width = 100;
    //    noDataBtn.height = 30;
    //    noDataBtn.centerX = SCREEN_WIDTH * 0.5;
    //    noDataBtn.y = 250;
    //    [noDataBtn addTarget:self action:@selector(seeSomething:) forControlEvents:UIControlEventTouchUpInside];
    //    [view addSubview:noDataBtn];
}

#pragma mark - 监听表情键盘删除
/**
 *  表情键盘的删除操作
 */
- (void)emotionDidDelete
{
    [self.hpTextView.internalTextView deleteBackward];
}

#pragma mark - 表情图片转成文字
- (NSString *)fullText
{
    NSMutableString * fulltext = [NSMutableString string];
    //遍历所有的文字
    [self.hpTextView.internalTextView.attributedText enumerateAttributesInRange:NSMakeRange(0, self.hpTextView.internalTextView.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        
        EmotionAttachment * attch = attrs[@"NSAttachment"];
        //如果是图片表情
        if (attch) {//图片
            [fulltext appendFormat:@"[%@]",attch.emotion.code];
        }else{//普通文本
            //获得这个范围内的文字
            NSAttributedString * str = [self.hpTextView.internalTextView.attributedText attributedSubstringFromRange:range];
            [fulltext appendString:str.string];
        }
    }];
    return fulltext;
}

- (void)urlRequestPost{
    [huds removeFromSuperview];
}

- (void)footerRefresh
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"positionFind"];
    [self.hpTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"EmotionDidSelectNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"EmotionDidDeleteNotification" object:nil];
    [self hidden];
//    self.hpTextView.text = @"";
//    self.markID = @"";
//    self.locationID = @"";
}

/**
 *  @brief  让menu消失
 */
- (void)hidden
{
    NSArray * temparr = [self.tableview visibleCells];
    for (LocationCell * tempCell in temparr) {
        tempCell.descriptionLabel.backgroundColor = [UIColor clearColor];
    }
}

//返回顶部
- (void)toTop
{
    toTopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    toTopBtn.frame = CGRectMake(SCREEN_WIDTH - 60, SCREEN_HEIGHT - 49 - 60 - 64 - 40, 45, 45);
    //    toTopBtn.backgroundColor = [UIColor redColor];
    [toTopBtn setImage:[UIImage imageNamed:@"pgup"] forState:UIControlStateNormal];
    [toTopBtn addTarget:self action:@selector(clickToTop) forControlEvents:UIControlEventTouchUpInside];
    toTopBtn.hidden = YES;
    [self.view addSubview:toTopBtn];
    [self.view bringSubviewToFront:toTopBtn];
}

- (void)clickToTop
{
    [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)customInit
{
    dataArray = [NSMutableArray array];
    imgArr = [NSMutableArray array];
    imgPage = 0;
    totalImgPage = 0;
    UITapGestureRecognizer * hiddenTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTap:)];
    [self.view addGestureRecognizer:hiddenTap];
    
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 39) style:UITableViewStylePlain];
    self.tableview = tableview;
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:tableview];
    tableview.backgroundColor = [UIColor clearColor];
    
    
    [tableview addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableview addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableview headerBeginRefreshing];
    
    self.tableview.delaysContentTouches = NO;
    if ([[[UIDevice currentDevice]systemVersion] floatValue]>=8.0) {
        for (UIView * currentView in tableview.subviews) {
            if ([currentView isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)currentView).delaysContentTouches = NO;
                break;
            }
        }
    }
    
    
    scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    AppDelegate * app = APPDELEGATE;
    [app.window addSubview:scrollPanel];
//    [[[UIApplication sharedApplication].windows lastObject] addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    downBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 12.5 - 18, 34, 40, 40);
    [downBtn addTarget:self action:@selector(saveImageToPhotos) forControlEvents:UIControlEventTouchUpInside];
    
    //显示页数
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.frame = CGRectMake((SCREEN_WIDTH - 40)/2, 42, 40, 16);
    imgPage = myScrollView.contentOffset.x/SCREEN_WIDTH+1;
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.font = SIZE_FOR_IPHONE;
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-10, 0, SCREEN_WIDTH + 20, SCREEN_HEIGHT)];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    
    [scrollPanel addSubview:self.pageLabel];
    [scrollPanel addSubview:downBtn];
  
    
    noData = [[NoDataView alloc]initWithFrame:tableview.frame];
    noData.hidden = YES;
    [tableview addSubview:noData];
    
    //输入框
    commentTextBGView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40)];
    commentTextBGView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    
    [self.view addSubview:commentTextBGView];
    
    
    self.hpTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30 - 60 - 12, 30)];
    self.hpTextView.contentInset = UIEdgeInsetsMake(0, 4, 0, 5);
    self.hpTextView.isScrollable = NO;
    self.hpTextView.layer.borderColor = [UIColor clearColor].CGColor;
    self.hpTextView.delegate = self;
    self.hpTextView.minNumberOfLines = 1;
    self.hpTextView.maxNumberOfLines = 4;
    self.hpTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.hpTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.hpTextView.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.hpTextView.layer.cornerRadius = 2;
    self.hpTextView.layer.masksToBounds = YES;
    self.hpTextView.returnKeyType = UIReturnKeySend;
    self.hpTextView.font = SIZE_FOR_IPHONE;
    self.hpTextView.placeholderColor = [GetColor16 hexStringToColor:@"#c9c9c9"];
    self.hpTextView.placeholder = @"我来说一句";
    self.hpTextView.layer.borderWidth = 1;
    
    [commentTextBGView addSubview:self.hpTextView];
    
//    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    submitBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, 5, 60, 25);
//    [submitBtn addTarget:self action:@selector(changeKeyboard) forControlEvents:UIControlEventTouchUpInside];
//    [submitBtn setBackgroundImage:[UIImage imageNamed:@"rc_smiley_normal"] forState:UIControlStateNormal];
//    submitBtn.enabled = YES;
//    [commentTextBGView addSubview:submitBtn];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 60, commentTextBGView.frame.size.height - 7 - 25, 55, 25);
    submitBtn.layer.cornerRadius = CGRectGetHeight(submitBtn.frame)*0.5;
    submitBtn.layer.masksToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"发 送" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[self imageWithColor:[GetColor16 hexStringToColor:@"#959595"] size:submitBtn.frame.size] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    submitBtn.enabled = NO;
    [commentTextBGView addSubview:submitBtn];
    
    commentTextBGView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadPost) name:@"reloadVC" object:nil];
    
}

- (void)changeKeyboard
{
    switchKeyBoard = YES;
    if (self.hpTextView.internalTextView.inputView == nil) {
        self.hpTextView.internalTextView.inputView = self.emotionKeyboard;
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"rc_message_bar_keyboard"] forState:UIControlStateNormal];
    }else{
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"rc_smiley_normal"] forState:UIControlStateNormal];
        self.hpTextView.internalTextView.inputView = nil;
    }
    [self.hpTextView endEditing:YES];
    switchKeyBoard = NO;
    [self.hpTextView becomeFirstResponder];
    
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

#pragma mark ----------==========----------==========----------==========----------==========

#pragma mark -
#pragma mark - custom method
- (void) addSubImgView:(NSIndexPath *)myIndexPath
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    LocationCell * tmpCell = (LocationCell *)[self.tableview cellForRowAtIndexPath:myIndexPath];
    
    LocationModel * locationModel = dataArray[myIndexPath.row];
    NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
    
    NSMutableArray * tempArr = [NSMutableArray array];
    for (int i = 0; i < photosArr.count; i++) {
        [tempArr addObject:[photosArr[i] stringByReplacingOccurrencesOfString:@"_sm" withString:@""]];
    }
    
    totalImgPage = (int)tempArr.count;
    self.pageLabel.text = [NSString stringWithFormat:@"%.0f/%d",myScrollView.contentOffset.x/SCREEN_WIDTH+1,totalImgPage];
    
    myScrollView.contentSize = CGSizeMake(tempArr.count * (SCREEN_WIDTH + 20), SCREEN_HEIGHT);
    
    [imgArr removeAllObjects];
    for (int i = 0; i < tempArr.count; i ++)
    {
//        if (i == currentIndex)
//        {
//            continue;
//        }
        
        TapImageView * tmpView;
        if (tempArr.count == 1) {
            tmpView = (TapImageView *)[tmpCell viewWithTag:601];
        }else{
            tmpView = (TapImageView *)[tmpCell viewWithTag:501 + i];
        }
        
        
        //转换后的rect
        
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:[[UIApplication sharedApplication].windows lastObject]];
        
        ImgScrollView * tmpImgScrollView = [[ImgScrollView alloc]initWithFrame:CGRectMake(i * (SCREEN_WIDTH + 20) + 10, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [tmpImgScrollView setContentWithFrame:convertRect];

        [tmpImgScrollView setImage:tmpView.image];
        
        UIActivityIndicatorView * tempActivitys = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 60)/2, (SCREEN_HEIGHT - 60)/2, 60, 60)];
        tempActivitys.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [tmpImgScrollView addSubview:tempActivitys];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [tempActivitys startAnimating];
        });
        
        [tmpImgScrollView.imgView sd_setImageWithURL:[NSURL URLWithString:tempArr[i]] placeholderImage:tmpView.image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image != nil) {
                [imgArr addObject:image];
            }
            [tempActivitys stopAnimating];
            [tempActivitys removeFromSuperview];
            
            [tmpImgScrollView setImage:image];
            if (i == currentIndex) {
                [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
            }else{
                [tmpImgScrollView setAnimationRect];
            }
        }];
        
        [myScrollView addSubview:tmpImgScrollView];
        

        tmpImgScrollView.i_delegate = self;
        
        if (i == currentIndex) {
            [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
        }else{
            [tmpImgScrollView setAnimationRect];
        }
    }
}

- (void)saveImageToPhotos{
    
    if (imgArr.count != 0 && imgArr != nil) {
        if (currentIndex < imgArr.count) {
            UIImageWriteToSavedPhotosAlbum([imgArr objectAtIndex:currentIndex], nil, nil, nil);
            [AutoDismissAlert autoDismissAlert:@"保存成功"];
        }else{
            [AutoDismissAlert autoDismissAlert:@"保存失败"];
        }
        
    }else{
        [AutoDismissAlert autoDismissAlert:@"保存失败"];
    }
}


- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.5 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - custom delegate
- (void) tappedWithObject:(id)sender
{
    AppDelegate * app = APPDELEGATE;
    [app.window bringSubviewToFront:scrollPanel];
    
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
    
    currentIndex = (int)tmpView.tag - 501;
    
    if (currentIndex == 100) {
        currentIndex = 0;
    }
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex* (SCREEN_WIDTH + 20);
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView:tmpView.indexpath];
    
}


- (void) tapImageViewTappedWithObject:(id)sender
{
    
    ImgScrollView *tmpImgView = sender;
    [[SDWebImageManager sharedManager]cancelAll];
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
        for (UIView *tmpView in myScrollView.subviews)
        {
            [tmpView removeFromSuperview];
        }
    }];
}

#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == myScrollView) {
        for (UIScrollView * s in myScrollView.subviews) {
            if ([s isKindOfClass:[UIScrollView class]]) {
                if (imgPage != myScrollView.contentOffset.x / SCREEN_WIDTH + 1) {
                    [s setZoomScale:1.0];
                }
            }
        }
        
        CGFloat pageWidth = scrollView.frame.size.width;
        currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        imgPage = myScrollView.contentOffset.x/SCREEN_WIDTH+1;
        self.pageLabel.text = [NSString stringWithFormat:@"%.0f/%d",myScrollView.contentOffset.x/SCREEN_WIDTH+1,totalImgPage];
    }
    
    Singleton * singleton = [Singleton sharedInstance];
    singleton.isScrolling = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSArray * temparr = [self.tableview visibleCells];
    for (LocationCell * tempCell in temparr) {
        CGRect rect = tempCell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
        rect.size.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            tempCell.twoButtonView.frame = rect;
        } completion:^(BOOL finished) {
            tempCell.twoButtonView.hidden = YES;
        }];
        tempCell.locationModel.isClick = NO;
    }
    if (![scrollView isEqual:self.hpTextView]) {
        [self.hpTextView resignFirstResponder];
//        self.hpTextView.text = @"";
//        self.markID = @"";
//        self.locationID = @"";
    }
    if(scrollView.contentOffset.y >= 130 * 5){
        toTopBtn.hidden = NO;
    }else if(scrollView.contentOffset.y < 130 * 5){
        toTopBtn.hidden = YES;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    Singleton * singleton = [Singleton sharedInstance];
    singleton.isScrolling = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    Singleton * singleton = [Singleton sharedInstance];
    singleton.isScrolling = NO;
}

#pragma mark ----------==========----------==========----------==========----------==========

- (void)reloadPost
{
    [dataArray removeAllObjects];
    [self.tableview reloadData];
    [self.tableview headerBeginRefreshing];
}

#pragma mark - 返回计算后的坐标,图片尺寸是否超过200*200
-(CGSize)onScreenPointSizeOfImageInImageView:(LocationModel *)locationModel{
    CGFloat scale;
    CGFloat width = [locationModel.width floatValue];
    CGFloat height = [locationModel.height floatValue];
    if (width > height) {
        scale = width / 200;
    } else {
        scale = height / 200;
    }
    return CGSizeMake(width / scale, height / scale);
}

#pragma mark - Table view data source

- (NSString *)appendStrWithLocationModel:(LocationModel *)locationmodel
{
    NSString * content = locationmodel.content;
    if (locationmodel.tags == nil || [locationmodel.tags isEqualToString:@""] || locationmodel.tags.length == 0) {
        
    }else{
        NSArray * tempArr = [locationmodel.tags componentsSeparatedByString:@","];
        NSMutableArray * attribuArr = [NSMutableArray array];
        for (NSString * str in tempArr) {
            if (![str isEqualToString:@""] && str.length != 0) {
                NSString * tempStr = [NSString stringWithFormat:@"#%@#",str];
                [attribuArr addObject:tempStr];
            }
        }
        NSString * attributedContentStr = @"";
        for (NSString * str in attribuArr) {
            attributedContentStr = [attributedContentStr stringByAppendingFormat:@"%@ ",str];
        }
        content = [attributedContentStr stringByAppendingString:locationmodel.content];
    }
    if (locationmodel.sourcemodule != nil && ![locationmodel.sourcemodule isEqualToString:@""] && locationmodel.sourcemodule.length != 0) {
        NSString * sourceStr = [NSString stringWithFormat:@"%@",@"【逛街】"];
        content = [NSString stringWithFormat:@"%@%@",sourceStr,content];
    }
    return content;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationModel * locationModel = dataArray[indexPath.row];
    NSArray * likesArr = locationModel.likes;
    int j = 0;
    int tempWidth = 0;  //计算赞所在view的高度
    if (locationModel.likes != nil && locationModel.likes.count != 0) {
        for (int i = 0; i < locationModel.likes.count + 1; i++) {
            @autoreleasepool {
                NSString * nameStr;
                NSDictionary * tempDic;
                if (i <= locationModel.likes.count - 1) {
                    tempDic = likesArr[i];
                    nameStr = [NSString stringWithFormat:@"%@,",[tempDic objectForKey:@"nickname"]];
                }else{
                    nameStr = @" 觉得很赞";
                }
                if (i == locationModel.likes.count - 1) {
                    nameStr = [nameStr substringToIndex:nameStr.length - 1];
                }
                
                CGSize tempSize = [nameStr sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}];
                
                tempWidth += tempSize.width;
                if (tempWidth > (SCREEN_WIDTH - 78 - 20)) {
                    tempWidth = 0;
                    tempWidth += tempSize.width;
                    j += 1;
                }
            }
        }
    }    
    
    NSArray * commentArr = locationModel.comments;
    double height = 0.0f; //计算评论内容的高度
    if (locationModel.comments != nil && locationModel.comments.count != 0) {
        for (int i = 0; i < locationModel.comments.count; i++) {
            NSDictionary * tempDic = commentArr[i];
            NSDictionary * fromuserDic = [tempDic objectForKey:@"fromuser"];
            NSDictionary * toUserDic = [tempDic objectForKey:@"touser"];
            
            NSString * commentStr;
            if (toUserDic == nil) {
                commentStr = [NSString stringWithFormat:@"%@：%@",[fromuserDic objectForKey:@"nickname"],[tempDic objectForKey:@"comment_content"]];
            }else{
                commentStr = [NSString stringWithFormat:@"%@ %@ %@：%@",[fromuserDic objectForKey:@"nickname"],@"回复",[toUserDic objectForKey:@"nickname"],[tempDic objectForKey:@"comment_content"]];
            }
            [locationModel setNameAttributedStrWith:commentStr andFont:SIZE_FOR_14];
            
            CGRect tempRect = [locationModel.nameAttributedText boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78 - 30, 50000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
            height += tempRect.size.height + 6;
        }
    }
    
    CGRect rect = [[self appendStrWithLocationModel:locationModel] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 78, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
//    CGRect rect = [locationModel.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 40 - 8, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    
    //内容起始位置
    CGFloat tempY = 0;
    if ((locationModel.content == nil || [locationModel.content isEqualToString:@""] || locationModel.content.length == 0 )&& (locationModel.tags == nil || [locationModel.tags isEqualToString:@""])) {
        tempY = 12;
    }else{
        tempY = 12 + 20 + 8;
    }
    
    //名字 + locationImg + 内容 + height + 我来说一句 + 空白
    CGFloat someHeight = 32 + 25 + tempY + rect.size.height + height + 44;
    CGFloat zanHeight = (j + 1)* 15 + 15;
    
    //没有照片
    if ([locationModel.photos isEqualToString:@""]) {
        //是否是自己发布的足迹
        if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
            //是否有赞的人
            if (likesArr.count == 0) {
                return someHeight + 28;
            }else{
                return someHeight + zanHeight + 28;
            }
        }else{
            if (likesArr.count == 0) {
                return someHeight;
            }else{
                return someHeight + zanHeight;
            }
        }
    }else{
        //有图片的情况
        NSArray * photosArr = [locationModel.photos componentsSeparatedByString:@","];
        //图片数量<=3
        if (photosArr.count <= 3) {
            //图片数量==1
            if (photosArr.count == 1) {
                NSInteger tempHeight = 200;
                if (locationModel.width != nil && ![locationModel.width isEqualToString:@""] && locationModel.height != nil && ![locationModel.height  isEqualToString:@""] && ![locationModel.width isEqualToString:@"0"] && ![locationModel.height isEqualToString:@"0"]) {
                    CGSize tempSize = [self onScreenPointSizeOfImageInImageView:locationModel];
                    tempHeight = tempSize.height;
                }else{
                    tempHeight = 200;
                }
                if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
                    if (likesArr.count == 0) {
                       return someHeight + tempHeight + 9 + 28;
                    }else{
                        return someHeight + tempHeight + 9  + 28 + zanHeight;
                    }
                }else{
                    if (likesArr.count == 0) {
                        return someHeight + tempHeight + 9 ;
                    }else{
                        return someHeight + tempHeight + 9  + zanHeight;
                    }
                }
            }else{
                if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
                    if (likesArr.count == 0) {
                        return someHeight + 81 + 28;
                    }else{
                        return someHeight + 81 + zanHeight + 28;
                    }
                    
                }else{
                    if (likesArr.count == 0) {
                        return someHeight + 81;
                    }else{
                        return someHeight + 81 + zanHeight;
                    }
                    
                }
            }
        }else{
            if ([locationModel.account isEqualToString:ACCOUNT_SELF]) {
                if (likesArr.count == 0) {
                    return someHeight + 156 +28;
                }else{
                    return someHeight + 156 + zanHeight + 28;
                }
                
            }else{
                if (likesArr.count == 0) {
                    return someHeight + 156;
                }else{
                    return someHeight + 156 + zanHeight;
                }
            }
        }
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (void)pushToGoodsDetailView:(NSString *)goodsID withLocationTextView:(LocationTextView *)locationTextView
{
    if (goodsID != nil && ![goodsID isEqualToString:@""] && goodsID.length != 0) {
        DetailActivityViewController * myAssureVC = [[DetailActivityViewController alloc]init];
        myAssureVC.idNumber = goodsID;
        [self.navigationController pushViewController:myAssureVC animated:YES];
    }
}

- (void)pushToLocationTagView:(NSString *)tag withLocationTextView:(LocationTextView *)locationTextView
{
    Singleton * singleton = [Singleton sharedInstance];
    if (singleton.isScrolling == NO) {
        TagLocationsViewController * tagLocationVC = [[TagLocationsViewController alloc]init];
        tagLocationVC.tagStr = tag;
        if (tag != nil) {
           [self.navigationController pushViewController:tagLocationVC animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * reuseID = @"cell";
    
    LocationCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (cell == nil) {
        cell = [[LocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    cell.descriptionLabel.delegate = self;
    cell.indexpath = indexPath;
    cell.locationModel = dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.moreBtn.indexpath = indexPath;
    [cell.moreBtn addTarget:self action:@selector(showMoreView:) forControlEvents:UIControlEventTouchUpInside];
    cell.zanBtn.indexpath = indexPath;
    [cell.zanBtn addTarget:self action:@selector(zanBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.shareBtn.indexpath = indexPath;
    [cell.shareBtn addTarget:self action:@selector(shareRequest:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    
    //cell.photoImg.indexpath = indexPath;
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLPersonal:)];
    [cell.logoImg addGestureRecognizer:logoTap];
    
    cell.logoImg.indexpath = indexPath;
    cell.logoImg.contentMode = UIViewContentModeScaleAspectFill;
    cell.logoImg.clipsToBounds = YES;
    
    cell.photoImg.indexpath = indexPath;
    cell.photoImg1.indexpath = indexPath;
    cell.photoImg2.indexpath = indexPath;
    cell.photoImg3.indexpath = indexPath;
    cell.photoImg4.indexpath = indexPath;
    cell.photoImg5.indexpath = indexPath;
    cell.photoImg6.indexpath = indexPath;
    
    cell.photoImg.t_delegate = self;
    cell.photoImg1.t_delegate = self;
    cell.photoImg2.t_delegate = self;
    cell.photoImg3.t_delegate = self;
    cell.photoImg4.t_delegate = self;
    cell.photoImg5.t_delegate = self;
    cell.photoImg6.t_delegate = self;
    
    cell.addressLabel.indexpath = indexPath;
    //地图
    UITapGestureRecognizer *addressTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressTap:)];
    [cell.addressLabel addGestureRecognizer:addressTap];
    cell.delBtn.indexpath = indexPath;
    [cell.delBtn addTarget:self action:@selector(delLocation:) forControlEvents:UIControlEventTouchUpInside];

    cell.commentBGView.indexpath = indexPath;
    
    UITapGestureRecognizer * makeCommentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(makeCommentTap:)];
    [cell.commentBGView addGestureRecognizer:makeCommentTap];
    
    return cell;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSDictionary * tempDic = [self parametersForDic:@"accountDeleteCommentLocation" parameters:@{ACCOUNT_PASSWORD,@"markId":self.markID}];
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"删除中,请稍后";
        hud.dimBackground = YES;
        [hud show:YES];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:tempDic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                LocationModel * tempModel = dataArray[tempIndexPath.row];
                NSMutableArray * tempArr = [NSMutableArray arrayWithArray:tempModel.comments];
                [tempArr removeObjectAtIndex:tempIndex];
                tempModel.comments = tempArr;
                [dataArray replaceObjectAtIndex:tempIndexPath.row withObject:tempModel];
                [self.tableview reloadRowsAtIndexPaths:@[tempIndexPath] withRowAnimation:NO];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
            [hud removeFromSuperview];
//            self.hpTextView.text = @"";
//            self.markID = @"";
//            self.locationID = @"";
        } andFailureBlock:^{
            [hud removeFromSuperview];
//            self.hpTextView.text = @"";
//            self.markID = @"";
//            self.locationID = @"";
        }];
    }
}

#pragma mark 点击赞的名字进入个人中心
- (void)tapZanName:(LocationCell *)locationCell index:(NSInteger)index
{
    [self.hpTextView resignFirstResponder];
//    self.hpTextView.text = @"";
//    self.markID = @"";
//    self.locationID = @"";
    LocationModel * locationModel = dataArray[locationCell.moreBtn.indexpath.row];
    NSDictionary * likesDic = locationModel.likes[index];
    PersonalViewController * personVC = [[PersonalViewController alloc]init];
    personVC.account = [likesDic objectForKey:@"account"] ;
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark 弹出输入框或者删除自己的评论
-(void)tapComment:(LocationCell *)locationCell index:(NSInteger)index withTap:(UITapGestureRecognizer *)tap
{
    
    [self.hpTextView resignFirstResponder];
    //self.hpTextView.text = @"";
    

    LocationModel * locationModel = dataArray[locationCell.moreBtn.indexpath.row];
    tempIndexPath = locationCell.moreBtn.indexpath;
    tempIndex = index;
    NSArray * commentsArr = locationModel.comments;
    NSDictionary * commentsDic = commentsArr[index];
    
    if (![self.markID isEqualToString:[commentsDic objectForKey:@"comment_id"]]) {
        self.hpTextView.text = @"";
    }
//    self.markID = @"";
//    self.locationID = @"";
    
    self.locationID = locationModel.ID;
    NSDictionary * fromUserDic = [commentsDic objectForKey:@"fromuser"];
    self.markID = [commentsDic objectForKey:@"comment_id"];
    tempHpTextView = self.hpTextView;
    if ([[fromUserDic objectForKey:@"account"] isEqualToString:ACCOUNT_SELF]) {
        [actionSheets removeFromSuperview];
        actionSheets = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [actionSheets showInView:[UIApplication sharedApplication].keyWindow];
        actionSheets.tag = 2200;
    }else{
        self.hpTextView.placeholder = [NSString stringWithFormat:@"回复：%@",[fromUserDic objectForKey:@"nickname"]];
        tapPoint = [tap locationInView:self.view];
        tempHpTextView = self.hpTextView;
        [self.hpTextView becomeFirstResponder];
    }
}

#pragma mark 点击名字进入个人主页
- (void)tapName1:(LocationCell *)locationCell index:(NSInteger)index
{
    Singleton * singleton = [Singleton sharedInstance];
    if (singleton.isScrolling == NO) {
        [self.hpTextView resignFirstResponder];
//        self.hpTextView.text = @"";
//        self.markID = @"";
//        self.locationID = @"";
        LocationModel * locationModel = dataArray[locationCell.moreBtn.indexpath.row];
        NSArray * commentsArr = locationModel.comments;
        NSDictionary * fromUserDic = commentsArr[index];
        PersonalViewController * personVC = [[PersonalViewController alloc]init];
        personVC.account = [[fromUserDic objectForKey:@"fromuser"] objectForKey:@"account"];
        personVC.myRun = @"2";
        [self.navigationController pushViewController:personVC animated:YES];
    }
    
}

- (void)tapName2:(LocationCell *)locationCell index:(NSInteger)index
{
    Singleton * singleton = [Singleton sharedInstance];
    if (singleton.isScrolling == NO) {
        [self.hpTextView resignFirstResponder];
//        self.hpTextView.text = @"";
//        self.markID = @"";
//        self.locationID = @"";
        LocationModel * locationModel = dataArray[locationCell.moreBtn.indexpath.row];
        NSArray * commentsArr = locationModel.comments;
        NSDictionary * fromUserDic = commentsArr[index];
        PersonalViewController * personVC = [[PersonalViewController alloc]init];
        personVC.account = [[fromUserDic objectForKey:@"touser"] objectForKey:@"account"];
        personVC.myRun = @"2";
        [self.navigationController pushViewController:personVC animated:YES];
    }
}

#pragma mark 提交评论
- (void)submitComment:(UIButton *)sender
{
    if (self.markID == nil) {
        self.markID = @"";
    }
    
    NSString * commentStr = [self.hpTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (commentStr.length == 0 || commentStr == nil) {
        [AutoDismissAlert autoDismissAlert:@"请填写评论内容"];
        return;
    }
    [self.hpTextView resignFirstResponder];
    NSDictionary * tempdic = [self parametersForDic:@"accountCommentLocation" parameters:@{ACCOUNT_PASSWORD,@"content":commentStr,@"id":self.locationID,@"markId":self.markID}];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"处理中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            LocationModel * locationModel = [dataArray objectAtIndex:tempIndexPath.row];
            NSMutableArray * tempArr = [NSMutableArray arrayWithArray:locationModel.comments];
            NSDictionary * tempdic = [dic objectForKey:@"data"];
            [tempArr addObject:tempdic];
            locationModel.comments = tempArr;
            [dataArray replaceObjectAtIndex:tempIndexPath.row withObject:locationModel];
            [self.tableview reloadRowsAtIndexPaths:@[tempIndexPath] withRowAnimation:NO];
            //[self urlRequestPost];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [hud removeFromSuperview];
        self.hpTextView.text = @"";
        self.markID = @"";
        self.locationID = @"";
    } andFailureBlock:^{
        [hud removeFromSuperview];
        self.hpTextView.text = @"";
        self.markID = @"";
        self.locationID = @"";
    }];
}

#pragma mark 弹出评论输入框
- (void)makeCommentTap:(UITapGestureRecognizer *)tap
{
    tempHpTextView = self.hpTextView;
    
//    self.hpTextView.text = @"";
//    self.locationID = @"";
    if (self.markID != nil && ![self.markID isEqualToString:@""]) {
        self.hpTextView.text = @"";
    }
    self.markID = @"";
    
    tempIndex = 2000;
    MyView * commentBGView = (MyView *)tap.view;
    LocationModel * locationModel = dataArray[commentBGView.indexpath.row];
    self.hpTextView.placeholder = @"我来说一句";
    if (![self.locationID isEqualToString:locationModel.ID]) {
        self.hpTextView.text = @"";
    }
    tempIndexPath = commentBGView.indexpath;
    self.locationID = locationModel.ID;
    tapPoint = [tap locationInView:self.view];
    tempHpTextView = self.hpTextView;
    [self.hpTextView becomeFirstResponder];
}

#pragma mark 键盘弹出与收回的通知
- (void)keyboardWasShown:(NSNotification *)notification
{
    if (switchKeyBoard == YES) return;
    
    //        submitBtn.enabled = NO;
    //        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_gray"] forState:UIControlStateNormal];
    //
    if (tempHpTextView == self.hpTextView) {
    isKeyboardHidden = NO;
    NSDictionary * userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    // 根据老的 frame 设定新的 frame
    CGRect newTextViewFrame = commentTextBGView.frame; // by michael
    newTextViewFrame.origin.y = keyboardRect.origin.y - commentTextBGView.frame.size.height;
    
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    commentTextBGView.frame = newTextViewFrame;
    if (tapPoint.y > commentTextBGView.frame.origin.y - 14) {
        CGRect tableRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 39);
        tableRect.origin.y -= tapPoint.y - commentTextBGView.frame.origin.y + 14;
        self.tableview.frame = tableRect;
    }
    
    // commit animations
    [UIView commitAnimations];
    }
}
- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    if (switchKeyBoard == YES) return;
    
    if (tempHpTextView == self.hpTextView) {
    isKeyboardHidden = YES;
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = commentTextBGView.frame;
    containerFrame.origin.y = SCREEN_HEIGHT - commentTextBGView.frame.size.height;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    commentTextBGView.frame = containerFrame;
    self.tableview.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49 - 39);
    // commit animations
    [UIView commitAnimations];
    }
}

#pragma mark growingTextView 代理
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = commentTextBGView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    commentTextBGView.frame = r;
    
    //[UIView beginAnimations:nil context:NULL];
    //[UIView setAnimationBeginsFromCurrentState:YES];
    //[UIView setAnimationDuration:0.1];
    if (isKeyboardHidden == NO) {
        CGRect tableRect = self.tableview.frame;
        tableRect.origin.y += diff;
        self.tableview.frame = tableRect;
    }
    //[UIView commitAnimations];
    submitBtn.frame = CGRectMake(CGRectGetMaxX(self.hpTextView.frame) + 15, commentTextBGView.frame.size.height - 7 - 25, 60, 25);
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length == 0 ) {
        //self.placeHolderLabel.hidden = NO;
        submitBtn.enabled = NO;
        [submitBtn setBackgroundImage:[self imageWithColor:[GetColor16 hexStringToColor:@"#959595"] size:submitBtn.frame.size] forState:UIControlStateNormal];
//        [submitBtn setBackgroundImage:[self imageWithColor:[GetColor16 hexStringToColor:@"#959595"] size:submitBtn.frame.size] forState:UIControlStateNormal];
    }else{
        //self.placeHolderLabel.hidden = YES;
        submitBtn.enabled = YES;
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    BOOL bChange =YES;
    const char * ch=[text cStringUsingEncoding:NSUTF8StringEncoding];
    
    if (*ch == 35 || *ch == 38) {
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        if (growingTextView.text.length != 0) {
            [self submitComment:nil];
        }
        bChange = NO;
    }
    return bChange;
}

#pragma mark 进入地址页面
- (void)addressTap:(UITapGestureRecognizer *)tap
{
    MyLabel * tempLabel = (MyLabel *)tap.view;
    LocationModel * locationModel = dataArray[tempLabel.indexpath.row];
    MapViewController *mapVC = [[MapViewController alloc] init];
    
    if (![locationModel.xyz isEqualToString:@"0"] && ![locationModel.xyz isEqualToString:@""] && locationModel.xyz != nil) {
        NSArray *locationArr = [locationModel.xyz componentsSeparatedByString:@","];
        mapVC.lat = [[locationArr objectAtIndex:0] doubleValue];
        mapVC.lon = [[locationArr objectAtIndex:1]doubleValue];
        mapVC.address = locationModel.title;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

#pragma mark 删除自己的足迹
- (void)delLocation:(ZZGoPayBtn *)sender
{
    indexpath = sender.indexpath;
    UIAlertView *delLocationAlert = [[UIAlertView alloc] initWithTitle:@"确定删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [delLocationAlert show];
}

#pragma mark UIAlertView 代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;{
    if (buttonIndex == 1) {
        LocationModel * locationModel = dataArray[indexpath.row];
        huds = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        huds.labelText = @"处理中,请稍后";
        huds.dimBackground = YES;
        [huds show:YES];
        NSDictionary * tempdic = [self parametersForDic:@"accountDeletePosition" parameters:@{ACCOUNT_PASSWORD,@"id":locationModel.ID}];
        [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [dataArray removeObjectAtIndex:indexpath.row];
//                [self.tableview deleteRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self urlRequestPost];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
                [huds removeFromSuperview];
            }
        } andFailureBlock:^{
            [huds removeFromSuperview];
        }];
        
    }
}

#pragma mark 隐藏赞和分享button
- (void)hiddenBtn
{
    NSArray * temparr = [self.tableview visibleCells];
    for (LocationCell * tempCell in temparr) {
//        CGRect rect = tempCell.twoButtonView.frame;
//        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
//        rect.size.width = 0;
//        tempCell.twoButtonView.frame = rect;
        tempCell.twoButtonView.hidden = YES;
        tempCell.locationModel.isClick = NO;
    }
}

- (void)hiddenTap:(UITapGestureRecognizer *)tap
{
    [self.hpTextView resignFirstResponder];
    //self.hpTextView.text = @"";
    NSArray * temparr = [self.tableview visibleCells];
    for (LocationCell * tempCell in temparr) {
        CGRect rect = tempCell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
        rect.size.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            tempCell.twoButtonView.frame = rect;
        } completion:^(BOOL finished) {
            tempCell.twoButtonView.hidden = YES;
        }];
        tempCell.locationModel.isClick = NO;
    }
}

#pragma mark 显示赞和分享按钮
- (void)showMoreView:(ZZGoPayBtn *)sender
{
    [self.hpTextView resignFirstResponder];
    //self.hpTextView.text = @"";
    LocationCell * cell = (LocationCell *)[self.tableview cellForRowAtIndexPath:sender.indexpath];
    cell.locationModel.isClick = !cell.locationModel.isClick;
    NSArray * temparr = [self.tableview visibleCells];
    for (int i = 0 ; i < temparr.count; i++) {
        LocationCell * tempCell = temparr[i];
        if (![tempCell isEqual:cell]) {
            tempCell.locationModel.isClick = NO;
            CGRect rect = tempCell.twoButtonView.frame;
            rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
            rect.size.width = 0;
            [UIView animateWithDuration:0.2 animations:^{
                tempCell.twoButtonView.frame = rect;
            } completion:^(BOOL finished) {
                tempCell.twoButtonView.hidden = YES;
            }];
        }
    }
    
    if (cell.locationModel.isClick) {
        CGRect rect = cell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10 - 150;
        rect.size.width = 151;
        [UIView animateWithDuration:0.2 animations:^{
            cell.twoButtonView.hidden = NO;
            cell.twoButtonView.frame = rect;
        }];
        
    }else{
        CGRect rect = cell.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
        rect.size.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            cell.twoButtonView.frame = rect;
        } completion:^(BOOL finished) {
            cell.twoButtonView.hidden = YES;
        }];
    }
}

#pragma mark 点击进入个人中心
- (void)tapToLPersonal:(UITapGestureRecognizer *)tap
{
    [self.hpTextView resignFirstResponder];
    //self.hpTextView.text = @"";
    MyImgView * tempImgView = (MyImgView *)tap.view;
    LocationModel * locationModel = dataArray[tempImgView.indexpath.row];
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    personalVC.hidesBottomBarWhenPushed = YES;
    personalVC.account = locationModel.account;
    personalVC.nickname = locationModel.nickname;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)viewreloadData
{
    [self.tableview reloadData];
}

#pragma mark - 点赞或取消
- (void)zanBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    LocationCell * cell = (LocationCell *)[self.tableview cellForRowAtIndexPath:sender.indexpath];
    NSDictionary * dic;
    if ([locationModel.isLike isEqualToString:@"0"]) {
        dic = [self parametersForDic:@"accountLikeLocation" parameters:@{@"id":locationModel.ID,ACCOUNT_PASSWORD}];
    }else{
        dic = [self parametersForDic:@"accountDeleteLikedLocation" parameters:@{@"id":locationModel.ID,ACCOUNT_PASSWORD}];
    }
    
//    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.labelText = @"处理中,请稍后";
//    hud.dimBackground = YES;
//    [hud show:YES];
    [cell hideTwoButtonView];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            
            LocationModel * tempModel = [dataArray objectAtIndex:sender.indexpath.row];
            NSMutableArray * temparr = [NSMutableArray arrayWithArray:tempModel.likes];
            locationModel.isClick = NO;
            
            if ([tempModel.isLike isEqualToString:@"0"]) {
                [cell showAlertLabel];
                tempModel.isLike = @"1";
                [temparr insertObject:[dic objectForKey:@"data"] atIndex:0];
                [dataArray replaceObjectAtIndex:sender.indexpath.row withObject:tempModel];
            }else{
                tempModel.isLike = @"0";
                [temparr enumerateObjectsUsingBlock:^(NSDictionary * arrDic, NSUInteger idx, BOOL *stop) {
                    if ([[arrDic objectForKey:@"account"] isEqualToString:[[dic objectForKey:@"data"] objectForKey:@"account"]]) {
                        [temparr removeObject:arrDic];
                        *stop = YES;
                    }
                }];
                [dataArray replaceObjectAtIndex:sender.indexpath.row withObject:tempModel];
            }
            tempModel.likes = temparr;
            
            [self.tableview reloadRowsAtIndexPaths:@[sender.indexpath] withRowAnimation:NO];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        //[hud removeFromSuperview];
    } andFailureBlock:^{
        //[hud removeFromSuperview];
    }];
}

#pragma mark - 分享
- (void)shareBtn:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel * locationModel = dataArray[sender.indexpath.row];
    NSString *content = [NSString stringWithFormat:@"%@ %@",locationModel.content, locationModel.shortUrl];
    //NSString *content = [NSString stringWithFormat:@"%@",_model.content];
    if (content.length > 140) {
        content = [content substringToIndex:140];
    }
    tempHpTextView = nil;
    [ShareViewController shareToThirdPlatformWithUIViewController:self Title:locationModel.title SecondTitle:[self.userInfoDic objectForKey:@"note"] Content:content ImageUrl:locationModel.url SencondImgUrl:[self.userInfoDic objectForKey:@"photo"] Btn:sender ShareUrl:nil];
}

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType;
{
    viewController.navigationController.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"#e5005d"];
}

//#pragma mark - 网络请求
//- (void)urlRequestPost
//{
//    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationList" parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"start":@"0",@"count":[NSString stringWithFormat:@"%d",count]}];
//    
//    __block UITableView *temTableView = self.tableview;
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        [dataArray removeAllObjects];
//        if ([result isEqualToString:@"0"]) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                LocationModel * locationModel = [[LocationModel alloc]init];
//                [locationModel setValuesForKeysWithDictionary:tempdic];
//                locationModel.zanCount = locationModel.likeCount;
//                [dataArray addObject:locationModel];
//            }
//            noData.hidden = YES;
//        }else if([result isEqualToString:@"4"]){
//            noData.hidden = NO;
//            toTopBtn.hidden = YES;
//        }else{
//            noData.hidden = NO;
//            toTopBtn.hidden = YES;
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//        [temTableView reloadData];
//        page = 0;
//        [temTableView headerEndRefreshing];
//    } andFailureBlock:^{
//        page = 0;
//        toTopBtn.hidden = YES;
//        [dataArray removeAllObjects];
//        [temTableView reloadData];
//        [temTableView headerEndRefreshing];
//        noData.hidden = NO;
//    }];
//}
//#pragma mark - 网络请求
- (void)shareRequest:(LeftImgAndRightTitleBtn *)sender
{
    LocationModel *locationModel;
    NSDictionary * dic = [self parametersForDic:@"getShortUrl" parameters:@{ACCOUNT_PASSWORD,@"url":locationModel.shareUrl}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString *result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [locationModel setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
            [self shareBtn:sender];
            
        }else if([result isEqualToString:@"4"]){
            NSLog(@"%@", result);
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }else{
            
        }
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

//#pragma mark - 加载更多
//- (void)footerRefresh
//{
//    page += NumOfItemsForZuji;
//    NSDictionary * dic = [self parametersForDic:@"getDynamicLocationList"
//        parameters:@{ACCOUNT_PASSWORD,@"type":@"0",@"start":[NSString stringWithFormat:@"%d",page],@"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
//    
//    __block UITableView *temTableView = self.tableview;
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            for (int i = 0; i < temparrs.count; i++) {
//                NSDictionary * tempdic = [temparrs objectAtIndex:i];
//                LocationModel * locationModel = [[LocationModel alloc]init];
//                [locationModel setValuesForKeysWithDictionary:tempdic];
//                [dataArray addObject:locationModel];
//                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
//                    [dataArray removeLastObject];
//                    page -= NumOfItemsForZuji;
//                    break;
//                }
//            }
//            [temTableView reloadData];
//            noData.hidden = YES;
//        }else if([result isEqualToString:@"4"]){
//            page -= NumOfItemsForZuji;
//        }else{
//            page -= NumOfItemsForZuji;
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//        [temTableView footerEndRefreshing];
//    } andFailureBlock:^{
//        page -= NumOfItemsForZuji;
//        [temTableView footerEndRefreshing];
//    }];
//}
//获取分享logo及信息
- (void)getSahreInfo
{
    NSDictionary * shareParam = @{@"method":@"getShareInfo",@"parameters":@{@"account":ACCOUNT_SELF, @"password":PASSWORD_SELF,@"type":@"1"}};
    [URLRequest postRequestssWith:iOS_POST_URL parameters:shareParam andblock:^(NSDictionary *dic) {
        self.userInfoDic = [dic objectForKey:@"data"];
    } andFailureBlock:^{
        NSLog(@"totalDataDic == %@",self.userInfoDic);
    }];
}


@end
