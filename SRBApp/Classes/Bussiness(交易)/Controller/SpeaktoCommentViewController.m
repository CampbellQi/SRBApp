//
//  SpeaktoCommentViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/4/8.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SpeaktoCommentViewController.h"
#import "CopyLabel.h"
#import <UIImageView+WebCache.h>
#import "HPGrowingTextView.h"
#import "SubViewController.h"

@interface SpeaktoCommentViewController ()<HPGrowingTextViewDelegate>
{
    UIView * detailCommentView;
    UIButton * clickBtn;
    UIButton * submitBtn;
    BOOL isCommentTextView;
    BOOL isBack;
    BOOL isKeyboardHidden;
    CGPoint tapPoint;
}
@property (nonatomic, strong)UIScrollView * scrollView;
@property (nonatomic, strong)UILabel * nameLabel;
@property (nonatomic, strong)UILabel * dateLabel;
@property (nonatomic, strong)CopyLabel * sayLabel;
@property (nonatomic, strong)UIImageView * headImage;
@property (nonatomic, strong)HPGrowingTextView * hpTextView;
@property (nonatomic, strong)NSString * markID;
@property (nonatomic ,strong)UILabel * huifuLabel;
@property (nonatomic ,strong)UILabel * sayToWhoLabel;
@end

@implementation SpeaktoCommentViewController

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
    self.sayLabel.backgroundColor = [UIColor clearColor];
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
    self.title = @"回复咨询";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    [self setTheView];
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTheView
{
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView * logoImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 40, 40)];
    self.headImage = logoImg;
    logoImg.layer.masksToBounds = YES;
    logoImg.layer.cornerRadius = 20;
    logoImg.userInteractionEnabled = YES;
    logoImg.contentMode = UIViewContentModeScaleAspectFill;
    logoImg.clipsToBounds = YES;
    [logoImg sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:[UIImage imageNamed:@"wutu"]];
    UITapGestureRecognizer *logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToLPersonal:)];
    [logoImg addGestureRecognizer:logoTap];
    [self.view addSubview:logoImg];
    
    UILabel * nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 8, 12, 200, 20)];
    nameLabel.font = SIZE_FOR_IPHONE;
    nameLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.nameLabel = nameLabel;
    self.nameLabel.text = _model.nickname;
    [self.view addSubview:nameLabel];
    
    _huifuLabel = [[UILabel alloc]initWithFrame:CGRectMake(nameLabel.frame.origin.x, nameLabel.frame.origin.y + nameLabel.frame.size.height + 2, 30, 16)];
    _huifuLabel.text = @"回复 ";
    _huifuLabel.font = SIZE_FOR_12;
    [self.view addSubview:_huifuLabel];
    
    _sayToWhoLabel = [[UILabel alloc]initWithFrame:CGRectMake(_huifuLabel.frame.origin.x + _huifuLabel.frame.size.width,_huifuLabel.frame.origin.y, 200, 14)];
    _sayToWhoLabel.font = SIZE_FOR_12;
    _sayToWhoLabel.hidden = NO;
    _sayToWhoLabel.textAlignment = NSTextAlignmentLeft;
    _sayToWhoLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:_sayToWhoLabel];
    
    UILabel * timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 140, nameLabel.frame.origin.y + 3, 140, 12)];
    timeLabel.font = SIZE_FOR_12;
    timeLabel.textAlignment = NSTextAlignmentRight;
    timeLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    self.dateLabel = timeLabel;
    self.dateLabel.text = _model.updatetime;
    [self.view addSubview:timeLabel];
    
    CopyLabel * descriptionLabel = [[CopyLabel alloc]initWithFrame:CGRectMake(logoImg.frame.size.width + logoImg.frame.origin.x + 8, _huifuLabel.frame.size.height + _huifuLabel.frame.origin.y + 5, SCREEN_WIDTH - 15 - 15 - 40 - 8, 26)];
    descriptionLabel.layer.borderColor = [GetColor16 hexStringToColor:@"#ffffff"].CGColor;
    descriptionLabel.userInteractionEnabled = YES;
    descriptionLabel.font = SIZE_FOR_14;
    descriptionLabel.lineBreakMode = NSLineBreakByCharWrapping;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    self.sayLabel = descriptionLabel;
    [self.view addSubview:descriptionLabel];
    
    CGRect rect = [_model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 15 - 15 - 40 - 8, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
    CGRect descriptionFram = self.sayLabel.frame;
    descriptionFram.size.height = rect.size.height + 3;
    self.sayLabel.frame = descriptionFram;
    self.sayLabel.text =  _model.content;
    
    
    
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
    hpTextView.placeholder = [NSString stringWithFormat:@"回复: %@",_model.nickname];
    [detailCommentView addSubview:hpTextView];
    
    clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.backgroundColor = [UIColor clearColor];
    clickBtn.frame = hpTextView.frame;
    [clickBtn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    clickBtn.hidden = NO;
    [detailCommentView addSubview:clickBtn];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(self.hpTextView.frame.size.width + self.hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 55, 25);
    submitBtn.layer.cornerRadius = CGRectGetHeight(submitBtn.frame)*0.5;
    submitBtn.layer.masksToBounds = YES;
    
    [submitBtn addTarget:self action:@selector(submitComment:) forControlEvents:UIControlEventTouchUpInside];
    
    [submitBtn setTitle:@"发 送" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [submitBtn setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[self imageWithColor:[GetColor16 hexStringToColor:@"#959595"] size:submitBtn.frame.size] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"bg_button_redred"] forState:UIControlStateHighlighted];
    submitBtn.enabled = NO;
    [detailCommentView addSubview:submitBtn];
    
    if (_model.touser != nil) {
        NSDictionary * dic = (NSDictionary *) _model.touser;
        _sayToWhoLabel.text = [dic objectForKey:@"nickname"];
        [_sayToWhoLabel sizeToFit];
    }else{
        _huifuLabel.hidden = YES;
    }
    
    [self.view addSubview:detailCommentView];
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

- (void)clickBtn:(UIButton *)sender
{
    [self.hpTextView becomeFirstResponder];
    isCommentTextView = NO;
    self.hpTextView.text = @"";
    self.markID = @"";
    self.hpTextView.placeholder = [NSString stringWithFormat:@"回复: %@",_model.nickname];;
}

#pragma mark 点击进入个人中心
//点击进入个人中心
- (void)tapToLPersonal:(UITapGestureRecognizer *)tap
{
    [self.hpTextView resignFirstResponder];
    self.hpTextView.text = @"";
    SubViewController *personalVC = [[SubViewController alloc] init];
    personalVC.account = _model.account;
    personalVC.nickname = _model.nickname;
    personalVC.myRun = @"2";
    [self.navigationController pushViewController:personalVC animated:YES];
}

#pragma mark 提交评论
- (void)submitComment:(UIButton *)sender
{
    [self urlRequestPost];
}


- (void)urlRequestPost
{
    NSDictionary * dic = [self parametersForDic:@"accountCommentPost" parameters:@{ACCOUNT_PASSWORD,@"id":_model.model_id,
                                                                                   @"markId":_model.markId,@"content":_hpTextView.text
}];
//    [HUD removeFromSuperview];
//    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    HUD.labelText = @"加载中";
//    HUD.dimBackground = YES;
//    [HUD show:YES];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"shuaxin" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
//        [HUD removeFromSuperview];
    } andFailureBlock:^{
//        [HUD removeFromSuperview];
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
            self.view.frame = viewRect;
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
        self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40);
        // commit animations
        [UIView commitAnimations];
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

#pragma mark growingTextView 代理
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = detailCommentView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    detailCommentView.frame = r;
    
    if (isKeyboardHidden == NO) {
        CGRect viewRect = self.view.frame;
        viewRect.origin.y += diff;
        self.view.frame = viewRect;
    }
    
    submitBtn.frame = CGRectMake(self.hpTextView.frame.size.width + self.hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 60, 25);
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
