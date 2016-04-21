//
//  PersonalOrderOperateButton.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define REJECT_REASON1 @"商品信息错误"
#define REJECT_REASON2 @"商品价格未达成一致"

#define CANCEL_PAYDEPOSIT_ALERTMSG @"请选择是否退还押金及取消交易的理由："
#define CANCEL_PAYPRICE_ALERTMSG @"对方同意您的取消申请后将自动退还您的商品价款，请选择是否退还押金及取消交易的理由："


#import "PersonalOrderOperateButton.h"

@interface PersonalOrderOperateButton ()
{
    NSString *_type;
    BussinessModel *_bussinessModel;
}
@end
@implementation PersonalOrderOperateButton

-(id)initWithFrame:(CGRect)frame TypeName:(NSString *)type BussinessModel:(BussinessModel *)bussinessModel {
    if (self = [super initWithFrame:frame]) {
        
        _type = type;
        _bussinessModel = bussinessModel;
        [self setTitle:[PersonalOrderOperateButton getButtonName:type] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.backgroundColor = [self getBackGroundColor];
        self.layer.cornerRadius = CGRectGetHeight(self.frame) * 0.5;
    }
    return self;
}
+(NSString *)getButtonName:(NSString *)type {
    NSString *typeName = @"";
    if ([@[CANCEL, CANCEL_REFUND_PAYED_DEPOSIT, CANCEL_REFUND_PAYED_PRICE] containsObject:type]) {
        typeName = @"取消求购";
    }else if ([type isEqualToString:REFRESH]) {
        typeName = @"刷新";
    }else if ([@[DELETE, HSP_DELETE,HSP_CANCLE_DELETE] containsObject:type]) {
        typeName = @"删除";
    }else if ([type isEqualToString:RESP]) {
        typeName =  @"再次求购";
    }else if ([@[REMINDER_GOODS, REMINDER_PIC, REMINDER_TACK, HSP_REMINDER_PAY] containsObject:type]) {
        typeName =  @"催单";
    }else if ([type isEqualToString:REJECT]) {
        typeName = @"拒绝";
    }else if ([type isEqualToString:SCAN] || [type isEqualToString:SCAN_CANNOTBUY]) {
        typeName = @"查看";
    }else if ([type isEqualToString:CANCEL_APPLY]) {
        typeName = @"取消申请";
    }else if ([type isEqualToString:RE_TAKE_ORDER]) {
        typeName = @"再次接单";
    }else if ([type isEqualToString:HSP_CANCEL]) {
        typeName = @"取消代购";
    }else if ([type isEqualToString:QUOTE_PRICE]) {
        typeName = @"商品报价";
    }else if ([type isEqualToString:CHANGE_QUOTE]) {
        typeName = @"修改商品";
    }else if ([type isEqualToString:RECEIVE]) {
        typeName = @"接受";
    }else if ([type isEqualToString:IGNORE]) {
        typeName = @"忽略";
    }else if ([type isEqualToString:PURCHASE_SUCCESS]) {
        typeName = @"采购成功";
    }else if ([type isEqualToString:PURCHASE_FAILED]) {
        typeName = @"采购失败";
    }else if ([type isEqualToString:REMIND_DELIVERY]) {
        typeName = @"提醒发货";
    }else if ([type isEqualToString:DELIVERY]) {
        typeName = @"发货";
    }else if ([type isEqualToString:VIEW_LOGISTICS]) {
        typeName = @"查看物流";
    }else if ([type isEqualToString:CONFIRM_RECEIPT]) {
        typeName = @"确认收货";
    }else if ([type isEqualToString:REMINDER_RECEIPT]) {
        typeName = @"提醒收货";
    }else if ([type isEqualToString:HSPEVALUATION] || [type isEqualToString:EVALUATION]) {
        typeName = @"评价";
    }else if ([type isEqualToString:APPEAL]) {
        typeName = @"申诉";
    }else if ([type isEqualToString:REJECT_CANCEL]) {
        typeName = @"拒绝";
    }else if ([type isEqualToString:AGREE]) {
        typeName = @"同意";
    }else if ([type isEqualToString:HSP_AGREE]) {
        typeName = @"同意";
    }else if ([type isEqualToString:CHANGETHEPRICE]) {
        typeName = @"改价";
    }else if ([type isEqualToString:PAY]) {
        typeName = @"付款";
    }else if ([type isEqualToString:HSP_SCAN_EVALUATE] || [type isEqualToString:SCAN_EVALUATE]) {
        typeName = @"查看评价";
    }else if ([type isEqualToString:MODIFY_LOGISTICS]) {
        typeName = @"修改物流";
    }
    return typeName;
}
//获取背景颜色
-(UIColor *)getBackGroundColor {
    NSArray *statusArray = @[CANCEL, DELETE, HSP_DELETE,HSP_CANCLE_DELETE, CANCEL_APPLY, IGNORE, HSP_CANCEL, REJECT, CANCEL_REFUND_PAYED_PRICE, CANCEL_REFUND_PAYED_DEPOSIT, PURCHASE_FAILED, PURCHASE_FAILED, APPEAL,
    AGREE, HSP_AGREE];
    if ([statusArray containsObject:_type]) {
        return [UIColor colorWithRed:175/255.0 green:175/255.0 blue:175/255.0 alpha:1];
    }
    return MAINCOLOR;
}
//获取弹出框提示语
-(NSString *)getAlertMessage {
    if ([_type isEqualToString:CANCEL]) {
        return @"确定取消求购？";
    }else if ([_type isEqualToString:DELETE]|| [_type isEqualToString:HSP_DELETE]|| [_type isEqualToString:HSP_CANCLE_DELETE]) {
        return @"确定删除？";
    }else if ([_type isEqualToString:CANCEL_APPLY]) {
        return @"确定取消申请？";
    }else if ([_type isEqualToString:IGNORE]) {
        return @"忽略后将无法再次查看此代购申请，确定忽略？";
    }else if ([_type isEqualToString:HSP_CANCEL]) {
        return @"确定取消代购？";
    }else if ([_type isEqualToString:RECEIVE]) {
        return [NSString stringWithFormat:@"确定支付押金￥%@？", _bussinessModel.money];
    }else if ([_type isEqualToString:REJECT]) {
        return @"确定拒绝？";
    }else if ([_type isEqualToString:PURCHASE_FAILED]) {
        return @"押金、商品价款将退还\n确认采购失败";
    }else if ([_type isEqualToString:PURCHASE_SUCCESS]) {
        return @"请拍摄上传购物票据、产品编号购买到的实物细节等图片信息";
    }else if ([_type isEqualToString:CONFIRM_RECEIPT]) {
        return [NSString stringWithFormat:@"您支付的%@元将转至对方账户，押金将转回，请务必收到货后再确认！", _bussinessModel.taskCashCost];
    }else if ([_type isEqualToString:APPEAL]) {
        return @"请先与对方沟通，无法达成一致可再提交申诉！";
    }else if ([_type isEqualToString:AGREE] || [_type isEqualToString:HSP_AGREE]) {
        return @"确定同意？";
    }
//    else if ([_type isEqualToString:DELIVERY] || [_type isEqualToString:MODIFY_LOGISTICS]) {
//        return @"您与求购人以自提方式交货？";
//    }
    return @"";
}
//按钮点击
-(void)btnClicked {
//    NSArray *statusArray = @[CANCEL, DELETE, HSP_DELETE, CANCEL_APPLY, IGNORE, RECEIVE, PURCHASE_FAILED, PURCHASE_SUCCESS, CONFIRM_RECEIPT, AGREE, HSP_AGREE, DELIVERY, MODIFY_LOGISTICS];
    NSArray *statusArray = @[CANCEL, DELETE, HSP_DELETE,HSP_CANCLE_DELETE, CANCEL_APPLY, IGNORE, RECEIVE, PURCHASE_FAILED, PURCHASE_SUCCESS, CONFIRM_RECEIPT, AGREE, HSP_AGREE];
    if ([statusArray containsObject:_type]) {
        [self showAlertWithMessage:[self getAlertMessage]];
    }else if ([_type isEqualToString:REFRESH]) {
        //我的求购-刷新
        [self orderRefreshRequest];
    }else if ([_type isEqualToString:RESP]) {
        //我的求购-再次求购
        [self reSP];
    }else if ([_type isEqualToString:REMINDER_GOODS]) {
        //我的求购-发布商品催单
        [self reminderGoodsRequest];
    }else if ([_type isEqualToString:QUOTE_PRICE]) {
        //我的代购-商品报价
        [self quotePrice];
    }else if ([_type isEqualToString:SCAN]) {
        //我的代购-查看
        [self scan];
    }else if ([_type isEqualToString:HSP_REMINDER_PAY]) {
        //我的代购-付款催单
        [self helpSPReminderPayRequest];
    }else if ([_type isEqualToString:CHANGE_QUOTE]) {
        //我的代购-修改报价
        [self changePrice];
    }else if ([_type isEqualToString:REMINDER_PIC]) {
        //我的求购-采购催单
        [self reminderPicRequest];
    }else if ([_type isEqualToString:REMINDER_TACK]) {
        //我的求购-发货催单
        [self reminderTackRequest];
    }else if ([_type isEqualToString:REJECT]) {
        //我的求购-拒绝
        [self showRejectAlertSheet];
    }else if ([_type isEqualToString:REMIND_DELIVERY]) {
        //我的求购-提醒发货
        [self reminderTackRequest];
    }else if ([_type isEqualToString:EVALUATION]) {
        //我的求购-评价
        [self evaluate];
    }else if ([_type isEqualToString:HSPEVALUATION]) {
        //我的代购-评价
        [self hspEvaluate];
    }else if ([_type isEqualToString:VIEW_LOGISTICS]) {
        //查看物流
        [self viewLogistics];
    }else if ([_type isEqualToString:SCAN_CANNOTBUY]) {
        //查看-不可购买
        [self scanCanNotBuy];
    }else if ([_type isEqualToString:CANCEL_REFUND_PAYED_PRICE]) {
        //取消求购-付完款了
        [self cancelRefundPayedPrice];
    }else if ([_type isEqualToString:CANCEL_REFUND_PAYED_DEPOSIT]) {
        //取消求购-付完款了
        [self cancelRefundPayedDeposit];
    }else if ([_type isEqualToString:APPEAL]) {
        //申诉
        [self appeal];
    }else if ([_type isEqualToString:HSP_CANCEL]) {
        //取消代购
        [self helpSPCancel];
    }else if ([_type isEqualToString:CHANGETHEPRICE]) {
        //改价
        [self changeThePrice];
    }else if ([_type isEqualToString:PAY]) {
        //付款
        [self pay];
    }else if ([_type isEqualToString:SCAN_EVALUATE]) {
        //查看评价
        [self scanEvaluate];
    }else if ([_type isEqualToString:HSP_SCAN_EVALUATE]) {
        //代购方-查看评价
        [self hspScanEvaluate];
    }else if ([_type isEqualToString:MODIFY_LOGISTICS]) {
        //代购方-修改物流
        //[self modifyLogistics];
        [self modifyLogisticsNO];
    }else if ([_type isEqualToString:DELIVERY]) {
            //发货
            [self delivery];
        }
}
//alert view 选择事件
-(void)alertOkClicked {
    //求购方
    if ([_type isEqualToString:CANCEL]) {
        [self cancel];
    }else if ([_type isEqualToString:DELETE]) {
        [self delete];
    }else if ([_type isEqualToString:CONFIRM_RECEIPT]) {
        [self confirmReceiptRequest];
    }else if ([_type isEqualToString:AGREE]) {
        [self agreeRequest];
    }
    
    //代购方
    if ([_type isEqualToString:CANCEL_APPLY]) {
        [self helpSPCancelApply];
    }else if ([_type isEqualToString:HSP_DELETE]) {
        [self helpSPdelete];
    }else if ([_type isEqualToString:HSP_CANCLE_DELETE]) {
        [self helpSPCancledelete];
    }else if ([_type isEqualToString:PURCHASE_FAILED]) {
        //我的代购-采购失败
        [self puchaseHelpSPFailedRequest];
    }else if ([_type isEqualToString:PURCHASE_SUCCESS]) {
        //我的代购-采购成功
        [self puchaseHelpSPSuccess];
    }else if ([_type isEqualToString:HSP_AGREE]) {
        [self hspAgreeRequest];
    }
//    else if ([_type isEqualToString:DELIVERY]) {
//        //发货自提
//        [self deliverySinceRequest];
//    }else if ([_type isEqualToString:MODIFY_LOGISTICS]) {
//        [self modifyLogistics];
//    }
    
    //求购申请单
    if ([_type isEqualToString:IGNORE]) {
        [self ignore];
    }else if ([_type isEqualToString:RECEIVE]) {
        [self receiveRequest];
    }
}
-(void)alertCancelClicked {
//    if ([_type isEqualToString:DELIVERY]) {
//        //发货
//        [self delivery];
//    }else if ([_type isEqualToString:MODIFY_LOGISTICS]) {
//        [self modifyLogisticsNO];
//    }
}
//弹出选择器(我的求购-拒绝)
-(void)showRejectAlertSheet {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertSheet addAction:[UIAlertAction actionWithTitle:REJECT_REASON1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self alertButtonAtIndex:0];
        }]];
        
        [alertSheet addAction:[UIAlertAction actionWithTitle:REJECT_REASON2 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self alertButtonAtIndex:1];
        }]];
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
        [self.currentVC presentViewController:alertSheet animated:YES completion:nil];
    }else {
        UIActionSheet *alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:REJECT_REASON1,REJECT_REASON2, nil];
        [alertSheet showInView:self.currentVC.view];
    }
}
-(void)alertButtonAtIndex:(int)index {
    if (index == 0) {
        [self orderRejectRequest:REJECT_REASON1];
    }else if (index == 1) {
        [self orderRejectRequest:REJECT_REASON2];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self alertButtonAtIndex:(int)buttonIndex];
}
//弹出框
-(void)showAlertWithMessage:(NSString *)message {
    NSString *cancel = @"取消";
    NSString *confirm = @"确定";
//    if ([@[DELIVERY, IGNORE, MODIFY_LOGISTICS] containsObject:_type]) {
//        cancel = @"否";
//        confirm = @"是";
//    }
        if ([@[IGNORE] containsObject:_type]) {
            cancel = @"否";
            confirm = @"是";
        }
    if (down_IOS_8) {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:cancel otherButtonTitles:confirm, nil];
        alert.tag = 1000;
        [alert show];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self alertOkClicked];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self alertCancelClicked];
        }]];
        [self.currentVC presentViewController:alert animated:YES completion:nil];
    }
}
-(void)showNoMoneyAlert:(NSString *)balance {
    NSString *message = [NSString stringWithFormat:@"您的账户余额￥%@元，不足以支付押金，立即充值？", balance];
    if (down_IOS_8) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1001;
        [alert show];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self noMoneyAlertOkClicked];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self.currentVC presentViewController:alert animated:YES completion:nil];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            [self alertOkClicked];
        }else {
            [self alertCancelClicked];
            
        }
    }else if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self noMoneyAlertOkClicked];
        }
    }
    
}
-(void)noMoneyAlertOkClicked {
    if ([self.delegate respondsToSelector:@selector(noMoneyWithBussinessModel)]) {
        [self.delegate noMoneyWithBussinessModel];
    }
}
#pragma mark- 执行事件
#pragma mark- 求购方
//取消求购单
-(void)cancel {
    [self orderCancelRequest];
}
-(void)cancelRefundPayedPrice {
    //付完款了取消求购
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPayedPriceWithBussinessModel:AlertMsg:)]) {
        [self.delegate cancelPayedPriceWithBussinessModel:_bussinessModel AlertMsg:CANCEL_PAYPRICE_ALERTMSG];
    }
}
-(void)cancelRefundPayedDeposit {
    //付完押金了取消求购
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPayedDepositWithBussinessModel:AlertMsg:)]) {
        [self.delegate cancelPayedDepositWithBussinessModel:_bussinessModel AlertMsg:CANCEL_PAYDEPOSIT_ALERTMSG];
    }
    
}
//删除求购单
-(void)delete {
    [self orderDeleteRequest];
}
//再次求购
-(void)reSP {
    if (self.delegate && [self.delegate respondsToSelector:@selector(reSPWithBussinessModel:)]) {
        [self.delegate reSPWithBussinessModel:_bussinessModel];
    }
}

//查看
-(void)scan {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanWithBussinessModel:)]) {
        [self.delegate scanWithBussinessModel:_bussinessModel];
    }
}
//查看-不可购买
-(void)scanCanNotBuy {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanCanNotBuyWithBussinessModel:)]) {
        [self.delegate scanCanNotBuyWithBussinessModel:_bussinessModel];
    }
}
//修改报价
-(void)changePrice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changePriceWithBussinessModel:)]) {
        [self.delegate changePriceWithBussinessModel:_bussinessModel];
    }
}
//评价
-(void)evaluate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(commentWithBussinessModel:)]) {
        [self.delegate commentWithBussinessModel:_bussinessModel];
    }
}
//申诉
-(void)appeal {
    if (self.delegate && [self.delegate respondsToSelector:@selector(appealWithBussinessModel:)]) {
        [self.delegate appealWithBussinessModel:_bussinessModel];
    }
}
//付款
-(void)pay {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(payWithBussinessModel:)]) {
        [self.delegate payWithBussinessModel:_bussinessModel];
    }
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.currentVC.view animated:YES];
//    hud.labelText = @"正在验证付款状态,请稍后...";
//    hud.dimBackground = YES;
//    [hud show:YES];
//    
//    //验证是否可以付款
//    NSDictionary * param = [self parametersForDic:@"accountCheckPayOrder" parameters:@{ACCOUNT_PASSWORD,@"orderId":_bussinessModel.taskOrderFormId}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        [hud removeFromSuperview];
//        if ([result isEqualToString:@"0"]) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(payWithBussinessModel:)]) {
//                [self.delegate payWithBussinessModel:_bussinessModel];
//            }
//        }else if ([result isEqualToString:@"4030001"]){
//            [self noMoneyAlertOkClicked];
//        }else{
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//    } andFailureBlock:^{
//        [hud removeFromSuperview];
//    }];
    
    
}
//查看评价
-(void)scanEvaluate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanEvaluateWithBussinessModel:)]) {
        [self.delegate scanEvaluateWithBussinessModel:_bussinessModel];
    }
}
#pragma mark- 代购方
//取消代购申请
-(void)helpSPCancelApply {
    [self helpSPOrderCancelApplyRequest];
}
//删除求购单
-(void)helpSPdelete {
    [self helpSPOrderDeleteRequest];
}
//删除已取消求购单
-(void)helpSPCancledelete {
    [self helpSPOrderCancleDeleteRequest];
}
//取消代购
-(void)helpSPCancel {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelPayedDepositWithBussinessModel:AlertMsg:)]) {
        [self.delegate hspCancelWithBussinessModel:_bussinessModel AlertMsg:CANCEL_PAYDEPOSIT_ALERTMSG];
    }
    
    //[self helpSPOrderCancelRequest];
}
//商品报价
-(void)quotePrice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(quotePriceWithBussinessModel:)]) {
        [self.delegate quotePriceWithBussinessModel:_bussinessModel];
    }
}
//发货
-(void)delivery {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deliveryWithBussinessModel:)]) {
        [self.delegate deliveryWithBussinessModel:_bussinessModel];
    }
}
//评价
-(void)hspEvaluate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hspCommentWithBussinessModel:)]) {
        [self.delegate hspCommentWithBussinessModel:_bussinessModel];
    }
}
//查看评价
-(void)hspScanEvaluate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(hspScanEvaluateWithBussinessModel:)]) {
        [self.delegate hspScanEvaluateWithBussinessModel:_bussinessModel];
    }
}
#pragma mark- 代购申请
-(void)ignore {
    
    
    [self ignoreRequest];
}
#pragma mark- 网络请求
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}
//求购方
#pragma mark- 求购方
//取消求购
-(void)orderCancelRequest {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountBuyPostCancel" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelWithBussinessModel:)]) {
                [self.delegate cancelWithBussinessModel:_bussinessModel];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
    }];
}
//删除
-(void)orderDeleteRequest {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountBuyPostDelete" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithBussinessModel:)]) {
                [self.delegate deleteWithBussinessModel:_bussinessModel];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
    }];
}
//拒绝
-(void)orderRejectRequest:(NSString *)reason {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.currentVC.view animated:YES];
    hud.labelText = @"刷新中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountBuyPostDisagreePrice" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id, @"note": reason}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        [hud removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithBussinessModel:)]) {
                [self.delegate deleteWithBussinessModel:_bussinessModel];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
        [hud removeFromSuperview];
    }];
}
//刷新
-(void)orderRefreshRequest {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.currentVC.view animated:YES];
    hud.labelText = @"刷新中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountBuyPostRefresh" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        [hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
           
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                [self.delegate reloadData];
            }
            [AutoDismissAlert autoDismissAlert:@"刷新成功"];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
        }
    } andFailureBlock:^{
        [hud removeFromSuperview];
    }];
}
//发布商品催单
-(void)reminderGoodsRequest {
    NSDictionary * param = [self parametersForDic:@"accountBuyPostPushPublish" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
    }];
}
//采购催单
-(void)reminderPicRequest {
        NSDictionary * param = [self parametersForDic:@"accountBuyPostPushPick" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
        //发送post请求
        [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
            NSLog(@"%@",[dic objectForKey:@"message"]);
            NSString * result = [dic objectForKey:@"result"];
            if ([result isEqualToString:@"0"]) {
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }else{
                [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            }
        } andFailureBlock:^{
        }];
}
//发货催单
-(void)reminderTackRequest {
    NSDictionary * param = [self parametersForDic:@"accountBuyPostPushTack" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
    }];
    
}
//确认收货
-(void)confirmReceiptRequest {
    NSDictionary * param = [self parametersForDic:@"accountSetOrderTake" parameters:@{ACCOUNT_PASSWORD, @"orderId": _bussinessModel.taskOrderFormId}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SPOrderContirmReceiptNF" object:nil];
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
    }];
}
//同意
-(void)agreeRequest {
    NSDictionary * param = [self parametersForDic:@"accountBuyPostAccept" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id, @"code": @"yes"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                [self.delegate reloadData];
            }
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
    }];
}
-(void)changeThePrice {
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeThePriceWithBussinessModel:)]) {
        [self.delegate changeThePriceWithBussinessModel:_bussinessModel];
    }
}
-(void)modifyLogistics {
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyLogisticsWithBussinessModel:)]) {
        [self.delegate modifyLogisticsWithBussinessModel:_bussinessModel];
    }
}
-(void)modifyLogisticsNO {
    if (self.delegate && [self.delegate respondsToSelector:@selector(modifyLogisticsNOWithBussinessModel:)]) {
        [self.delegate modifyLogisticsNOWithBussinessModel:_bussinessModel];
    }
}
#pragma mark- 代购方
//取消代购申请
-(void)helpSPOrderCancelApplyRequest {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountTaskCancel" parameters:@{ACCOUNT_PASSWORD, @"taskBid": _bussinessModel.bid[@"taskBid"]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelWithBussinessModel:)]) {
                [self.delegate cancelWithBussinessModel:_bussinessModel];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
    }];
}
//取消代购
-(void)helpSPOrderCancelRequest {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountBidPostCancel" parameters:@{ACCOUNT_PASSWORD, @"taskBid": _bussinessModel.bid[@"taskBid"]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
    }];
}
//删除
-(void)helpSPOrderDeleteRequest {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountTaskDelete" parameters:@{ACCOUNT_PASSWORD, @"taskBid": _bussinessModel.bid[@"taskBid"]}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithBussinessModel:)]) {
                [self.delegate deleteWithBussinessModel:_bussinessModel];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
    }];
}
//删除已取消求购单
-(void)helpSPOrderCancleDeleteRequest {
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountDeleteTask" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithBussinessModel:)]) {
                [self.delegate deleteWithBussinessModel:_bussinessModel];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
    }];
}
//付款催单
-(void)helpSPReminderPayRequest {
    NSDictionary * param = [self parametersForDic:@"accountBidPostPushPay" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
    }];
    
}
//采购失败
-(void)puchaseHelpSPFailedRequest {
    NSDictionary * param = [self parametersForDic:@"accountBidPostPurchase" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id, @"goodsId": _bussinessModel.taskDealPostId, @"code": @"no"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithBussinessModel:)]) {
                [self.delegate deleteWithBussinessModel:_bussinessModel];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
    }];
    
}
//采购成功
-(void)puchaseHelpSPSuccess {
    if (self.delegate && [self.delegate respondsToSelector:@selector(purchaiseSuccessWithBussinessModel:)]) {
        [self.delegate purchaiseSuccessWithBussinessModel:_bussinessModel];
    }
}
//查看物流
-(void)viewLogistics {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewLogistisWithBussinessModel:)]) {
        [self.delegate viewLogistisWithBussinessModel:_bussinessModel];
    }
}
//同意
-(void)hspAgreeRequest {
    NSDictionary * param = [self parametersForDic:@"accountBidPostAccept" parameters:@{ACCOUNT_PASSWORD, @"id": _bussinessModel.model_id, @"code": @"yes"}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(reloadData)]) {
                [self.delegate reloadData];
            }
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    } andFailureBlock:^{
    }];
}
////发货自提
//-(void)deliverySinceRequest {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.currentVC.view animated:YES];
//    hud.labelText = @"提交中,请稍后";
//    hud.dimBackground = YES;
//    [hud show:YES];
//    
//    NSDictionary * dic = [self parametersForDic:@"sellerSetOrderTake" parameters:@{ACCOUNT_PASSWORD,@"orderId":_bussinessModel.taskOrderFormId,@"invoiceName":@"0",@"invoiceNo":@"0"}];
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        [hud removeFromSuperview];
//        if ([result isEqualToString:@"0"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"SPOrderDeliveryCompletedNF" object:nil];
//            if (self.delegate && [self.delegate respondsToSelector:@selector(deliverySinceWithBussinessModel:)]) {
//                [self.delegate deliverySinceWithBussinessModel:_bussinessModel];
//            }
//        }else{
//            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
//        }
//    } andFailureBlock:^{
//        [hud removeFromSuperview];
//    }];
//}
#pragma mark- 忽略
-(void)ignoreRequest{
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountTaskThank" parameters:@{ACCOUNT_PASSWORD, @"taskBid": _bussinessModel.taskBid}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWithBussinessModel:)]) {
                [self.delegate deleteWithBussinessModel:_bussinessModel];
            }
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            //[hud removeFromSuperview];
        }
    } andFailureBlock:^{
        //[hud removeFromSuperview];
    }];
}
-(void)receiveRequest {
    //拼接post参数
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.currentVC.view animated:YES];
    hud.labelText = @"支付中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    NSDictionary * param = [self parametersForDic:@"accountTaskWin" parameters:@{ACCOUNT_PASSWORD, @"taskBid": _bussinessModel.taskBid}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        NSLog(@"%@",[dic objectForKey:@"message"]);
        NSString * result = [dic objectForKey:@"result"];
        [hud removeFromSuperview];
        if ([result isEqualToString:@"0"]) {
            [AutoDismissAlert autoDismissAlertSecond:@"付款成功"];
            if (self.delegate && [self.delegate respondsToSelector:@selector(receiveWithBussinessModel:)]) {
                [self.delegate receiveWithBussinessModel:_bussinessModel];
            }
        }else if ([result isEqualToString:@"4030001"]) {
            //余额不足
            [self showNoMoneyAlert:dic[@"data"][@"balance"]];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            
        }
    } andFailureBlock:^{
        [hud removeFromSuperview];
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
