//
//  ZZViewController.m
//  bangApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zz. All rights reserved.
//

#import "ZZViewController.h"

@interface ZZViewController ()

@end

@implementation ZZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#eeeeee"];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 拼接post参数
/**
 *  @brief  拼接post所需参数
 *  @param method        接口名
 *  @param parametersDic 参数
 *  @return 返回拼接好的字典
 */
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
