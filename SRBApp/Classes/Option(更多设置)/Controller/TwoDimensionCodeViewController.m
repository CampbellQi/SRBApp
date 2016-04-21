//
//  TwoDimensionCodeViewController.m
//  SRBApp
//
//  Created by lizhen on 15/4/22.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "TwoDimensionCodeViewController.h"
#import "SubSublPersonalViewController.h"
#import "FriendsViewController.h"
#import "DetailActivityViewController.h"

@interface TwoDimensionCodeViewController ()

@end

@implementation TwoDimensionCodeViewController

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
    self.view.backgroundColor = [UIColor blackColor];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.center.x - 150, self.view.center.y - 150, 300, 300)];
    imageView.image = [UIImage imageNamed:@"pick_bg"];
    [self.view addSubview:imageView];
    
    UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanButton setTitle:@"取 消" forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [scanButton setTitleColor:[GetColor16 hexStringToColor:@"e5005d"] forState:UIControlStateNormal];
    scanButton.frame = CGRectMake(self.view.center.x - 60, imageView.frame.origin.y + imageView.frame.size.height + 30, 120, 40);
    [scanButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    upOrdown = NO;
    num =0;
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.center.x - 140, self.view.center.y - 120, 240, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [self.view addSubview:_line];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(self.view.center.x - 120, self.view.center.y - 140+2*num, 240, 2);
        if (2*num == 280) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(self.view.center.x - 120, self.view.center.y - 140+2*num, 240, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
}
-(void)backAction
{
    
    [self dismissViewControllerAnimated:YES completion:^{
        [timer invalidate];
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self setupCamera];
}
- (void)setupCamera
{
    
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    // Input
    _input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // Output
    _output = [[AVCaptureMetadataOutput alloc]init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // Session
    _session = [[AVCaptureSession alloc]init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.input])
    {
        [_session addInput:self.input];
    }
    
    if ([_session canAddOutput:self.output])
    {
        [_session addOutput:self.output];
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    _output.metadataObjectTypes =@[AVMetadataObjectTypeQRCode];
    
    // Preview
    _preview =[AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _preview.frame =CGRectMake(self.view.center.x - 140, self.view.center.y - 140, 280,280);
    
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    // Start
    [_session startRunning];
    
}
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    
    NSString *stringValue;
    
    if ([metadataObjects count] >0)
    {
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex:0];
        stringValue = metadataObject.stringValue;
    }
    
    [_session stopRunning];
    [self dismissViewControllerAnimated:YES completion:^
     {
         [timer invalidate];
         NSLog(@"stringValue == %@",stringValue);
         if ([stringValue rangeOfString:@"http"].length > 0 && ![stringValue rangeOfString:@"srbapp"].length > 0) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:stringValue]];
         }else if([stringValue rangeOfString:@"http"].length > 0 && [stringValue rangeOfString:@"srbapp"].length > 0 && [stringValue rangeOfString:@"userpost"].length > 0){
             
             NSArray *idArr = [stringValue componentsSeparatedByString:@"/"];
             AppDelegate *app = APPDELEGATE;
             DetailActivityViewController *detailVC = [[DetailActivityViewController alloc] init];
             ZZNavigationController * nac3 = app.mainTab.viewControllers[3];
             FriendsViewController * friendsVC = nac3.viewControllers[0];
             detailVC.idNumber = idArr.lastObject;
             [friendsVC.navigationController pushViewController:detailVC animated:YES];
         }else if ([stringValue rangeOfString:@"http"].length > 0 && [stringValue rangeOfString:@"srbapp"].length > 0 && [stringValue rangeOfString:@"invitecode"].length > 0){
             NSArray *accountArr = [stringValue componentsSeparatedByString:@"/"];
             AppDelegate *app = APPDELEGATE;
             SubSublPersonalViewController *personalVC = [[SubSublPersonalViewController alloc] init];
             ZZNavigationController * nac3 = app.mainTab.viewControllers[3];
             FriendsViewController * friendsVC = nac3.viewControllers[0];
             personalVC.invitecode = accountArr.lastObject;
             personalVC.myRun = @"2";
             [friendsVC.navigationController pushViewController:personalVC animated:YES];
         }
//         else if ([stringValue rangeOfString:@"http"].length > 0 && [stringValue rangeOfString:@"srbapp"].length > 0 && [stringValue rangeOfString:@"userinfo"].length > 0){
//             NSArray *accountArr = [stringValue componentsSeparatedByString:@"/"];
//             AppDelegate *app = APPDELEGATE;
//             SubSublPersonalViewController *personalVC = [[SubSublPersonalViewController alloc] init];
//             ZZNavigationController * nac3 = app.mainTab.viewControllers[3];
//             FriendsViewController * friendsVC = nac3.viewControllers[0];
//             personalVC.account = accountArr.lastObject;
//             personalVC.myRun = @"2";
//             [friendsVC.navigationController pushViewController:personalVC animated:YES];
//         }
         else
         {
             [AutoDismissAlert autoDismissAlert:@"类型错误"];
         }
     }];
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
