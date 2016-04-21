//
//  ReceiveGoodsTableViewCell.m
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ReceiveGoodsTableViewCell.h"
#import "GetColor16.h"

@implementation ReceiveGoodsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        //收货人
//        self.receivePeopleLB = [[UILabel alloc] initWithFrame:CGRectMake(25, 12, 65, 19)];
//        self.receivePeopleLB.text = @"收货人:";
//        self.receivePeopleLB.font = [UIFont systemFontOfSize:18];
//        self.receivePeopleLB.textAlignment = NSTextAlignmentCenter;
////        receivePeopleLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
//        [self addSubview:self.receivePeopleLB];
        
        //姓名
        //UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(95, 10, SCREEN_WIDTH - 95 - 15, 21)];
        UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, 90, 21)];
        nameLB.font = [UIFont systemFontOfSize:18];
        self.receivePeople = nameLB;
        nameLB.textAlignment = NSTextAlignmentLeft;
        //nameLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
        [self addSubview:nameLB];
        
        //电话
        //UILabel *phoneDetailLB = [[UILabel alloc] initWithFrame:CGRectMake(95, 43, 180, 14)];
        UILabel *phoneDetailLB = [[UILabel alloc] initWithFrame:CGRectMake(115, 18, SCREEN_WIDTH - 30 - 100, 14)];
        phoneDetailLB.font = [UIFont systemFontOfSize:14];
        phoneDetailLB.textAlignment = NSTextAlignmentLeft;
        self.mobile = phoneDetailLB;
        //        phoneDetailLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
        [self addSubview:phoneDetailLB];
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, CGRectGetMinY(nameLB.frame) - 8, 30, 30)];
        [editBtn setImage:[UIImage imageNamed:@"sp_edit_goods"] forState:UIControlStateNormal];
        self.editBtn = editBtn;
        [editBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:editBtn];
//        //联系电话
//        self.phoneLB = [[UILabel alloc] initWithFrame:CGRectMake(25, 43, 65, 14)];
//        self.phoneLB.text = @"联系电话:";
//        self.phoneLB.font = [UIFont systemFontOfSize:14];
//        self.phoneLB.textAlignment = NSTextAlignmentCenter;
////        phoneLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
//        [self addSubview:self.phoneLB];
        

        
//        //收货地址
//        self.receiveAddrLB = [[UILabel alloc] initWithFrame:CGRectMake(25, 69, 65, 14)];
//        self.receiveAddrLB.text = @"收货地址:";
//        self.receiveAddrLB.font = [UIFont systemFontOfSize:14];
//        self.receiveAddrLB.textAlignment = NSTextAlignmentCenter;
////        receiveAddrLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
//        [self addSubview:self.receiveAddrLB];
        
        //地址
        //UILabel *addressLB = [[UILabel alloc] initWithFrame:CGRectMake(95, 66, SCREEN_WIDTH - 95 - 15, 17)];
        UILabel *addressLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 45, SCREEN_WIDTH - 15 - 40, 35)];
        addressLB.font = [UIFont systemFontOfSize:14];
        addressLB.textAlignment = NSTextAlignmentLeft;
        addressLB.numberOfLines = 0;
        addressLB.lineBreakMode = NSLineBreakByCharWrapping;
        self.receiveAddress = addressLB;
//        addressLB.textColor = [GetColor16 hexStringToColor:[NSString stringWithFormat:@"#434343"]];
        [self addSubview:addressLB];
    }
    return self;
}
-(void)editBtnClicked {
    if (self.editBlock) {
        self.editBlock(self.indexpath);
    }
}

@end
