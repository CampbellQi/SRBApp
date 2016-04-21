//
//  SuggestionViewCell.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "SuggestionViewCell.h"

@implementation SuggestionViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(25, 20, 70, 16)];
        _label.text = @"反馈内容";
        [self.contentView addSubview:_label];
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(_label.frame.origin.x + _label.frame.size.width + 5, 10, 1, 90)];
        label.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
        [self addSubview:label];
        
//        _textView = [[UITextView alloc]initWithFrame:CGRectMake(label.frame.origin.x + label.frame.size.width + 5, 5, 180, 30)];
//        
//        self.textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
//        
//        self.textView.font = [UIFont systemFontOfSize:16];//设置字体名字和字体大小
//        
////        self.textView.delegate = self;//设置它的委托方法
//        
//        self.textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
//        
////        self.textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";//设置它显示的内容
//        
//        self.textView.returnKeyType = UIReturnKeyDefault;//返回键的类型
//        
//        self.textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
//        
//        self.textView.scrollEnabled = YES;//是否可以拖动
//        
//        self.textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
//        
//        [self.contentView addSubview: self.textView];//加入到整个页面中
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

@end
