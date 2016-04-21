//
//  Constant.h
//  bangApp
//
//  Created by zxk on 14/12/16.
//  Copyright (c) 2014年 zz. All rights reserved.
//

/*  文件说明:该文件用来存放常用的宏以及C函数， 静态常变量等
 *  该文件可能会随时添加一些C函数，成员可以往其添加新的宏，但不允许
 *  修改已经添加好的宏名称或函数名称等，以免影响到其他文件的使用（切记！）
 *  该文件已经添加到了预编译头文件的包含，使用这个文件的常量时，可以不用
 *  进行import
 */

#ifndef bangApp_Constant_h
#define bangApp_Constant_h

//自定义NSLog
#ifdef DEBUG
#define NSLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#else
#define NSLog(...)
#define debugMethod()
#endif


//appleID
#define APP_ID 963736324
#pragma mark - 常用Size
//全屏幕高度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
//全屏幕宽度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//适配高度
#define WIDTH [UIScreen mainScreen].bounds.size.width / 320
//适配宽度
#define HEIGHT [UIScreen mainScreen].bounds.size.height / 480

//每次刷新加载条数
#define NumOfItemsForZuji 10

//每次刷新加载条数
#define NumOfItems 20

//每次刷新加载条数
#define NumOfItemsForShuren 50
//url头
//#define TestApi //测试环境
#ifdef TestApi
#define URLHeader @"http://testapi.shurenbang.net/"
#else
#define URLHeader @"http://mapi.shurenbang.net/"
#endif

#define SHARE_URL @"http://www.shurenbang.net/download/"

#define Cant_DanBao @"您不能担保的原因是：\n1.您与卖家不是熟人\n   关系；\n2.剩余库存为0；\n3.该商品由您自己发\n   布。"
#define Cant_Buy @"您不能购买的原因是：\n1.您与卖家不是熟人\n   关系且没有共同熟\n   人；\n2.剩余库存为0；\n3.该商品由您自己发\n   布。"
#define Cant_Qiang @"您不能推荐的原因是：\n1.您与发布人不是熟\n   人关系；\n2.该信息由您自己发\n   布。"
#define Cant_ChuanSong @"您不能操作的原因是：\n该信息由您自己发布。"

//游客userName
#define GUEST @"guest"
#define GUEST_PWD @""

//用户userName
#define ACCOUNT_SELF (((NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]).length ? [[NSUserDefaults standardUserDefaults]objectForKey:@"userName"] : GUEST)
//字体
#define SetFont(floatNum)[UIFont systemFontOfSize:floatNum]
//用户password
#define PASSWORD_SELF (((NSString *)[[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"]).length ? [[NSUserDefaults standardUserDefaults]objectForKey:@"pwd"] : GUEST)

//网络请求必备参数
#define ACCOUNT_PASSWORD @"account":ACCOUNT_SELF, @"password":PASSWORD_SELF



//游客提示
#define FRIEND_SGIN @"登录后，你的熟人、聊天记录都会展示在这里"

#define MY_SGIN @"登录后，你的订单、担保信息、钱包、个人设置都会展示在这里"

//照片页

//屏幕减去navigationBar的高度
#define MAIN_NAV_HEIGHT (SCREEN_HEIGHT - 64)

#pragma mark - 设备型号识别
#define is_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define down_IOS_8 ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)
#define down_IOS_7 ([[[UIDevice currentDevice] systemVersion] floatValue] <= 7.0)

//app主色调
#define MAINCOLOR [GetColor16 hexStringToColor:@"#ec77a3"]
#define MAINMAINCOLOR [GetColor16 hexStringToColor:@"#d41659"]
//滑动字体色调
#define MAINSCROLLCOLOR [GetColor16 hexStringToColor:@"#e34186"]
//app求购单边框色调
#define GRAYCOLOR [GetColor16 hexStringToColor:@"#d6d6d6"]

#define RGBCHANGYONG ([UIColor colorWithRed:212/255.0 green:222/255.0 blue:184/255.0 alpha:1])

#define DICECOLOR(R,G,B,A) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#define RandomColor RGBCOLOR(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),1)
//白色
#define WHITE ([UIColor whiteColor])
#define LIGHTGRAY ([UIColor lightGrayColor])

//设备名称
#define PHONE_NAME [[UIDevice currentDevice] model]

//根据设备设置字体
#define SIZE_FOR_IPHONE [UIFont systemFontOfSize:16]

//14号字体
#define SIZE_FOR_14 [UIFont systemFontOfSize:14]

//12号字体
#define SIZE_FOR_12 [UIFont systemFontOfSize:12]

//10号字体
#define SIZE_FOR_10 [UIFont systemFontOfSize:10]

//订单类型数组
#define ORDER_TYPE_ARR @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价",@"完成"]

//买家取消订单理由
#define CANCEL_ORDER_RESON @[@"不想要了",@"卖家缺货",@"下错单了",@"其他"]

//卖家取消订单里有
#define SELLER_Cancel_Reson @[@"库存不足",@"商品问题",@"发票问题",@"七天无理由退换货",@"其他"]

//appdelegate
#define APPDELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate

//tabBar显示延迟
#define TAB_DARLY_TIME 0.14
//话题，足迹发布最大限制字数
#define FOOTER_MAX_COUNT 500


#define CACHE_PATH      [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject]
#define DOCUMENT_PATH   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define LIBRARY_PATH        [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)lastObject]

//用户配置文件
#define USER_CONFIG_PATH ([LIBRARY_PATH stringByAppendingPathComponent:@"userConfigura"])
//列表缓存文件


////自动消失提示框
//NS_INLINE void autoDismissMessage(NSString * strMes)
//{
//    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:strMes delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
//    [alert show];
//    [alert performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:@[@"0",@"1"] afterDelay:2];
//}
//
////获取文字高度
//NS_INLINE float getStringHeight(NSString * str,float width,float size)
//{
//    
//    CGRect rect = [str boundingRectWithSize:CGSizeMake(width, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:size]} context:nil];
//    return rect.size.height;
//}


#endif
