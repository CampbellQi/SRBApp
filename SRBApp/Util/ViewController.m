//
//  ViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "ViewController.h"
#import "TwoDimensionCodeViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
	UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"扫描" forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(100, 100, 120, 40);
    [scanButton addTarget:self action:@selector(setupCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
}
-(void)setupCamera
{
    TwoDimensionCodeViewController * rt = [[TwoDimensionCodeViewController alloc]init];
    [self presentViewController:rt animated:YES completion:^{
        
    }];
}

//扫描线
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    [timer invalidate];
//    _line.frame = CGRectMake(30, 10, 220, 2);
//    num = 0;
//    upOrdown = NO;
//    [picker dismissViewControllerAnimated:YES completion:^{
//        [picker removeFromParentViewController];
//        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
//        //初始化
//        ZBarReaderController * read = [ZBarReaderController new];
//        //设置代理
//        read.readerDelegate = self;
//        CGImageRef cgImageRef = image.CGImage;
//        ZBarSymbol * symbol = nil;
//        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
//        for (symbol in results)
//        {
//            break;
//        }
//        NSString * result;
//        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
//            
//        {
//            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
//        }
//        else
//        {
//            result = symbol.data;
//        }
//        
//        
//        NSLog(@"%@",result);
//        
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
