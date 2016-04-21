//
//  SelectPersonRongViewController.m
//  
//
//  Created by lizhen on 14/12/24.
//
//

#import "SelectPersonRongViewController.h"
#import "MyChatListViewController.h"

@interface SelectPersonRongViewController ()
@property (nonatomic) RCUserAvatarStyle portaitStyle;

@end

@implementation SelectPersonRongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.portaitStyle = RCUserAvatarCycle;
    
    //self.navigationController.navigationBar.barTintColor = [GetColor16 hexStringToColor:@"#e5005d"];

    //自定义导航左按钮
    UIButton *customLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    customLeftBtn.frame = CGRectMake(0, 0, 78/2, 49/2);
    [customLeftBtn setImage:[UIImage imageNamed:@"wd_lt2"] forState:UIControlStateNormal];
    [customLeftBtn addTarget:self action:@selector(leftBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customLeftBtn];
    
}

//传值
- (void)alone:(AloneBlock)block
{
    self.aloneBlock = block;
}

- (void)rightBarButtonItemPressed:(UIBarButtonItem *)sender
{
    if (self.aloneBlock != nil) {
        self.aloneBlock(@"1");
    }
    [super rightBarButtonItemPressed:sender];
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
