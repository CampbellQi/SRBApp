//
//  WQTimePickerView.h
//  tusstar
//
//  Created by fengwanqi on 15/7/13.
//  Copyright (c) 2015年 zxk. All rights reserved.
//
#define PICKERVIEW_HEIGHT 206

typedef void (^ConfirmBlock) (NSString *date);

#import <UIKit/UIKit.h>

@interface WQDatePickerView : UIView<UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIDatePicker *pickerView;
- (IBAction)completeClicked:(id)sender;

- (IBAction)cancelClicked:(id)sender;
@property (nonatomic, copy)ConfirmBlock confirmBlock;

@property (nonatomic, strong)NSString *dateFormat;
@end
