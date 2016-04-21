//
//  GoodsMarkListCell.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/9.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "GoodsMarkListCell.h"

@implementation GoodsMarkListCell
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        for (int i=0; i<4; i++) {
            float width = MARK_WIDTH;
            MarkView *view = [[MarkView alloc] initWithFrame:CGRectMake(i * (width + MARK_SPAE) + MARK_SPAE, 0, width, width) MarkName:nil];
            view.tag = 100 + i;
            view.hidden = YES;
            [self.contentView addSubview:view];
        }
    }
    return self;
}
-(void)setMarksArray:(NSMutableArray *)marksArray {
    for (int i=0; i<4; i++) {
        UIView *view = [self viewWithTag:100 + i];
        view.hidden = YES;
    }
    
    _marksArray = marksArray;
    for (int i=0; i<marksArray.count; i++) {
        MarkView *view = (MarkView *)[self viewWithTag:100 + i];
        view.hidden = NO;
        view.markDict = marksArray[i];
    }
}
-(void)setMarkViewTapBlock:(MarkViewTapBlock)markViewTapBlock {
    for (int i=0; i<_marksArray.count; i++) {
        MarkView *view = (MarkView *)[self viewWithTag:100 + i];
        view.hidden = NO;
        view.markViewTapBlock = markViewTapBlock;
    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
