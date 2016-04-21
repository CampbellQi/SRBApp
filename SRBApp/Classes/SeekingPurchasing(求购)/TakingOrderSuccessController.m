//
//  TakingOrderSuccessController.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/22.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "TakingOrderSuccessController.h"
#import "RecomendSPController.h"
#import "RecommendTopicListController.h"
#import "CommonView.h"
#import "PersonalHelpSPController.h"
#import "LayoutFrame.h"

@interface TakingOrderSuccessController ()<RecomendSPControllerDelegate, RecommendTopicListControllerDelegate>
{
    UILabel *_lineLbl;
}
@end

@implementation TakingOrderSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
}

#pragma mark- 页面
-(void)setUpView {
    self.title = @"接单成功";
    //滑动页
    RecomendSPController *vc1 = [[RecomendSPController alloc] init];
    vc1.delegate = self;
    RecommendTopicListController *vc2 = [[RecommendTopicListController alloc] init];
    vc2.delegate = self;
    
    vc1.name = self.name;
    vc1.brand = self.brand;
    vc2.name = self.name;
    
    NSLog(@"superSV.frame = %@", NSStringFromCGRect(self.superSV.frame));
    [self.superSV addSubview:vc1.view];
    vc1.view.frame = CGRectMake(0, 0, self.superSV.width, self.superSV.height);
    [self.superSV addSubview:vc2.view];
    vc2.view.frame = CGRectMake(SCREEN_WIDTH, 0, self.superSV.width, self.superSV.height);
    
    [self addChildViewController:vc1];
    [self addChildViewController:vc2];
    
    self.superSV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    //滑动条
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
    PersonalHelpSPController *vc = [[PersonalHelpSPController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)spBtnClicked:(id)sender {
    [self.superSV setContentOffset:CGPointMake(0, 0) animated:YES];
    [self showSPView];
}
- (IBAction)topicBtnClicked:(id)sender {
    [self.superSV setContentOffset:CGPointMake(self.superSV.width, 0) animated:YES];
    [self showTopicView];
}
-(void)completedClicked {
    //AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //[app tabbarSelectedIndex:1];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark- scrollview delegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x == 0) {
        [self showSPView];
    }else {
        [self showTopicView];
    }
}
#pragma mark- RecomendSPControllerDelegate, RecommendTopicListControllerDelegate
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
-(void)showSPView {
    self.spBtn.selected = YES;
    self.topicBtn.selected = NO;
    [_lineLbl setOrigin:CGPointMake(SCREEN_WIDTH/2 - 120 - 20, _lineLbl.y)];
}
-(void)showTopicView {
    self.spBtn.selected = NO;
    self.topicBtn.selected = YES;
    [_lineLbl setOrigin:CGPointMake(SCREEN_WIDTH/2 + 20, _lineLbl.y)];
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
