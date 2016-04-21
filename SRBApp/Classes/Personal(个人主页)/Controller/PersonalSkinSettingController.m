//
//  PersonalSkinSettingViewController.m
//  SRBApp
//  皮肤设置
//  Created by fengwanqi on 16/1/25.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#define SKIN_TYPE 1
#define STATURE_TYPE 2

#import "PersonalSkinSettingController.h"
#import "CommonView.h"
#import "PersonalSkinSettingCell.h"
#import "WQPickerView.h"

@interface PersonalSkinSettingController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray *_dataArray;
    PersonalSkinSettingCell *_propertyCell;
    int _type;
    
    NSDictionary *_currentSelDict;
    //选择后
    NSDictionary *_selDict;
    
    WQPickerView *_currentPickerView;
}
@end

@implementation PersonalSkinSettingController

-(id)initWithSkin
{
    if (self = [super init]) {
        _type = SKIN_TYPE;
    }
    return self;
}
-(id)initWithStature {
    if (self = [super init]) {
        _type = STATURE_TYPE;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _selDict = [NSMutableDictionary new];
    self.navigationItem.leftBarButtonItem = [CommonView backBarButtonItemTarget:self Action:@selector(backBtnClicked)];
    
    UINib *nib = [UINib nibWithNibName:@"PersonalSkinSettingCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PersonalSkinSettingCell"];
    _propertyCell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonalSkinSettingCell"];
    
    UIView *footerView = [UIView new];
    footerView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.tableFooterView = footerView;
    [self loadDataRequest];
}
#pragma mark- 事件
-(void)backBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- tableview delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CGRectGetHeight(_propertyCell.frame);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonalSkinSettingCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"PersonalSkinSettingCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dict = _dataArray[indexPath.row];
    cell.nameLbl.text = dict[@"categoryName"];
    
    NSString *feature = dict[@"feature"];
    NSDictionary *selDict = [_selDict objectForKey:dict[@"categoryID"]];
    if (selDict) {
        cell.valueLbl.text = selDict[@"categoryName"];
    }else if(feature.length) {
        cell.valueLbl.text = feature;
    }else {
        cell.valueLbl.text = @"未设置";
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentSelDict = _dataArray[indexPath.row];
    [self showPicker];
}
-(void)showPicker {
    if (_currentPickerView) {
        [_currentPickerView cancelBtnClicked:nil];
    }
    WQPickerView *pickerView = [[WQPickerView alloc] initWithFrame:CGRectMake(0, MAIN_NAV_HEIGHT, SCREEN_WIDTH, PICKERVIEW_HEIGHT) DataArray:_currentSelDict[@"subCategory"]];
    _currentPickerView = pickerView;
    pickerView.confirmBlock = ^(id selectedItem) {
        [_selDict setValue:selectedItem forKey:_currentSelDict[@"categoryID"]];
        [self setRequestCategoryName:selectedItem[@"categoryName"] CategoryID:_currentSelDict[@"categoryID"]];
        [self.tableView reloadData];
        //resultTF.text = selectedItem;
    };
    pickerView.titleForRowBlock = ^(NSArray *sourceArray, NSInteger row) {
        NSDictionary *dict = sourceArray[row];
        return dict[@"categoryName"];
    };
    
    [self.view addSubview:pickerView];
    [UIView animateWithDuration:0.3 animations:^{
        pickerView.y = MAIN_NAV_HEIGHT - PICKERVIEW_HEIGHT;
    }];
}
#pragma mark- 网络请求
- (void)loadDataRequest
{
    NSString *categoryID = @"334";
    if (_type == STATURE_TYPE) {
        categoryID = @"335";
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"获取中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];
    
    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"getCategoryList" parameters:@{@"categoryID": categoryID, @"feature": @"1", ACCOUNT_PASSWORD}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        [hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            _dataArray = [dic objectForKey:@"data"][@"list"];
            [self.tableView reloadData];
        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        
    } andFailureBlock:^{
        //[_hud removeFromSuperview];
    }];
}
//设置
-(void)setRequestCategoryName:(NSString *)categoryName CategoryID:(NSString *)categoryID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"设置中,请稍后";
    hud.dimBackground = YES;
    [hud show:YES];

    //拼接post参数
    NSDictionary * param = [self parametersForDic:@"accountSetUserFeature" parameters:@{ACCOUNT_PASSWORD, @"id": categoryID, @"value": categoryName}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        [hud removeFromSuperview];
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {

        }else{
            [AutoDismissAlert autoDismissAlert:[dic objectForKey:@"message"]];
        }
        
    } andFailureBlock:^{
        //[_hud removeFromSuperview];
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
