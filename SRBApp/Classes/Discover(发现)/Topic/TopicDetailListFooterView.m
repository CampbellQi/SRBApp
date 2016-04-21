//
//  TopicDetailListFooterView.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/11.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//
#define TDPraiseCountView @"TDPraiseCountView"
#define TDCommentsView @"TDCommentsView"
#define TDLoadCommentsView @"TDLoadCommentsView"
#define TDMarksView @"TDMarksView"

#define MARKVIEW_TOP_SCALE 8

#import "TopicDetailListFooterView.h"
#import "CompareCurrentTime.h"
#import "TopicCommentListCell.h"

@implementation TopicDetailListFooterView
{
    TopicCommentListCell *_commentView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.height = 0.0;
    //位置
    if (![_sourceModel.positionxyz isEqualToString:@"0"] && ![_sourceModel.positionxyz isEqualToString:@""] && _sourceModel.positionxyz != nil) {
        self.locationLbl.text = self.sourceModel.model_position;
        [self.view addSubview:self.locationView];
        self.locationView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, self.locationView.height);
        self.height += self.locationView.height + 10;
    }
    
    //举报
    self.reportBtn.layer.cornerRadius = 4.0f;
    self.reportBtn.layer.borderColor = MAINCOLOR.CGColor;
    self.reportBtn.layer.borderWidth = 1.0f;
    [self.view addSubview:self.reportSuperView];
    self.reportSuperView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, self.reportSuperView.height);
    self.height += self.reportSuperView.height;
    //赞
    self.browseCount.text = self.sourceModel.hitCount;
    if (_praiseDict) {
        //self.praiseCountTopView = [[[NSBundle mainBundle] loadNibNamed:@"TDPraiseCountView" owner:self options:nil] objectAtIndex:0];
        self.praiseCount.text = [NSString stringWithFormat:@"%@",[_praiseDict objectForKey:@"totalCount"]];
//        self.praiseCountLbl.text = [NSString stringWithFormat:@"%@ 个人喜欢", [_praiseDict objectForKey:@"totalCount"]];
//        self.praiseCountLbl.textColor = [GetColor16 hexStringToColor:@"#ec77a3"];
        NSArray *praiseArray = [_praiseDict objectForKey:@"list"];
        [self.view addSubview:self.praiseCountTopView];
        self.praiseCountTopView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, self.praiseCountTopView.height);
        self.height += self.praiseCountTopView.height;
        float width = self.praiseAvaterSV.height - 2 * MARKVIEW_TOP_SCALE;
        for (int i=0; i<praiseArray.count; i++) {
            NSDictionary *dict = praiseArray[i];
            UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(MARKVIEW_TOP_SCALE + (width + MARKVIEW_TOP_SCALE) * i, MARKVIEW_TOP_SCALE, width, width)];
            iv.layer.masksToBounds = YES;
            iv.layer.cornerRadius = iv.width * 0.5;
            iv.contentMode=UIViewContentModeScaleAspectFill;
            [iv sd_setImageWithURL:[NSURL URLWithString:dict[@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            [self.praiseAvaterSV addSubview:iv];
            //事件
            iv.tag = 200 + i;
            [iv addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(praiseAvaterClicked:)]];
            iv.userInteractionEnabled = YES;
        }
        self.praiseAvaterSV.contentSize = CGSizeMake(praiseArray.count * (MARKVIEW_TOP_SCALE + width) + MARKVIEW_TOP_SCALE, self.praiseAvaterSV.height);
    }
    //评论
    NSArray *commentsArray = [[_commentsDict objectForKey:@"data"] objectForKey:@"list"];
    if (commentsArray.count) {
        //self.commentTopView = [[[NSBundle mainBundle] loadNibNamed:@"TDCommentsView" owner:self options:nil] objectAtIndex:0];
        
        TopicCommentModel *model = [[TopicCommentModel alloc] init];
        [model setValuesForKeysWithDictionary:commentsArray[0]];
    
        self.commentAccountLbl.text = model.nickname;
        self.commentContentLbl.text = model.content;
        self.commentAvterIV.layer.masksToBounds = YES;
        self.commentAvterIV.layer.cornerRadius = 0.5 * self.commentAvterIV.width;
        [self.commentAvterIV sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"zanwu"]];
        NSString * timeStr = [CompareCurrentTime compareCurrentTime:model.updatetimeLong];
        self.commentTimeLbl.text = timeStr;
        
        self.commentCount.text = [NSString stringWithFormat:@"%@", [[_commentsDict objectForKey:@"data"] objectForKey:@"totalCount"]];
//        self.commentCountLbl.text = [NSString stringWithFormat:@"%@ 条评论", [[_commentsDict objectForKey:@"data"] objectForKey:@"totalCount"]];
//        self.commentCountLbl.textColor = [GetColor16 hexStringToColor:@"#ec77a3"];
        CGSize size = [self.commentContentLbl sizeThatFits:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000)];
        //CGSize size = [model.content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 2 * CONTENT_LBL_XMARGIN, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0]} context:nil].size;
        
        [self.view addSubview:self.commentTopView];
        self.commentTopView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, self.commentTopView.height + size.height - 18);
        self.height += self.commentTopView.height;
        
        //事件
        [self.commentAvterIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentAvaterClicked:)]];
        
//        TopicCommentListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TopicCommentListCell" owner:self options:nil] objectAtIndex:0];
//        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.commentTopView.height);
//        [self.commentSuperView addSubview:cell];
//        cell.sourceModel = [_commentsArray objectAtIndex:0];
//        _commentView = cell;
        
    }
    //加载更多评论
    [self.view addSubview:self.loadCommentTopView];
    self.loadCommentTopView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, self.loadCommentTopView.height);
    self.commentTF.layer.cornerRadius = 3.0f;
    if (commentsArray.count == 0) {
        self.loadMoreCommentBtn.hidden = YES;
        self.commentLine1Lbl.hidden = YES;
        self.loadCommentTopView.height = 45;
    }
    self.height += (self.loadCommentTopView.height + 10);
    //推荐标签
    if (_marksArray) {
        //self.markTopView = [[[NSBundle mainBundle] loadNibNamed:@"TDCommentsView" owner:self options:nil] objectAtIndex:0];
        [self.view addSubview:self.markTopView];
        self.markTopView.frame = CGRectMake(0, self.height, SCREEN_WIDTH, self.markTopView.height);
        self.height += self.markTopView.height;
        //推荐标签
        float width = self.marksSV.size.height - 2 * MARKVIEW_TOP_SCALE;
        for (int i=0; i<_marksArray.count; i++) {
            CGRect frame = CGRectMake((width + MARKVIEW_TOP_SCALE) * i + MARKVIEW_TOP_SCALE, MARKVIEW_TOP_SCALE, width, width);
            NSDictionary *marksDict = _marksArray[i];
            
            MarkView *markView = [[MarkView alloc] initWithFrame:frame MarkName:marksDict];
            [self.marksSV addSubview:markView];
            markView.tag = 100 + i;
        }
        self.marksSV.contentSize = CGSizeMake(_marksArray.count * (width + MARKVIEW_TOP_SCALE) + MARKVIEW_TOP_SCALE, 0);
    }
    self.height += 50;
    self.view.height = self.height;
}
-(void)setMarkViewTapBlock:(MarkViewTapBlock)markViewTapBlock {
    for (int i=0; i<_marksArray.count; i++) {
        MarkView *view = (MarkView *)[self.view viewWithTag:100 + i];
        view.markViewTapBlock = markViewTapBlock;
    }
}
//评论头像点击
-(void)commentAvaterClicked:(UIGestureRecognizer *)gr {
    NSArray *commentsArray = [[_commentsDict objectForKey:@"data"] objectForKey:@"list"];
    if (commentsArray.count) {
        TopicCommentModel *model = [[TopicCommentModel alloc] init];
        [model setValuesForKeysWithDictionary:commentsArray[0]];
        if (self.avaterClickedBlock) {
            self.avaterClickedBlock(model.account);
        }
    }
}
//点赞头像点击
-(void)praiseAvaterClicked:(UIGestureRecognizer *)gr {
    NSArray *praiseArray = _praiseDict[@"list"];
    NSDictionary *dict = praiseArray[gr.view.tag - 200];
    if (self.avaterClickedBlock) {
        self.avaterClickedBlock(dict[@"account"]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
