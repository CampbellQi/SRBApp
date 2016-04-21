//
//  PublishSPSucessController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/16.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PublishSPSucessController.h"
#import "RecommendGoodsCollectionController.h"
#import "RecommendTopicListController.h"
#import "CommonView.h"
#import "PersonalSPController.h"
#import "LayoutFrame.h"

@interface PublishSPSucessController ()<RecommendGoodsCollectionControllerDelegate, RecommendTopicListControllerDelegate>
{
//    MBProgressHUD *_hud;
    UILabel *_lineLbl;
}
@end

@implementation PublishSPSucessController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpView];
    // Do any additional setup after loading the view.
    
    
}
#pragma mark- 页面
-(void)setUpView {
    self.title = @"发布成功";
    //滑动页
    RecommendGoodsCollectionController *goodsVC = [[RecommendGoodsCollectionController alloc] init];
    RecommendTopicListController *topicVC = [[RecommendTopicListController alloc] init];
    topicVC.name = self.name;
    topicVC.delegate = self;
    goodsVC.name = self.name;
    goodsVC.delegate = self;
    
    NSLog(@"superSV.frame = %@", NSStringFromCGRect(self.superSV.frame));
    [self.superSV addSubview:goodsVC.view];
    goodsVC.view.frame = CGRectMake(0, 0, self.superSV.width, self.superSV.height);
    [self.superSV addSubview:topicVC.view];
    topicVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, self.superSV.width, self.superSV.height);
    
    [self addChildViewController:goodsVC];
    [self addChildViewController:topicVC];
    
    self.superSV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    
    //UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(_goodsBtn.x + (_goodsBtn.width - 40)/2, 35, 40, 1.5)];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2 - 120 - 20, _itemSuperView.height - 1.5, 120, 1.5)];
    lbl.backgroundColor = MAINSCROLLCOLOR;
    [_itemSuperView addSubview:lbl];
    _lineLbl = lbl;
    //导航栏
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
    self.navigationItem.rightBarButtonItem = [CommonView rightWithBgBarButtonItemTitle:@"完 成" Target:self Action:@selector(completedClicked)];
}
#pragma mark- 事件
- (IBAction)scanBtnClicked:(id)sender {
    PersonalSPController *vc = [[PersonalSPController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)goodsBtnClicked:(id)sender {
    [self.superSV setContentOffset:CGPointMake(0, 0) animated:YES];
    [self showGoodsView];
}
- (IBAction)topicBtnClicked:(id)sender {
    [self.superSV setContentOffset:CGPointMake(self.superSV.width, 0) animated:YES];
    [self showTopicView];
}
-(void)completedClicked {
//    //发送通知刷新求购单列表
    [[NSNotificationCenter defaultCenter] postNotificationName:@"publishSPComletedNF" object:nil];
//    [_hud removeFromSuperview];
    if (self.isFromPublish) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [app tabbarSelectedIndex:1];
        [self.navigationController dismissViewController];
    }else {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
#pragma mark- scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [self showGoodsView];
    }else {
        [self showTopicView];
    }
}

#pragma mark- RecommendGoodsCollectionControllerDelegate, RecommendTopicListControllerDelegate
-(void)scrollViewWillEndDraggingDelegate:(CGPoint)velocity {
    if (velocity.y > 0) {
        [UIView animateWithDuration:0.3 animations:^{
            [LayoutFrame showViewConstraint:self.topView AttributeTop:-self.topView.frame.size.height];
            //[LayoutFrame showViewConstraint:self.topView AttributeHeight:0.0];
            NSLog(@"%f",self.topView.frame.size.height);
        } completion:^(BOOL finished) {
            self.topView.hidden = YES;
        }];
    }else if(velocity.y < 0){
        self.topView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [LayoutFrame showViewConstraint:self.topView AttributeTop:0.0];
        }];
    }
}
-(void)showGoodsView {
    self.goodsBtn.selected = YES;
    self.topicBtn.selected = NO;
    [_lineLbl setOrigin:CGPointMake(SCREEN_WIDTH/2 - 120 - 20, _lineLbl.y)];
}
-(void)showTopicView {
    self.goodsBtn.selected = NO;
    self.topicBtn.selected = YES;
    [_lineLbl setOrigin:CGPointMake(SCREEN_WIDTH/2 + 20, _lineLbl.y)];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
