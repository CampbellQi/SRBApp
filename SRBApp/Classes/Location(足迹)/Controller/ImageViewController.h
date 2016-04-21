//
//  ImageViewController.h
//  Car
//
//  Created by lizhen on 14-10-20.
//  Copyright (c) 2014年 Lizhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController
@property (nonatomic,retain) NSMutableArray *imageArray;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,assign)NSInteger imgIndex;     //图片下标
@property (nonatomic, assign)BOOL isDownBtnHide;
@end
