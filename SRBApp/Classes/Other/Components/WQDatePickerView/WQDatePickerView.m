//
//  WQTimePickerView.m
//  tusstar
//
//  Created by fengwanqi on 15/7/13.
//  Copyright (c) 2015年 zxk. All rights reserved.
//

#import "WQDatePickerView.h"

@implementation WQDatePickerView

-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.topView = [[[NSBundle mainBundle] loadNibNamed:@"WQDatePickerView" owner:self options:nil] objectAtIndex:0];
        self.topView.frame = self.bounds;
        self.clipsToBounds = YES;
        [self addSubview:self.topView];
        
        NSDate * currentDate = [NSDate date];
        NSCalendar * calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents * comps = [[NSDateComponents alloc]init];
        [comps setYear:30];
        NSDate * maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [comps setYear:0];
        [comps setDay:1];
        NSDate * minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        
        [self.pickerView setMaximumDate:maxDate];
        [self.pickerView setMinimumDate:minDate];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)completeClicked:(id)sender {
    if (self.confirmBlock) {
        [self cancelClicked:nil];
        self.confirmBlock([self stringForDate]);
    }
}

- (IBAction)cancelClicked:(id)sender {
    [self removeFromSuperview];
}
- (NSString *)stringForDate {
    NSDate *date = self.pickerView.date;
    if (self.dateFormat) {
        return [WQDatePickerView stringFromDate:date withFormat:self.dateFormat];
    }else {
        return [WQDatePickerView stringFromDate:date withFormat:[WQDatePickerView dateFormatString]];
    }
    
}
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    
    NSString *string = [inputFormatter stringFromDate:date];
    return string;
    
}
+ (NSString *)dateFormatString {
    return @"yyyy年MM月dd日";
}
@end
