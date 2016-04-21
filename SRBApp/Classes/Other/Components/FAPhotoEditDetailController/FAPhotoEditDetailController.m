//
//  FAPhotoShowDetailController.m
//  FArts
//
//  Created by zhanShen3 on 15/5/28.
//  Copyright (c) 2015年 com.uwny. All rights reserved.
//

#import "FAPhotoEditDetailController.h"
#import "FANavigationBar.h"
//#import "UIView+Helper.h"

@interface FAPhotoEditDetailController ()<FANavigationBarDelegate,UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    NSInteger _currentIndex;
}
@end

@implementation FAPhotoEditDetailController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.imageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationController.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //_navigationBar = [[FANavigationBar alloc] initWithLeftImage:[UIImage imageNamed:@"backBtn.png"] withTitle:@"浏览照片" rightImage:[UIImage imageNamed:@"deletePhoto.png"]];
//    _navigationBar.delegate = self;
//    _navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
//    [self.view addSubview:_navigationBar];
    
//    NSDictionary *views = NSDictionaryOfVariableBindings(_navigationBar);
//    NSMutableArray *constraints = [NSMutableArray array];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_navigationBar]-0-|" options:0 metrics:nil views:views]];
//    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_navigationBar(64)]" options:0 metrics:nil views:views]];
//    [self.view addConstraints:constraints];
//    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = [NSString stringWithFormat:@"%ld/%lu",self.selectedIndex+1,(unsigned long)[_imageArray count]];
    //导航栏
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(leftButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton * delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [delBtn setBackgroundImage:[UIImage imageNamed:@"deletePhoto.png"] forState:UIControlStateNormal];
    delBtn.frame = CGRectMake(15, 0, 30, 30);
    [delBtn addTarget:self action:@selector(rightButtonDidTouch) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:delBtn];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view .width, self.view .height)];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake( _imageArray.count * self.view .width, 0);
    [self.view addSubview:_scrollView];
    
    [self reloadData];
    _scrollView.contentOffset = CGPointMake(self.selectedIndex * self.view .width, 0);
    
}

- (void)reloadData
{
    for (UIView *iv in _scrollView.subviews) {
        [iv removeFromSuperview];
    }
    if( _imageArray.count == 0){
        [self.navigationController popViewControllerAnimated:YES];
    }
    [ _imageArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImage *image = obj;
        UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.width * idx, 0, self.view.width, self.view.height-64)];
        if ([image isKindOfClass:[UIImage class]]) {
            photoView.image = image;
            if (photoView.image.size.height > photoView.image.size.width) {
                photoView.contentMode = UIViewContentModeScaleToFill;
            }else{
                photoView.contentMode = UIViewContentModeScaleAspectFit;
            }
        }else {
            [photoView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"zanwu"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (photoView.image.size.height > photoView.image.size.width) {
                    photoView.contentMode = UIViewContentModeScaleToFill;
                }else{
                    photoView.contentMode = UIViewContentModeScaleAspectFit;
                }
            }];
        }
        
        photoView.backgroundColor = [UIColor clearColor];
        
        
        photoView.clipsToBounds = YES;
        _scrollView.contentSize = CGSizeMake( _imageArray.count * self.view .width, 0);
        [_scrollView addSubview:photoView];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float currentPosition = scrollView.contentOffset.x;
    _currentIndex = currentPosition/_scrollView.width;
    self.title = [NSString stringWithFormat:@"%ld/%lu", _currentIndex+1,(unsigned long)[ _imageArray count]];
}

- (void)rightButtonDidTouch
{
    [_imageArray removeObjectAtIndex: _currentIndex];
    self.editImageBlock(_imageArray);
    self.title = [NSString stringWithFormat:@"%ld/%lu", _currentIndex+1,(unsigned long)[_imageArray count]];
    [self reloadData];
}

-  (void)leftButtonDidTouch
{
    [self.navigationController popViewControllerAnimated:YES];
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
