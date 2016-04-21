//
//  ChooseDanbaoViewController.m
//  SRBApp
//
//  Created by 刘若曈 on 15/3/26.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "ChooseDanbaoViewController.h"
#import "ShurenCell.h"
#import "DanBaoRenModel.h"

@interface ChooseDanbaoViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSString * sign;
}
@property (nonatomic, strong)UITableView * tableView;
@end

@implementation ChooseDanbaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择邀请";
    sign = @"0";
    
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"rutern"] forState:UIControlStateNormal];
    backBtn.frame = CGRectMake(15, 0, 12, 25);
    [backBtn addTarget:self action:@selector(backBtn) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    
    UIButton * regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    regBtn.frame = CGRectMake(0, 15, 60, 25);
    [regBtn setTitle:@"邀 请" forState:UIControlStateNormal];
    //regBtn.titleLabel.textColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.tintColor = [GetColor16 hexStringToColor:@"#e5005d"];
    regBtn.backgroundColor = WHITE;
    regBtn.layer.cornerRadius = 2;
    regBtn.layer.masksToBounds = YES;
    [regBtn addTarget:self action:@selector(regController) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:regBtn];
    
    
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:_tableView];
}

- (void)backBtn
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)regController
{
    self.block(_nameArr);
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShurenCell * cell = [[ShurenCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    if (indexPath.row == 0) {
        cell.nameLabel.text = @"全选";
        if ([sign isEqualToString:@"0"]) {
            cell.chooseImage.image = [UIImage imageNamed:@"not__choose"];
        }else{
            cell.chooseImage.image = [UIImage imageNamed:@"had__choose"];
        }
    }else{
        NSMutableDictionary * dic = _nameArr[indexPath.row - 1];
        DanBaoRenModel * model = [[DanBaoRenModel alloc]init];
        model = [dic valueForKey:@"name"];
        cell.nameLabel.text = model.nickname;
        [cell.nameLabel sizeToFit];
        if ([[dic valueForKey:@"sign"] isEqualToString:@"0"]) {
            cell.chooseImage.image = [UIImage imageNamed:@"not__choose"];
        }else if([[dic valueForKey:@"sign"] isEqualToString:@"1"]){
            cell.chooseImage.image = [UIImage imageNamed:@"had__choose"];
        }}
    return cell;
}

- (void)sendMessage:(MyBlock2)jgx
{
    self.block = jgx;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nameArr.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([sign isEqualToString:@"0"]) {
            for (int i = 0; i < _nameArr.count; i++)
            {
                [_nameArr[i] setObject:@"1" forKey:@"sign"];
                sign = @"1";
            }
        }else{
            for (int i = 0; i < _nameArr.count; i++)
            {
                [_nameArr[i] setObject:@"0" forKey:@"sign"];
                sign = @"0";
            }
        }
        [_tableView reloadData];
    }else{
        if ([[_nameArr[indexPath.row - 1] valueForKey:@"sign"] isEqualToString:@"0"] ) {
            [_nameArr[indexPath.row - 1] setObject:@"1" forKey:@"sign"];
        }else
        {
            [_nameArr[indexPath.row - 1] setObject:@"0" forKey:@"sign"];
        }
        [_tableView reloadData];
    }
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
