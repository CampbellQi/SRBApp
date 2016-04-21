//
//  MyTwoDimensionCodeViewController.m
//  SRBApp
//
//  Created by lizhen on 15/4/22.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "MyTwoDimensionCodeViewController.h"
//#import "QRCodeGenerator.h"
#import "PersonalModel.h"
@interface MyTwoDimensionCodeViewController ()

@end

@implementation MyTwoDimensionCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的二维码";
    self.view.backgroundColor = [UIColor blackColor];
//    self.view.alpha = 0.7;
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];

    [self creatCustomView];
    [self urlRequestPostT];
}
- (void)backBtn:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)creatCustomView
{
    UIView *customV = [[UIView alloc] init];
    self.customView = customV;
//    customV.backgroundColor = [GetColor16 hexStringToColor:@"#959595"];
    if (self.view.frame.size.height < 600) {
        customV.frame = CGRectMake(30, 40, SCREEN_WIDTH - 60, 346);
    }else if(self.view.frame.size.height > 667){
        customV.frame = CGRectMake(30, 40, SCREEN_WIDTH - 60, self.view.frame.size.height - 34 - 260);
    }else{
        customV.frame = CGRectMake(30, 40, SCREEN_WIDTH - 60, self.view.frame.size.height - 34 - 230);
    }
    customV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:customV];
    
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20,70, 70)];
    headImageView.layer.masksToBounds = YES;
    headImageView.layer.cornerRadius = 4;
    self.headImageV = headImageView;
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    [customV addSubview:headImageView];
    
    UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x + headImageView.frame.size.width + 10, headImageView.frame.origin.y + 5, customV.frame.size.width - 100 - 20 -20 -20, 30)];

    self.nicknameLabel = nickName;
    nickName.textAlignment = NSTextAlignmentLeft;

    [customV addSubview:nickName];
    
    //性别
    UIImageView *sexImageV = [[UIImageView alloc] initWithFrame:CGRectMake(nickName.frame.origin.x + nickName.frame.size.width + 4, nickName.frame.origin.y+4, 15, 15)];
    self.sexImgV = sexImageV;
    [customV addSubview:sexImageV];
    
    //星座
    UIImageView *xingzuoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(sexImageV.frame.origin.x + sexImageV.frame.size.width + 5, sexImageV.frame.origin.y, 25, 15)];
//    xingzuoImageV.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    self.constellationcodeImgV = xingzuoImageV;
//    [customV addSubview:xingzuoImageV];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(nickName.frame.origin.x, nickName.frame.origin.y + nickName.frame.size.height - 12, customV.frame.size.width - 100 - 20 -20, 30)];
    addressLabel.text = @"我的唯一邀请码：";
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.font = SIZE_FOR_14;
    [customV addSubview:addressLabel];
    
    UILabel *invitecodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(headImageView.frame.origin.x + headImageView.frame.size.width + 10, addressLabel.frame.origin.y + addressLabel.frame.size.height - 10, customV.frame.size.width - 100 - 20 -20 -20, 30)];
    invitecodeLabel.textAlignment = NSTextAlignmentLeft;
    invitecodeLabel.font = SIZE_FOR_14;
    self.invitecodeLabel = invitecodeLabel;
    [customV addSubview:invitecodeLabel];
    
    UIImageView * twoDemensionCodeImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 90, customV.frame.size.width, customV.frame.size.width - 20)];
    self.qrCodeImaV = twoDemensionCodeImgV;
    twoDemensionCodeImgV.backgroundColor = [UIColor clearColor];
    [customV addSubview:twoDemensionCodeImgV];
    
    
    UILabel *signLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, twoDemensionCodeImgV.frame.origin.y + twoDemensionCodeImgV.frame.size.height - 30, twoDemensionCodeImgV.frame.size.width, 60)];
    signLabel.text = @"扫一扫上面的二维码，加我为熟人";
    signLabel.numberOfLines = 0;
    signLabel.textAlignment = NSTextAlignmentCenter;
    signLabel.font = SIZE_FOR_12;
    signLabel.lineBreakMode = NSLineBreakByWordWrapping;
    signLabel.textColor = [GetColor16 hexStringToColor:@"#959595"];
    [customV addSubview:signLabel];
    
}

//网络请求
- (void)urlRequestPostT
{
    if (self.account == nil || [self.account isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"账号不存在"];
        return;
    }

    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD,@"user":self.account}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            self.dataDic = [dic objectForKey:@"data"];
            [self.qrCodeImaV sd_setImageWithURL:[NSURL URLWithString:[self.dataDic objectForKey:@"userqrcode"]] placeholderImage:[UIImage imageNamed:@"zanwu_clean"]];
            [self.headImageV sd_setImageWithURL:[NSURL URLWithString:[self.dataDic objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.invitecodeLabel.text = [self.dataDic objectForKey:@"invitecode"];
            
//            //赋值部分
            NSString *memo = [self.dataDic objectForKey:@"memo"];
            if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
                self.labelRect = [[self.dataDic objectForKey:@"nickname"] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                
                self.nicknameLabel.text = [self.dataDic objectForKey:@"nickname"];
                NSString *str = [self.dataDic objectForKey:@"nickname"];
                if ([ChangeSizeOfNSString convertToInts: str]  > 12) {
                    self.nicknameLabel.frame = CGRectMake(self.headImageV.frame.origin.x + self.headImageV.frame.size.width + 10, self.headImageV.frame.origin.y + 5, self.customView.frame.size.width - 100 - 20 -20 -20, self.labelRect.size.height);
                }else{
                    self.nicknameLabel.frame = CGRectMake(self.headImageV.frame.origin.x + self.headImageV.frame.size.width + 10, self.headImageV.frame.origin.y + 5, self.labelRect.size.width, self.labelRect.size.height);
                }
            }else{
                self.labelRect = [memo boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.nicknameLabel.text = memo;
                if (memo.length >=7) {
                    self.nicknameLabel.frame = CGRectMake(self.headImageV.frame.origin.x + self.headImageV.frame.size.width + 10, self.headImageV.frame.origin.y, self.customView.frame.size.width - 100 - 20 -20 -20, self.labelRect.size.height);
                }else{
                    self.nicknameLabel.frame = CGRectMake(self.headImageV.frame.origin.x + self.headImageV.frame.size.width + 10, self.headImageV.frame.origin.y, self.labelRect.size.width, self.labelRect.size.height);                }
            }
            self.sexImgV.frame = CGRectMake(self.nicknameLabel.frame.origin.x + 5 + self.nicknameLabel.frame.size.width + 4, self.nicknameLabel.frame.origin.y+4, 15, 15);
            self.constellationcodeImgV.frame = CGRectMake(self.sexImgV.frame.origin.x + self.sexImgV.frame.size.width + 5, self.sexImgV.frame.origin.y, 25, 15);
            self.constellationcodeImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"xingzuo-%@",[self.dataDic objectForKey:@"constellationcode"]]];
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"0"]) {
                self.sexImgV.image = [UIImage imageNamed:@"famale001"];
            }
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"1"]) {
                self.sexImgV.image = [UIImage imageNamed:@"male001"];
            }

            
        }else if(result == 4){
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
    }];
}

#pragma mark - 拼接post参数
- (NSDictionary *)parametersForDic:(NSString *)method parameters:(NSDictionary *)parametersDic
{
    NSDictionary * dic = @{@"method":method,@"parameters":parametersDic};
    return dic;
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
