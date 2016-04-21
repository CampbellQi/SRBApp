//
//  SuggestionViewController.h
//  SRBApp
//
//  Created by 刘若曈 on 14/12/19.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZViewController.h"

@interface SuggestionViewController : ZZViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSString * _str1;
    NSString * _str2;
    NSString * _str3;
    UILabel * _label;
    UITextView * _textView;
    UITextField * _textField;
    UILabel * labeltext;
    UIImageView * theImage;
}
@property (nonatomic, strong)UITableView * tableView;
@property (nonatomic, strong)UIButton * button;
- (void)regController:(id)sender;
@end
