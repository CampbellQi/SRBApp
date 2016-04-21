//
//  CategoryView.m
//  SRBApp
//
//  Created by zxk on 14/12/30.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//

#import "CategoryView.h"

@implementation CategoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GetColor16 hexStringToColor:@"#ffffff"];
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, 120, 16)];
        label.text = @"商品分类";
        [self addSubview:label];
        
        _fushiView = [[SquareSearchView alloc]initWithFrame:CGRectMake(50, 43, 50, 72)];
        _xiangbaoView = [[SquareSearchView alloc]initWithFrame:CGRectMake(frame.size.width/2-25, 43, 50, 72)];
        //_xiangbaoView.center = CGPointMake(frame.size.width/2, 68);
        _xiemaoView = [[SquareSearchView alloc]initWithFrame:CGRectMake(frame.size.width - 50 - 50, 43, 50, 72)];
        
        _shipinView = [[SquareSearchView alloc]initWithFrame:CGRectMake(50, 150, 50, 72)];
        _hufuView = [[SquareSearchView alloc]initWithFrame:CGRectMake(frame.size.width/2-25, 150, 50, 72)];
        //_hufuView.center = CGPointMake(frame.size.width/2, 175);
        _muyingView = [[SquareSearchView alloc]initWithFrame:CGRectMake(frame.size.width - 50 -50, 150, 50, 72)];
        
        _shumaView = [[SquareSearchView alloc]initWithFrame:CGRectMake(50, 257, 50, 72)];
        _qitaView = [[SquareSearchView alloc]initWithFrame:CGRectMake(frame.size.width/2 - 25, 257, 50, 72)];
        

        _fushiView.imgview.image = [UIImage imageNamed:@"fuzhuang"];
        _fushiView.searchLabel.text = @"服饰";
        _xiangbaoView.imgview.image = [UIImage imageNamed:@"xiangbao"];
        _xiangbaoView.searchLabel.text = @"箱包";
        _xiemaoView.imgview.image = [UIImage imageNamed:@"xiemao"];
        _xiemaoView.searchLabel.text = @"鞋帽";
        _shipinView.imgview.image = [UIImage imageNamed:@"shipin"];
        _shipinView.searchLabel.text = @"食品";
        _hufuView.imgview.image = [UIImage imageNamed:@"hufu"];
        _hufuView.searchLabel.text = @"护肤";
        _muyingView.imgview.image = [UIImage imageNamed:@"muying"];
        _muyingView.searchLabel.text = @"母婴";
        _shumaView.imgview.image = [UIImage imageNamed:@"shuma"];
        _shumaView.searchLabel.text = @"数码";
        _qitaView.imgview.image = [UIImage imageNamed:@"qita"];
        _qitaView.searchLabel.text = @"其他";
        
        [self addSubview:_fushiView];
        [self addSubview:_xiangbaoView];
        [self addSubview:_xiemaoView];
        [self addSubview:_shipinView];
        [self addSubview:_hufuView];
        [self addSubview:_muyingView];
        [self addSubview:_shumaView];
        [self addSubview:_qitaView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
