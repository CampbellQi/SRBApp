//
//  SubofclassImageViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 15/3/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubofclassImageViewController : UIViewController
@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,assign)NSInteger imgIndex;     //图片下标
@end
