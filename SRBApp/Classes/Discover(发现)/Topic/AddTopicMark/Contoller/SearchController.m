//
//  SearchController.m
//  SRBApp
//
//  Created by fengwanqi on 15/11/3.
//  Copyright © 2015年 BJshurenbang. All rights reserved.
//

#import "SearchController.h"
#import "pinyin.h"

static NSArray *_brandArray;
@interface SearchController ()

@end

@implementation SearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
}
#pragma mark- 数据
-(void)setType:(enum Type)type {
    _type = type;
    if (_type == Currency) {
        //NSString *currencyStr = @"人民币,港币,日元,韩元,美元,欧元,英镑,澳元,泰铢,台币,加拿大元,新加坡币,澳门元,迪拉姆";
        NSString *currencyStr = @"人民币";
        _sourceArray = [currencyStr componentsSeparatedByString:@","];
        _dataArray = [NSMutableArray arrayWithArray:_sourceArray];
    }else if (_type == Country) {
        NSString *countryStr = @"中国,日本,朝鲜,韩国,蒙古,巴基斯坦,印度,尼泊尔,不丹,孟加拉国,斯里兰卡,马尔代夫,哈萨克斯坦,乌兹别克斯坦,土库曼斯坦,塔吉克斯坦,吉尔吉斯斯坦越南,老挝,泰国,缅甸,柬埔寨,菲律宾,文莱,东帝汶,印度尼西亚,马来西亚,新加坡,阿富汗,伊朗,伊拉克,科威特,巴林,卡塔尔,阿拉伯联合酋长国,阿曼,也门,沙特,叙利亚,约旦,以色列,黎巴嫩,土耳其,巴勒斯坦,塞浦路斯,阿塞拜疆,格鲁吉亚,亚美尼亚,芬兰,瑞典,挪威,冰岛,丹麦,法罗群岛爱沙尼亚,拉脱维亚,立陶宛,白俄罗斯,俄罗斯,乌兰克,摩尔多瓦,波兰,捷克,斯洛伐克,匈牙利,德国,奥地利,瑞士,列支敦士登,英国,爱尔兰,荷兰,比利时,卢森堡,法国,摩纳哥,罗马尼亚,保加利亚,塞尔维亚,马其顿,阿尔巴尼亚,希腊,斯洛文尼亚,克罗地亚,波斯尼亚,黑塞哥维纳,意大利,梵蒂冈,圣马力诺,马耳他,西班牙,葡萄牙,安道尔,埃及,苏丹,利比亚,突尼斯,阿尔及利亚,摩洛哥,亚速尔群岛,马德拉群岛,埃塞俄比亚,厄立特里亚,索马里,吉布提,肯尼亚,坦桑尼亚,乌干达,卢旺达,布隆迪,塞舌尔,毛里塔尼亚,西撒哈拉,塞内加尔,冈比亚,马里,布基纳法索,几内亚,几内亚比绍,佛得角,塞拉利昂,利比里亚,科特迪瓦,加纳,多哥,贝宁,尼日尔,尼日尼亚,加那利群岛,乍得,中非,喀麦隆,赤道几内亚,加蓬,刚果（布）,刚果（金）,圣多美,普林西比,赞比亚,津巴布韦,马拉维,莫桑比克,博茨瓦纳,纳米比亚,南非,斯威士兰,莱索托,马达加斯加,科摩罗,毛里求斯,圣赫勒拿岛,阿森松岛,巴哈马联邦,巴拿马,尼加拉瓜,巴巴多斯,牙买加,海地,墨西哥,危地马拉,古巴,洪都拉斯,格林纳达,哥斯达黎加,多米尼加,圣基茨和尼维斯,美国,圣文森特和格林纳丁斯,特立尼达和多巴哥,安提瓜和巴布达,多米尼克国,伯利兹,萨尔瓦多,加拿大,圣卢西亚,阿根廷,巴拉圭,巴西,玻利维亚,委内瑞拉,智利,乌拉圭,苏里南,秘鲁,哥伦比亚,厄瓜多尔,圭亚那,澳大利亚,新西兰,巴布亚新几内亚,所罗门群岛,北马里亚纳群岛（美国）,瓦努阿图,帕劳,瑙鲁,图瓦卢,基里巴斯,萨摩亚,美属萨摩亚,纽埃（新西兰）,库克群岛（新西兰）,汤加,密克罗尼西亚联邦,皮特凯恩（英国）,新喀里多尼亚（法国）,斐济群岛,密克罗尼亚联邦,马绍尔群岛,关岛（美国）,托克劳（新西兰）,瓦利斯和富图纳（法国）,法属波利尼西亚,美国/夏威夷檀香山,美国/阿拉斯加安克雷奇,美国/旧金山,美国/西雅图,美国/洛杉矶,美国/凤凰城,美国/丹佛,美国/明尼亚波利斯,美国/圣保罗,美国/新奥尔良,美国/芝加哥,美国/蒙哥马利,美国/印地安纳波利斯,美国/ 亚特兰大,美国/底特律,美国/华盛顿哥伦比亚特区,美国/费城,美国/纽约,美国/波士顿,美国/亚拉巴马州,美国/阿拉斯加州,美国/亚利桑那州,美国/阿肯色州,美国/加利福尼亚州,美国/北开罗莱纳州,美国/南开罗莱纳州,美国/科罗拉多州,美国/康涅狄格州,美国/特拉华州,美国/佛罗里达州,美国/佐治亚州,美国/夏威夷州,美国/爱达荷州,美国/伊利诺伊州,美国/艾奥瓦州,美国/堪萨斯州,美国/肯塔基州,美国/路易斯安那州,美国/缅因州,美国/马里兰州,美国/马萨诸塞州,美国/密歇根州,美国/明尼苏达州,美国/密西西比州,美国/密苏里州,美国/蒙大拿州,美国/内布拉斯加州,美国/内华达州,美国/新罕布什尔州,美国/新泽西,美国/新墨西哥州,美国/纽约州,美国/北达科他州,美国/南达科他州,美国/俄亥俄州,美国/俄克拉荷马州,美国/俄勒冈州,美国/宾夕法尼亚州,美国/罗德岛州,美国/田纳西州,美国/德克萨斯州,美国/犹他州,美国/佛蒙特州,美国/弗吉尼亚州,美国/华盛顿州,美国/西弗吉尼亚州,美国/威斯康星州,美国/怀俄明州,加拿大/阿克拉维克,加拿大/艾德蒙顿,加拿大/温尼伯,加拿大/温哥华,加拿大/多伦多,加拿大/渥太华,美国/休斯敦,加拿大/蒙特利尔,加拿大/圣约翰斯,加拿大/哈里法克斯,澳大利亚/布里斯班,澳大利亚/墨尔本,澳大利亚/堪培拉,澳大利亚/悉尼,澳大利亚/阿德莱德,澳大利亚/达尔文,澳大利亚/珀斯,俄罗斯/符拉迪沃斯托克(海参崴),俄罗斯/堪察加,俄罗斯/阿纳德尔,俄罗斯/莫斯科,英国/伦敦,英国/牛津,英国/普利茅斯,英国/剑桥,英国/伯明翰,英国/曼彻斯特,英国/利物浦,英国/布拉德福德,英国/诺丁汉,英国/爱丁堡,法国/巴黎,法国/普罗旺斯,法国/里昂,冰岛/雷克雅未克,葡萄牙/里斯本,塞尔维亚与蒙特内哥罗/贝尔格莱德,波兰/华沙,爱尔兰/都柏林,西班牙/马德里,西班牙/巴塞罗那,比利时/布鲁塞尔,荷兰/阿姆斯特丹,瑞士/日内瓦,瑞士/苏黎世,德国/柏林,德国/法兰克福,挪威/ 奥斯陆,丹麦/哥本哈根,意大利/罗马,捷克/布拉格,克罗地亚/萨格雷布,奥地利/维也纳,瑞典/斯德哥尔摩,匈牙利/布达佩斯,保加利亚/索非亚,希腊/雅典城,爱沙尼亚/塔林,芬兰/赫尔辛基,罗马尼亚/布加勒斯特,白俄罗斯/明斯克,土耳其/伊斯坦布尔,乌克兰/基辅,乌克兰/敖德萨,土耳其/安卡拉,墨西哥/墨西哥城,危地马拉/危地马拉,萨尔瓦多/圣萨尔瓦多,洪都拉斯/特古西加尔巴,尼加拉瓜/马那瓜,古巴/哈瓦那,巴哈马/拿骚,秘鲁/利马,牙买加/金斯敦,多米尼加/圣多明各,玻利维亚/拉帕兹,委内瑞拉/加拉加斯,波多黎各/圣胡安,智利/圣地亚哥,巴拉圭/亚松森,阿根廷/布宜诺斯艾利斯,乌拉圭/蒙特维的亚,巴西/巴西利亚,巴西/圣保罗,巴西/里约热内卢,摩洛哥/卡萨布兰卡,尼日利亚/拉各斯,阿尔及利亚/阿尔及尔,黎巴嫩/贝鲁特,约旦/安曼,南非/开普敦,南非/约翰尼斯堡,津巴布韦/哈拉雷,埃及/开罗,苏丹/喀土穆,肯尼亚/内罗毕,埃塞俄比亚/亚的斯亚贝巴,也门/亚丁,马达加斯加/安塔那那利佛,基里巴斯/圣诞岛,科威特/科威特城,沙特阿拉伯/利雅得,以色列/耶路撒冷,伊拉克/巴格达,伊朗/德黑兰,阿拉伯联合酋长国/阿布扎比,阿富汗/喀布尔,柬埔寨/波哥大,巴基斯坦/卡拉奇,乌兹别克斯坦/塔什干,巴基斯坦/伊斯兰堡,巴基斯坦/拉合尔,印度/孟买,印度/新德里,印度/柯尔喀塔,尼泊尔/加德满都,孟加拉/达卡,缅甸/仰光,泰国/曼谷,越南/河内,印尼/ 雅加达,马来西亚/吉隆坡,新加坡/新加坡,中国/香港,中国/北京,中国/上海,中国/台北,中国/西藏,中国/陕西,韩国/首尔,朝鲜/平壤,日本/东京,日本/大阪,日本/名古屋,斐济/苏瓦,新西兰/惠灵顿,菲律宾/马尼拉,新西兰/查塔姆群岛,新西兰/惠灵顿,新西兰/奥克兰";
        _sourceArray = [countryStr componentsSeparatedByString:@","];
    }else if (_type == Brand) {
        //_sourceArray = _brandArray;
    }
}
-(void)setKeyWords:(NSString *)keyWords {
    _keyWords = keyWords;
    if (_type == Currency) {
        [self.tableView reloadData];
    }else if (_type == Brand) {
        [self searchBrandRequset];
    }else {
        self.dataArray = [NSMutableArray new];
        if (_keyWords.length < 2 && isalpha([_keyWords characterAtIndex:0])) {
            NSString *pKeyWorkds = [[self hanZiToPinYinWithString:keyWords] substringToIndex:1];
            for (NSString *str in _sourceArray) {
                NSString *pStr = [[self hanZiToPinYinWithString:str] substringToIndex:1];
                if ([pKeyWorkds isEqualToString:pStr]) {
                    [_dataArray addObject:str];
                }
            }
        }else {
            for (NSString *str in _sourceArray) {
                if ([str containsString:keyWords]) {
                    [_dataArray addObject:str];
                }
            }
        }
        [self.tableView reloadData];
    }
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
#pragma mark- tableview delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedBlock) {
        self.selectedBlock(_dataArray[indexPath.row]);
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.hideKeboardBlock) {
        self.hideKeboardBlock();
    }
}
#pragma mark- 网络请求
- (void)searchBrandRequset
{
    NSDictionary * dic = [self parametersForDic:@"getCategoryList" parameters:@{@"keyword": _keyWords, @"type":@"1045"}];
    [URLRequest postRequestssWith:iOS_POST_URL parameters:dic andblock:^(NSDictionary *dic) {
        NSString * result = [dic objectForKey:@"result"];
        if ([result isEqualToString:@"0"]) {
            NSArray * temparrs = [[dic objectForKey:@"data"] objectForKey:@"list"];
            NSMutableArray *tempArray = [NSMutableArray new];
            for (NSDictionary *dic in temparrs) {
                [tempArray addObject:dic[@"categoryName"]];
            }
            self.dataArray = tempArray;
            [self.tableView reloadData];
            
            if (self.showBlock) {
                self.showBlock();
            }
        }else if ([result isEqualToString:@"4"]) {
            self.dataArray = [NSMutableArray new];
            [self.tableView reloadData];
            if (self.hideBlock) {
                self.hideBlock();
            }
        }
    } andFailureBlock:^{
        
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
