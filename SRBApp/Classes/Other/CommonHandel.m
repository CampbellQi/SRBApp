//
//  CommonHandel.m
//  SRBApp
//
//  Created by fengwanqi on 15/10/8.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "CommonHandel.h"
#import "UIImage+Compress.h"

@implementation CommonHandel
//除了图片查看大图路径
+(void)handleScanBigPhoto:(NSMutableString *)urlString {
    [urlString replaceOccurrencesOfString:@"_sm" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, urlString.length)];
    [urlString replaceOccurrencesOfString:@"thumbnail" withString:@"bmiddle" options:NSCaseInsensitiveSearch range:NSMakeRange(0, urlString.length)];
}
//上传图片
+(void)uploadPhotoRequest:(NSArray *)photoArray SucBlock:(void (^) (NSString *photoUrl))success FailBlock:(void (^) (NSError *error))failure{
    
    //NSString *url = @"http://120.27.52.97:8080/tusstar/servlet/JJUploadImageServlet";
    NSString *url = iOS_POST_REALPICTURE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (UIImage *image in photoArray) {
            NSData *imageData = [image compressAndResize];
            [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", self.uuid] mimeType:@"image/*"];
        }
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        if (success) {
            success([dic objectForKey:@"msg"]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
}
@end
