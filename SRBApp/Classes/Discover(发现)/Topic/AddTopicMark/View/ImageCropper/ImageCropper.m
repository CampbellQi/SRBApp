//
//  ImageCropper.m
//  Created by http://github.com/iosdeveloper
//

#import "ImageCropper.h"
#import "CropRectView.h"

@interface ImageCropper()
{
    CGRect _cropRect;
    CropRectView *_cropRectView;
    UIImage *_image;
    CGRect _frame;
}
@end
@implementation ImageCropper

@synthesize delegate;

- (id)initWithImage:(UIImage *)image Frame:(CGRect)frame {
	self = [super init];
	
	if (self) {
		//[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
        _image = image;
        _frame = frame;
        
	}
	
	return self;
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.frame = _frame;
    self.view.backgroundColor = [UIColor whiteColor];
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setDelegate:self];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setMaximumZoomScale:10.0];
    
    _imageView = [[UIImageView alloc] initWithImage:_image];
    
    float height = self.view.frame.size.width * 3 / 4.0;
    
    CGRect rect;
    rect.origin.x = 0;
    float y = (CGRectGetHeight(_scrollView.frame) - height)/2;
    rect.origin.y = y;
    rect.size.width = _image.size.width;
    rect.size.height = _image.size.height;
    
    
    [_imageView setFrame:rect];
    [_scrollView setContentSize:_imageView.frame.size];
    
    //[_scrollView setMinimumZoomScale:[_scrollView frame].size.width / [_imageView frame].size.width];
    //NSLog(@"%@", NSStringFromCGRect(_imageView.frame));
    if (CGRectGetHeight(_imageView.frame) / CGRectGetWidth(_imageView.frame) > 3.0 / 4.0) {
        [_scrollView setMinimumZoomScale:[_scrollView frame].size.width / [_imageView frame].size.width];
    }else {
        [_scrollView setMinimumZoomScale:height / CGRectGetHeight(_imageView.frame)];
    }
//    if (CGRectGetWidth(_scrollView.frame) > CGRectGetWidth(_imageView.frame) || CGRectGetHeight(_scrollView.frame) > CGRectGetHeight(_imageView.frame)) {
//        [_scrollView setZoomScale:[_scrollView minimumZoomScale]];
//    }
    [_scrollView setZoomScale:[_scrollView minimumZoomScale]];
    [_scrollView addSubview:_imageView];
    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 2 * fabs(y), 0);
    
    [[self view] addSubview:_scrollView];
    
    CropRectView *cropRectView = [[CropRectView alloc] initWithFrame:self.view.bounds];
    cropRectView.backgroundColor = [UIColor clearColor];
    cropRectView.userInteractionEnabled = NO;
    [self.view addSubview:cropRectView];
    _cropRectView = cropRectView;
    
}
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //_imageView.center = CGPointMake(_scrollView.frame.size.width/2, (_scrollView.frame.size.height)/2);
}
//- (void)cancelCropping {
//	[delegate imageCropperDidCancel:self]; 
//}

- (void)finishCropping {
    
	float zoomScale = 1.0 / [_scrollView zoomScale];
	float height = self.view.frame.size.width * 3 / 4;
    
    //CGPoint point1 = [_cropRectView convertPoint:CGPointMake(0, (CGRectGetHeight(_cropRectView.frame) - height)/2) toView:_imageView];
    CGPoint point = [_imageView convertPoint:CGPointMake(0, (CGRectGetHeight(_cropRectView.frame) - height)/2) fromView:_cropRectView];
    
    //NSLog(@"point1 = %@", NSStringFromCGPoint(point1));
    NSLog(@"point = %@", NSStringFromCGPoint(point));
	CGRect rect;
	rect.origin.x = point.x;
	rect.origin.y = point.y;
	rect.size.width = CGRectGetWidth(_cropRectView.frame) * zoomScale;
	rect.size.height = height * zoomScale;
	NSLog(@"rect = %@", NSStringFromCGRect(rect));
    NSLog(@"size = %@", NSStringFromCGSize(_imageView.image.size));
    
    //rect = CGRectMake(0, CGRectGetHeight(_scrollView.frame), SCREEN_WIDTH * zoomScale, SCREEN_WIDTH * zoomScale * (3/4.0));
	CGImageRef cr = CGImageCreateWithImageInRect([[_imageView image] CGImage], rect);
	
	UIImage *cropped = [UIImage imageWithCGImage:cr];
	
	CGImageRelease(cr);
	
    self.croppedImage = cropped;
	//[delegate imageCropper:self didFinishCroppingWithImage:cropped];
}

- (UIImage*)createNewImageFrom:(UIImage*)image withRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, rect, image.CGImage);
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return outputImage;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _imageView;
}
-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    float height = self.view.frame.size.width * 3.0 / 4.0;
    height += height * (3.0/4.0 - _image.size.height/_image.size.width);
    //scrollView.contentInset = UIEdgeInsetsMake(0, 0, height, 0);
//    UIImageView *imgContainer = _imageView;
//    
//    
//    float height = self.view.frame.size.width * 3.0 / 4.0;
//    //scrollView.contentSize = CGSizeMake(scrollView.contentSize.width, scrollView.contentSize.height + height);
//    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
//    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
//    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
//    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
//    imgContainer.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
//                                      scrollView.contentSize.height * 0.5 + offsetY);
    
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {

}
@end