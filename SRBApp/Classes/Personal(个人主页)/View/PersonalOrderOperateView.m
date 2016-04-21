//
//  PersonalOrderOperateView.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/23.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "PersonalOrderOperateView.h"
#import "PersonalOrderOperateButton.h"
#define FONT [UIFont systemFontOfSize:12.0]
@implementation PersonalOrderOperateView

-(id)initWithFrame:(CGRect)frame OrderStatus:(NSString *)orderStatus CurrentViewController:(UIViewController *)currentVC BussinessModel:(BussinessModel *)bussinessModel{
    if (self = [super initWithFrame:frame]) {
        //根据不同状态产生不同操作按钮
        NSArray *titleArray = nil;
        if ([bussinessModel.account isEqualToString:ACCOUNT_SELF]) {
            //我的求购
            if ([orderStatus isEqualToString:@"0"] || [orderStatus isEqualToString:@"20"]) {
                //待接单-刷新，取消求购
                titleArray = @[REFRESH, CANCEL];
            }else if ([orderStatus isEqualToString:@"-20"]) {
                //待接单-再次求购，删除
                titleArray = @[RESP, DELETE];
            }else if ([@[@"10", @"-40", @"-41"] containsObject:orderStatus]) {
                //待报价-取消求购，发布商品-催单
                titleArray = @[REMINDER_GOODS, CANCEL_REFUND_PAYED_DEPOSIT];
            }else if ([@[@"40", @"41"] containsObject:orderStatus]) {
                //待付款-取消求购，拒绝，查看
                titleArray = @[SCAN, REJECT, CANCEL_REFUND_PAYED_DEPOSIT];
            }else if ([orderStatus isEqualToString:@"42"]) {
                //待采购-提醒采购，取消求购
                titleArray = @[REMINDER_PIC, CANCEL_REFUND_PAYED_PRICE];
            }else if ([orderStatus isEqualToString:@"46"]) {
                //待发货-取消求购，提醒发货，查看
                titleArray = @[SCAN_CANNOTBUY,REMIND_DELIVERY, CANCEL_REFUND_PAYED_PRICE];
            }else if ([orderStatus isEqualToString:@"48"]) {
                //待收货-取消求购，查看物流，确认收货
                titleArray = @[CONFIRM_RECEIPT,VIEW_LOGISTICS, CANCEL_REFUND_PAYED_PRICE];
            }else if ([orderStatus isEqualToString:@"50"] || [orderStatus isEqualToString:@"62"]) {
                //待评价-评价，查看物流，删除
                titleArray = @[EVALUATION,VIEW_LOGISTICS];
            }else if ([orderStatus isEqualToString:@"-13"]) {
                //已取消-(卖家申请取消)，同意，申诉
                titleArray = @[AGREE, APPEAL, SCAN];
            }else if ([orderStatus isEqualToString:@"-10"]) {
                //已取消-（已经取消），删除
                titleArray = @[HSP_CANCLE_DELETE];
            }else if ([orderStatus isEqualToString:@"-11"]) {
                //已取消-(买家申请取消)，查看
                titleArray = @[SCAN];
            }else if ([orderStatus isEqualToString:@"-15"]) {
                //已取消-(交易关闭)，申诉
                titleArray = @[HSP_CANCLE_DELETE,SCAN];
            }else if ([orderStatus isEqualToString:@"35"]) {
                //已取消-(买家申请取消)，付款，取消求购
                titleArray = @[PAY, CANCEL_REFUND_PAYED_PRICE];
            }else if ([@[@"60", @"61", @"62", @"70"] containsObject:orderStatus]) {
                //已完成-查看评价
                titleArray = @[SCAN_EVALUATE];
            }
            
        }else if ([orderStatus isEqualToString:APPLY_HELPSP_STATUS]) {
            //求购申请单
             titleArray = @[RECEIVE, IGNORE];
        }else {
            if ([@[@"0", @"20", @"-20"] containsObject:orderStatus]) {
                //我的代购-申请中，取消申请，删除
                NSDictionary *bid = bussinessModel.bid;
                if ([bid[@"status"] isEqualToString:@"0"] || [bid[@"status"] isEqualToString:@"1"]) {
                    titleArray = @[CANCEL_APPLY];
                }else if ([bid[@"status"] isEqualToString:@"2"] || [bid[@"status"] isEqualToString:@"-1"]) {
                    titleArray = @[HSP_DELETE];
                }else {
                    titleArray = @[CANCEL_APPLY];
                }
            }else if([orderStatus isEqualToString:@"10"]) {
                //我的代购-待报价，报价，取消代购
                titleArray = @[QUOTE_PRICE, HSP_CANCEL];
            }else if([@[@"40", @"41"] containsObject:orderStatus]) {
                //我的代购-待付款，查看，取消代购
                titleArray = @[SCAN, HSP_CANCEL];
            }else if([orderStatus isEqualToString:@"35"]) {
                    //我的代购-待付款(下完单)，改价，付款催单，取消代购
                    titleArray = @[CHANGETHEPRICE, HSP_REMINDER_PAY, HSP_CANCEL];
            }else if ([@[@"-40", @"-41"] containsObject:orderStatus]) {
                //我的代购-待报价，修改商品，查看，取消代购
                titleArray = @[CHANGE_QUOTE, SCAN, HSP_CANCEL];
            }else if ([orderStatus isEqualToString:@"42"]) {
                //我的代购-待采购，采购成功，采购失败
                titleArray = @[PURCHASE_SUCCESS, PURCHASE_FAILED];
            }else if ([orderStatus isEqualToString:@"46"]) {
                //我的代购-待发货，发货，取消代购
                titleArray = @[DELIVERY, HSP_CANCEL];
            }else if ([orderStatus isEqualToString:@"48"]) {
                //我的代购-待收货，取消代购，修改物流，查看物流
                titleArray = @[VIEW_LOGISTICS, MODIFY_LOGISTICS, HSP_CANCEL];
            }else if ([orderStatus isEqualToString:@"50"] || [orderStatus isEqualToString:@"61"]) {
                //我的代购-待评价，评价，查看物流，删除
                titleArray = @[HSPEVALUATION, VIEW_LOGISTICS];
            }else if ([orderStatus isEqualToString:@"-10"]) {
                //已取消-删除
                titleArray = @[HSP_CANCLE_DELETE];
            }else if ([orderStatus isEqualToString:@"-11"]) {
                //已取消-(卖家申请取消)，同意，申诉
                titleArray = @[HSP_AGREE, APPEAL, SCAN];
            }else if ([orderStatus isEqualToString:@"-13"]) {
                //已取消-(买家申请取消)，查看
                titleArray = @[SCAN];
            }else if ([orderStatus isEqualToString:@"-15"]) {
                //已取消-(交易关闭)，申诉
                titleArray = @[HSP_CANCLE_DELETE,SCAN];
            }else if ([@[@"60", @"61", @"62", @"70"] containsObject:orderStatus]) {
                //已完成-查看评价
                titleArray = @[HSP_SCAN_EVALUATE];
            }
            
        }
        
        float space = 10;
        float width = 0;
        for (int i=0; i<titleArray.count; i++) {
            CGSize size = [[PersonalOrderOperateButton getButtonName:titleArray[i]] sizeWithAttributes:@{NSFontAttributeName:FONT,NSPaperSizeDocumentAttribute:[NSValue valueWithCGSize:CGSizeMake(MAXFLOAT, 25)]}];
            size.width += 14.0;
            float y = 8.0;
            PersonalOrderOperateButton *btn = [[PersonalOrderOperateButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(frame) - size.width - space - width, y, size.width, CGRectGetHeight(frame) - 2 * y) TypeName:titleArray[i] BussinessModel:bussinessModel];
            btn.titleLabel.font = FONT;
            width += (size.width + space);
            btn.currentVC = currentVC;
            btn.delegate = currentVC;
            [self addSubview:btn];
        }
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
