//
//  MyLabel.h
//  SRBApp
//
//  Created by zxk on 15/1/13.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;
@interface MyLabel : UILabel
{
    @private VerticalAlignment _verticalAlignment;
}
@property (nonatomic) VerticalAlignment verticalAlignment;
@property (nonatomic, strong) NSIndexPath * indexpath;
@end
