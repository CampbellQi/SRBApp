//
//  MarkSearchListController.m
//  SRBApp
//
//  Created by fengwanqi on 15/9/15.
//  Copyright (c) 2015年 BJshurenbang. All rights reserved.
//

#import "BaseMarkListController.h"
#import "pinyin.h"
#import "MarkTopicListController.h"

@interface BaseMarkListController ()

@end

@implementation BaseMarkListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _noDataView = [[NoDataView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MAIN_NAV_HEIGHT)];
    _noDataView.hidden = YES;
    //_noDataView.center = _tableView.center;
    [_tableView addSubview:_noDataView];
}
#pragma mark- 数据
-(void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    _keys = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z",@"#"];
    _sortedDataDict = [NSMutableDictionary new];
    _allKeys = [NSMutableArray new];
    if (_dataArray==nil||_dataArray.count<1) {
        if (_dataArray.count < 20) {
            self.hideSectionHeader = YES;
        }
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            _sortedDataDict = [self sortedArrayWithPinYinDic:_dataArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        });
    }else
    {
        if (_dataArray.count < 20) {
            self.hideSectionHeader = YES;
        }
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            _sortedDataDict = [self sortedArrayWithPinYinDic:_dataArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                [self.tableView reloadData];
                
            });
        });
    }
}

#pragma mark - tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString *key = [_allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [_sortedDataDict objectForKey:key];
    
    NSDictionary *dict = arrayForKey[indexPath.row];
    if(dict){
        cell.textLabel.text = dict[@"name"];
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [_allKeys objectAtIndex:section];
    
    NSArray *arr = [_sortedDataDict objectForKey:key];
    
    return [arr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_allKeys count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MarkTopicListController *vc = [[MarkTopicListController alloc] init];
    
    NSString *key = [_allKeys objectAtIndex:indexPath.section];
    NSArray *arrayForKey = [_sortedDataDict objectForKey:key];
    NSDictionary *dict = arrayForKey[indexPath.row];
    vc.tagName = dict[@"name"];
    [self.navigationController pushViewController:vc animated:YES];
}
//pinyin index
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    if (self.hideSectionHeader) {
        return nil;
    }
    return _allKeys;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.hideSectionHeader) {
        return nil;
    }
    
    NSString *key = [_allKeys objectAtIndex:section];
    return key;
    
}
#pragma mark - 拼音排序
-(NSString *) hanZiToPinYinWithString:(NSString *)hanZi
{
    if(!hanZi) return nil;
    NSString *pinYinResult=[NSString string];
    for(int j=0;j<hanZi.length;j++){
        NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([hanZi characterAtIndex:j])] uppercaseString];
        pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
        
    }
    
    return pinYinResult;
    
}
-(NSMutableDictionary *) sortedArrayWithPinYinDic:(NSArray *) marks
{
    if(!marks) return nil;
    
    NSMutableDictionary *returnDic = [NSMutableDictionary new];
    NSMutableArray * tempOtherArr = [NSMutableArray new];
    BOOL isReturn = NO;
    
    for (NSString *key in _keys) {
        
        if ([tempOtherArr count]) {
            isReturn = YES;
        }
        
        NSMutableArray *tempArr = [NSMutableArray new];
        for (NSDictionary *dict in marks) {
            
            NSString *pyResult = [self hanZiToPinYinWithString:dict[@"name"]];
            NSString *firstLetter = [pyResult substringToIndex:1];
            if ([firstLetter isEqualToString:key]){
                [tempArr addObject:dict];
            }
            
            if(isReturn) continue;
            char c = [pyResult characterAtIndex:0];
            if (isalpha(c) == 0) {
                [tempOtherArr addObject:dict];
            }
        }
        if(![tempArr count]) continue;
        [returnDic setObject:tempArr forKey:key];
        
    }
    if([tempOtherArr count])
        [returnDic setObject:tempOtherArr forKey:@"#"];
    
    
    _allKeys = [[returnDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    return returnDic;
}
#pragma mark- 网络请求
//- (void)searchTagsListRequest
//{
//    NSDictionary * param = [self parametersForDic:@"getTagList" parameters:@{ACCOUNT_PASSWORD, @"start": @"0", @"count": @"100", @"type": @"1042", @"name": @""}];
//    
//    [URLRequest postRequestssWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
//        NSString * result = [dic objectForKey:@"result"];
//        if ([result isEqualToString:@"0"]) {
//            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
//            self.dataArray = temparrs;
//            _noDataView.hidden = YES;
//        }else if([result isEqualToString:@"4"]){
//            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//            self.dataArray = [NSArray new];
//            _noDataView.hidden = NO;
//            //[AutoDismissAlert autoDismissAlertSecond:@"没有搜索到相关数据"];
//        }else{
//            _noDataView.hidden = NO;
//        }
//        [self.tableView reloadData];
//        
//    } andFailureBlock:^{
//        
//    }];
//    
//}

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
