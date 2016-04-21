//
//  ReplaceEmotionTool.m
//  SRBApp
//
//  Created by zxk on 15/4/30.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ReplaceEmotionTool.h"
#import "ZZTextPart.h"
#import "RegexKitLite.h"
#import "EmotionTool.h"
#import "Emotion.h"

@implementation ReplaceEmotionTool
+ (NSAttributedString *)enumerateStringWithStr:(NSString *)content andFont:(UIFont *)font
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    //表情
    NSString * emotionPattern = @"\\[(\\S+?)\\]";
    
    NSString *pattern = [NSString stringWithFormat:@"%@",emotionPattern];
    //遍历特殊字符
    NSMutableArray * parts = [NSMutableArray array];
    [content enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        ZZTextPart * part = [[ZZTextPart alloc]init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
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
    
    for (ZZTextPart * part in parts) {
        NSAttributedString * substr = nil;
        if (part.emotion){
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
            substr = [[NSAttributedString alloc]initWithString:part.text attributes:@{NSForegroundColorAttributeName:[GetColor16 hexStringToColor:@"#496da5"]}];
        }else{
            substr = [[NSAttributedString alloc]initWithString:part.text];
        }
        [attributedText appendAttributedString:substr];
    }
    
    [attributedText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributedText.length)];
    
    return attributedText;
}

@end
