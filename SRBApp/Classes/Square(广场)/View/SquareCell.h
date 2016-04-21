//
//  SquareCell.h
//  hh
//
//  Created by zxk on 14/12/28.
//  Copyright (c) 2014年 zxk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SquareScrollInfoView.h"
#import "ZZGoPayBtn.h"
#import "SquareModel.h"
#import "GroupModel.h"

@protocol squareCellDelegate <NSObject>

- (void)jumpToDetail:(NSInteger)index;

@end

@interface SquareCell : UITableViewCell
@property (nonatomic,strong)UIScrollView * mainScrollvew;
@property (nonatomic,strong)ZZGoPayBtn * moreBtn;
@property (nonatomic,strong)SquareScrollInfoView * squareScrollView;
@property (nonatomic,strong)UILabel * titleLabel;
@property (nonatomic,strong)UIView * colorImg;
@property (nonatomic,strong)SquareModel * squareModel;
@property (nonatomic,strong)GroupModel * groupModel;
@property (nonatomic,strong)NSArray * detailArr;
//@property (nonatomic,strong)ZZArray * dataArray;

@property (nonatomic,assign)id<squareCellDelegate>delegate;

+ (id)squareCellWithTableView:(UITableView *)tableView andIndexPath:(NSIndexPath *)indexPath;
+ (id)squareCellWithTableView:(UITableView *)tableView;

@end
