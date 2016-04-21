//
//  CropController.m
//  testImageEdit
//
//  Created by fengwanqi on 15/10/15.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "CropController.h"

@interface CropController ()
{
    ImageCropper *_cropper;
}
@end

@implementation CropController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ImageCropper *cropper = [[ImageCropper alloc] initWithImage:self.sourceImage Frame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 70 - 64 * 2)];
    [cropper setDelegate:self];
    _cropper = cropper;
    [self.view addSubview:cropper.view];
    [self addChildViewController:cropper];
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

- (IBAction)cancelClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)nextClicked:(id)sender {
    [self performSegueWithIdentifier:@"showFilterController" sender:self];
    
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showFilterController"]) {
        [_cropper finishCropping];
        FilterController *vc =  segue.destinationViewController;
        vc.originalImage = _cropper.croppedImage;
        vc.comleteBlock = self.comleteBlock;
        vc.marksCount = self.marksCount;
        //[showMarkVC setValue:_cropper.croppedImage forKey:@"originalImage"];
    }
}

#pragma mark- cropper delegate
-(void)imageCropper:(ImageCropper *)cropper didFinishCroppingWithImage:(UIImage *)image {
    
}
@end
