/**
 * editViewController
 * @description 本文件提供拖动排序编辑界面，点击编辑按钮之后可以进行删除和长按拖动排序
 * @package
 * @author 		yinlinlin
 * @copyright 	Copyright (c) 2012-2020
 * @version 		1.0
 * @description 本文件提供拖动排序编辑界面，点击编辑按钮之后可以进行删除和长按拖动排序
 */

#import "editViewController.h"
#import "SubofclassImageViewController.h"
#import <UIButton+WebCache.h>

@interface editViewController ()

@end

@implementation editViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];
    
    _editBu = [UIButton buttonWithType:UIButtonTypeSystem];
    _editBu.frame = CGRectMake(0, 15, 60, 25);
    [_editBu setTitle:@"编 辑" forState:UIControlStateNormal];
    [_editBu setTitle:@"完 成" forState:UIControlStateSelected];
//regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [_editBu setTitleColor:[GetColor16 hexStringToColor:@"#e5005d"] forState:UIControlStateNormal] ;
    _editBu.backgroundColor = WHITE;
    _editBu.layer.cornerRadius = 2;
    _editBu.layer.masksToBounds = YES;
    _editBu.selected = NO;
    [_editBu addTarget:self action:@selector(editBuPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_editBu];
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    
    _newAlbumlist = [[NSMutableArray alloc]initWithArray:_albumlist];
    _newbigAlbumlist = [[NSMutableArray alloc]initWithArray:_bigAlbumlist];
    _newarrlist = [[NSMutableArray alloc]initWithArray:_arrlist];
    _photoAlbumScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height)];
    [self.view addSubview:_photoAlbumScroll];
    //判断是否需要添加一行，当数量刚好是3的倍数时不需要添加
    NSInteger addLine = 0;
    if (_newAlbumlist.count % 3 > 0)
    {
        addLine = 1;
    }
    _photoAlbumScroll.contentSize = CGSizeMake(SCREEN_WIDTH, (_newAlbumlist.count/3 + addLine) * 130 + 55);
    [self updatephotoAlbumScroll];
}

- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 点击navigation右侧编辑按钮
- (void)editBuPressed:(UIButton *)sender
{

    if (sender.selected)
    {
        //处理排序完成的事件
        sender.selected = NO;
        NSLog(@"输出交换之后的数组:%@, %@, %@",_newAlbumlist,_newbigAlbumlist,_newarrlist);
        if (_sortCompleteCallBack)
        {
            _sortCompleteCallBack(_newAlbumlist,_newbigAlbumlist,_newarrlist);
        }
        //[self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        //可以编辑相册
        sender.selected = YES;
        
    }
    for (UIButton * dragBu in _photoAlbumScroll.subviews)
    {
        UIButton * deleteBu = (UIButton *)[dragBu viewWithTag:1000];
        [deleteBu setHidden:!sender.selected];
    }
}

#pragma mark - 拖动晃动
- (void)startShake:(UIView* )imageV
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    shakeAnimation.duration = 0.08;
    shakeAnimation.autoreverses = YES;
    shakeAnimation.repeatCount = MAXFLOAT;
    shakeAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, -0.06, 0, 0, 1)];
    shakeAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate(imageV.layer.transform, 0.06, 0, 0, 1)];
    [imageV.layer addAnimation:shakeAnimation forKey:@"shakeAnimation"];
}

- (void)stopShake:(UIView* )imageV
{
    [imageV.layer removeAnimationForKey:@"shakeAnimation"];
}

#pragma mark - 根据相册数量进行排版
/**
 * @函数名称：updatephotoAlbumScroll
 * @函数描述：根据上一界面获取到的具体的相册数据进行排版
 * @输入参数：void
 * @输出参数：void
 * @返回值：void
 */
- (void)updatephotoAlbumScroll
{
    for (int i = 0; i < _newAlbumlist.count; i ++)
    {
        CGFloat x = i % 3 * SCREEN_WIDTH / 3+ SCREEN_WIDTH / 6;
        CGFloat y = i / 3 * 125 + 60;
//        UIButton * dragBu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [dragBu setFrame:CGRectMake(x, y, 83, 81)];
//        [dragBu setImage:_bigAlbumlist[i] forState:UIControlStateNormal];
//        [_photoAlbumScroll addSubview:dragBu];
        UIImageView * imageView = [[UIImageView alloc]init];
        [imageView setFrame:CGRectMake(0, 0, 83, 81)];
        imageView.center = CGPointMake(x, y);
        imageView.image = _newbigAlbumlist[i];
        imageView.tag = 100 + i;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [imageView setUserInteractionEnabled:YES];
        [_photoAlbumScroll addSubview:imageView];
        UILongPressGestureRecognizer * panTap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        [imageView addGestureRecognizer:panTap];
            UIButton * deleteBu = [UIButton buttonWithType:UIButtonTypeCustom];
        deleteBu.tag = 1000;
        [deleteBu setImage:[UIImage imageNamed:@"img_cancel"] forState:UIControlStateNormal];
        [deleteBu setFrame:CGRectMake(0, 0, 28, 28)];
        [imageView addSubview:deleteBu];
        [deleteBu addTarget:self action:@selector(deleteAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBu setHidden:YES];
    }
}

#pragma mark - 删除相册方法
/**
 * @函数名称：deleteAlbum:
 * @函数描述：用户点击删除相册的按钮，重新排版，并把要删除的相册的id传到后台处理
 * @输入参数：(id)sender
 * @输出参数：void
 * @返回值：void
 */
- (void)deleteAlbum:(UIButton*)sender
{
    _deleteIndex = sender.superview.tag - 100;
    NSLog(@"删除按钮:%@",[_newAlbumlist objectAtIndex:_deleteIndex]);
    //局部变量是不能在闭包中发生改变的，所以需要把_dragToPoint，_dragFromPoint定义成全局变量
    //记录删除按钮的位置
    _dragToPoint = sender.superview.center;
    
    [sender.superview removeFromSuperview];
    
    __block NSMutableArray * bnewAlbumlist = _newAlbumlist;
    __block NSMutableArray * bnewbigAlbumlist = _newbigAlbumlist;
    __block NSMutableArray * bnewarrlist = _newarrlist;
    __block UIScrollView * bphotoScrol = _photoAlbumScroll;
    //把删除按钮的下一个按钮移动到记录的删除按钮的位置，并把下一按钮的位置记为新的_toFrame，并把view的tag值-1,依次处理
    [UIView animateWithDuration:0.3 animations:^
    {
        for (NSInteger i = _deleteIndex + 1; i < bnewAlbumlist.count; i ++)
        {
            UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
            _dragFromPoint = dragBu.center;
            dragBu.center = _dragToPoint;
            _dragToPoint = _dragFromPoint;
            dragBu.tag --;
        }
        
    } completion:^(BOOL finished) {
        //移动完成之后,才能从_newAlbumlist列表中移除要删除按钮的数据
        
        [bnewAlbumlist removeObjectAtIndex:_deleteIndex];
        [bnewbigAlbumlist removeObjectAtIndex:_deleteIndex];
        [bnewarrlist removeObjectAtIndex:_deleteIndex];
    }];
}


#pragma mark - 拖动排序处理方法
/**
 * @函数名称：handlePanGesture:
 * @函数描述：处理相册上面的拖动手势，判断手势的state，并做处理
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)handlePanGesture:(UIGestureRecognizer *)recognizer
{
    if (![_editBu isSelected]) {
        SubofclassImageViewController * vc = [[SubofclassImageViewController alloc]init];
        vc.imageArray = _newbigAlbumlist;
        vc.imgIndex =recognizer.view.tag - 99 ;
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            [self dragTileBegan:recognizer];
            [self startShake:recognizer.view];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self dragTileMoved:recognizer];
            break;//开始时忘记加break，一直执行结束方法
        }
        case UIGestureRecognizerStateEnded:
        {
            [self dragTileEnded:recognizer];
            [self stopShake:recognizer.view];
            break;
        }
            
        default:
            break;
    }
    
}

/**
 * @函数名称：dragTileBegan:
 * @函数描述：拖动手势开始，记录拖动的起始位置，并把拖动的view做放大处理
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)dragTileBegan:(UIGestureRecognizer *)recognizer
{
    //把要移动的视图放在顶层
    [_photoAlbumScroll bringSubviewToFront:recognizer.view];
    
    _dragFromPoint = recognizer.view.center;
}

/**
 * @函数名称：dragTileMoved:
 * @函数描述：拖动手势进行中，获取手势在界面的位置（location），把拖动的view的center设为location
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)dragTileMoved:(UIGestureRecognizer *)recognizer
{
    CGPoint locationPoint = [recognizer locationInView:_photoAlbumScroll];
    recognizer.view.center = locationPoint;
    [self pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIImageView *)recognizer.view];
}

/**
 * @函数名称：pushedTileMoveToDragFromPointIfNecessaryWithTileView:
 * @函数描述：拖动手势进行中，判断被拖动的界面是否移动到另一界面所在frame
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)pushedTileMoveToDragFromPointIfNecessaryWithTileView:(UIView *)tileView
{
    for (UIButton *item in _photoAlbumScroll.subviews)
    {
        //移动到另一个按钮的区域，判断需要移动按钮的位置
        if (CGRectContainsPoint(item.frame, tileView.center) && item != tileView )
        {
            
            //开始的位置
            NSInteger fromIndex = tileView.tag - 100;
            //需要移动到的位置
            NSInteger toIndex = (item.tag - 100)>0?(item.tag - 100):0;
            NSLog(@"从位置%ld移动到位置%ld",(long)fromIndex, (long)toIndex);
            [self dragMoveFromIndex:fromIndex ToIndex:toIndex withView:tileView];
        }
    }
}

/**
 * @函数名称：dragMoveFromIndex:ToIndex:withView:
 * @函数描述：拖动view交换位置
 * @输入参数：(NSInteger)fromIndex：被移动view的位置在第几个
 (NSInteger)toIndex：移动到的位置
 (UIImageView *)tileView：被移动的view
 * @输出参数：void
 * @返回值：void
 */
- (void)dragMoveFromIndex:(NSInteger)fromIndex ToIndex:(NSInteger)toIndex withView:(UIView *)tileView
{
    //局部变量是不能在闭包中发生改变的，所以需要把_dragFromPoint，_dragToPoint定义成全局变量
    __block NSMutableArray * bnewAlbumlist = _newAlbumlist;
    __block NSMutableArray * bnewbigAlbumlist = _newbigAlbumlist;
    __block NSMutableArray * bnewarrlist = _newarrlist;
    __block UIScrollView * bphotoScrol = _photoAlbumScroll;
    NSDictionary * moveDict = [bnewAlbumlist objectAtIndex:fromIndex];
    [bnewAlbumlist removeObjectAtIndex:fromIndex];
    [bnewAlbumlist insertObject:moveDict atIndex:toIndex];
    
    NSDictionary * moveDict1 = [bnewbigAlbumlist objectAtIndex:fromIndex];
    [bnewbigAlbumlist removeObjectAtIndex:fromIndex];
    [bnewbigAlbumlist insertObject:moveDict1 atIndex:toIndex];

    NSDictionary * moveDict2 = [bnewarrlist objectAtIndex:fromIndex];
    [bnewarrlist removeObjectAtIndex:fromIndex];
    [bnewarrlist insertObject:moveDict2 atIndex:toIndex];

    //向前移动
    if (fromIndex > toIndex)
    {
        //把移动相册的上一个相册移动到记录的移动相册的位置，并把上一相册的位置记为新的_dragFromPoint，并把view的tag值+1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            
            for (NSInteger i = fromIndex - 1; i >= toIndex; i--)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag ++;
            }
            tileView.tag = 100 + toIndex;
            
        }];
        
    }
    //向后移动
    else
    {
        //把移动相册的下一个相册移动到记录的移动相册的位置，并把下一相册的位置记为新的_dragFromPoint，并把view的tag值-1,依次处理
        [UIView animateWithDuration:0.3 animations:^{
            for (NSInteger i = fromIndex + 1; i <= toIndex; i++)
            {
                UIButton * dragBu = (UIButton *)[bphotoScrol viewWithTag:i + 100];
                _dragToPoint = dragBu.center;
                dragBu.center = _dragFromPoint;
                _dragFromPoint = _dragToPoint;
                dragBu.tag --;
            }
            tileView.tag = 100 + toIndex;
            
        }];
    }
    
}

/**
 * @函数名称：dragTileEnded:
 * @函数描述：拖动手势完成，把拖动的界面放到最后记录的位置
 * @输入参数：(UIPanGestureRecognizer *)recognizer
 * @输出参数：void
 * @返回值：void
 */
- (void)dragTileEnded:(UIGestureRecognizer *)recognizer
{
    //    [UIView animateWithDuration:0.2f animations:^{
    //        recognizer.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
    //        recognizer.view.alpha = 1.f;
    //    }];
    
    [UIView animateWithDuration:0.2f animations:^{
        if (_isDragTileContainedInOtherTile)
            recognizer.view.center = _dragToPoint;
        else
            recognizer.view.center = _dragFromPoint;
    }];
    _isDragTileContainedInOtherTile = NO;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
