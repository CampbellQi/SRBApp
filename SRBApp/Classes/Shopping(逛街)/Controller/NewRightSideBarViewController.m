//
//  NewRightSideBarViewController.m
//  SRBApp
//
//  Created by zxk on 15/6/23.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "NewRightSideBarViewController.h"
#import "FriendGroupModel.h"
#import "NewShoppingViewController.h"

static int topOldIndex;
static int bottomOldIndex;
static int groupOldIndex;

@interface NewRightSideBarViewController ()
@property (nonatomic,strong)UIRefreshControl * control;
@end

@implementation NewRightSideBarViewController
{
    UIScrollView * mainScroll;
    NSMutableArray * typeArr;
    NSMutableArray * tempArr;           //临时分类数组,包含全部
    NSMutableArray * tempGroupArr;      //分组数组,包含全部
    int tempTopNewIndex;
    int tempBottomNewIndex;
    int tempGroupNewIndex;
    UILabel * saleAndBuyLabel;      //买卖类型分组
    UILabel * goodsTypeLabel;       //信息类型分组
    UILabel * groupTypeLabel;       //熟人分组
    UIActivityIndicatorView * activity;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    // Do any additional setup after loading the view.
    topOldIndex = 1000;
    bottomOldIndex = 2000;
    groupOldIndex = 4000;
    [self customInit];
}

- (void)categoryRequest
{
    [activity startAnimating];
    NSDictionary * dic = [self parametersForDic:@"getCategoryList" parameters:@{@"type":@"123"}];
    [self.dealTypeArr removeAllObjects];
    for (int i = 0; i < tempArr.count; i++) {
        UIButton * tempBtn = (UIButton *)[self.view viewWithTag:2000+i];
        [tempBtn removeFromSuperview];
    }
    
    for (int i = 0; i < typeArr.count; i++) {
        UIButton * tempBtn = (UIButton *)[self.view viewWithTag:1000+i];
        [tempBtn removeFromSuperview];
    }
    
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                GroupModel * groupModel = [[GroupModel alloc]init];
                [groupModel setValuesForKeysWithDictionary:tempdic];
                [self.dealTypeArr addObject:groupModel];
            }
            [self groupRequest];
        }
    } andFailureBlock:^{
        [self.control endRefreshing];
        [activity stopAnimating];
    }];
}

- (void)groupRequest
{
    NSDictionary * dic = [self parametersForDic:@"accountGetFriendGroup" parameters:@{ACCOUNT_PASSWORD}];
    [self.groupArr removeAllObjects];
    for (int i = 0; i < tempGroupArr.count; i++) {
        UIButton * tempBtn = (UIButton *)[self.view viewWithTag:4000+i];
        [tempBtn removeFromSuperview];
    }
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        [activity stopAnimating];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            
            for (int i = 0; i < temparrs.count; i++) {
                NSDictionary * tempdic = [temparrs objectAtIndex:i];
                FriendGroupModel * friendGroup = [[FriendGroupModel alloc]init];
                [friendGroup setValuesForKeysWithDictionary:tempdic];
                [self.groupArr addObject:friendGroup];
            }
            [self createBottomBtn];
        }else if ([result isEqualToString:@"4"]){
            [self createBottomBtn];
        }
        [self.control endRefreshing];
    } andFailureBlock:^{
        [self.control endRefreshing];
        [activity stopAnimating];
    }];
}

- (void)createBottomBtn
{
    
    for (int i = 0; i < 3; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:typeArr[i] forState:UIControlStateNormal];
        button.tag = 1000+i;
        if (i == topOldIndex) {
            button.selected = YES;
        }
        [button addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(15, (saleAndBuyLabel.frame.size.height + saleAndBuyLabel.frame.origin.y + 12) + i * 31, 160 - 30, 30);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        [button setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateSelected];
        [button setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"button_pink"] forState:UIControlStateSelected];
        [mainScroll addSubview:button];
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.2) {
            [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
        }
        
        //        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(btnLong:)];
        //        longPress.minimumPressDuration = 0.5;
        //        [button addGestureRecognizer:longPress];
    }
    
    UIButton * tempBtn = (UIButton *)[self.view viewWithTag:1002];
    goodsTypeLabel.frame = CGRectMake(15,tempBtn.frame.size.height + tempBtn.frame.origin.y + 24,100,16);
    
    
    UIButton * lastGoodBtn;
    UIButton * lastGroupBtn;
    [tempArr removeAllObjects];
    [tempGroupArr removeAllObjects];
    for (int i = 0; i < self.dealTypeArr.count; i++) {
        GroupModel * groupModel = self.dealTypeArr[i];
        [tempArr addObject:groupModel.categoryName];
    }
    [tempArr insertObject:@"全部" atIndex:0];
    for (int i = 0; i < tempArr.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:tempArr[i] forState:UIControlStateNormal];
        button.tag = 2000+i;
        if (button.tag == bottomOldIndex) {
            button.selected = YES;
        }
        [button addTarget:self action:@selector(changeDealType:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(15, (goodsTypeLabel.frame.size.height + goodsTypeLabel.frame.origin.y + 24) + i * 31, 160 - 30, 30);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        [button setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateSelected];
        [button setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.2) {
            [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
        }
        if (i == tempArr.count - 1) {
            lastGoodBtn = button;
        }
        
        //        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(bottomBtnLong:)];
        //        longPress.minimumPressDuration = 0.5;
        //        [button addGestureRecognizer:longPress];
        
        
        [button setBackgroundImage:[UIImage imageNamed:@"button_pink"] forState:UIControlStateSelected];
        [mainScroll addSubview:button];
    }
    
    groupTypeLabel.frame = CGRectMake(15,CGRectGetMaxY(lastGoodBtn.frame) + 24,100,16);
    
    for (int i = 0; i < self.groupArr.count; i++) {
        FriendGroupModel * friendGroup = self.groupArr[i];
        [tempGroupArr addObject:friendGroup.groupName];
    }
    [tempGroupArr insertObject:@"全部" atIndex:0];
    for (int i = 0; i < tempGroupArr.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:tempGroupArr[i] forState:UIControlStateNormal];
        button.tag = 4000+i;
        if (button.tag == groupOldIndex) {
            button.selected = YES;
        }
        [button addTarget:self action:@selector(changeGroupType:) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(15, (CGRectGetMaxY(groupTypeLabel.frame) + 24) + i * 31, 160 - 30, 30);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
        [button setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateSelected];
        [button setTitleColor:[GetColor16 hexStringToColor:@"#434343"] forState:UIControlStateNormal];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.2) {
            [button setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
        }
        
        if (i == tempGroupArr.count - 1) {
            lastGroupBtn = button;
        }
        
        //        UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(bottomBtnLong:)];
        //        longPress.minimumPressDuration = 0.5;
        //        [button addGestureRecognizer:longPress];
        
        
        [button setBackgroundImage:[UIImage imageNamed:@"button_pink"] forState:UIControlStateSelected];
        [mainScroll addSubview:button];
    }
    mainScroll.contentSize = CGSizeMake(160, CGRectGetMaxY(lastGroupBtn.frame) + 10);
    if (CGRectGetMaxY(lastGroupBtn.frame) + 10 < SCREEN_HEIGHT) {
        mainScroll.contentSize = CGSizeMake(160, SCREEN_HEIGHT + 5);
    }
    
    [self changeTopIndex:topOldIndex newIndex:topOldIndex];
    [self changeBottomIndex:bottomOldIndex newIndex:bottomOldIndex];
    [self changeGroupIndex:groupOldIndex newIndex:groupOldIndex];
}

- (void)customInit
{
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.center = CGPointMake(80, self.view.height/2);
    [activity setHidesWhenStopped:YES];
    [self.view addSubview:activity];
    
    self.dealTypeArr = [NSMutableArray array];
    self.groupArr = [NSMutableArray array];
    tempArr = [NSMutableArray array];
    tempGroupArr = [NSMutableArray array];
    mainScroll = [[UIScrollView alloc]init];
    mainScroll.frame = CGRectMake(0, 0, 160, SCREEN_HEIGHT);
    
    UIRefreshControl * control = [[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(categoryRequest) forControlEvents:UIControlEventValueChanged];
    self.control = control;
    [mainScroll addSubview:control];
    
    [self.view addSubview:mainScroll];
    
    saleAndBuyLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,20,80,16)];
    saleAndBuyLabel.font = SIZE_FOR_IPHONE;
    saleAndBuyLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    saleAndBuyLabel.text = @"供求分类";
    [mainScroll addSubview:saleAndBuyLabel];
    
    typeArr = [NSMutableArray arrayWithObjects:@"全部",@"出售",@"求购", nil];
    
    goodsTypeLabel = [[UILabel alloc]init];
    goodsTypeLabel.font = SIZE_FOR_IPHONE;
    goodsTypeLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    goodsTypeLabel.text = @"信息分类";
    [mainScroll addSubview:goodsTypeLabel];
    
    
    groupTypeLabel = [[UILabel alloc]init];
    groupTypeLabel.font = SIZE_FOR_IPHONE;
    groupTypeLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    groupTypeLabel.text = @"熟人分组";
    [mainScroll addSubview:groupTypeLabel];
    
    [self categoryRequest];
    
    //    __block LeftSideBarViewController * tempVC = self;
    //    self.isRestBlock = ^(void){
    //        [tempVC changeTopIndex:topOldIndex newIndex:1000];
    //        [tempVC changeBottomIndex:bottomOldIndex newIndex:2000];
    //        [tempVC submit:nil];
    //    };
}

- (void)restAllState
{
    [self changeTopIndex:topOldIndex newIndex:1000];
    [self changeBottomIndex:bottomOldIndex newIndex:2000];
    [self changeGroupIndex:groupOldIndex newIndex:4000];
    [self submit];
}

- (void)changeBottomIndex:(int)oldIndex newIndex:(int)newIndex
{
    UIButton * oldBtn = (UIButton *)[self.view viewWithTag:oldIndex];
    UIButton * newBtn = (UIButton *)[self.view viewWithTag:newIndex];
    [oldBtn setSelected:NO];
    [newBtn setSelected:YES];
    bottomOldIndex = (int)newIndex;
    
}

- (void)changeTopIndex:(int)oldIndex newIndex:(int)newIndex
{
    UIButton * oldBtn = (UIButton *)[self.view viewWithTag:oldIndex];
    UIButton * newBtn = (UIButton *)[self.view viewWithTag:newIndex];
    [oldBtn setSelected:NO];
    [newBtn setSelected:YES];
    topOldIndex = (int)newIndex;
}

- (void)changeGroupIndex:(int)oldIndex newIndex:(int)newIndex
{
    UIButton * oldBtn = (UIButton *)[self.view viewWithTag:oldIndex];
    UIButton * newBtn = (UIButton *)[self.view viewWithTag:newIndex];
    [oldBtn setSelected:NO];
    [newBtn setSelected:YES];
    groupOldIndex = (int)newIndex;
}

- (void)changeType:(UIButton *)sender
{
    [self changeTopIndex:topOldIndex newIndex:(int)sender.tag];
    [self submit];
}

- (void)changeDealType:(UIButton *)sender
{
    [self changeBottomIndex:bottomOldIndex newIndex:(int)sender.tag];
    [self submit];
}

- (void)changeGroupType:(UIButton *)sender
{
    [self changeGroupIndex:groupOldIndex newIndex:(int)sender.tag];
    [self submit];
}

- (void)submit
{
    NSString * categoryIDStr;
    if (bottomOldIndex - 2000 == 0) {
        categoryIDStr = @"";
    }else{
        GroupModel * groupModel = self.dealTypeArr[bottomOldIndex - 2000-1];
        categoryIDStr = groupModel.categoryID;
    }
    NSString * friendGroupIDStr;
    if (groupOldIndex - 4000 == 0) {
        friendGroupIDStr = @"";
    }else{
        FriendGroupModel * friendGroup = self.groupArr[groupOldIndex - 4000 - 1];
        friendGroupIDStr = friendGroup.groupId;
    }
    
    NSString * goodsType = tempArr[bottomOldIndex - 2000];
    NSString * saleOrBuy = typeArr[topOldIndex - 1000];
    NSString * groupType = tempGroupArr[groupOldIndex - 4000];
    self.shoppingVC.goodsType = goodsType;
    self.shoppingVC.saleOrBuy = saleOrBuy;
    self.shoppingVC.groupType = groupType;
    self.shoppingVC.isShowBlock(saleOrBuy,goodsType,groupType);
    
    
    
    self.shoppingVC.saleAndBuyType = [NSString stringWithFormat:@"%d",topOldIndex-1000];
    self.shoppingVC.categoryID = categoryIDStr;
    self.shoppingVC.groupID = friendGroupIDStr;
    
    [self.rightSideBar dismissAnimated:YES];
    
    
    [self.shoppingVC.dataArray removeAllObjects];
    [self.shoppingVC.tableView reloadData];
    [self.shoppingVC start];
    
    [self.shoppingVC urlRequestPost];
}

@end
