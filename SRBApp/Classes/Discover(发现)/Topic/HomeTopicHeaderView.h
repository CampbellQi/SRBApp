//
//  HomeTopicListHeaderView2.h
//  SRBApp
//
//  Created by fengwanqi on 16/1/29.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CAROUSEL_HEIGHT SCREEN_WIDTH / 320 * 160.0

enum CarsouselType {
    Position,
    Topic,
    Userpost,
    Tagindex
};
typedef void (^CarouselIVTap) (enum CarsouselType carsouselType, NSString *ID);

@interface HomeTopicHeaderView : UIView
@property (nonatomic, assign)float totalHeight;
@property (nonatomic, copy)CarouselIVTap carouselIVTap;

-(id)initWithFrame:(CGRect)frame CarouselArray:(NSArray *)carouselArray ToolbarArray:(NSArray *)toolbarArray;
@end
