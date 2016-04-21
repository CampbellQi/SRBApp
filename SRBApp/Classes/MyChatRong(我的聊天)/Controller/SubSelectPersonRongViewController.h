//
//  SubSelectPersonRongViewController.h
//  SRBApp
//
//  Created by lizhen on 15/2/28.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SelectPersonRongViewController.h"
typedef void (^AloneBlock)(NSString *type);

@interface SubSelectPersonRongViewController : SelectPersonRongViewController
@property (nonatomic, copy) AloneBlock aloneBlock;

- (void)alone:(AloneBlock)block;
@end
