//
//  SubSublPersonalViewController.m
//  SRBApp
//
//  Created by lizhen on 15/1/17.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "SubSublPersonalViewController.h"
#import "AppDelegate.h"
@interface SubSublPersonalViewController ()
{
    BOOL isBack;
}
@end

@implementation SubSublPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    isBack = NO;
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    AppDelegate *app = APPDELEGATE;
    app.mainTab.tabBar.hidden = YES;
    app.customTab.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    AppDelegate *app = APPDELEGATE;
    if (isBack) {
        app.mainTab.tabBar.hidden = YES;
        app.customTab.hidden = NO;
    }
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)backBtn:(UIButton *)sender
{
    isBack = YES;
    [self.navigationController popToRootViewControllerAnimated:YES];
    AppDelegate *app = APPDELEGATE;
    app.tabBarBtn1.selected = NO;
    app.tabBarBtn2.selected = NO;
    app.tabBarBtn4.selected = NO;
}

//网络请求
- (void)urlRequestPostT
{
    if (self.invitecode == nil || [self.invitecode isEqualToString:@""]) {
        [AutoDismissAlert autoDismissAlert:@"账号不存在"];
        return;
    }
    [activity startAnimating];
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD,@"user":@"0",@"invitecode":self.invitecode}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            self.dataDic = [dic objectForKey:@"data"];
            self.account = [self.dataDic objectForKey:@"account"];
            [self customView];
            //赋值部分
            NSString *memo = [self.dataDic objectForKey:@"memo"];
            if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
                self.navigationItem.title = [self.dataDic objectForKey:@"nickname"];
                self.nickname = [self.dataDic objectForKey:@"nickname"];
            }else{
                self.navigationItem.title = memo;
                self.nickname = memo;
            }
            
            if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
                self.labelRect = [[self.dataDic objectForKey:@"nickname"] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.remarkLabel.text = [self.dataDic objectForKey:@"nickname"];
                NSString *str = [self.dataDic objectForKey:@"nickname"];
                if ([ChangeSizeOfNSString convertToInts: str]  > 12) {
                    self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, 150, self.labelRect.size.height);
                }else{
                    self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);
                }
            }else{
                self.labelRect = [memo boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.remarkLabel.text = memo;
                if (memo.length >=7) {
                    self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, 150, self.labelRect.size.height);
                }else{
                    self.remarkLabel.frame = CGRectMake(25/2+40+16, 45/2, self.labelRect.size.width, self.labelRect.size.height);                }
                
            }
            
            self.sexImageV.frame = CGRectMake(25/2+40+16+self.remarkLabel.frame.size.width + 6, self.remarkLabel.frame.origin.y+4, 15, 15);
            self.xingzuoImageV.frame = CGRectMake(self.sexImageV.frame.origin.x + self.sexImageV.frame.size.width + 5, self.sexImageV.frame.origin.y, 25, 15);
            self.xingzuoImageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"xingzuo-%@",[self.dataDic objectForKey:@"constellationcode"]]];
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"0"]) {
                self.sexImageV.image = [UIImage imageNamed:@"woman"];
            }
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"1"]) {
                self.sexImageV.image = [UIImage imageNamed:@"man"];
            }
            [self.logoImageV sd_setImageWithURL:[self.dataDic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            //            self.avatar = [self.dataDic objectForKey:@"avatar"];
            self.logoImageV.contentMode = UIViewContentModeScaleAspectFill;
            self.logoImageV.clipsToBounds = YES;
            
            
            //            CGRect rect = [[self.dataDic objectForKey:@"sign"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 25/2 - 75- 16 - 15, 4000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:SIZE_FOR_14} context:nil];
            //            CGRect signLabelFram = self.signLabel.frame;
            //            signLabelFram.size.height = rect.size.height;
            //
            //            self.signLabel.frame = signLabelFram;
            self.signLabel.text = [self.dataDic objectForKey:@"sign"];
            
            self.addressLabel.text = [self.dataDic objectForKey:@"location"];
            self.friendId = [self.dataDic objectForKey:@"friendId"];
            self.avatar = [self.dataDic objectForKey:@"avatar"];
            //            self.imageArray = @[[self.dataDic objectForKey:@"avatar"]];
            
            if ([self.dataDic objectForKey:@"postCount"] != nil) {
                [relationBtn setTitle:[NSString stringWithFormat:@"发布 (%@)",[self.dataDic objectForKey:@"postCount"]] forState:UIControlStateNormal];
            }
            if ([self.dataDic objectForKey:@"guaranteeCount"] != nil) {
                [circleBtn setTitle:[NSString stringWithFormat:@"担保 (%@)",[self.dataDic objectForKey:@"guaranteeCount"]] forState:UIControlStateNormal];
            }
            if ([self.dataDic objectForKey:@"locationCount"] != nil) {
                [totalBtn setTitle:[NSString stringWithFormat:@"足迹 (%@)",[self.dataDic objectForKey:@"locationCount"]] forState:UIControlStateNormal];
            }
            
            self.hoestyPercentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[self.dataDic objectForKey:@"evaluationper"] floatValue]];
            self.liePercentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[self.dataDic objectForKey:@"fakeper"] floatValue]];
            self.honestyOnView.frame = CGRectMake(0, 0, self.honestyBGView.frame.size.width *[[self.dataDic objectForKey:@"evaluationper"] floatValue]/100, 10);
            self.lieOnView.frame = CGRectMake(0, 0, self.lieBGView.frame.size.width *[[self.dataDic objectForKey:@"fakeper"] floatValue]/100, 10);
            
        }else if(result == 4){
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [activity stopAnimating];
    }];
}

//网络请求
- (void)urlRequestPostTAgain
{
    [activity startAnimating];
    NSDictionary * dic = [self parametersForDic:@"getUserInfo" parameters:@{ACCOUNT_PASSWORD,@"user":@"0",@"invitecode":self.invitecode}];
    [URLRequest postRequestWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            self.dataDic = [dic objectForKey:@"data"];
            //赋值部分
            NSString *memo = [self.dataDic objectForKey:@"memo"];
            if (!memo || [memo isEqualToString:@""] || [memo isEqualToString:@"(null)"] || memo.length == 0) {
                self.labelRect = [[self.dataDic objectForKey:@"nickname"] boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.remarkLabel.text = [self.dataDic objectForKey:@"nickname"];
                self.navigationItem.title = [self.dataDic objectForKey:@"nickname"];
                NSString *str = [self.dataDic objectForKey:@"nickname"];
                if ([ChangeSizeOfNSString convertToInts: str]  > 12) {
                    [self bigOrSmallWidth:150];
                }else{
                    [self bigOrSmallWidth:self.labelRect.size.width];
                }
            }else{
                self.labelRect = [memo boundingRectWithSize:CGSizeMake(320, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
                self.remarkLabel.text = memo;
                self.navigationItem.title = memo;
                if (memo.length >=7) {
                    [self bigOrSmallWidth:150];
                }else{
                    [self bigOrSmallWidth:self.labelRect.size.width];
                }
            }
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"0"]) {
                self.sexImageV.image = [UIImage imageNamed:@"woman"];
            }
            if ([[self.dataDic objectForKey:@"sex"] isEqualToString:@"1"]) {
                self.sexImageV.image = [UIImage imageNamed:@"man"];
            }
            [self.logoImageV sd_setImageWithURL:[self.dataDic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"zanwu"]];
            self.logoImageV.contentMode = UIViewContentModeScaleAspectFill;
            self.logoImageV.clipsToBounds = YES;
            self.signLabel.text = [self.dataDic objectForKey:@"sign"];
            self.addressLabel.text = [self.dataDic objectForKey:@"location"];
            self.friendId = [self.dataDic objectForKey:@"friendId"];
            self.avatar = [self.dataDic objectForKey:@"avatar"];
            
            [relationBtn setTitle:[NSString stringWithFormat:@"发布 (%@)",[self.dataDic objectForKey:@"postCount"]] forState:UIControlStateNormal];
            [circleBtn setTitle:[NSString stringWithFormat:@"担保 (%@)",[self.dataDic objectForKey:@"guaranteeCount"]] forState:UIControlStateNormal];
            [totalBtn setTitle:[NSString stringWithFormat:@"足迹 (%@)",[self.dataDic objectForKey:@"locationCount"]] forState:UIControlStateNormal];
            
            self.hoestyPercentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[self.dataDic objectForKey:@"evaluationper"] floatValue]];
            self.liePercentLabel.text = [NSString stringWithFormat:@"%.0f%%",[[self.dataDic objectForKey:@"fakeper"] floatValue]];
            self.honestyOnView.frame = CGRectMake(0, 0, self.honestyBGView.frame.size.width *[[self.dataDic objectForKey:@"evaluationper"] floatValue]/100, 10);
            self.lieOnView.frame = CGRectMake(0, 0, self.lieBGView.frame.size.width *[[self.dataDic objectForKey:@"fakeper"] floatValue]/100, 10);
            
        }else if(result == 4){
            
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        [activity stopAnimating];
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
