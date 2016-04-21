//
//  LocationCell.h
//  SRBApp
//
//  Created by zxk on 14/12/26.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//
#define DISCREPTIOIN_MAX_HEIGHT 90

#import "ZZTableViewCell.h"

#import "ZZGoPayBtn.h"
#import "LocationModel.h"
#import "LeftImgAndRightTitleBtn.h"
#import "MyImgView.h"
#import "MyLabel.h"
#import "MyView.h"
#import "MyCommentView.h"
#import "Singleton.h"
#import "CopyLabel.h"
#import "TapImageView.h"
#import "LocationTextView.h"
#import "NameTextView.h"

@class LocationCell;

@protocol TableViewCellDelegates<NSObject>

- (void)viewreloadData;
- (void)tapComment:(LocationCell *)locationCell index:(NSInteger)index withTap:(UITapGestureRecognizer *)tap;                                   //点击评论内容代理
- (void)tapName1:(LocationCell *)locationCell index:(NSInteger)index;   //点击名字的代理
- (void)tapName2:(LocationCell *)locationCell index:(NSInteger)index;
- (void)tapZanName:(LocationCell *)locationCell index:(NSInteger)index; //点击赞的人名代理

@end


@interface LocationCell : ZZTableViewCell<UIGestureRecognizerDelegate>
@property (nonatomic,strong)NSIndexPath * indexpath;
@property (nonatomic,strong)MyImgView * logoImg;  //头像
@property (nonatomic,strong)UILabel * nameLabel;    //标题
@property (nonatomic,strong)UILabel * timeLabel;    //时间
@property (nonatomic,strong)LocationTextView * descriptionLabel;     //详情
@property (nonatomic,strong)UIButton * fullTextBtn;
@property (nonatomic,strong)ZZGoPayBtn * delBtn;    //删除
@property (nonatomic,assign)BOOL isLoad;            //是否下载
//是否展开
@property (nonatomic,assign)BOOL isSpread;
//@property (nonatomic,strong)MyImgView * photoImg1;  //照片1
//@property (nonatomic,strong)MyImgView * photoImg2;  //照片2
//@property (nonatomic,strong)MyImgView * photoImg3;  //照片3
//@property (nonatomic,strong)MyImgView * photoImg4;  //照片4
//@property (nonatomic,strong)MyImgView * photoImg5;  //照片5
//@property (nonatomic,strong)MyImgView * photoImg6;  //照片6
//@property (nonatomic,strong)MyImgView * photoImg;   //大图

@property (nonatomic,strong)TapImageView * photoImg1;  //照片1
@property (nonatomic,strong)TapImageView * photoImg2;  //照片2
@property (nonatomic,strong)TapImageView * photoImg3;  //照片3
@property (nonatomic,strong)TapImageView * photoImg4;  //照片4
@property (nonatomic,strong)TapImageView * photoImg5;  //照片5
@property (nonatomic,strong)TapImageView * photoImg6;  //照片6
@property (nonatomic,strong)TapImageView * photoImg7;  //照片7
@property (nonatomic,strong)TapImageView * photoImg8;  //照片8
@property (nonatomic,strong)TapImageView * photoImg9;  //照片9
@property (nonatomic,strong)TapImageView * photoImg;   //大图

@property (nonatomic,strong)UIImageView * locationImg;  //定位
@property (nonatomic,strong)MyLabel * addressLabel;    //地址
@property (nonatomic,strong)ZZGoPayBtn * moreBtn;         //分享和点赞
@property (nonatomic,strong)UIImageView * sanjiaoImg;   //三角图片
@property (nonatomic,strong)UIView * zanNumBgView;      //赞的背景view
@property (nonatomic,strong)UIView * zanLineView;          //赞分割线
@property (nonatomic,strong)MyView * commentBGView;     //评论的假框
@property (nonatomic,strong)UIView * tempViewForComment;
@property (nonatomic,strong)UIView * tempViewForZanPerson;

@property (nonatomic,strong)UILabel * numPerLabel;      //多少人赞
@property (nonatomic,strong)UIView * twoButtonView;     //两个button的背景view
@property (nonatomic,strong)MyCommentView * commentContent;    //评论

@property (nonatomic,strong)UIView * lineView;        //时间
@property (nonatomic,copy)LocationModel * locationModel;
@property (nonatomic,strong)UILabel * alertLabel;   //+1
@property (nonatomic,strong)LeftImgAndRightTitleBtn * zanBtn;   //点赞button
@property (nonatomic,strong)LeftImgAndRightTitleBtn * shareBtn; //分享button
@property (nonatomic, assign)id <TableViewCellDelegates>delegate;

+ (id)locationCellWithTaableView:(UITableView *)tableView;
- (void)showAlertLabel;
-(void)hideTwoButtonView;
@end
