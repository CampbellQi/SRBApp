//
//  FilterController.m
//  testImageEdit
//
//  Created by fengwanqi on 15/10/30.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "FilterController.h"
#import "CropImageView.h"
#import "InputMarkController.h"
#import "ResultController.h"
#import "UIImage+Compress.h"

@interface FilterController ()
{
    CropImageView *_cropImageView;
    NSArray *_filtersArray;
    CGPoint _unPoint;
    NSMutableArray *_dataArray;
}
@end

@implementation FilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray new];
    self.sourceIV.image = _originalImage;
    //self.sourceIV.transform = CGAffineTransformMakeRotation(M_PI * 0.5);
    self.sourceIV.tapBlock = ^(CGPoint point){
        [self demoIVTap:point];
        _animationIV.hidden = YES;
    };
    _cropImageView = [[CropImageView alloc] init];
    _filtersArray = nil;
    [self setUpView];
}
#pragma mark- 页面
-(void)setUpView {
    self.markMsgLbl.text = @"点击图片\n选择添加商品相关信息";
//动画手势
    _animationIV.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"ic_animation1"],
                                      [UIImage imageNamed:@"ic_animation2"],
                                      [UIImage imageNamed:@"ic_animation3"],
                                      [UIImage imageNamed:@"ic_animation4"],
                                      [UIImage imageNamed:@"ic_animation5"],
                                      [UIImage imageNamed:@"ic_animation6"],
                                      [UIImage imageNamed:@"ic_animation7"],
                                      nil];
    
    // all frames will execute in 1.75 seconds
    _animationIV.animationDuration = 1.0;
    // repeat the annimation forever
    _animationIV.animationRepeatCount = 0;
    // start animating
    [_animationIV startAnimating];
    // add the animation view to the main window
    [self.view addSubview:_animationIV];

    
    //滚动滤镜
    NSArray *array = [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色", nil];
    _filtersArray = array;
    float space = 5.0;
    float scale = 0.8;
    float width = CGRectGetHeight(_filterSV.frame) - 2 * space;
    width *= scale;
    for (int index = 0; index < [array count]; index++)
    {
        float x = space + (width + space)*index;
        CGRect frame = CGRectMake(x, space, width, CGRectGetHeight(_filterSV.frame));
        UIView *view = [self createFilterItemWithFrame:frame Title:array[index] Image:[UIImage imageNamed:[NSString stringWithFormat:@"ic_filter%d", index+1]]];
        //NSLog(@"%@", [NSString stringWithFormat:@"ic_filter%d", index+1]);
        view.tag = 100 + index;
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(filtersSelectButtonDidPressed:)]];
        [_filterSV addSubview:view];
    }
    [_filterSV setContentSize:CGSizeMake([array count]*(space + width) + space, 0)];
}

//创建滤镜按钮们
-(UIView *)createFilterItemWithFrame:(CGRect)frame Title:(NSString *)title Image:(UIImage *)image {
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    
    //float scale = 0.3;
    float height = CGRectGetWidth(frame);
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), height)];
    iv.image = image;
    [view addSubview:iv];
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(iv.frame), CGRectGetWidth(frame), CGRectGetHeight(frame) - height)];
    lbl.text = title;
    [view addSubview:lbl];
    lbl.textAlignment = NSTextAlignmentCenter;
    lbl.textColor = [UIColor lightGrayColor];
    lbl.font = [UIFont systemFontOfSize:12.0];
    lbl.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark- 事件
-(void)demoIVTap:(CGPoint )unPoint {
    if (self.filterBtn.selected) {
        return;
    }
    if (_dataArray.count == self.marksCount) {
        [AutoDismissAlert autoDismissAlertSecond:[NSString stringWithFormat:@"最多只能添加%d个标签哦", self.marksCount]];
        return;
    }
    [self performSegueWithIdentifier:@"showInputMarkController" sender:nil];
    _unPoint = unPoint;
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showInputMarkController"]) {
        InputMarkController *input =  segue.destinationViewController;
        if (sender) {
            input.sourceMarkView = sender;
        }
        __block typeof(InputMarkController) *unInput = input;
        
        input.completeBlock = ^(TPMarkModel *model) {
            if (unInput.sourceMarkView) {
                [unInput.sourceMarkView removeFromSuperview];
                [_dataArray removeObject:unInput.sourceMarkView.sourceModel];
                _unPoint = unInput.sourceMarkView.currentPoint;
            }
            
            if (model) {
                WQMarkView *markView = [WQMarkView produceWithData:model];
                __block typeof(WQMarkView *) unMarView = markView;
                [self.sourceIV addSubview:markView];
                [_dataArray addObject:model];
                unMarView.needAnimation = YES;
                
                markView.sourceModel = model;
                //markView.center = unPoint;
                markView.currentPoint = _unPoint;
                [markView resetCenter];
                
                unInput.sourceMarkView = markView;
                
                NSString * xScale = [NSString stringWithFormat:@"%.3f", markView.currentPoint.x/self.sourceIV.width];
                NSString *yScale = [NSString stringWithFormat:@"%.3f", markView.currentPoint.y/self.sourceIV.height];
                model.xyz = [NSString stringWithFormat:@"%@,%@",xScale, yScale];
                
                markView.tappedBlock = ^(void) {
                    if (self.filterBtn.selected) {
                        return;
                    }
                    [self performSegueWithIdentifier:@"showInputMarkController" sender:unMarView];
                };
                
                markView.resetPointBlock = ^(void) {
                    NSString * xScale = [NSString stringWithFormat:@"%.3f", markView.currentPoint.x/self.sourceIV.width];
                    NSString *yScale = [NSString stringWithFormat:@"%.3f", markView.currentPoint.y/self.sourceIV.height];
                    model.xyz = [NSString stringWithFormat:@"%@,%@",xScale, yScale];
                };
            }
            
        };
    }else if ([segue.identifier isEqualToString:@"showResultController"]) {
        ResultController *vc = segue.destinationViewController;
        vc.sourceImage = sender[0];
        vc.markArray = sender[1];
    }
}

- (IBAction)filterBtnClicked:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        self.filtersSuperView.hidden = NO;
        self.markBtn.selected = NO;
        //self.markMsgLbl.hidden = YES;
        _animationIV.hidden = YES;
    
    }
    
}

- (IBAction)markBtnClicked:(UIButton *)sender {
    if (!sender.selected) {
        self.filtersSuperView.hidden = YES;
        sender.selected = YES;
        self.filterBtn.selected = NO;
        //self.markMsgLbl.hidden = NO;
        _animationIV.hidden = NO;
    }
    
}

- (IBAction)okBtnClicked:(id)sender {
#if 1
    //从求购发布页面进来，必须要求输入一个标签
    if (self.marksCount == 1 && _dataArray.count == 0) {
        //[AutoDismissAlert autoDismissAlert:@"请添加标签填写品牌、名称才可以发布求购哟~"];
        if (down_IOS_8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请添加标签填写品牌、\n名称才可以发布求购哟~" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
            [alert show];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请添加标签填写品牌、\n名称才可以发布求购哟~" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [alert addAction:[UIAlertAction actionWithTitle:nil style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                //[self.navigationController dismissViewController];
//            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }

        return;
    }
    if (self.comleteBlock) {
        self.comleteBlock(self.sourceIV.image, _dataArray);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
#else
    [self performSegueWithIdentifier:@"showResultController" sender:@[self.sourceIV.image, _dataArray]];
#endif
}
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(UIImage *)filterWithNumber:(int)number Image:(UIImage *)aImage{
    UIImage *image = nil;
    switch (number - 100)
    {
        case 0:
        {
            image= aImage;
            break;
        }
        case 1:
        {
            image = [aImage lomo];
            break;
        }
        case 2:
        {
            image = [aImage blackWhite];
            break;
        }
        case 3:
        {
            image = [aImage missOld];
            break;
        }
        case 4:
        {
            image = [aImage geTe];
            break;
        }
        case 5:
        {
            image = [aImage ruiHuai];
            break;
        }
        case 6:
        {
            image = [aImage danYa];
            break;
        }
        case 7:
        {
            image = [aImage jiuHong];
            break;
        }
        case 8:
        {
            image = [aImage qingNing];
            break;
        }
        case 9:
        {
            image = [aImage langMan];
            break;
        }
        case 10:
        {
            image = [aImage guangYun];
            break;
        }
        case 11:
        {
            image = [aImage lanDiao];
            break;
        }
        case 12:
        {
            image = [aImage mengHuan];
            break;
        }
        case 13:
        {
            image = [aImage yeSe];
            break;
        }
        default:
            break;
    }
    return image;
}
- (void)filters:(NSNumber*)number
{
    UIImage *image = [self filterWithNumber:number.intValue Image:self.originalImage];
    [self.sourceIV setImage:image];
}

- (void)filtersSelectButtonDidPressed:(UIGestureRecognizer*)gr
{
    MBProgressHUD *waitView = [[MBProgressHUD alloc] initWithFrame:self.view.frame];
    [waitView setDelegate:self];
    [self.view addSubview:waitView];
    [waitView showWhileExecuting:@selector(filters:) onTarget:self withObject:[NSNumber numberWithInt:(int)gr.view.tag] animated:YES];
}
#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
