//
//  DWTagList.m
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import "FootPrintDWTagList.h"
#import <QuartzCore/QuartzCore.h>
#import "FootPrintDWTagLable.h"

#define CORNER_RADIUS 5.0f
#define LABEL_MARGIN 10.0f
#define BOTTOM_MARGIN 10.0f
#define FONT_SIZE 13.0f
#define HORIZONTAL_PADDING 6.0f
#define VERTICAL_PADDING 4.0f
#define BACKGROUND_COLOR [UIColor whiteColor]
#define TEXT_COLOR [UIColor lightGrayColor]
#define TEXT_SHADOW_COLOR [UIColor clearColor]
#define TEXT_SHADOW_OFFSET CGSizeMake(0.0f, 1.0f)
#define BORDER_COLOR [UIColor lightGrayColor].CGColor
#define BORDER_WIDTH 1.0f

@implementation FootPrintDWTagList

@synthesize view, textArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:view];
    }
    return self;
}
-(void)setSelectedTextArray:(NSArray *)selectedTextArray {
    _selectedTextArray = selectedTextArray;
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
    for (FootPrintDWTagLable *subview in [self subviews]) {
        [subview removeFromSuperview];
    }
    float totalHeight = 0;
    CGRect previousFrame = CGRectZero;
    BOOL gotPreviousFrame = NO;
    for (int i=0; i<textArray.count; i++) {
        NSDictionary *dict = textArray[i];
        NSString *text = dict[@"name"];
        FootPrintDWTagLable *label = [[FootPrintDWTagLable alloc] init];
        label.tag = 200 + i;
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
            [label setBackgroundColor:BACKGROUND_COLOR];
        } else {
            [label setBackgroundColor:lblBackgroundColor];
        }
        [label setTextColor:TEXT_COLOR];

        [label setTextAlignment:NSTextAlignmentCenter];
        [label setShadowColor:TEXT_SHADOW_COLOR];
        [label setShadowOffset:TEXT_SHADOW_OFFSET];
        [label.layer setMasksToBounds:YES];
        [label.layer setCornerRadius:CORNER_RADIUS];
        [label.layer setBorderColor:BORDER_COLOR];
        [label.layer setBorderWidth: BORDER_WIDTH];
        
        label.userInteractionEnabled = YES;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClicked:)]];
        [self addSubview:label];
        
        //设置选中状态
        if ([self containtsDict:dict]) {
            [self setSelected:label];
        }
        
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(tagLongPressed:)];
        
        //[label removeGestureRecognizer:longPressGR];
        //添加长按事件
        [label addGestureRecognizer:longPressGR];
        
    }
    sizeFit = CGSizeMake(self.frame.size.width, totalHeight + 1.0f);
}
-(BOOL)containtsDict:(NSDictionary *)aDict {
    if ([self.selectedTextArray containsObject:aDict]) {
        return YES;
    }
    return NO;
}
-(void)tagClicked:(UIGestureRecognizer *)gr {
    FootPrintDWTagLable *lbl = (FootPrintDWTagLable *)gr.view;
    if (lbl.selected) {
        [self setNormal:lbl];
    }else {
        if (_selectedTextArray.count >= _maxSelectedCount) {
            [AutoDismissAlert autoDismissAlertSecond:@"添加标签数量超过限制"];
            return;
        }
        [self setSelected:lbl];
    }
}
-(void)tagLongPressed:(UIGestureRecognizer *)gr {
    FootPrintDWTagLable *lbl = (FootPrintDWTagLable *)gr.view;
    NSDictionary *dict = textArray[lbl.tag - 200];
    if (_canDelete) {
        //支持删除
        if (self.tagLongPressBlock) {
            self.tagLongPressBlock(dict, self.deleteMethod);
        }
    }
}
-(void)setSelected:(FootPrintDWTagLable *)lbl {
    lbl.textColor = MAINMAINCOLOR;
    lbl.layer.borderColor = MAINMAINCOLOR.CGColor;
    lbl.selected = YES;
    
    if (self.tagSelectedBlock) {
        self.tagSelectedBlock(textArray[lbl.tag - 200]);
    }
}
-(void)setNormal:(FootPrintDWTagLable *)lbl {
    lbl.textColor = TEXT_COLOR;
    lbl.layer.borderColor = BORDER_COLOR;
    lbl.selected = NO;
    
    if (self.tagNormalBlock) {
        self.tagNormalBlock(textArray[lbl.tag - 200]);
    }
}
- (CGSize)fittedSize
{
    return sizeFit;
}

@end
