//
//  WQPickerView.h
//  SRBApp
//
//  Created by fengwanqi on 15/11/28.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//
#define PICKERVIEW_HEIGHT 206
#import <UIKit/UIKit.h>

typedef void (^ConfirmBlock) (id selectedItem);
typedef NSString* (^TitleForRowBlock) (NSArray *sourceArray, NSInteger row);

@interface WQPickerView : UIView<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
- (IBAction)cancelBtnClicked:(id)sender;
- (IBAction)confirmBtnClicked:(id)sender;

@property (nonatomic, copy)ConfirmBlock confirmBlock;
@property (nonatomic, copy)TitleForRowBlock titleForRowBlock;

-(id)initWithFrame:(CGRect)frame DataArray:(NSArray *)dataArray;
@end
