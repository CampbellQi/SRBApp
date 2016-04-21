//
//  URLRequest.m
//  SRBApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import "URLRequest.h"
#import "Reachability.h"

@implementation URLRequest
/**
 *  @brief  网络请求(弃用)
 *  @param urlstr     传入url
 *  @param parameters 传入参数
 *  @param block      请求完,回调
 */
+(void)postRequestWith:(NSString *)urlstr parameters:(NSDictionary *)parameters andblock:(datablock)block
{
    BOOL isConnection = YES;
    Reachability * r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
        {
            isConnection = NO;
            block(nil);
//            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前网络连接中断" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//            [alert show];
//            [AutoDismissAlert autoDismissAlert:@"当前网络连接中断"];
            UIView * noView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, (SCREEN_HEIGHT - 60)/2, 200, 60)];
            noView.layer.cornerRadius = 2;
            noView.layer.masksToBounds = YES;
            noView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
            UILabel * noLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,9,140,42)];
            noLabel.font = SIZE_FOR_14;
            noLabel.textAlignment = NSTextAlignmentCenter;
            noLabel.numberOfLines = 2;
            noLabel.text = @"当前网络连接不可用,请设置网络。";
            noLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
            [noView addSubview:noLabel];
            [[UIApplication sharedApplication].keyWindow addSubview:noView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [noView removeFromSuperview];
            });
            
            return;
            break;
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"使用3G网络");
            break;
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"使用WIFI网络");
            break;
        }
    }
    
    
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        NSLog(@"11123123----%@",AFStringFromNetworkReachabilityStatus(status));
//    }];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager POST:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}

/**
 *  @brief  网络请求
 *  @param urlstr       传入url(NSString类型)
 *  @param parameters   参数
 *  @param block        请求成功回调
 *  @param failureBlock 请求失败回调
 */
+ (void)postRequestssWith:(NSString *)urlstr parameters:(NSDictionary *)parameters andblock:(datablock)block andFailureBlock:(failureBlock)failureBlock
{
    BOOL isConnection = YES;
    Reachability * r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
        {
            isConnection = NO;
            failureBlock();
            UIView * noView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, (SCREEN_HEIGHT - 60)/2, 200, 60)];
            noView.layer.cornerRadius = 2;
            noView.layer.masksToBounds = YES;
            noView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
            UILabel * noLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,9,140,42)];
            noLabel.font = SIZE_FOR_14;
            noLabel.textAlignment = NSTextAlignmentCenter;
            noLabel.numberOfLines = 2;
            noLabel.text = @"当前网络连接不可用,请设置网络。";
            noLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
            [noView addSubview:noLabel];
            [[UIApplication sharedApplication].keyWindow addSubview:noView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [noView removeFromSuperview];
            });
            
            return;
            break;
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"使用3G网络");
            break;
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"使用WIFI网络");
            break;
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/json"];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    //[manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 15.0f;
    //[manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureBlock();
        //[AutoDismissAlert autoDismissAlert:@"连接服务器失败"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

+ (void)getRequestWith:(NSString *)urlstr parameters:(NSDictionary *)parameters andblock:(datablock)block
{
    BOOL isConnection = YES;
    Reachability * r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
        {
            isConnection = NO;
            block(nil);
            //            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"当前网络连接中断" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            //            [alert show];
            //            [AutoDismissAlert autoDismissAlert:@"当前网络连接中断"];
            UIView * noView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 200)/2, (SCREEN_HEIGHT - 60)/2, 200, 60)];
            noView.layer.cornerRadius = 2;
            noView.layer.masksToBounds = YES;
            noView.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
            UILabel * noLabel = [[UILabel alloc]initWithFrame:CGRectMake(30,9,140,42)];
            noLabel.font = SIZE_FOR_14;
            noLabel.textAlignment = NSTextAlignmentCenter;
            noLabel.numberOfLines = 2;
            noLabel.text = @"当前网络连接不可用,请设置网络。";
            noLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
            [noView addSubview:noLabel];
            [[UIApplication sharedApplication].keyWindow addSubview:noView];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [noView removeFromSuperview];
            });
            
            return;
            break;
        }
        case ReachableViaWWAN:
        {
            //NSLog(@"使用3G网络");
            break;
        }
        case ReachableViaWiFi:
        {
            //NSLog(@"使用WIFI网络");
            break;
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager GET:urlstr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];

}

-(void)getPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{

    
}
-(void)postPath:(NSString *)path parameters:(NSDictionary *)parameters success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
//    //创建请求
//    sessionManager = [[AFURLSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    //添加请求接口
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
    
    
}
@end
