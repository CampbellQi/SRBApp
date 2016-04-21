//
//  PersonImformationViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/1/7.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "PersonImformationViewController.h"
#import <UIImageView+WebCache.h>

@interface PersonImformationViewController ()
@property (nonatomic ,strong)UIImageView * imageView;
@property (nonatomic ,strong)UIButton * imageButton;
@property (nonatomic ,strong)UILabel * textLabel;
@end

@implementation PersonImformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    
    
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    _imageView.center = CGPointMake(SCREEN_WIDTH / 2,  30 + 37.5);
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_headImageUrl] placeholderImage:[UIImage imageNamed:@"zanwu"]];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    _imageView.layer.cornerRadius = 37;
    _imageView.layer.masksToBounds = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    [self.view addSubview:_imageView];
    
    //图片按钮
//    _imageButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
//    _imageButton.center = CGPointMake(SCREEN_WIDTH / 2,  30 + 37.5);
//    _imageButton.backgroundColor = [UIColor clearColor];
//    _imageButton.layer.cornerRadius = 37;
//    _imageButton.layer.masksToBounds = YES;
//    [_imageButton addTarget:self action:@selector(cameraButton:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_imageButton];
    
    
    
    //文字
    _textLabel = [[UILabel alloc]init];
    _textLabel.font = [UIFont systemFontOfSize:16];
    _textLabel.textAlignment = NSTextAlignmentRight;
    _textLabel.numberOfLines = 0;
    _textLabel.text = _name;
    //    detailLabel.text = _model.content;
    //NSString * string = _name;
    CGSize frame = [_textLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH - 30, 1000)];
    //CGSize frame = [string sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(SCREEN_WIDTH - 30, 1000) lineBreakMode:NSLineBreakByWordWrapping];
    //    cell.sayLabel.numberOfLines = 0;
    _textLabel.frame = CGRectMake(0, 0, frame.width, frame.height);
    _textLabel.center = CGPointMake(SCREEN_WIDTH / 2, _imageView.frame.origin.y + _imageView.frame.size.height + 12 + 8);
    
    [_textLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
    [self.view addSubview:_textLabel];
    
    UIImageView * sexImage = [[UIImageView alloc]initWithFrame:CGRectMake(_textLabel.frame.origin.x + _textLabel.frame.size.width, _textLabel.frame.origin.y - 2, 15, 15)];
    if ([_sex isEqualToString:@"1"]) {
        sexImage.image = [UIImage imageNamed:@"man.png"];
    }else {
        sexImage.image = [UIImage imageNamed:@"woman.png"];
    }
    [self.view addSubview:sexImage];
    
    UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, _textLabel.frame.origin.y + _textLabel.frame.size.height + 20, SCREEN_WIDTH, 40)];
    label1.text = [NSString stringWithFormat:@"  位置:%@",_position];
    label1.backgroundColor = [UIColor whiteColor];
    label1.font = SIZE_FOR_14;
    label1.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:label1];
    
    UIView * breakView = [[UIView alloc]initWithFrame:CGRectMake(0, label1.frame.origin.y + label1.frame.size.height - 1, SCREEN_WIDTH, 1)];
    breakView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:breakView];
    
    UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, label1.frame.origin.y + label1.frame.size.height, SCREEN_WIDTH, 40)];
    label2.font = SIZE_FOR_14;
    label2.backgroundColor = [UIColor whiteColor];
    label2.text = [NSString stringWithFormat:@"  生日:%@",_birthday];
    label2.textColor = [GetColor16 hexStringToColor:@"#434343"];
    [self.view addSubview:label2];
    
    UIView * breakView2 = [[UIView alloc]initWithFrame:CGRectMake(0, label2.frame.origin.y + label2.frame.size.height - 1, SCREEN_WIDTH, 1)];
    breakView2.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    [self.view addSubview:breakView2];
    
    UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, label2.frame.origin.y + label2.frame.size.height, SCREEN_WIDTH, 40)];
    label3.backgroundColor = [UIColor whiteColor];
    label3.text = [NSString stringWithFormat:@"  个性签名:%@",_sign];
    label3.textColor = [GetColor16 hexStringToColor:@"#434343"];
    label3.font = SIZE_FOR_14;
    [self.view addSubview:label3];
    
    
    
    
}

- (void)backBtn:(id)sender
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
