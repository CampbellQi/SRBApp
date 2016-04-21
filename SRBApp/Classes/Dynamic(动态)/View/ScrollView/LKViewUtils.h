//
//  MyViewUtils.h
//  Cat
//
//  Created by mac on 12-3-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuartzCore/QuartzCore.h"
//some Animation Type
#define LKView_Anima_PageCurl @"pageCurl"//向上翻页
#define LKView_Anima_PageUnCurl @"pageUnCurl"//向下翻页
#define LKView_Anima_CameraIrisHollowOpen @"cameraIrisHollowOpen" //相机打开
#define LKView_Anima_RippleEffect @"rippleEffect" //滴水效果
#define LKView_Anima_OglFlip @"oglFlip" //上下翻转
#define LKView_Anima_Cube @"cube" //立方体效果
#define LKView_Anima_SuckEffect @"suckEffect" //收缩效果
#define LKView_Anima_CameraIrisHollowClose @"cameraIrisHollowClose" //相机关闭
#define LKView_Anima_Fade kCATransitionFade //淡入淡出
#define LKView_Anima_MoveIn kCATransitionMoveIn //移进
#define LKView_Anima_Reveal kCATransitionReveal //揭开
// some sub type
#define LKView_AnimaSubType_FromTop kCATransitionFromTop //从上方进入
#define LKView_AnimaSubType_FromBottom kCATransitionFromBottom //从下方进入
#define LKView_AnimaSubType_FromLeft kCATransitionFromLeft  //从左边进入
#define LKView_AnimaSubType_FromRight kCATransitionFromRight //从右边进入

@interface LKViewUtils : NSObject

+(void)MakeViewRadius:(UIView*)view radius:(float)radius;            //为UIView 创建圆角 如果是放在ScrollView 里面会非常卡 如果数量多 建议还是用圆角图片当背景
+(void)MakeViewRadiusAndShaow:(UIView *)view radius:(float)radius;
+(void)MakeViewRadiusAndShaow:(UIView*)view; //为UIView 创建阴影  如果有移动非常卡
+(void)MakeViewBorder:(UIView *)view;        // 为 UIView 创建边框
+(void)MakeViewRadiusAndBorder:(UIView*)view;
+(void)MakeViewShaow:(UIView*)view offset:(CGSize)offset;

+(void)AnimationFrame:(UIView*) view frame:(CGRect) newframe;  //创建 frame 改变动画 默认动画时间1秒
+(void)AnimationFrame:(UIView *)view frame:(CGRect)newframe didEndEvent:(void(^)(void)) endEvent; //支持动画结束事件
+(void)AnimationAlpha:(UIView*) view Alpha:(float)alpha; //UIView alpha动画
+(CATransition*)AnimationFade; //创建layer 淡入淡出动画
+(CATransition*)AnimationLayer:(NSString*)type; //type 在上面  LKView_Anima_PageCurl
+(CATransition*)AnimationLayer:(NSString *)type subType:(NSString*)subType; //subtype 一般是方向


+(void)removeAllSubView:(UIView*)view;  //移除一个UIView 的所有子View
+(void)clearTableViewFooter: (UITableView *)tableView; //清楚 UITableView 底部的线条

+(void)setButton:(UIButton*)bt title:(NSString*) title;   //设置 Button中显示的字体
+(UIImage *)getImageFromView:(UIView *)view;//把View 转换成UIImage
+(UILabel *)getAutoLable:(NSString *)txt font:(UIFont *)font point:(CGPoint) point;//根据文本生成指定大小的Lable
+(UILabel*)getAutoLable:(NSString *)txt font:(UIFont *)font point:(CGPoint)point maxWidth:(int) maxWidth;
+(CGFloat)getTextHeight:(NSString*)txt font:(UIFont *)font width:(CGFloat)width;


+(void)showAlertView:(NSString *)message;//跳出个提示框
+(void)showAlertViewYesOrNo:(NSString*)title message:(NSString*)message yes:(void(^)()) yesblock no:(void(^)())noblock;
@end