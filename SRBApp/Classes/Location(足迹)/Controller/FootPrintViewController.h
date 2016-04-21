//
//  FootPrintViewController.h
//  SRBApp
//
//  Created by lizhen on 15/1/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^refreshBlock) ();
/**
 *  @brief  足迹,包含关系圈和熟人圈
 */
@interface FootPrintViewController : UIViewController
{
    BOOL secondVC;
}
@property (nonatomic, strong) NSString *type;
@property (nonatomic,copy)refreshBlock refreshblock;
@end
