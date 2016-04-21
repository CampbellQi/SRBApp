//
//  WQPickerView.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/28.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "WQPickerView.h"

@interface WQPickerView()
{
    NSArray *_dataArray;
    NSString *_selecedItem;
}
@end
@implementation WQPickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"WQPickerView" owner:self options:nil][0];
        [self addSubview:self.topView];
        self.clipsToBounds = YES;
        self.topView.clipsToBounds = YES;
        self.topView.frame = self.bounds;
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame DataArray:(NSArray *)dataArray {
    if (self = [self initWithFrame:frame]) {
        _dataArray = dataArray;
        [self.pickerView reloadAllComponents];
        _selecedItem = dataArray[0];
    }
    return self;
}
- (IBAction)cancelBtnClicked:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmBtnClicked:(id)sender {
    [self removeFromSuperview];
    if (self.confirmBlock) {
        self.confirmBlock(_selecedItem);
    }
}

#pragma mark- pickerview deleagte
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selecedItem = _dataArray[row];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _dataArray.count;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (self.titleForRowBlock) {
        return self.titleForRowBlock(_dataArray, row);
    }else {
        return _dataArray[row];
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
@end
