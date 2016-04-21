//
//  TopicDetailListFooterView.h
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MarkView.h"
#import "TopicCommentModel.h"
#import "BussinessModel.h"

typedef void (^AvaterClickedBlock) (NSString *account);

@interface TopicDetailListFooterView : UIViewController
//赞
@property (weak, nonatomic) IBOutlet UILabel *praiseCount;
@property (weak, nonatomic) IBOutlet UILabel *praiseCountLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *praiseAvaterSV;
@property (strong, nonatomic) IBOutlet UIView *praiseCountTopView;
//加载更多评论
@property (weak, nonatomic) IBOutlet UIButton *loadMoreCommentBtn;
@property (weak, nonatomic) IBOutlet UITextField *commentTF;
@property (weak, nonatomic) IBOutlet UILabel *commentLine1Lbl;
@property (weak, nonatomic) IBOutlet UILabel *commentLine2Lbl;

//标签
@property (weak, nonatomic) IBOutlet UIScrollView *marksSV;
@property (strong, nonatomic) IBOutlet UIView *markTopView;
@property (strong, nonatomic) IBOutlet UIView *loadCommentTopView;
//评论
@property (weak, nonatomic) IBOutlet UIView *commentSuperView;
@property (strong, nonatomic) IBOutlet UIView *commentTopView;
@property (weak, nonatomic) IBOutlet UIImageView *commentAvterIV;
@property (weak, nonatomic) IBOutlet UILabel *commentAccountLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentContentLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLbl;
//浏览次数
@property (weak, nonatomic) IBOutlet UILabel *browseCount;

//举报
@property (strong, nonatomic) IBOutlet UIView *reportSuperView;
@property (weak, nonatomic) IBOutlet UIButton *reportBtn;
//位置
@property (strong, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
@property (weak, nonatomic) IBOutlet UILabel *locationLbl;

@property (nonatomic, strong)NSMutableArray *marksArray;
@property (nonatomic, strong)NSDictionary *commentsDict;
@property (nonatomic, strong)NSDictionary *praiseDict;
@property (nonatomic, strong)BussinessModel *sourceModel;

@property (nonatomic, copy)MarkViewTapBlock markViewTapBlock;


@property (nonatomic, copy)AvaterClickedBlock avaterClickedBlock;
@property (nonatomic, assign)float height;
@end
