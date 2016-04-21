//
//  ChangeGroupView.h
//  SRBApp
//
//  Created by zxk on 14/12/31.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"
@class ChangeGroupView;
@protocol changeGroupDelegate <NSObject>

- (void)changeGroup:(ChangeGroupView *)changeGroupView didSelectBtn:(NSInteger)index withName:(NSString *)groupName andNum:(NSString *)groupNum;

@end

@interface ChangeGroupView : ZZView<UITextViewDelegate>

@property (nonatomic,copy)NSString * groupName;
@property (nonatomic,assign)id<changeGroupDelegate>delegate;
@property (nonatomic,strong)UITextView * numText;
@property (nonatomic,strong)UITextView * nameText;

@end
