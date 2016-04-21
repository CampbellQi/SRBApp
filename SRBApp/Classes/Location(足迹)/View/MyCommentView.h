//
//  MyCommentView.h
//  SRBApp
//
//  Created by zxk on 15/2/4.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ZZView.h"
#import "CommentNameView.h"
#import "MyLabel.h"
#import "LocationTextView.h"

@interface MyCommentView : ZZView
@property (nonatomic,strong)NSIndexPath * indexpath;
@property (nonatomic,strong)CommentNameView * name1View;
@property (nonatomic,strong)CommentNameView * name2View;
@property (nonatomic,strong)UILabel * huifuLabel;
@property (nonatomic,strong)MyLabel * commentLabel;
@property (nonatomic,strong)UIView * lineView;
@property (nonatomic,strong)UITapGestureRecognizer * commentTap;
@end
