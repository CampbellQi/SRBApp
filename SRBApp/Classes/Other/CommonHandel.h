//
//  CommonHandel.h
//  SRBApp
//
//  Created by fengwanqi on 15/10/8.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonHandel : NSObject
+(void)handleScanBigPhoto:(NSMutableString *)urlString;

//上传图片
+(void)uploadPhotoRequest:(NSArray *)photoArray SucBlock:(void (^) (NSString *photoUrl))success FailBlock:(void (^) (NSError *error))failure;
@end
