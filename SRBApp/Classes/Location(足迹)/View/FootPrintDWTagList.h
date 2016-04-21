//
//  DWTagList.h
//
//  Created by Dominic Wroblewski on 07/07/2012.
//  Copyright (c) 2012 Terracoding LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TagSelectedBlock) (NSDictionary *aTagDict);
typedef void (^TagNormalBlock) (NSDictionary *aTagDict);
typedef void (^TagLongPressBlock) (NSDictionary *aTagDict, NSString *deleteMethod);

@interface FootPrintDWTagList : UIView
{
    UIView *view;
    NSArray *textArray;
    CGSize sizeFit;
    UIColor *lblBackgroundColor;
}
@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSArray *textArray;
@property (nonatomic, strong) NSArray *selectedTextArray;
@property (nonatomic, assign) int maxSelectedCount;
@property (nonatomic, assign) BOOL canDelete;
@property (nonatomic, strong) NSString *deleteMethod;
@property (nonatomic, copy)TagSelectedBlock tagSelectedBlock;
@property (nonatomic, copy)TagNormalBlock tagNormalBlock;
@property (nonatomic, copy)TagLongPressBlock tagLongPressBlock;
- (void)setLabelBackgroundColor:(UIColor *)color;
- (void)setTags:(NSArray *)array;
- (void)display;
- (CGSize)fittedSize;

@end
