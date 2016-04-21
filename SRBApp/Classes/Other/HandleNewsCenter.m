//
//  HandleMsgCenter.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/3.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "HandleNewsCenter.h"

#import "NewsCenterViewController.h"
#import "ZZOrderDetailViewController.h"
#import "SellerOrderDetailViewController.h"
#import "SellerEvaluateListActivityViewController.h"
#import "MyEvaluateListViewController.h"
#import "MyAssureViewController.h"
#import "SubNewFriendApplyViewController.h"
#import "MyFriendsViewController.h"
#import "SecondSubclassDetailViewController.h"
#import "SubViewController.h"
#import "LocationDetailViewController.h"
#import "GuaranteeDetailViewController.h"
#import "MessageCenterToSubClassViewController.h"
#import "SubViewController.h"
#import "SubAddressBookListActivityViewController.h"
#import "TopicDetailListController.h"
#import "TopicCommentListController.h"
#import "OrderDetailController.h"
#import "PersonalSPController.h"
#import "PersonalHelpSPController.h"

@implementation HandleNewsCenter
+(void)handleMsgCenterModule:(NSString *)module Value:(NSString *)value NavigationController:(UINavigationController *)navigationController {
    if ([module isEqualToString:@"sellerorder"]) {
        //卖家订单
        SellerOrderDetailViewController * sellerDetailVC = [[SellerOrderDetailViewController alloc]init];
        sellerDetailVC.orderID = value;
        [navigationController pushViewController:sellerDetailVC animated:YES];
    }else if ([module isEqualToString:@"buyerorder"]){
        //买家订单
        ZZOrderDetailViewController * orderDetailVC = [[ZZOrderDetailViewController alloc]init];
        orderDetailVC.orderID = value;
        [navigationController pushViewController:orderDetailVC animated:YES];
    }else if ([module isEqualToString:@"userapply"]){
        //新的熟人
        SubNewFriendApplyViewController * newFriendVC = [[SubNewFriendApplyViewController alloc]init];
        [navigationController pushViewController:newFriendVC animated:YES];
    }else if ([module isEqualToString:@"userfriend"]){
        //我的熟人
        MyFriendsViewController * myFriendVC = [[MyFriendsViewController alloc]init];
        myFriendVC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:myFriendVC animated:YES];
    }else if ([module isEqualToString:@"postguarantee"] || [module isEqualToString:@"userguarantee"]){
        //担保人
        MyAssureViewController * myAssureVC = [[MyAssureViewController alloc]init];
        [navigationController pushViewController:myAssureVC animated:YES];
    }else if ([module isEqualToString:@"sellercomment"]){
        //卖家评价列表
        SellerEvaluateListActivityViewController * sellerEvaluateVC = [[SellerEvaluateListActivityViewController alloc]init];
        [navigationController pushViewController:sellerEvaluateVC animated:YES];
    }else if ([module isEqualToString:@"buyercomment"]){
        //买家评价列表
        MyEvaluateListViewController * myEvaluateVC = [[MyEvaluateListViewController alloc]init];
        [navigationController pushViewController:myEvaluateVC animated:YES];
    }else if ([module isEqualToString:@"userpost"]){
        //商品详情
        MessageCenterToSubClassViewController * sellerManagementVC = [[MessageCenterToSubClassViewController alloc]init];
        sellerManagementVC.idNumber = value;
        [navigationController pushViewController:sellerManagementVC animated:YES];
    }else if ([module isEqualToString:@"userposition"]){
        //足迹详情
        LocationDetailViewController * vc = [[LocationDetailViewController alloc]init];
        vc.ID = value;
        [navigationController pushViewController:vc animated:YES];
    }else if ([module isEqualToString:@"inviteguarantee"]){
        //邀请担保详情
        GuaranteeDetailViewController * guaranteeVC = [[GuaranteeDetailViewController alloc]init];
        guaranteeVC.orderID = value;
        [navigationController pushViewController:guaranteeVC animated:YES];
    }else if ([module isEqualToString:@"userinfo"]){
        //个人主页
        SubViewController * personalVC = [[SubViewController alloc]init];
        personalVC.account = value;
        personalVC.myRun = @"2";
        [navigationController pushViewController:personalVC animated:YES];
    }else if ([module isEqualToString:@"userrecommend"]){
        //发现熟人
        SubAddressBookListActivityViewController * subAddress = [[SubAddressBookListActivityViewController alloc]init];
        [navigationController pushViewController:subAddress animated:YES];
    }else if ([module isEqualToString:@"usertopic"]) {
        //话题
        TopicDetailListController *detail = [[TopicDetailListController alloc] init];
        detail.modelId = value;
        [navigationController pushViewController:detail animated:YES];
    }else if ([module isEqualToString:@"usertopiccomment"]) {
        //话题
        TopicDetailListController *detail = [[TopicDetailListController alloc] init];
        detail.modelId = value;
        [navigationController pushViewController:detail animated:NO];
        //话题评论
        TopicCommentListController *vc = [[TopicCommentListController alloc] init];
        vc.modelID = value;
        [navigationController pushViewController:vc animated:YES];
    }else if ([module isEqualToString:@"taskorder"]) {
        //求购单
        OrderDetailController *vc = [[OrderDetailController alloc] init];
        vc.orderID = value;
        [navigationController pushViewController:vc animated:YES];
    }else if ([module isEqualToString:@"sellertask"]) {
        //我的代购
        PersonalHelpSPController *vc = [[PersonalHelpSPController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }else if ([module isEqualToString:@"buyertask"]) {
        //我的代购
        PersonalSPController *vc = [[PersonalSPController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
}
@end
