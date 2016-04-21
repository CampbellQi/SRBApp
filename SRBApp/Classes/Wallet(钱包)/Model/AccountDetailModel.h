//
//  AccountDetailModel.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/22.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountDetailModel : NSObject
@property (nonatomic, strong)NSString * model_id;
@property (nonatomic, strong)NSString * memo;
@property (nonatomic, strong)NSString * price;
@property (nonatomic, strong)NSString * model_type;
@property (nonatomic, strong)NSString * updatetime;
@property (nonatomic, assign)double updatetimeLong;
@end
