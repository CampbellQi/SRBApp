//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "DWTagList.h"
#import "DWTagLabel.h"
#import <QuartzCore/QuartzCore.h>

#define CORNER_RADIUS 0.0f
#define LABEL_MARGIN 5.0f
#define BOTTOM_MARGIN 0.0f
#define FONT_SIZE 13.0f
#define HORIZONTAL_PADDING 1.0f
#define VERTICAL_PADDING 0.0f
#define BACKGROUND_COLOR [UIColor redColor]
#define TEXT_COLOR [UIColor colorWithRed:227/225.0 green:66/225.0 blue:134/225.0 alpha:1]
#define TEXT_SHADOW_COLOR [UIColor clearColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor clearColor].CGColor
#define BORDER_WIDTH 1.0f

@implementation DWTagList

@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
    }
    return self;
}

- (void)setTags:(NSArray *)array
{
    textArray = [[NSArray alloc] initWithArray:array];
    sizeFit = CGSizeZero;
    [self display];
}

- (void)setLabelBackgroundColor:(UIColor *)color
{
    lblBackgroundColor = color;
    [self display];
}

- (void)display
{
    for (UILabel *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (NSString *text in textArray) {
        DWTagLabel *label = [[DWTagLabel alloc] init];
        label.tagTappedBlock = ^(UILabel *tappedLabel) {
            [self tagClicked:tappedLabel];
        };
        [label setFont:[UIFont systemFontOfSize:FONT_SIZE]];
        [label setText:text];
        CGSize textSize = [label sizeThatFits:CGSizeMake(self.frame.size.width, 1500)];
        //CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:CGSizeMake(self.frame.size.width, 1500) lineBreakMode:UILineBreakModeWordWrap];
        textSize.width += HORIZONTAL_PADDING*2;
        textSize.height += VERTICAL_PADDING*2;
        
        if (!gotPreviousFrame) {
            label.frame = CGRectMake(0, 0, textSize.width, textSize.height);
            //label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, textSize.width, textSize.height)];
            totalHeight = textSize.height;
        } else {
            CGRect newRect = CGRectZero;
            if (previousFrame.origin.x + previousFrame.size.width + textSize.width + LABEL_MARGIN > self.frame.size.width) {
                newRect.origin = CGPointMake(0, previousFrame.origin.y + textSize.height + BOTTOM_MARGIN);
                totalHeight += textSize.height + BOTTOM_MARGIN;
            } else {
                newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
            }
            newRect.size = textSize;
            label.frame = newRect;
            //label = [[UILabel alloc] initWithFrame:newRect];
        }
        previousFrame = label.frame;
        gotPreviousFrame = YES;
        
        if (!lblBackgroundColor) {
            //[label setBackgroundColor:TEXT_COLOR];
            [label setTextColor:TEXT_COLOR];
        } else {
            //[label setBackgroundColor:lblBackgroundColor];
            [label setTextColor:lblBackgroundColor];
        }
        //[label setTextColor:TEXT_COLOR];

        [label setTextAlignment:NSTextAlignmentCenter];
        [label setShadowColor:TEXT_SHADOW_COLOR];
        [label setShadowOffset:TEXT_SHADOW_OFFSET];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:CORNER_RADIUS];
        [label.layer setBorderColor:BORDER_COLOR];
        [label.layer setBorderWidth: BORDER_WIDTH];
        
        label.userInteractionEnabled = YES;
        //[label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClicked:)]];
        [self addSubview:label];
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
}
-(void)tagClicked:(UILabel *)aLabel {
    if (self.tagClickedBlock) {
        self.tagClickedBlock(aLabel.text);
    }
}
- (CGSize)fittedSize
{
    return sizeFit;
}

@end
