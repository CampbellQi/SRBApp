//
//  SubofclassImageViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/19.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubofclassImageViewController.h"
#import "UIImageView+WebCache.h"
#import "ZoomingView.h"
#import "AppDelegate.h"
#import "DACircularProgressView.h"

@interface SubofclassImageViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain) UIScrollView *scrollView;
@property (nonatomic,retain) UILabel *pageLabel;
@property (nonatomic,assign) BOOL tap;
@property (nonatomic,retain) NSMutableArray * tempArr;

@end

@implementation SubofclassImageViewController
{
    BOOL isHidden;
    UIView * topBGView;
    NSMutableArray * imgArr;
    int page;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageArray = [[NSMutableArray alloc] init];
        imgArr = [NSMutableArray array];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBar.translucent = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.navigationController.navigationBar.translucent = NO;
}

- (void)hiddenTap:(UITapGestureRecognizer *)tap
{
    //    isHidden = !isHidden;
    //    AppDelegate * app = APPDELEGATE;
    //    [UIView animateWithDuration:0.2 animations:^{
    //        [self prefersStatusBarHidden];
    //        if (isHidden) {
    //            [app.application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    //            topBGView.alpha = 0;
    //        }else{
    //            [app.application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    //            topBGView.alpha = 1;
    //        }
    //    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backBtn:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    self.tap = YES;
    isHidden = NO;
    [super viewDidLoad];
    self.view.backgroundColor = [GetColor16 hexStringToColor:@"#000000"];
    //scrollView自我集成  使它恢复手动调节frame的方法一
    self.automaticallyAdjustsScrollViewInsets = NO;
    
//    if (self.imageUrl.length < 120) {
//        [self.imageArray addObject:self.imageUrl];
//    }else{
//        self.imageArray = [self.imageUrl componentsSeparatedByString:@","];
//    }
//    
//    self.tempArr = [NSMutableArray array];
//    for (int i = 0; i < self.imageArray.count; i++) {
//        [self.tempArr addObject:[self.imageArray[i] stringByReplacingOccurrencesOfString:@"_sm" withString:@""]];
//    }
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-10, 0, SCREEN_WIDTH+20, SCREEN_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake((SCREEN_WIDTH + 20)*(self.imageArray.count), SCREEN_HEIGHT);
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.delegate = self;
    self.scrollView.contentOffset = CGPointMake((self.imgIndex - 1)*(SCREEN_WIDTH + 20), 0);
    [self.view addSubview:self.scrollView];
    
    UITapGestureRecognizer * hiddenTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenTap:)];
    [_scrollView addGestureRecognizer:hiddenTap];
    //http://mapi.shurenbang.net/upload/image/20150213/28afabee-002b-4682-8a4d-e27a000e7cd8.png
    
    //添加图片
    for (int i = 0; i < self.imageArray.count; i ++) {
        ZoomingView * zoomingView = [[ZoomingView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH + 20)*i + 10, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        zoomingView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
        zoomingView.minimumZoomScale = 1;
        zoomingView.maximumZoomScale = 4;
        [self.scrollView addSubview:zoomingView];
        
        UIImageView * imageV = [[UIImageView alloc] init];
        imageV.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        imageV.userInteractionEnabled = YES;
        imageV.image = _imageArray[i];
//        
//        //        [imgView sd_setImageWithURL:[NSURL URLWithString:self.gifModel.mp4_url] placeholderImage:[UIImage imageNamed:@"GIF_temp.png"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//        //            NSLog(@"%lu---%lu",receivedSize,expectedSize);
//        //            countInteger = 1.0f/(double)expectedSize;
//        //            everyInteger = (double)receivedSize / (double)expectedSize;
//        //            progressView.progress = everyInteger;
//        //        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //            [progressView removeFromSuperview];
//        //            imgView.image = image;
//        //        }];
//        
//        DACircularProgressView * progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(140.0f, 20.0f, 40.0f, 40.0f)];
//        progressView.center = imageV.center;
//        progressView.hidden = YES;
//        [imageV addSubview:progressView];
//        
//        [imageV sd_setImageWithURL:[NSURL URLWithString:self.tempArr[i]] placeholderImage:[UIImage imageNamed:@"zanwu"] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
//            progressView.hidden = NO;
//            NSLog(@"%lu---%lu",receivedSize,expectedSize);
//            //            countInteger = 1.0f/(double)expectedSize;
//            progressView.progress = (double)receivedSize / (double)expectedSize;
//            if (receivedSize == expectedSize) {
//                progressView.hidden = YES;
//            }
//            //            progressView.hidden = YES;
//            //            progressView.progress = everyInteger;
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            if (image) {
//                [imgArr addObject:image];
//            }
//            imageV.image = image;
//            progressView.hidden = YES;
//            //            [[SDImageCache sharedImageCache] removeImageForKey:self.tempArr[i]];
//        }];
//        //        [[SDImageCache sharedImageCache] removeImageForKey:self.tempArr[i]];
//        
//        //        [imageV sd_setImageWithURL:[NSURL URLWithString:self.imageArray[i]] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        //            if (image) {
//        //               [imgArr addObject:image];
//        //            }
//        //            CGRect rect = imageV.frame;
//        //            rect.size.height = image.size.height;
//        //            rect.size.width = image.size.width;
//        //            imageV.frame = rect;
//        //
//        //            float minimScale = SCREEN_WIDTH / imageV.frame.size.width;
//        //            [zoomingView setMinimumZoomScale:minimScale];
//        //            [zoomingView setZoomScale:minimScale];
//        
//        
//        
//        //            if (image.size.width > SCREEN_WIDTH) {
//        //                imageV.frame = CGRectMake(0, (SCREEN_HEIGHT - (image.size.height*(SCREEN_WIDTH/image.size.width)))/2, SCREEN_WIDTH, image.size.height*(SCREEN_WIDTH/image.size.width));
//        //                //imageV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//        //                //zoomingView.contentSize = CGSizeMake(SCREEN_WIDTH, image.size.height*(SCREEN_WIDTH/image.size.width));//image.size;
//        //            }else if(image.size.height > SCREEN_HEIGHT){
//        //                imageV.frame = CGRectMake((SCREEN_WIDTH - image.size.width*(SCREEN_HEIGHT/image.size.height))/2, 0, image.size.width*(SCREEN_HEIGHT/image.size.height), SCREEN_HEIGHT);
//        //                //imageV.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//        //                //zoomingView.contentSize = CGSizeMake(image.size.width*(SCREEN_HEIGHT/image.size.height), SCREEN_HEIGHT);//image.size;
//        //            }else{
//        //                zoomingView.contentSize = image.size;
//        //            }
//        //        }];
        
        imageV.contentMode = UIViewContentModeScaleAspectFit;
        [zoomingView addSubview:imageV];
        //双击放大缩小的手势
        UITapGestureRecognizer *doubelTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(zoomingTap:)];
        doubelTap.numberOfTapsRequired = 2;
        [imageV addGestureRecognizer:doubelTap];
        
        [hiddenTap requireGestureRecognizerToFail:doubelTap];
    }
    
    //顶部view
    topBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 40)];
    topBGView.backgroundColor = [UIColor clearColor];
    //topBGView.hidden = YES;
    topBGView.alpha = 1;
    [self.view addSubview:topBGView];
    

    
    UIButton * downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [downBtn setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    downBtn.frame = CGRectMake(SCREEN_WIDTH - 15 - 12.5 - 18, 4, 40, 40);
    [downBtn addTarget:self action:@selector(saveImageToPhotos) forControlEvents:UIControlEventTouchUpInside];
    //[topBGView addSubview:downBtn];
    
    //显示页数
    self.pageLabel = [[UILabel alloc] init];
    self.pageLabel.frame = CGRectMake((SCREEN_WIDTH - 40)/2, 12, 40, 16);
    page = _scrollView.contentOffset.x/SCREEN_WIDTH+1;
    self.pageLabel.text = [NSString stringWithFormat:@"%.0f/%lu",_scrollView.contentOffset.x/SCREEN_WIDTH + 1,(unsigned long)self.imageArray.count];
    self.pageLabel.textColor = [UIColor whiteColor];
    self.pageLabel.textAlignment = NSTextAlignmentCenter;
    self.pageLabel.font = SIZE_FOR_IPHONE;
    [topBGView addSubview:self.pageLabel];
}


- (void)saveImageToPhotos{
    
    if (imgArr.count != 0) {
        if ([self.pageLabel.text integerValue] > imgArr.count) {
            UIImageWriteToSavedPhotosAlbum([imgArr objectAtIndex:imgArr.count - 1], nil, nil, nil);
        }else{
            UIImageWriteToSavedPhotosAlbum([imgArr objectAtIndex:[self.pageLabel.text integerValue]-1], nil, nil, nil);
        }
        [AutoDismissAlert autoDismissAlert:@"保存成功"];
    }
}

//代理方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (UIScrollView *s in scrollView.subviews){
        if ([s isKindOfClass:[UIScrollView class]]){
            if (page != self.scrollView.contentOffset.x/SCREEN_WIDTH + 1) {
                [s setZoomScale:1.0];
            }
        }
    }
    page = self.scrollView.contentOffset.x/SCREEN_WIDTH+1;
    self.pageLabel.text = [NSString stringWithFormat:@"%.0f/%lu",self.scrollView.contentOffset.x/SCREEN_WIDTH + 1,(unsigned long)self.imageArray.count];
    
    
    //    if (self.scrollView.contentOffset.x == 320*_imageArray.count-320) {
    //        UIAlertView *lastImage = [[UIAlertView alloc] initWithTitle:@"已经是最后一张了" message:nil delegate:self cancelButtonTitle:@"好" otherButtonTitles: nil];
    //        [lastImage show];
    //        [lastImage release];
    //    }
    
}
//自定义方法
- (void)zoomingTap:(UITapGestureRecognizer *)doubleTap
{
    UIScrollView *s = (UIScrollView *)doubleTap.view.superview;
    if ([s isKindOfClass:[UIScrollView class]]) {
        float newScale;
        if (self.tap == YES) {
            //[s setZoomScale:2.0];
            newScale = s.zoomScale *4.0;
            self.tap = NO;
        }else{
            //[s setZoomScale:1.0];
            newScale = s.zoomScale *0.0;
            self.tap = YES;
        }
        
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[doubleTap locationInView:doubleTap.view]];
        [s zoomToRect:zoomRect animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height =SCREEN_WIDTH / scale;
    zoomRect.size.width  =SCREEN_HEIGHT  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
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
