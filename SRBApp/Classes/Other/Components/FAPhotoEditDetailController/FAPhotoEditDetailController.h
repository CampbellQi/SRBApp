//
//  FAPhotoShowDetailController.h
//  FArts
//
//  Created by zhanShen3 on 15/5/28.
//  Copyright (c) 2015年 com.uwny. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EditImageBlock)(NSMutableArray *imgArray); ;


@interface FAPhotoEditDetailController : UIViewController

@property (nonatomic, copy) EditImageBlock editImageBlock;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end
