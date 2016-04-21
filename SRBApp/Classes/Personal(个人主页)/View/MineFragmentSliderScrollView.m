//
//  WQNavSliderScrollView.m
//  DocumentaryChina
//
//  Created by fengwanqi on 14-7-24.
//  Copyright (c) 2014年 com.uwny. All rights reserved.
//
#define BUTTON_FONT [UIFont systemFontOfSize:16]
#define BUTTON_BIG_FONT [UIFont systemFontOfSize:16]
#define kButtonTagStart 100
#define LINE_HIGHT 2

#define TITLEBTN_NORMAL_COLOR [UIColor diceColorWithRed:255 green:255 blue:255 alpha:1]
#define TITLESV_HEIGHT 50
#define Font_COLOR DICECOLOR(223, 0, 85, 1)

#import "MineFragmentSliderScrollView.h"
#import "UIColor+Dice.h"

@implementation MineFragmentSliderScrollView
{
    UIView *_titleSuperView;
    UIScrollView *_contentSV;
    NSArray *_titlesArray;
    
    NSMutableArray *_buttonArray;
    UILabel *_lineLbl;
    UIButton *_selectedTitleBtn;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame TitlesArray:(NSArray *)titlesArray FirstView:(UIView *)firstView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // Initialization code
        _titlesArray=titlesArray;
        _contentViewArray= [NSMutableArray arrayWithArray:titlesArray];
        
        [_contentViewArray replaceObjectAtIndex:0 withObject:firstView];
        
        _titleSuperView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, TITLESV_HEIGHT)];
        _titleSuperView.backgroundColor=[UIColor clearColor];
        [self addSubview:_titleSuperView];
        //添加标题按钮
        //int width = 10;
        _buttonArray = [[NSMutableArray alloc]init];
        for (int i = 0 ; i < _titlesArray.count; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.backgroundColor = [UIColor clearColor];
            button.titleLabel.font = BUTTON_FONT;
            [button setTitleColor:[UIColor diceColorWithRed:158 green:158 blue:158 alpha:1] forState:UIControlStateNormal];
            [button setTitleColor:Font_COLOR forState:UIControlStateSelected];
            NSString *title = [_titlesArray objectAtIndex:i];
            [button setTitle:title forState:UIControlStateNormal];
            
            button.tag = kButtonTagStart+i;
            
            //CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:BUTTON_BIG_FONT,NSPaperSizeDocumentAttribute:[NSValue valueWithCGSize:CGSizeMake(MAXFLOAT, 25)]}];
            //CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 25) lineBreakMode:NSLineBreakByWordWrapping];
            float width = frame.size.width / _titlesArray.count;
            float buttonHeight = 0.5 * TITLESV_HEIGHT;
            button.frame = CGRectMake(width * i, (TITLESV_HEIGHT - buttonHeight)/2, width, buttonHeight);
            [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
            [_titleSuperView addSubview:button];
            [_buttonArray addObject:button];
            
            //分割线
            float separateIVTopMargin = 5;
            if (i!=_titlesArray.count - 1) {
                UIImageView *separateIV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)- 5, separateIVTopMargin, 10, CGRectGetHeight(_titleSuperView.frame) - 2*separateIVTopMargin)];
                separateIV.contentMode = UIViewContentModeCenter;
                separateIV.image = [UIImage imageNamed:@"pc_separater"];
                //separateIV.backgroundColor = [UIColor redColor];
                [_titleSuperView addSubview:separateIV];
            }
            
            //状态栏下横线
            UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(_titleSuperView.frame) - 1, SCREEN_WIDTH, 1)];
            lineView.image = [UIImage imageNamed:@"topic_detail_dividing_line"];
            [_titleSuperView addSubview:lineView];
            
            //滑动线
            if (i==0) {
                _lineLbl=[[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetHeight(_titleSuperView.frame) - LINE_HIGHT - 1, button.frame.size.width - 10, LINE_HIGHT)];
                _lineLbl.backgroundColor=MAINSCROLLCOLOR;
                [_titleSuperView addSubview:_lineLbl];
                button.selected=YES;
                _lineLbl.tag=button.tag+100;
                _selectedTitleBtn=button;
                _selectedTitleBtn.titleLabel.font = BUTTON_BIG_FONT;
            }
        }
        
        
        
        //添加内容
        _contentSV=[[UIScrollView alloc] initWithFrame:CGRectMake(0, TITLESV_HEIGHT, frame.size.width, frame.size.height-TITLESV_HEIGHT)];
        _contentSV.delegate = self;
        _contentSV.contentSize = CGSizeMake(self.bounds.size.width * titlesArray.count, 0);
        _contentSV.showsHorizontalScrollIndicator = NO;
        _contentSV.pagingEnabled = YES;
        _contentSV.alwaysBounceHorizontal = NO;
        //_contentSV.bounces = NO;
        [self addSubview:_contentSV];
        
        
        UIView *view=firstView;
        view.frame=CGRectMake(0, 0, _contentSV.frame.size.width, _contentSV.frame.size.height);
        [_contentSV addSubview:view];

    }
    return self;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_contentSV) {
        int x = _contentSV.contentOffset.x/_contentSV.frame.size.width;
        UIButton *titleBtn=(UIButton *)[self viewWithTag:(x+kButtonTagStart)];
        
        if (![_contentViewArray[x] isKindOfClass:[UIView class]]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getShowItemViewWithIndex:)]) {
                UIView *view = [self.delegate getShowItemViewWithIndex:x];
                self.currentView = view;
                view.frame=CGRectMake(_contentSV.frame.size.width*x, 0, _contentSV.frame.size.width, _contentSV.frame.size.height);
                [_contentSV addSubview:view];
                [_contentViewArray replaceObjectAtIndex:x withObject:view];
            }
        }
        NSLog(@"tag=%ld",(long)titleBtn.tag);
        
       // [self updateTitleBtnCenter:titleBtn];
        [UIView animateWithDuration:0.4 animations:^{
            
            _lineLbl.center=CGPointMake(titleBtn.center.x, _lineLbl.center.y);
            _lineLbl.tag=titleBtn.tag+100;
        } completion:^(BOOL finished) {
            _selectedTitleBtn.selected=NO;
            _selectedTitleBtn.titleLabel.font = BUTTON_FONT;
            _selectedTitleBtn=titleBtn;
            _selectedTitleBtn.titleLabel.font = BUTTON_BIG_FONT;
            titleBtn.selected=YES;
            
        }];
    }
}
//标题按钮跟着移动
//-(void)updateTitleBtnCenter:(UIButton *)titleBtn {
//    //如果在两头，则不发生位移变化
//    CGPoint point = [_titleSV convertPoint:titleBtn.center toView:_titleSV.superview];
//    if (CGRectGetWidth(_titleSV.frame) / 2 > titleBtn.center.x) {
//        [_titleSV setContentOffset:CGPointMake(0, 0) animated:YES];
//    }else if ((_titleSV.contentSize.width - titleBtn.center.x) < CGRectGetWidth(_titleSV.frame) /2){
//        [_titleSV setContentOffset:CGPointMake(_titleSV.contentSize.width - CGRectGetWidth(_titleSV.frame), _titleSV.contentOffset.y) animated:YES];
//    }else {
//        
//        float space = point.x - CGRectGetWidth(_titleSV.superview.frame)/2;
//        //float space = CGRectGetMinX(titleBtn.frame) - CGRectGetMinX(_selectedTitleBtn.frame);
//        [_titleSV setContentOffset:CGPointMake(_titleSV.contentOffset.x+space, _titleSV.contentOffset.y) animated:YES];
//    }
//}
-(void)scrollToIndex:(int)index {
    [self onClick:_buttonArray[index]];
    //[_contentSV setContentOffset:CGPointMake(_contentSV.frame.size.width*index, _contentSV.contentOffset.y) animated:YES];
}
-(void)onClick:(UIButton *)titleBtn
{
    if (titleBtn.tag==_lineLbl.tag-100) {
        //点击当前显示的
        return;
    }
    //[self updateTitleBtnCenter:titleBtn];
//    if (_titleSV.contentOffset.x+_titleSV.frame.size.width<titleBtn.frame.origin.x+titleBtn.frame.size.width) {
//        [_titleSV setContentOffset:CGPointMake(_titleSV.contentOffset.x+titleBtn.frame.size.width, _titleSV.contentOffset.y) animated:YES];
//    }
//    else if (_titleSV.contentOffset.x>titleBtn.frame.origin.x)
//    {
//        [_titleSV setContentOffset:CGPointMake(titleBtn.frame.origin.x, _titleSV.contentOffset.y) animated:YES];
//    }
    [UIView animateWithDuration:0.4 animations:^{
        _lineLbl.center=CGPointMake(titleBtn.center.x, _lineLbl.center.y);
        _lineLbl.tag=titleBtn.tag+100;
    } completion:^(BOOL finished) {
        _selectedTitleBtn.selected=NO;
        _selectedTitleBtn.titleLabel.font = BUTTON_FONT;
        _selectedTitleBtn=titleBtn;
        _selectedTitleBtn.titleLabel.font = BUTTON_BIG_FONT;
        titleBtn.selected=YES;
    }];
    
    if (_contentSV) {
        //判断是否已经初始化过view
        long x = titleBtn.tag-kButtonTagStart;
        if (![_contentViewArray[x] isKindOfClass:[UIView class]]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(getShowItemViewWithIndex:)]) {
                UIView *view = [self.delegate getShowItemViewWithIndex:(int)x];
                self.currentView = view;
                view.frame=CGRectMake(_contentSV.frame.size.width*x, 0, _contentSV.frame.size.width, _contentSV.frame.size.height);
                [_contentSV addSubview:view];
                [_contentViewArray replaceObjectAtIndex:x withObject:view];
            }
        }
        [_contentSV setContentOffset:CGPointMake(_contentSV.frame.size.width*(titleBtn.tag-kButtonTagStart), _contentSV.contentOffset.y) animated:YES];
        
        
    }
    if (self.slideBtnClickedBlock) {
        self.slideBtnClickedBlock([_titlesArray objectAtIndex:(int)titleBtn.tag-kButtonTagStart]);
    }
}
//-(UIButton *)getTitleButton:(NSDictionary *)dict Frame:(CGRect)frame {
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.backgroundColor = [UIColor clearColor];
//    button.titleLabel.font = BUTTON_FONT;
//    [button setTitleColor:[UIColor diceColorWithRed:158 green:158 blue:158 alpha:1] forState:UIControlStateNormal];
//    [button setTitleColor:Font_COLOR forState:UIControlStateSelected];
//    NSString *title = dict[TITLE_NAME];
//    [button setTitle:title forState:UIControlStateNormal];
//    
//    //button.tag = kButtonTagStart+i;
//    
//    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:BUTTON_BIG_FONT,NSPaperSizeDocumentAttribute:[NSValue valueWithCGSize:CGSizeMake(MAXFLOAT, 25)]}];
//    //CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(MAXFLOAT, 25) lineBreakMode:NSLineBreakByWordWrapping];
//    button.frame = CGRectMake(width, 0, size.width, TITLESV_HEIGHT-LINE_HIGHT);
//    //button.backgroundColor = [UIColor redColor];
//    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews {
    [super layoutSubviews];
    _contentSV.frame = CGRectMake(0, TITLESV_HEIGHT, self.frame.size.width, self.frame.size.height-TITLESV_HEIGHT);
    for (UIView *view in _contentSV.subviews) {
        view.frame = CGRectMake(view.origin.x, view.origin.y, _contentSV.frame.size.width, _contentSV.frame.size.height);
    }
}
@end
