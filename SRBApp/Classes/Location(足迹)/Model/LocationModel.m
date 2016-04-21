//
//  LocationModel.m
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "LocationModel.h"
#import "RegexKitLite.h"
#import "ZZTextPart.h"
#import "ZZSpecial.h"
#import "EmotionTool.h"
#import "Emotion.h"

@implementation LocationModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}

- (void)setAttributedStrWith:(NSString *)content andFont:(UIFont *)font
{
    if (self.tags == nil || [self.tags isEqualToString:@""] || self.tags.length == 0) {
        
    }else{
        NSArray * tempArr = [self.tags componentsSeparatedByString:@","];
        NSMutableArray * attribuArr = [NSMutableArray array];
        if (tempArr.count != 0 && tempArr != nil) {
            for (NSString * str in tempArr) {
                if (![str isEqualToString:@""] && str != nil && str.length != 0) {
                    NSString * tempStr = [NSString stringWithFormat:@"#%@#",str];
                    [attribuArr addObject:tempStr];
                }
            }
            NSString * attributedContentStr = @"";
            for (NSString * str in attribuArr) {
                if (str != nil && ![str isEqualToString:@""] && str.length != 0) {
                   attributedContentStr = [attributedContentStr stringByAppendingFormat:@"%@ ",str];
                }
            }
            content = [attributedContentStr stringByAppendingString:content];
        }
    }
    if (self.sourcemodule != nil && ![self.sourcemodule isEqualToString:@""] && self.sourcemodule.length != 0 && self.sourcetitle.length != 0) {
        NSString * sourceStr = [NSString stringWithFormat:@"link:【%@】:link",self.sourcetitle];
        content = [NSString stringWithFormat:@"%@%@",sourceStr,content];
       
    }
    
    self.attributedText = [self enumerateStringWithStr:content andFont:font];
}

- (void)setNameAttributedStrWith:(NSString *)content andFont:(UIFont *)font
{
//    if (self.comments == nil || self.comments.count == 0) {
//        
//    }else{
//        NSArray * tempArr = [self.tags componentsSeparatedByString:@","];
//        NSMutableArray * attribuArr = [NSMutableArray array];
//        if (tempArr.count != 0 && tempArr != nil) {
//            for (NSString * str in tempArr) {
//                NSString * tempStr = [NSString stringWithFormat:@"#%@#",str];
//                [attribuArr addObject:tempStr];
//            }
//            NSString * attributedContentStr = @"";
//            for (NSString * str in attribuArr) {
//                if (str != nil && ![str isEqualToString:@""] && str.length != 0) {
//                    attributedContentStr = [attributedContentStr stringByAppendingFormat:@"%@ ",str];
//                }
//            }
//            content = [attributedContentStr stringByAppendingString:content];
//        }
//    }
    self.nameAttributedText = [self enumerateStringWithStr:content andFont:font];
}

- (NSAttributedString *)enumerateStringWithStr:(NSString *)content andFont:(UIFont *)font
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    // #话题#的规则
    NSString *topicPattern = @"#([^#|.]+)#";
    //@名字@的规则
    NSString * namePattern = @"&([^&|.]+)&";
    //链接的规则
    NSString * linkPattern = @"link:([^link:|.]+):link";
    //表情
    NSString * emotionPattern = @"\\[(\\S+?)\\]";
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@",topicPattern,namePattern,linkPattern,emotionPattern];
    //遍历特殊字符
    NSMutableArray * parts = [NSMutableArray array];
    [content enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        ZZTextPart * part = [[ZZTextPart alloc]init];
        part.special = YES;
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.specialName = [part.text hasPrefix:@"&"] && [part.text hasSuffix:@"&"];
        part.link = [part.text hasPrefix:@"link:"] && [part.text hasSuffix:@":link"];
        [parts addObject:part];
    }];
    
    //遍历所有非特殊字符
    [content enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        ZZTextPart *part = [[ZZTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    //排序
    [parts sortUsingComparator:^NSComparisonResult(ZZTextPart *part1, ZZTextPart *part2) {
        if (part1.range.location > part2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    NSMutableArray * specials = [NSMutableArray array];
    for (ZZTextPart * part in parts) {
        NSAttributedString * substr = nil;
        if (part.specialName == YES) {
            part.text = [part.text stringByReplacingOccurrencesOfString:@"&" withString:@""];
            substr = [[NSAttributedString alloc]initWithString:part.text attributes:@{NSForegroundColorAttributeName:MAINCOLOR}];
            //创建特殊对象
            ZZSpecial * s = [[ZZSpecial alloc]init];
            s.text = part.text;
            NSUInteger loc = attributedText.length;
            NSUInteger length = part.text.length;
            if (loc != 0) {
                s.nameNum = @"2";
            }else{
                s.nameNum = @"1";
            }
            s.range = NSMakeRange(loc, length);
            [specials addObject:s];
        }else if (part.link == YES){
            part.text = [part.text stringByReplacingOccurrencesOfString:@"link:" withString:@""];
            part.text = [part.text stringByReplacingOccurrencesOfString:@":link" withString:@""];
            substr = [[NSAttributedString alloc]initWithString:part.text attributes:@{NSForegroundColorAttributeName:MAINCOLOR}];
            //创建特殊对象
            ZZSpecial * s = [[ZZSpecial alloc]init];
            s.text = part.text;
            NSUInteger loc = attributedText.length;
            NSUInteger length = part.text.length;
            s.nameNum = @"-1";
            s.range = NSMakeRange(loc, length);
            s.goodsID = self.sourcevalue;
            s.sourcemodule = self.sourcemodule;
            [specials addObject:s];
        }else if (part.emotion){
            part.text = [part.text stringByReplacingOccurrencesOfString:@"[" withString:@""];
            part.text = [part.text stringByReplacingOccurrencesOfString:@"]" withString:@""];
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            NSString *name = [EmotionTool emotionWithChs:part.text].png;
            if (name) { // 能找到对应的图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            } else { // 表情图片不存在
                substr = [[NSAttributedString alloc] initWithString:part.text];
            }
        }else if (part.special) {
            substr = [[NSAttributedString alloc]initWithString:part.text attributes:@{NSForegroundColorAttributeName:MAINCOLOR}];
            
            //创建特殊对象
            ZZSpecial * s = [[ZZSpecial alloc]init];
            s.text = part.text;
            NSUInteger loc = attributedText.length;
            NSUInteger length = part.text.length;
            s.nameNum = @"0";
            s.range = NSMakeRange(loc, length);
            [specials addObject:s];
        }else{
            substr = [[NSAttributedString alloc]initWithString:part.text];
        }
        [attributedText appendAttributedString:substr];
    }
    
    if (attributedText.length != 0 && attributedText != nil) {
        [attributedText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    }
    
    
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    return attributedText;
}

@end
