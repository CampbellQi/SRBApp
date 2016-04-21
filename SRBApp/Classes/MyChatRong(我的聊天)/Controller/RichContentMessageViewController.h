//
//  RichContentMessageViewController.h
//  SRBApp
//
//  Created by lizhen on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "RCChatViewController.h"

@interface RichContentMessageViewController : RCChatViewController
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *idNumber;
@property (nonatomic, strong) NSString *photo;//有图/无图
-(void)sendDebugRichMessage;

@end
