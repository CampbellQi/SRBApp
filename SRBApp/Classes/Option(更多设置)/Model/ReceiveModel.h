//
//  ReceiveModel.h
//  SRBApp
//
//  Created by lizhen on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveModel : NSObject
@property (nonatomic, strong) NSString *receiver;   //收货人
@property (nonatomic, strong) NSString *mobile;     //联系电话
@property (nonatomic, strong) NSString *address;    //收货地址
@property (nonatomic, strong) NSString *iD;
@property (nonatomic, strong) NSString *isdefault;

@end
