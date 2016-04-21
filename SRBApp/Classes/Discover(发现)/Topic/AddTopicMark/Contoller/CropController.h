//
//  CropController.h
//  testImageEdit
//
//  Created by fengwanqi on 15/10/15.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageCropper.h"
#import "FilterController.h"

@interface CropController : UIViewController<ImageCropperDelegate>
- (IBAction)cancelClicked:(id)sender;
- (IBAction)nextClicked:(id)sender;

@property (nonatomic, strong)UIImage *sourceImage;

@property (nonatomic, copy)ComleteBlock comleteBlock;

@property (nonatomic, assign)int marksCount;
@end
