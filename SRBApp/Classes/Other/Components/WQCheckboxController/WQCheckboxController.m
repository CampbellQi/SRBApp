//
//  WQCheckboxController.m
//  testWQCheckbox
//
//  Created by fengwanqi on 15/7/9.
//  Copyright (c) 2015年 fengwanqi. All rights reserved.
//

#import "WQCheckboxController.h"
#import "WQCheckboxCell.h"

static WQCheckboxController *_checkBoxController;
@interface WQCheckboxController ()

@property (nonatomic, strong)NSArray *sourceData;
@property (nonatomic, strong)NSString *currentSelItem;
@property (nonatomic, copy)SelectItemBlock selectItemBlock;
@end
@implementation WQCheckboxController
-(id)init {
    if (self = [super init]) {
    }
    return self;
}
+(void)showWithSourceData:(NSArray *)dataArray Message:(NSString *)msg CurrentSelItem:(NSString *)currentSelItem SelectItemBlock:(void (^) (NSString *selectItem))selectItemBlock{
    if (!_checkBoxController) {
        _checkBoxController = [[WQCheckboxController alloc] init];
    }
    _checkBoxController.sourceData = dataArray;
    [_checkBoxController.tableView reloadData];
    _checkBoxController.messageLbl.text = msg;
    _checkBoxController.currentSelItem = currentSelItem;
    _checkBoxController.selectItemBlock = selectItemBlock;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_checkBoxController.view];
    _checkBoxController.view.frame = window.bounds;
}
+(void)hide {
    [_checkBoxController.view removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 5.0f;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_checkBoxController.view removeFromSuperview];
}
#pragma mark- tableview delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 42;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sourceData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"WQCheckboxCell";
    WQCheckboxCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellID owner:nil options:nil] lastObject];
    }
    if (_sourceData && _sourceData.count) {
        cell.contentLbl.text = [_sourceData objectAtIndex:indexPath.row];
        if ([cell.contentLbl.text isEqualToString:_checkBoxController.currentSelItem]) {
            cell.selIV.image = [UIImage imageNamed:@"fs_main_login_selected"];
        }else {
            cell.selIV.image = [UIImage imageNamed:@"fs_main_login_normal"];
        }
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //WQCheckboxCell *cell = (WQCheckboxCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (_checkBoxController.selectItemBlock) {
        _checkBoxController.selectItemBlock([_checkBoxController.sourceData objectAtIndex:indexPath.row]);
    }
    [_checkBoxController.view removeFromSuperview];
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
