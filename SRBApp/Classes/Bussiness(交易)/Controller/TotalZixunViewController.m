//
//  TotalZixunViewController.m
//  SRBApp
//
//  Created by zxk on 15/4/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TotalZixunViewController.h"
#import "MarkOrCommentsCell.h"
#import "SubViewController.h"
#import "HPGrowingTextView.h"
#import "MarkModel.h"
#import "MJRefresh.h"
static int page = 0;

@interface TotalZixunViewController ()<UITableViewDataSource,UITableViewDelegate,HPGrowingTextViewDelegate,UIScrollViewDelegate>
@end

@implementation TotalZixunViewController
{
    NoDataView * nodataView;
    UIView * detailCommentView;
    UIButton * submitBtn;
    HPGrowingTextView * hpTextView;
    MarkModel * tempMarkModel;
    NSMutableArray * dataArray;
    MBProgressHUD * HUD;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [NSMutableArray array];
    
    UITableView * tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 39) style:UITableViewStylePlain];
    self.tableView = tableView;
    tableView.delegate =self;
    tableView.dataSource =self;
    tableView.tableFooterView = [[UIView alloc]init];
    tableView.backgroundColor = [UIColor clearColor];
    [tableView addHeaderWithTarget:self action:@selector(headerRefresh)];
    [tableView addFooterWithTarget:self action:@selector(footerRefresh)];
    [tableView headerBeginRefreshing];
    [self.view addSubview:tableView];
    
    nodataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 40)];
    nodataView.hidden = YES;
    [tableView addSubview:nodataView];
    [self commentItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [hpTextView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MarkOrCommentsCell * cell = [[MarkOrCommentsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    //    CGSize boundSize = CGSizeMake(216, CGFLOAT_MAX);
    //    cell.sayLabel.text = [dataArray[indexPath.row] content];
    //    cell.sayLabel.numberOfLines = 0;
    //    CGSize requiredSize = [cell.sayLabel.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:boundSize lineBreakMode:0];
    
    cell.headImage.indexpath = indexPath;
    UITapGestureRecognizer *tapToPersonal = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToPersonal:)];
    [cell.headImage addGestureRecognizer:tapToPersonal];
    
    
    [cell.headImage sd_setImageWithURL:[NSURL URLWithString:[dataArray[indexPath.row] avatar]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    cell.headImage.contentMode = UIViewContentModeScaleAspectFill;
    cell.headImage.clipsToBounds = YES;
    cell.titleLabel.text =[dataArray[indexPath.row] nickname];
    
    if ([dataArray[indexPath.row]touser] != nil) {
        NSDictionary * dic = (NSDictionary *) [dataArray[indexPath.row] touser];
        cell.sayToWhoLabel.text = [dic objectForKey:@"nickname"];
        [cell.sayToWhoLabel sizeToFit];
    }else{
        cell.huifuLabel.hidden = YES;
    }
    
    if ([[dataArray[indexPath.row] grade] isEqualToString:@"1"]) {
        cell.commentImg.image = [UIImage imageNamed:@"s_good"];
        cell.goodComment.text = @"综合评分：好评";
    }else if([[dataArray[indexPath.row] grade] isEqualToString:@"0"]){
        cell.commentImg.image = [UIImage imageNamed:@"s_middle"];
        cell.goodComment.text = @"综合评分：中评";
    }else if([[dataArray[indexPath.row] grade] isEqualToString:@"-1"]){
        cell.commentImg.image = [UIImage imageNamed:@"s_negative"];
        cell.goodComment.text = @"综合评分：差评";
    }else
    {
        cell.commentImg.image = [UIImage imageNamed:@"s_fake"];
        cell.goodComment.text = @"综合评分：假货";
    }
    [cell setIntroductionText:[dataArray[indexPath.row] content]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    NSDate * date = [dateFormatter dateFromString:[dataArray[indexPath.row] updatetime]];
    //    [dateFormatter setDateFormat:@"MM-dd"];
    //    NSString * str = [dateFormatter stringFromDate:date];
//    cell.dateLabel.text = [dataArray[indexPath.row] updatetime];
    MarkModel * modfl = dataArray[indexPath.row];
    double i = modfl.updatetimeLong;
    cell.dateLabel.text = [CompareCurrentTime compareCurrentTime:i];
    //    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    //    CGRect rect = cell.frame;
    //    rect.size.height = requiredSize.height + 100;
    //    cell.frame = rect;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MarkModel * markModel = dataArray[indexPath.row];
    if (![markModel.account isEqualToString:ACCOUNT_SELF]) {
        tempMarkModel = markModel;
        hpTextView.text = @"";
        hpTextView.placeholder = [NSString stringWithFormat:@"回复：%@",markModel.nickname];
        [hpTextView becomeFirstResponder];
    }else{
        [hpTextView resignFirstResponder];
    }
    //    SpeaktoCommentViewController * vc = [[SpeaktoCommentViewController alloc]init];
    //    vc.model = dataArray[indexPath.row];
    //    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.tableView]) {
        [hpTextView resignFirstResponder];
    }
}

#pragma mark 键盘弹出与收回的监听
- (void)keyboardWasShown:(NSNotification *)notification
{
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
    // commit animations
    [UIView commitAnimations];
    
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    NSNumber *duration = [notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // get a rect for the textView frame
    CGRect containerFrame = detailCommentView.frame;
    containerFrame.origin.y = SCREEN_HEIGHT;
    
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    // set views with new info
    detailCommentView.frame = containerFrame;
    // commit animations
    [UIView commitAnimations];
    
}

#pragma mark growingTextView 代理
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
    CGRect r = detailCommentView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
    detailCommentView.frame = r;
    
    submitBtn.frame = CGRectMake(hpTextView.frame.size.width + hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 60, 25);
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

- (void)commentItem
{
    detailCommentView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 40)];
    detailCommentView.backgroundColor = [GetColor16 hexStringToColor:@"#f6f6f6"];
    [self.view addSubview:detailCommentView];
    
    hpTextView = [[HPGrowingTextView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH - 30 - 60 - 15, 30)];
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
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(hpTextView.frame.size.width + hpTextView.frame.origin.x + 15, detailCommentView.frame.size.height - 7 - 25, 55, 25);
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

- (void)submitComment:(UIButton *)sender
{
    NSDictionary * dic = [self parametersForDic:@"accountCommentPost" parameters:@{ACCOUNT_PASSWORD,@"id":tempMarkModel.model_id,@"markId":tempMarkModel.markId,@"content":hpTextView.text}];
    [HUD removeFromSuperview];
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"加载中";
    HUD.dimBackground = YES;
    [HUD show:YES];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [hpTextView resignFirstResponder];
            [self urlRequestPost];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [HUD hide:YES];
        [HUD removeFromSuperview];
    } andFailureBlock:^{
        [HUD hide:YES];
        [HUD removeFromSuperview];
    }];
}

- (void)tapToPersonal:(UITapGestureRecognizer *)sender
{
    MyImgView * myImg = (MyImgView *)sender.view;
    SubViewController * personVC = [[SubViewController alloc]init];
    personVC.account = [dataArray[myImg.indexpath.row] account];
    personVC.myRun = @"2";
    [self.navigationController pushViewController:personVC animated:YES];
}


- (void)urlRequestPost
{
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0",@"id":self.idNumber,@"start":@"0", @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [dataArray removeAllObjects];
        if ([result isEqualToString:@"0"]) {
            
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MarkModel * bussinessModel = [[MarkModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
            }
            nodataView.hidden = YES;
        }else if([result isEqualToString:@"4"]){
            nodataView.hidden = NO;
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        page = 0;
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
    } andFailureBlock:^{
        page = 0;
        nodataView.hidden = NO;
        [dataArray removeAllObjects];
        [temTableView reloadData];
        [temTableView headerEndRefreshing];
    }];
}
#pragma mark - 下拉刷新
- (void)headerRefresh
{
    //__block NSString * tempStatus = status;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self urlRequestPost];
    });
}

#pragma mark - 加载更多
- (void)footerRefresh
{
    page += NumOfItemsForZuji;
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"getPostCommentsByRelation" parameters:@{ACCOUNT_PASSWORD, @"isFriended":@"0",@"id":self.idNumber,@"start":[NSString stringWithFormat:@"%d",page], @"count":[NSString stringWithFormat:@"%d",NumOfItemsForZuji]}];
    
    __block UITableView *temTableView = self.tableView;
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                MarkModel * bussinessModel = [[MarkModel alloc]init];
                [bussinessModel setValuesForKeysWithDictionary:tempdic];
                [dataArray addObject:bussinessModel];
                if (dataArray.count > [[[dic objectForKey:@"data"] objectForKey:@"totalCount"] intValue]) {
                    [dataArray removeLastObject];
                    page -= NumOfItemsForZuji;
                    break;
                }
            }
            nodataView.hidden = YES;
            [temTableView reloadData];
        }else if([result isEqualToString:@"4"]){
            page -= NumOfItemsForZuji;
        }else{
            page -= NumOfItemsForZuji;
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [temTableView footerEndRefreshing];
        }
        [temTableView footerEndRefreshing];
    } andFailureBlock:^{
        page -= NumOfItemsForZuji;
        [temTableView footerEndRefreshing];
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
