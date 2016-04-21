//
//  DynamicViewController.h
//  SRBApp
//
//  Created by zxk on 14/12/15.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "ZZViewController.h"
#import "AppDelegate.h"
@interface DynamicViewController : ZZViewController
{
@private
    //    UITableView *_tableView;
    AppDelegate *_appDelegate;
    BOOL _ssoEnable;
    UIWebView *_webView;
}
@end
