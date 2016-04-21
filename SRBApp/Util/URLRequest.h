//
//  URLRequest.h
//  SRBApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void (^datablock) (NSDictionary * dic);
typedef void (^failureBlock) ();
@interface URLRequest : NSObject
{
    AFHTTPRequestOperationManager * manager;//创建请求(iOS 6-7)
    AFURLSessionManager * sessionManager;//创建请求(iOS 7)
    AFHTTPRequestOperation * operation;//创建请求管理(用于上传下载)
}


+ (void)postRequestWith:(NSString *)urlstr
                      parameters:(NSDictionary *)parameters
               andblock:(datablock)block;
//        andFailureBlock:(failureBlock)failureBlock;

+ (void)postRequestssWith:(NSString *)urlstr
             parameters:(NSDictionary *)parameters
               andblock:(datablock)block andFailureBlock:(failureBlock)failureBlock;

+ (void)getRequestWith:(NSString *)urlstr
             parameters:(NSDictionary *)parameters
              andblock:(datablock)block;


- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters
        success:(void (^)(AFHTTPRequestOperation * operation,id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation * operation,NSError * error))failure;
- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
