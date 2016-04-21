//
//  SaytoCommentViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/4/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SaytoCommentViewController.h"
#import <UIImageView+WebCache.h>
#import "ImgScrollView.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WeiboApi.h"

#import "ShareViewController.h"
@interface SaytoCommentViewController ()<HPGrowingTextViewDelegate,TapImageViewDelegate,ImgScrollViewDelegate,ISSShareViewDelegate,UIActionSheetDelegate,UIScrollViewDelegate>

@end

@implementation SaytoCommentViewController
{
    UIScrollView * myScrollView;
    LocationModel * tempLocationModel;
    UIView * detailCommentView;
    UIButton * submitBtn;
    CGPoint tapPoint;
    BOOL isKeyboardHidden;
    BOOL isCommentTextView;
    BOOL isClick;
    UIActionSheet * actionSheets;
    int currentIndex;
    UIView * markView;
    UIView * scrollPanel;
    UIButton * downBtn;
    NSMutableArray * imgArr;
    int imgPage;
    int totalImgPage;
    UIScrollView * imgScrollView;
    NoDataView * imageview;
    BOOL isBack;
    NSInteger tempIndex;
    UIButton * clickBtn;
}

- (void)viewWillAppear:(BOOL)animated
{
    AppDelegate *app = APPDELEGATE;
    app.customTab.hidden = YES;
    app.mainTab.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hidden) name:UIMenuControllerDidHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)hidden
{
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
}

- (void)dealloc
{
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIMenuControllerDidHideMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
    [self customInit];
//    self.userInfoDic = [NSDictionary dictionary];
//    [self getSahreInfo];
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)hiddenTap:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

- (void)customInit
{
    imgArr = [NSMutableArray array];
    imgPage = 0;
    totalImgPage = 0;
    isClick = NO;
    self.title = @"回复咨询";
    
    imageview = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageview.hidden = YES;
    [self.view addSubview:imageview];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    myScrollView.delegate = self;
    myScrollView.delaysContentTouches = NO;
    [self.view addSubview:myScrollView];
    
    UITapGestureRecognizer * hiddenTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTap:)];
    [myScrollView addGestureRecognizer:hiddenTap];
    
    UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    self.logoImg = logoImg;
    logoImg.layer.masksToBounds = YES;
    logoImg.layer.cornerRadius = 20;
    logoImg.userInteractionEnabled = YES;
    logoImg.contentMode = UIViewContentModeScaleAspectFill;
    logoImg.clipsToBounds = YES;
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLPersonal:)];
    [logoImg addGestureRecognizer:logoTap];
    [myScrollView addSubview:logoImg];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 8, 12, 200, 20)];
    nameLabel.font = SIZE_FOR_IPHONE;
    nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.nameLabel = nameLabel;
    [myScrollView addSubview:nameLabel];
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 100, nameLabel.frame.origin.y, 100, 12)];
    timeLabel.font = SIZE_FOR_12;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.timeLabel = timeLabel;
    [myScrollView addSubview:timeLabel];
    
    CopyLabel * descriptionLabel = [[CopyLabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 8, nameLabel.frame.size.height + nameLabel.frame.origin.y + 8, SCREEN_WIDTH - 15 - 15 - 40 - 8, 26)];
    descriptionLabel.layer.borderColor = [GetColor16 hexStringToColor:@"#ffffff"].CGColor;
    descriptionLabel.userInteractionEnabled = YES;
    descriptionLabel.font = SIZE_FOR_14;
    descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.descriptionLabel = descriptionLabel;
    [myScrollView addSubview:descriptionLabel];
    
    
    detailCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 40 - 64, SCREEN_WIDTH, 40)];
    detailCommentView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    
    
    HPGrowingTextView * hpTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30 - 60 - 15, 30)];
    self.hpTextView = hpTextView;
    hpTextView.contentInset = UIEdgeInsetsMake(0, 4, 0, 5);
    hpTextView.isScrollable = NO;
    hpTextView.layer.borderColor = [UIColor clearColor].CGColor;
    hpTextView.delegate = self;
    hpTextView.minNumberOfLines = 1;
    hpTextView.maxNumberOfLines = 4;
    hpTextView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    hpTextView.textColor = [GetColor16 hexStringToColor:@"#434343"];
    hpTextView.layer.cornerRadius = 2;
    hpTextView.layer.masksToBounds = YES;
    hpTextView.returnKeyType = UIReturnKeySend;
    hpTextView.font = SIZE_FOR_IPHONE;
    hpTextView.placeholder = @"我来说一句";
    [detailCommentView addSubview:hpTextView];
    
    clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.backgroundColor = [UIColor clearColor];
    clickBtn.frame = hpTextView.frame;
    [clickBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    clickBtn.hidden = NO;
    [detailCommentView addSubview:clickBtn];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(self.hpTextView.frame.size.width + self.hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 60, 25);
    submitBtn.layer.cornerRadius = 2;
    submitBtn.layer.masksToBounds = YES;
    
    [submitBtn addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [submitBtn setTitle:@"发 送" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[self imageWithColor:[GetColor16 hexStringToColor:@"#959595"] size:submitBtn.frame.size] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    submitBtn.enabled = NO;
    [detailCommentView addSubview:submitBtn];
    //    commentTextBGView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [self urlRequestPost];
}

#pragma mark ----------==========----------==========----------==========----------==========

#pragma mark -
#pragma mark - custom method
- (void) addSubImgView:(NSIndexPath *)myIndexPath
{
    for (UIView *tmpView in imgScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    
    NSArray * photosArr = [tempLocationModel.photos componentsSeparatedByString:@","];
    
    NSMutableArray * tempArr = [NSMutableArray array];
    for (int i = 0; i < photosArr.count; i++) {
        [tempArr addObject:[photosArr[i] stringByReplacingOccurrencesOfString:@"_sm" withString:@""]];
    }
    
    totalImgPage = (int)tempArr.count;
    self.pageLabel.text = [NSString stringWithFormat:@"%.0f/%d",imgScrollView.contentOffset.x/SCREEN_WIDTH+1,totalImgPage];
    
    imgScrollView.contentSize = CGSizeMake(tempArr.count * (SCREEN_WIDTH + 20), SCREEN_HEIGHT);
    
    
    for (int i = 0; i < tempArr.count; i ++)
    {
        //        if (i == currentIndex)
        //        {
        //            continue;
        //        }
        [imgArr removeAllObjects];
        TapImageView * tmpView;
        if (tempArr.count == 1) {
            tmpView = (TapImageView *)[self.view viewWithTag:601];
        }else{
            tmpView = (TapImageView *)[self.view viewWithTag:501 + i];
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
            [imgArr addObject:image];
            [tempActivitys stopAnimating];
            [tempActivitys removeFromSuperview];
            
            [tmpImgScrollView setImage:image];
            if (i == currentIndex) {
                [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
            }else{
                [tmpImgScrollView setAnimationRect];
            }
        }];
        
        [imgScrollView addSubview:tmpImgScrollView];
        
        
        tmpImgScrollView.i_delegate = self;
        
        if (i == currentIndex) {
            [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
        }else{
            [tmpImgScrollView setAnimationRect];
        }
    }
}

- (void)saveImageToPhotos{
    
    if (imgArr.count != 0) {
        if (currentIndex > imgArr.count) {
            UIImageWriteToSavedPhotosAlbum([imgArr objectAtIndex:imgArr.count - 1], nil, nil, nil);
        }else{
            UIImageWriteToSavedPhotosAlbum([imgArr objectAtIndex:currentIndex], nil, nil, nil);
        }
        [AutoDismissAlert autoDismissAlert:@"保存成功"];
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
    [self.view bringSubviewToFront:scrollPanel];
    
    
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
    
    currentIndex = (int)tmpView.tag - 501;
    
    if (currentIndex == 100) {
        currentIndex = 0;
    }
    CGPoint contentOffset = imgScrollView.contentOffset;
    contentOffset.x = currentIndex* (SCREEN_WIDTH + 20);
    imgScrollView.contentOffset = contentOffset;
    
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
        for (UIView *tmpView in imgScrollView.subviews)
        {
            [tmpView removeFromSuperview];
        }
    }];
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == imgScrollView) {
        for (UIScrollView * s in imgScrollView.subviews) {
            if ([s isKindOfClass:[UIScrollView class]]) {
                if (imgPage != myScrollView.contentOffset.x / SCREEN_WIDTH + 1) {
                    [s setZoomScale:1.0];
                }
            }
        }
        
        CGFloat pageWidth = scrollView.frame.size.width;
        currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        
        imgPage = imgScrollView.contentOffset.x/SCREEN_WIDTH+1;
        self.pageLabel.text = [NSString stringWithFormat:@"%.0f/%d",imgScrollView.contentOffset.x/SCREEN_WIDTH+1,totalImgPage];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == myScrollView) {
        [self.view endEditing:YES];
        self.hpTextView.text = @"";
        self.markID = @"";
    }
}

#pragma mark ----------==========----------==========----------==========----------==========

#pragma mark 显示评论和赞的按钮
- (void)showMoreView:(ZZGoPayBtn *)sender
{
    [self.hpTextView resignFirstResponder];
    self.hpTextView.text = @"";
    
    if (isClick == NO) {
        CGRect rect = self.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10 - 150;
        rect.size.width = 151;
        [UIView animateWithDuration:0.2 animations:^{
            self.twoButtonView.hidden = NO;
            self.twoButtonView.frame = rect;
        }];
    }else{
        CGRect rect = self.twoButtonView.frame;
        rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
        rect.size.width = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.twoButtonView.frame = rect;
        } completion:^(BOOL finished) {
            self.twoButtonView.hidden = YES;
        }];
    }
    isClick = !isClick;
}

#pragma mark - 点赞
- (void)zanBtn:(LeftImgAndRightTitleBtn *)sender
{
    NSDictionary * dic = [self parametersForDic:@"accountLikeLocation" parameters:@{@"id":tempLocationModel.ID,ACCOUNT_PASSWORD}];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"处理中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [self showAlertLabel];
            NSMutableArray * temparr = [NSMutableArray arrayWithArray:tempLocationModel.likes];
            [temparr addObject:[dic objectForKey:@"data"]];
            tempLocationModel.likes = temparr;
            [self makeDataToControls];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [hud removeFromSuperview];
    } andFailureBlock:^{
        [hud removeFromSuperview];
    }];
    
}

#pragma mark - 分享
- (void)shareBtn:(LeftImgAndRightTitleBtn *)sender
{
    isCommentTextView = YES;
    
    [ShareViewController shareToThirdPlatformWithUIViewController:self Title:tempLocationModel.title SecondTitle:[self.userInfoDic objectForKey:@"note"] Content:tempLocationModel.content ImageUrl:tempLocationModel.url SencondImgUrl:[self.userInfoDic objectForKey:@"photo"] Btn:sender ShareUrl:nil];
}

- (void)tapComment:(UITapGestureRecognizer *)tap
{
    [self.hpTextView resignFirstResponder];
    self.hpTextView.text = @"";
    self.markID = @"";
    LocationMyLabel * tempLabel = (LocationMyLabel *)tap.view;
    
    tempIndex = tap.view.tag - 8000;
    NSArray * commentsArr = tempLocationModel.comments;
    NSDictionary * commentsDic = commentsArr[tempLabel.tag - 8000];
    NSDictionary * fromUserDic = [commentsDic objectForKey:@"fromuser"];
    self.markID = [commentsDic objectForKey:@"comment_id"];
    
    if ([[fromUserDic objectForKey:@"account"] isEqualToString:ACCOUNT_SELF]) {
        [actionSheets removeFromSuperview];
        actionSheets = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles: nil];
        [actionSheets showInView:[UIApplication sharedApplication].keyWindow];
        actionSheets.tag = 2200;
    }else{
        self.hpTextView.placeholder = [NSString stringWithFormat:@"回复：%@",[fromUserDic objectForKey:@"nickname"]];
        tapPoint = [tap locationInView:self.view];
        isCommentTextView = NO;
        [self.hpTextView becomeFirstResponder];
    }
}

#pragma mark actionsheet代理
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
                NSMutableArray * temparr = [NSMutableArray arrayWithArray:tempLocationModel.comments];
                [temparr removeObjectAtIndex:tempIndex];
                tempLocationModel.comments = temparr;
                [self makeDataToControls];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
            [hud removeFromSuperview];
            self.hpTextView.text = @"";
        } andFailureBlock:^{
            self.hpTextView.text = @"";
            [hud removeFromSuperview];
        }];
    }
    
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView
{
    clickBtn.hidden = YES;
}

- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView
{
    clickBtn.hidden = NO;
}

- (void)clickBtn:(UIButton *)sender
{
    [self.hpTextView becomeFirstResponder];
    isCommentTextView = NO;
    self.hpTextView.text = @"";
    self.markID = @"";
    self.hpTextView.placeholder = @"我来说一句";
    
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL bChange =YES;
    if ([text isEqualToString:@"\n"]) {//检测到“完成”
        if (growingTextView.text.length != 0) {
            [self submitComment:nil];
        }
        bChange = NO;
    }
    return bChange;
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView
{
    if (growingTextView.text.length == 0 ) {
        //self.placeHolderLabel.hidden = NO;
        submitBtn.enabled = NO;
        [submitBtn setBackgroundImage:[self imageWithColor:[GetColor16 hexStringToColor:@"#959595"] size:submitBtn.frame.size] forState:UIControlStateNormal];
    }else{
        //self.placeHolderLabel.hidden = YES;
        submitBtn.enabled = YES;
        [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_red"] forState:UIControlStateNormal];
    }
}

#pragma mark 提交评论
- (void)submitComment:(UIButton *)sender
{
    if (self.markID == nil) {
        self.markID = @"";
    }
    [self.hpTextView resignFirstResponder];
    NSDictionary * tempdic = [self parametersForDic:@"accountCommentLocation" parameters:@{ACCOUNT_PASSWORD,@"content":self.hpTextView.text,@"id":self.locationID,@"markId":self.markID}];
    MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"处理中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:tempdic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSMutableArray * tempArr = [NSMutableArray arrayWithArray:tempLocationModel.comments];
            NSDictionary * tempdic = [dic objectForKey:@"data"];
            [tempArr addObject:tempdic];
            tempLocationModel.comments = tempArr;
            [self makeDataToControls];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [hud removeFromSuperview];
        self.hpTextView.text = @"";
        self.markID = @"";
    } andFailureBlock:^{
        [hud removeFromSuperview];
        self.hpTextView.text = @"";
        self.markID = @"";
    }];
}

#pragma mark 键盘弹出与收回的监听
- (void)keyboardWasShown:(NSNotification *)notification
{
    if (isCommentTextView == NO) {
        isKeyboardHidden = NO;
        NSDictionary * userInfo = [notification userInfo];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        
        CGRect keyboardRect = [aValue CGRectValue];
        keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
        
        // 根据老的 frame 设定新的 frame
        CGRect newTextViewFrame = detailCommentView.frame; // by michael
        newTextViewFrame.origin.y = keyboardRect.origin.y - detailCommentView.frame.size.height;
        
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        detailCommentView.frame = newTextViewFrame;
        if (tapPoint.y > detailCommentView.frame.origin.y - 14) {
            CGRect viewRect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
            viewRect.origin.y -= tapPoint.y - detailCommentView.frame.origin.y + 14;
            myScrollView.frame = viewRect;
        }
        
        // commit animations
        [UIView commitAnimations];
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    if (isCommentTextView == NO) {
        isKeyboardHidden = YES;
        NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
        NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
        
        // get a rect for the textView frame
        CGRect containerFrame = detailCommentView.frame;
        containerFrame.origin.y = SCREEN_HEIGHT - detailCommentView.frame.size.height - 64;
        
        // animations settings
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [UIView setAnimationDuration:[duration doubleValue]];
        [UIView setAnimationCurve:[curve intValue]];
        
        // set views with new info
        detailCommentView.frame = containerFrame;
        myScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        // commit animations
        [UIView commitAnimations];
    }
}

#pragma mark growingTextView 代理
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = detailCommentView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    detailCommentView.frame = r;
    
    if (isKeyboardHidden == NO) {
        CGRect viewRect = myScrollView.frame;
        viewRect.origin.y += diff;
        myScrollView.frame = viewRect;
    }
    
    submitBtn.frame = CGRectMake(self.hpTextView.frame.size.width + self.hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 60, 25);
}

#pragma mark 点击进入个人中心
//点击进入个人中心
- (void)tapToLPersonal:(UITapGestureRecognizer *)tap
{
    [self.hpTextView resignFirstResponder];
    self.hpTextView.text = @"";
    SubViewController *personalVC = [[SubViewController alloc] init];
    personalVC.account = tempLocationModel.account;
    personalVC.nickname = tempLocationModel.nickname;
    personalVC.myRun = @"2";
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark 点击进入地图
//地图
- (void)addressTap:(UITapGestureRecognizer *)tap
{
    MapViewController *mapVC = [[MapViewController alloc] init];
    
    if (![tempLocationModel.xyz isEqualToString:@"0"] && ![tempLocationModel.xyz isEqualToString:@""] && tempLocationModel.xyz != nil) {
        NSArray *locationArr = [tempLocationModel.xyz componentsSeparatedByString:@","];
        mapVC.lat = [[locationArr objectAtIndex:0] doubleValue];
        mapVC.lon = [[locationArr objectAtIndex:1]doubleValue];
        mapVC.address = tempLocationModel.title;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
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

- (void)tapToPersonInfo:(UITapGestureRecognizer *)tap
{
    MyImgView * tempImg = (MyImgView *)tap.view;
    NSDictionary * tempDic = tempLocationModel.likes[tempImg.tag - 1000];
    SubViewController * personalVC = [[SubViewController alloc]init];
    personalVC.account = [tempDic objectForKey:@"account"];
    personalVC.myRun = @"2";
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark 创建赞的头像=================
- (int)createZanPersonLogo
{
    int j = 0;
    int tempWidth = 0;
    NSArray * likesArr = tempLocationModel.likes;
    for (UIView * view in self.tempViewForZanPerson.subviews) {
        [view removeFromSuperview];
    }
    if (likesArr != nil && likesArr.count != 0) {
        self.tempViewForZanPerson.hidden = NO;
        for (int i = 0; i < likesArr.count; i++) {
            @autoreleasepool {
                MyImgView * logoImg = [[MyImgView alloc]initWithFrame:CGRectMake(15, 5, 30, 30)];
                logoImg.userInteractionEnabled = YES;
                logoImg.layer.cornerRadius = 15;
                logoImg.layer.masksToBounds = YES;
                logoImg.tag = 1000 + i;
                logoImg.contentMode = UIViewContentModeScaleAspectFill;
                logoImg.clipsToBounds = YES;
                NSDictionary * tempDic = likesArr[i];
                
                UITapGestureRecognizer * personTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToPersonInfo:)];
                [logoImg addGestureRecognizer:personTap];
                
                [logoImg sd_setImageWithURL:[tempDic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
                if (i == 0) {
                    logoImg.frame = CGRectMake(54, 5 + j * 35, 30, 30);
                    tempWidth += logoImg.frame.size.width + 5 + 54;
                }else{
                    logoImg.frame = CGRectMake(tempWidth, 5 + j * 35, 30, 30);
                    tempWidth += logoImg.frame.size.width + 5;
                }
                
                if ((logoImg.frame.size.width + logoImg.frame.origin.x) > ((SCREEN_WIDTH - 30 - 15))) {
                    j += 1;
                    tempWidth = 0;
                    logoImg.frame = CGRectMake(54, 5 + j * 35, 30, 30);
                    tempWidth += logoImg.frame.size.width + 59;
                }
                [self.tempViewForZanPerson addSubview:logoImg];
            }
        }
        self.tempViewForZanPerson.frame = CGRectMake(0, 0, SCREEN_WIDTH - 78, (j + 1)* 35 + 5);
        self.zanLineView.frame = CGRectMake(0, self.tempViewForZanPerson.frame.size.height + self.tempViewForZanPerson.frame.origin.y, SCREEN_WIDTH - 78, 1);
        UIImageView * imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, (self.tempViewForZanPerson.frame.size.height - 15)/2, 15, 15)];
        imgView.image = [UIImage imageNamed:@"zanPink"];
        [self.tempViewForZanPerson addSubview:imgView];
    }else{
        self.tempViewForZanPerson.hidden = YES;
        self.zanLineView.frame = CGRectMake(0, 0, SCREEN_WIDTH - 78, 0);
    }
    
    return j;
}

#pragma mark 创建评论内容=================
- (float)createComment
{
    float height = 0.0;
    NSArray * commentArr = tempLocationModel.comments;
    for (UIView * view in self.zanNumBgView.subviews) {
        if ([view isKindOfClass:[LocationDetailView class]]) {
            [view removeFromSuperview];
        }
    }
    for (int i = 0; i < commentArr.count; i++) {
        @autoreleasepool {
            NSDictionary * tempDic = commentArr[i];
            LocationDetailView * detailView = [[LocationDetailView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 30, 50)];
            detailView.tag = 5000 + i;
            detailView.contentLabel.tag = 8000 + i;
            [detailView.logoImg sd_setImageWithURL:[[tempDic objectForKey:@"fromuser"] objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            
            UITapGestureRecognizer * commentTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapComment:)];
            [detailView.contentLabel addGestureRecognizer:commentTap];
            
            NSArray * URLs;
            NSArray * URLRanges;
            NSAttributedString * as = [self attributedString:&URLs URLRanges:&URLRanges withDic:tempDic];
            detailView.nameLabel.whatLabel = @"locationLabel";
            detailView.nameLabel.attributedText = as;
            [detailView.nameLabel setURLs:URLs forRanges:URLRanges];
            LocationDetailView * tempView = detailView;
            detailView.nameLabel.URLClickHandler = ^(CXAHyperlinkLabel * label,NSURL * URL,NSRange range,NSArray * textRects){
                if ([[URL absoluteString]isEqualToString:@"a"]) {
                    [self tapName1index:tempView.tag - 5000];
                }
                if ([[URL absoluteString]isEqualToString:@"b"]) {
                    [self tapName2index:tempView.tag - 5000];
                }
            };
            
            
            NSString * timeStr = [CompareCurrentTime compareCurrentTime:[[tempDic objectForKey:@"comment_updatetimeLong"] doubleValue]];
            detailView.timeLabel.text = timeStr;
            
            detailView.timeLabel.frame = CGRectMake(detailView.frame.size.width - 15 - 100, 10, 100, 14);
            [detailView.timeLabel sizeToFit];
            CGSize tempSize = detailView.timeLabel.frame.size;
            detailView.timeLabel.frame = CGRectMake(detailView.frame.size.width - 15 - tempSize.width, 10, tempSize.width, 14);
            
            CGRect nameRect = [detailView.nameLabel.text boundingRectWithSize:CGSizeMake(detailView.frame.size.width - 54 - detailView.timeLabel.frame.size.width - 15, 50000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
            
            detailView.nameLabel.frame = CGRectMake(54, 10, detailView.frame.size.width - 54 - detailView.timeLabel.frame.size.width - 15, nameRect.size.height + 6);
            
            detailView.contentLabel.text = [tempDic objectForKey:@"comment_content"];
            CGRect contentRect = [detailView.contentLabel.text boundingRectWithSize:CGSizeMake(detailView.frame.size.width - 15 - 54, 5000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
            detailView.contentLabel.frame = CGRectMake(54, detailView.nameLabel.frame.size.height + detailView.nameLabel.frame.origin.y + -3, detailView.frame.size.width - 15 - 54,contentRect.size.height);
            detailView.frame = CGRectMake(0, self.zanLineView.frame.size.height + self.zanLineView.frame.origin.y + height, SCREEN_WIDTH - 30, detailView.contentLabel.frame.size.height + detailView.contentLabel.frame.origin.y + 10);
            height += detailView.frame.size.height;
            
            [self.zanNumBgView addSubview:detailView];
        }
    }
    return height;
}

#pragma mark 点击进入个人中心=================
- (void)tapName1index:(NSInteger)index
{
    [self.hpTextView resignFirstResponder];
    self.hpTextView.text = @"";
    self.markID = @"";
    
    NSDictionary * fromUserDic = tempLocationModel.comments[index];
    SubViewController * personVC = [[SubViewController alloc]init];
    personVC.account = [[fromUserDic objectForKey:@"fromuser"] objectForKey:@"account"];
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)tapName2index:(NSInteger)index
{
    [self.hpTextView resignFirstResponder];
    self.hpTextView.text = @"";
    self.markID = @"";
    NSDictionary * fromUserDic = tempLocationModel.comments[index];
    SubViewController * personVC = [[SubViewController alloc]init];
    personVC.account = [[fromUserDic objectForKey:@"touser"] objectForKey:@"account"];
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}

#pragma mark - privates
- (NSAttributedString *)attributedString:(NSArray *__autoreleasing *)outURLs
                               URLRanges:(NSArray *__autoreleasing *)outURLRanges
                                 withDic:(NSDictionary *)contentDic
{
    NSDictionary * fromuserDic = [contentDic objectForKey:@"fromuser"];
    NSDictionary * toUserDic = [contentDic objectForKey:@"touser"];
    NSString *HTMLText;
    if (toUserDic == nil) {
        HTMLText = [NSString stringWithFormat:@"<a href='a'>%@</a>：",[fromuserDic objectForKey:@"nickname"]];
    }else{
        HTMLText = [NSString stringWithFormat:@"<a href='a'>%@</a> %@ <a href='b'>%@</a>：",[fromuserDic objectForKey:@"nickname"],@"回复",[toUserDic objectForKey:@"nickname"]];
    }
    NSArray *URLs;
    NSArray *URLRanges;
    UIColor *color = [UIColor blackColor];
    UIFont *font = SIZE_FOR_14;
    NSMutableParagraphStyle *mps = [[NSMutableParagraphStyle alloc] init];
    if (down_IOS_8) {
        mps.maximumLineHeight = 18.2;
    }else{
        mps.maximumLineHeight = 17;
    }
    mps.lineSpacing = ceilf(font.pointSize * 0.008);
    mps.lineBreakMode = NSLineBreakByCharWrapping;
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor whiteColor];
    shadow.shadowOffset = CGSizeMake(0, 1);
    NSString *str = [NSString stringWithHTMLText:HTMLText baseURL:[NSURL URLWithString:nil] URLs:&URLs URLRanges:&URLRanges];
    NSMutableAttributedString *mas = [[NSMutableAttributedString alloc] initWithString:str attributes:@
                                      {
                                          NSForegroundColorAttributeName : color,
                                          NSFontAttributeName            : font,
                                          NSParagraphStyleAttributeName  : mps,
                                          NSShadowAttributeName          : shadow,
                                      }];
    
    [URLRanges enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        [mas addAttributes:@
         {
             NSForegroundColorAttributeName : [GetColor16 hexStringToColor:@"#496da5"],
             
             //NSUnderlineStyleAttributeName  : @(NSUnderlineStyleSingle)
         } range:[obj rangeValue]];
    }];
    
    *outURLs = URLs;
    *outURLRanges = URLRanges;
    
    return [mas copy];
}

#pragma mark 赋值
- (void)makeDataToControls
{
    [self.view addSubview:detailCommentView];
    CGRect rect = [_model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 40 - 8, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    CGRect descriptionFram = self.descriptionLabel.frame;
    descriptionFram.size.height = rect.size.height + 3;
    self.descriptionLabel.frame = descriptionFram;
    
//    self.photoImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 9, 200, 200);
//    self.photoImg1.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 9, 72, 72);
//    self.photoImg2.frame = CGRectMake(self.photoImg1.frame.origin.x + self.photoImg1.frame.size.width + 3, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 9, 72, 72);
//    self.photoImg3.frame = CGRectMake(self.photoImg2.frame.origin.x + self.photoImg2.frame.size.width + 3, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 9, 72, 72);
//    
//    self.photoImg4.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12 + 72 + 3, 72, 72);
//    self.photoImg5.frame = CGRectMake(self.photoImg4.frame.origin.x + self.photoImg4.frame.size.width + 3, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12 + 72 + 3, 72, 72);
//    self.photoImg6.frame = CGRectMake(self.photoImg5.frame.origin.x + self.photoImg5.frame.size.width + 3, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12 + 72 + 3, 72, 72);
//    
//    if ([tempLocationModel.photos isEqualToString:@""]) {
//        self.photoImg.hidden = YES;
//        self.photoImg1.hidden = YES;
//        self.photoImg2.hidden = YES;
//        self.photoImg3.hidden = YES;
//        self.photoImg4.hidden = YES;
//        self.photoImg5.hidden = YES;
//        self.photoImg6.hidden = YES;
//        self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12, 11, 16);
//    }else{
//        NSArray * photosArr = [tempLocationModel.photos componentsSeparatedByString:@","];
//        if (photosArr.count <= 3) {
//            if (photosArr.count == 1) {
//                [self.photoImg sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                
//                
//                self.photoImg.hidden = NO;
//                self.photoImg1.hidden = YES;
//                self.photoImg2.hidden = YES;
//                self.photoImg3.hidden = YES;
//                self.photoImg4.hidden = YES;
//                self.photoImg5.hidden = YES;
//                self.photoImg6.hidden = YES;
//            }else if (photosArr.count == 2) {
//                self.photoImg.hidden = YES;
//                self.photoImg1.hidden = NO;
//                self.photoImg2.hidden = NO;
//                self.photoImg3.hidden = YES;
//                self.photoImg4.hidden = YES;
//                self.photoImg5.hidden = YES;
//                self.photoImg6.hidden = YES;
//                [self.photoImg1 sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg1.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg1.clipsToBounds = YES;
//                [self.photoImg2 sd_setImageWithURL:[NSURL URLWithString:photosArr[1]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg2.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg2.clipsToBounds = YES;
//                
//            }else if (photosArr.count == 3) {
//                [self.photoImg3 sd_setImageWithURL:[NSURL URLWithString:photosArr[2]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg3.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg3.clipsToBounds = YES;
//                [self.photoImg2 sd_setImageWithURL:[NSURL URLWithString:photosArr[1]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg2.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg2.clipsToBounds = YES;
//                [self.photoImg1 sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg1.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg1.clipsToBounds = YES;
//                self.photoImg.hidden = YES;
//                self.photoImg1.hidden = NO;
//                self.photoImg2.hidden = NO;
//                self.photoImg3.hidden = NO;
//                self.photoImg4.hidden = YES;
//                self.photoImg5.hidden = YES;
//                self.photoImg6.hidden = YES;
//            }
//            if (photosArr.count == 1) {
//                self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12 + 200 + 12, 11, 16);
//            }else{
//                self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12 + 72 + 12 + 3, 11, 16);
//            }
//        }else{
//            self.photoImg.hidden = YES;
//            self.photoImg1.hidden = NO;
//            self.photoImg2.hidden = NO;
//            self.photoImg3.hidden = NO;
//            [self.photoImg3 sd_setImageWithURL:[NSURL URLWithString:photosArr[2]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//            self.photoImg3.contentMode = UIViewContentModeScaleAspectFill;
//            self.photoImg3.clipsToBounds = YES;
//            [self.photoImg2 sd_setImageWithURL:[NSURL URLWithString:photosArr[1]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//            self.photoImg2.contentMode = UIViewContentModeScaleAspectFill;
//            self.photoImg2.clipsToBounds = YES;
//            [self.photoImg1 sd_setImageWithURL:[NSURL URLWithString:photosArr[0]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//            self.photoImg1.contentMode = UIViewContentModeScaleAspectFill;
//            self.photoImg1.clipsToBounds = YES;
//            if (photosArr.count == 4) {
//                [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg4.clipsToBounds = YES;
//                self.photoImg.hidden = YES;
//                self.photoImg4.hidden = NO;
//                self.photoImg5.hidden = YES;
//                self.photoImg6.hidden = YES;
//            }else if (photosArr.count == 5) {
//                [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg4.clipsToBounds = YES;
//                [self.photoImg5 sd_setImageWithURL:[NSURL URLWithString:photosArr[4]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg5.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg5.clipsToBounds = YES;
//                self.photoImg.hidden = YES;
//                self.photoImg4.hidden = NO;
//                self.photoImg5.hidden = NO;
//                self.photoImg6.hidden = YES;
//            }else if (photosArr.count == 6) {
//                [self.photoImg4 sd_setImageWithURL:[NSURL URLWithString:photosArr[3]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg4.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg4.clipsToBounds = YES;
//                [self.photoImg5 sd_setImageWithURL:[NSURL URLWithString:photosArr[4]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg5.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg5.clipsToBounds = YES;
//                [self.photoImg6 sd_setImageWithURL:[NSURL URLWithString:photosArr[5]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//                self.photoImg6.contentMode = UIViewContentModeScaleAspectFill;
//                self.photoImg6.clipsToBounds = YES;
//                self.photoImg.hidden = YES;
//                self.photoImg4.hidden = NO;
//                self.photoImg5.hidden = NO;
//                self.photoImg6.hidden = NO;
//            }
//            self.locationImg.frame = CGRectMake(self.descriptionLabel.frame.origin.x, self.descriptionLabel.frame.size.height + self.descriptionLabel.frame.origin.y + 12 + 72 + 6 + 72 + 12, 11, 16);
//        }
//    }
    
//    int j = [self createZanPersonLogo];
//    float height = [self createComment];
    
//    NSString * timeStr = [CompareCurrentTime compareCurrentTime:_model.updatetimeLong];
//    self.timeLabel.text = timeStr;
//    self.timeLabel.text = _model.updatetimeLong;
//    self.addressLabel.text = tempLocationModel.title;
    
//    self.moreBtn.frame = CGRectMake(SCREEN_WIDTH - 40 - 15, self.locationImg.frame.origin.y - 15, 55, 45);
//    self.addressLabel.frame = CGRectMake(self.locationImg.frame.origin.x + self.locationImg.frame.size.width + 4, self.locationImg.frame.origin.y - 6, SCREEN_WIDTH - self.locationImg.frame.size.width - self.locationImg.frame.origin.x - 15 - self.moreBtn.frame.size.width - 5, 30);
    
//    self.sanjiaoImg.frame = CGRectMake(30, self.locationImg.frame.origin.y + self.locationImg.frame.size.height + 6.5, 17, 7);
//    if (tempLocationModel.likes.count == 0 || tempLocationModel.likes == nil) {
//        self.zanNumBgView.frame = CGRectMake(15, self.sanjiaoImg.frame.origin.y + self.sanjiaoImg.frame.size.height, SCREEN_WIDTH - 30, height);
//    }else{
//        self.zanNumBgView.frame = CGRectMake(15, self.sanjiaoImg.frame.origin.y + self.sanjiaoImg.frame.size.height, SCREEN_WIDTH - 30, height + (j + 1) * 35 + 5);
//    }
//    
//    self.twoButtonView.frame = CGRectMake(SCREEN_WIDTH - 15 - 25 - 10, self.moreBtn.frame.origin.y + 8, 0, 30);
//    
//    self.zanBtn.frame = CGRectMake(0, 0, 75, 30);
//    self.lineView.frame = CGRectMake(self.zanBtn.frame.origin.x + self.zanBtn.frame.size.width, self.zanBtn.frame.origin.y + 5, 1, 20);
//    self.shareBtn.frame = CGRectMake(self.lineView.frame.origin.x + self.lineView.frame.size.width, 0, 75, 30);
//    
//    
//    [self.logoImg sd_setImageWithURL:[NSURL URLWithString:tempLocationModel.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
//    self.logoImg.contentMode = UIViewContentModeScaleAspectFill;
//    self.logoImg.clipsToBounds = YES;
    self.nameLabel.text = _model.nickname;
    self.descriptionLabel.text = _model.content;
    
//    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.zanNumBgView.frame.size.height + self.zanNumBgView.frame.origin.y + 10);
    myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 100);
}

- (void)showAlertLabel
{
    self.alertLabel.frame = CGRectMake(self.twoButtonView.frame.size.width/2/2 + self.twoButtonView.frame.origin.x, self.twoButtonView.frame.origin.y, 40, 20);
    [UIView animateWithDuration:0.6 animations:^{
        self.alertLabel.hidden = NO;
        self.alertLabel.frame = CGRectMake(self.twoButtonView.frame.size.width/2/2 + self.twoButtonView.frame.origin.x, self.twoButtonView.frame.origin.y - 30, 40, 20);
    } completion:^(BOOL finished) {
        self.alertLabel.hidden = YES;
    }];
    
    CGRect rect = self.twoButtonView.frame;
    rect.origin.x = SCREEN_WIDTH - 15 - 25 - 10;
    rect.size.width = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.twoButtonView.frame = rect;
    } completion:^(BOOL finished) {
        
        self.twoButtonView.hidden = YES;
    }];
}

#pragma mark - 网络请求
- (void)urlRequestPost
{
//    NSDictionary * dic = [self parametersForDic:@"getLocationDetail" parameters:@{ACCOUNT_PASSWORD,@"id":self.locationID}];
//    [HUD removeFromSuperview];
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中";
//    HUD.dimBackground = YES;
//    [HUD show:YES];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            tempLocationModel = [[LocationModel alloc]init];
//            [tempLocationModel setValuesForKeysWithDictionary:[dic objectForKey:@"data"]];
//            imageview.hidden = YES;
//            
//        }else{
//            imageview.hidden = NO;
//            [self.view bringSubviewToFront:imageview];
//            if (![result isEqualToString:@"4"]) {
//                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//            }
//        }
//        [HUD removeFromSuperview];
//    } andFailureBlock:^{
//        [HUD removeFromSuperview];
//    }];
    [self makeDataToControls];
}

//获取分享logo及信息
- (void)getSahreInfo
{
    NSDictionary * shareParam = @{@"method":@"getShareInfo",@"parameters":@{@"account":ACCOUNT_SELF, @"password":PASSWORD_SELF,@"type":@"1"}};
    [URLRequest postRequestssWith:iOS_POST_URL parameters:shareParam andblock:^(NSDictionary *dic) {
        self.userInfoDic = [dic objectForKey:@"data"];
        NSLog(@"dataDic == %@",self.userInfoDic);
    } andFailureBlock:^{
        
    }];
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
