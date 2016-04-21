 //
//  AskedAddressBookViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 14/12/18.
//  Copyright (c) 2014年 BJshurenbang. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AskedAddressBookViewController.h"
#import "AddressBookModel.h"
#import "SubAddressBookListActivityViewController.h"

@interface AskedAddressBookViewController ()<UIAlertViewDelegate>

@end

@implementation AskedAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.addressBookArray = [[NSMutableArray alloc] init];
//    [self asked];// 得到手机通信录信息
    self.title = @"导入通讯录";
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
   
    
    UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 242)/2 + 5 , 45, 64, 68)];
    [image2 setImage:[UIImage imageNamed:@"titlebook.png"]];
    [self.view addSubview:image2];
    
    UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(image2.frame.size.width +5 + image2.frame.origin.x + 30, image2.frame.origin.y + image2.frame.size.height / 2 - 5, 32, 15)];
    [image1 setImage:[UIImage imageNamed:@"pointer.png"]];
    [self.view addSubview:image1];
    
    UIImageView * image3 = [[UIImageView alloc]initWithFrame:CGRectMake(image1.frame.size.width + image1.frame.origin.x + 25, 45, 87, 71)];
    [image3 setImage:[UIImage imageNamed:@"logo_book.png"]];
    [self.view addSubview:image3];
    
    UILabel * bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, image3.frame.size.height + image3.frame.origin.y + 60, SCREEN_WIDTH, 16)];
    bigLabel.text = @"导入通讯录, 完善属于你的熟人圈";
    bigLabel.textAlignment = NSTextAlignmentCenter;
    bigLabel.textColor = [GetColor16 hexStringToColor:@"#434343"];
    bigLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:bigLabel];
    
    UILabel * smallLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, bigLabel.frame.origin.y + bigLabel.frame.size.height + 22.5, SCREEN_WIDTH - 50, 30)];
    smallLabel.text = @"来找更多熟人分享购物心得，一起买买买！\n导入通讯录我们会严格保密哒~";
    smallLabel.font = [UIFont systemFontOfSize:12];
    [smallLabel setTextColor:[GetColor16 hexStringToColor:@"#434343"]];
    smallLabel.numberOfLines = 0;
    smallLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:smallLabel];
    
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(25, smallLabel.frame.origin.y + smallLabel.frame.size.height + 40, SCREEN_WIDTH - 50, 40)];
    button.backgroundColor = [GetColor16 hexStringToColor:@"#e5005d"];
    [button setTitle:@"确定并继续" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    [button setTitleColor:[GetColor16 hexStringToColor:@"#ffffff"] forState:UIControlStateNormal];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 2;
    [button addTarget:self action:@selector(asked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton * downLabel = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 80)/2, button.frame.size.height + button.frame.origin.y + 30, 80, 16)];
    [downLabel setTitle:@"回头再说~" forState:UIControlStateNormal];
    [downLabel addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [downLabel setTitleColor:[UIColor colorWithRed:0.64 green:0.64 blue:0.64 alpha:1] forState:UIControlStateNormal];
    downLabel.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:downLabel];
}



- (void)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)asked
{
    ABAddressBookRef addressBooks = nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)// 判断当前设备的系统版本,因为iOS6之后获取通讯录的方式有变化
        
    {
        addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0); // 参考http://blog.csdn.net/robincui2011/article/details/9270249
        
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){dispatch_semaphore_signal(sema);}); // 请求访问的用户地址簿数据
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER); // 等待一个信号量
        
    }
    else
    {
        addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        
    }
    if (ABAddressBookGetAuthorizationStatus() != kABAuthorizationStatusAuthorized) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请在iPhone的“设置 → 隐私 → 通讯录”中 ,允许熟人邦访问你的通讯录" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }else{
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在导入通讯录...";
    HUD.dimBackground = YES;
    [HUD show:YES];
        //新建一个通讯录类
        
        
        //获取通讯录中的所有人
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
        
        //通讯录中人数
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
        
        //循环，获取每个人的个人信息
        for (NSInteger i = 0; i < nPeople; i++)
        {
            //新建一个addressBook model类
            AddressBookModel *addressBook = [[AddressBookModel alloc] init];
            //获取个人
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            //获取个人名字
            CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            NSString *nameString = (__bridge NSString *)abName;
            NSString *lastNameString = (__bridge NSString *)abLastName;
            
            if ((__bridge id)abFullName != nil) {
                nameString = (__bridge NSString *)abFullName;
            } else {
                if ((__bridge id)abLastName != nil)
                {
                    nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                }
            }
            addressBook.name = nameString;
            addressBook.recordID = (int)ABRecordGetRecordID(person);;
            
            ABPropertyID multiProperties[] = {
                kABPersonPhoneProperty,
                kABPersonEmailProperty
            };
            NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
            for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
                ABPropertyID property = multiProperties[j];
                ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
                NSInteger valuesCount = 0;
                if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
                
                if (valuesCount == 0) {
                    CFRelease(valuesRef);
                    continue;
                }
                //获取电话号码和email
                for (NSInteger k = 0; k < valuesCount; k++) {
                    CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                    switch (j) {
                        case 0: {// Phone number
                            addressBook.tel = (__bridge NSString*)value;
                            break;
                        }
                        case 1: {// Email
                            addressBook.email = (__bridge NSString*)value;
                            break;
                        }
                    }
                    CFRelease(value);
                }
                CFRelease(valuesRef);
            }
            //将个人信息添加到数组中，循环完成后addressBookTemp中包含所有联系人的信息
            [self.addressBookArray addObject:addressBook];
            if (abName) CFRelease(abName);
            if (abLastName) CFRelease(abLastName);
            if (abFullName) CFRelease(abFullName);
        }
    [self post];
}
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - post请求
- (void)post
{
    NSMutableArray * arr = [NSMutableArray array];
    for (int i = 0; i < _addressBookArray.count; i++) {
        NSLog(@"%@",_addressBookArray);
        AddressBookModel * model = [[AddressBookModel alloc]init];
        model = [_addressBookArray objectAtIndex:i];
        NSString * nameStr = model.name;
        NSString * telStr = model.tel;
        NSString * emailStr = model.email;
        if (emailStr == nil || emailStr.length == 0) {
            emailStr = @"";
        }
        if (telStr == nil || telStr.length == 0) {
            telStr = @"";
        }
        if (nameStr == nil || nameStr.length == 0) {
            nameStr = @"";
        }
        NSDictionary * dic = @{@"name":nameStr, @"tel":telStr, @"email":emailStr, @"workphone":@""};
        [arr addObject:dic];
    }
    //拼接post参数
    NSDictionary * dic = [self parametersForDic:@"accountImportContacts" parameters:@{ACCOUNT_PASSWORD, @"data":arr}];
    //发送post请求
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        int result = [[dic objectForKey:@"result"]intValue];
        if (result == 0) {
            [HUD removeFromSuperview];
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            if (self.isFaxian == YES) {
                [self.addressBookVC post];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                SubAddressBookListActivityViewController * vc = [[SubAddressBookListActivityViewController alloc]init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            
        }else{
            [HUD removeFromSuperview]; 
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
            [self wrong];
        }
    }andFailureBlock:^{
        [HUD removeFromSuperview];
    }];
}



- (void)wrong
{
    [self.navigationController popViewControllerAnimated:YES];
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
