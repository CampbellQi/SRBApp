//
//  PublishTopicController.m
//  SRBApp
//
//  Created by fengwanqi on 16/1/9.
//  Copyright © 2016年 BJshurenbang. All rights reserved.
//

#import "PublishTopicController.h"
#import "PublishTopicHeaderView.h"
#import "PublishTopicCell.h"
#import "PublishTopicFooterView.h"
#import "PublishTopicModel.h"
#import "PublishTopicImageCell.h"
#import "PublishTopicTextCell.h"
#import "PublishTopicSuperCell.h"
#import "PublishTopicTextController.h"
#import "CropController.h"
#import "ZYQAssetPickerController.h"
#import <CoreLocation/CoreLocation.h>
#import "NearbyLocationsViewController.h"
#import "ZZNavigationController.h"
#import "CreateSignViewController2.h"
#import "AppDelegate.h"
#import "UIImage+Compress.h"
#import "NSString+CalculateSize.h"
#import "ODMCombinationPickerViewController.h"

#define HEADER_HEIGHT SCREEN_WIDTH * (238.0 / 320.0)

@interface PublishTopicController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate, ZYQAssetPickerControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate, ODMCombinationPickerViewControllerDelegate>
{
    NSMutableArray *_dataArray;
    NSIndexPath *_editIndexPath;
    PublishTopicHeaderView *_header;
    PublishTopicFooterView *_footer;
    NSString *_topicTitle;
    NSString *_topicTags;
    NSString *_topicDesc;
    NSMutableArray *_selectedSignArray;
    NSMutableArray *_imageModelArray;
    
    PublishTopicCell *_propertyTopicCell;
    PublishTopicImageCell *_propertyImageCell;
    PublishTopicTextCell *_propertyTextCell;
    
    MBProgressHUD *_hud;
}
@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) NSString *latitude;//纬度
@property (nonatomic, strong) NSString *longitude;//经度
@property (nonatomic, strong) NSString *city;//城市
@property (nonatomic, strong) NSString *detailAddress;//具体地址
@end

@implementation PublishTopicController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //开启定位
    [self.locMgr startUpdatingLocation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [NSMutableArray new];
    _imageModelArray = [NSMutableArray new];
    _topicDesc = @"";
    _topicTags = @"";
    _topicTitle = @"";
    
    PublishTopicModel *model = [[PublishTopicModel alloc] init];
    model.original = @"0";
    [_dataArray addObject:model];
    [self setUpView];
}
#pragma mark- 页面
-(void)setUpView {
    //页面设置
    self.publishBtn.layer.cornerRadius = CGRectGetHeight(self.publishBtn.frame) * 0.5;
    [self.backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.publishBtn addTarget:self action:@selector(uploadRequest) forControlEvents:UIControlEventTouchUpInside];

    //注册
    UINib *nib = [UINib nibWithNibName:@"PublishTopicCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PublishTopicCell"];
    _propertyTopicCell = [self.tableView dequeueReusableCellWithIdentifier:@"PublishTopicCell"];
    //图片
    UINib *nibImage = [UINib nibWithNibName:@"PublishTopicImageCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibImage forCellReuseIdentifier:@"PublishTopicImageCell"];
    _propertyImageCell = [self.tableView dequeueReusableCellWithIdentifier:@"PublishTopicImageCell"];
    //文字
    UINib *nibText = [UINib nibWithNibName:@"PublishTopicTextCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nibText forCellReuseIdentifier:@"PublishTopicTextCell"];
    _propertyTextCell = [self.tableView dequeueReusableCellWithIdentifier:@"PublishTopicTextCell"];
    
    //页头
    PublishTopicHeaderView *header = [[PublishTopicHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, HEADER_HEIGHT)];
    //CGFloat height = [header systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    self.tableView.tableHeaderView = header;
    
    _header = header;
    [header.titleLbl addTapAction:@selector(titleLblTap) forTarget:self];
    [header.descLbl addTapAction:@selector(descLblTap) forTarget:self];
    [header.addTagBtn addTarget:self action:@selector(addTagBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [header.tagsLbl addTapAction:@selector(addTagBtnClicked) forTarget:self];
    //页尾
    PublishTopicFooterView *footer = [[PublishTopicFooterView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    self.tableView.tableFooterView = footer;
    [_footer.locationLbl addTapAction:@selector(findPosition) forTarget:self];
    _footer = footer;
}
#pragma mark- 事件
-(void)backBtnClicked{
    if (_topicTags.length || _topicTitle.length || _topicDesc.length || _dataArray.count > 1) {
        if (down_IOS_8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定放弃编辑?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.tag = 1234;
            [alert show];
        }else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定放弃编辑?" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController dismissViewController];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }else {
        [self.navigationController dismissViewController];
    }
}
-(void)titleLblTap {
    PublishTopicTextController *vc = [[PublishTopicTextController alloc] init];
    vc.title = @"编辑标题";
    vc.sourceText = _topicTitle;
    vc.maxWordsCount = 20;
    vc.completedBlock = ^(NSString *text){
        if (!text.length) {
            _header.titleLbl.text = @"标题";
        }else {
            _header.titleLbl.text = text;
        }
        _topicTitle = text;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)descLblTap {
    PublishTopicTextController *vc = [[PublishTopicTextController alloc] init];
    vc.title = @"编辑简介";
    vc.sourceText = _topicDesc;
    vc.maxWordsCount = 60;
    vc.completedBlock = ^(NSString *text){
        if (!text.length) {
            _header.descLbl.text = @"简介";
        }else {
            _header.descLbl.text = text;
        }
        _topicDesc = text;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)addTagBtnClicked {
    CreateSignViewController2 *vc = [[CreateSignViewController2 alloc] initWithTopic];
    vc.selectedSignArray = _selectedSignArray;
    vc.completeBlock = ^(NSMutableArray *signArray) {
        _selectedSignArray = signArray;
        NSMutableArray *tempArray = [NSMutableArray new];
        if (signArray.count) {
            for (NSDictionary *dict in signArray) {
                [tempArray addObject:dict[@"name"]];
            }
            _topicTags = [tempArray componentsJoinedByString:@", "];
            _header.tagsLbl.text = _topicTags;
//            _header.tagsLbl.shadowColor = [GetColor16 hexStringToColor:@"#E34286"];
//            //_header.tagsLbl.layer.shadowOpacity = 0.5;
//            _header.tagsLbl.shadowOffset = CGSizeMake(-1, 2);
            _header.addTagBtn.hidden = YES;
        }else {
            _header.tagsLbl.text = @"";
            _header.addTagBtn.hidden = NO;
        }
        
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark- 定位
- (CLLocationManager *)locMgr
{
    // 定位服务不可用
    if(![CLLocationManager locationServicesEnabled]) return nil;
    
    if (!_locMgr) {
        // 创建定位管理者
        self.locMgr = [[CLLocationManager alloc] init];
        // 设置代理
        self.locMgr.delegate = self;
        if ([[UIDevice currentDevice].systemVersion floatValue]>= 8.0) {
            [self.locMgr requestAlwaysAuthorization];
        }
    }
    return _locMgr;
    
}
/**
 *  只要定位到用户的位置，就会调用（调用频率特别高）
 *  @param locations : 装着CLLocation对象
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 1.取出位置对象
    CLLocation *loc = [locations firstObject];
    
    // 2.取出经纬度
    CLLocationCoordinate2D coordinate = loc.coordinate;
    
    // 3.打印经纬度
    NSLog(@"didUpdateLocations------%f %f", coordinate.latitude, coordinate.longitude);
    
    CLLocation *c = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    //创建位置
    CLGeocoder *revGeo = [[CLGeocoder alloc] init];
    [revGeo reverseGeocodeLocation:c
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                     if (!error && [placemarks count] > 0)
                     {
                         NSDictionary *dict =
                         [[placemarks objectAtIndex:0] addressDictionary];
                         
                         self.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
                         self.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
                         self.city = [dict objectForKey:@"State"];
                         NSString *SubLocality = [dict objectForKey:@"SubLocality"];
                         NSString *Street = [dict objectForKey:@"Street"];
                         if (Street == nil) {
                             Street = @"";
                         }
                         NSString *address = [self.city stringByAppendingString:SubLocality];
                         if (_city == nil) {
                             _city = @"";
                         }
                         self.detailAddress = [address stringByAppendingString:Street];
                         _footer.locationLbl.text =  self.detailAddress;
                         
                     }
                     else
                     {
                         NSLog(@"ERROR: %@", error); }
                 }];
    
    // 停止定位(省电措施：只要不想用定位服务，就马上停止定位服务)
    [manager stopUpdatingLocation];
}
//附近位置
- (void)findPosition
{
    NearbyLocationsViewController *nearbyLocationVC = [[NearbyLocationsViewController alloc] init];
    [nearbyLocationVC position:^(NSString *position,NSDictionary *location) {
        self.detailAddress = position;
        self.latitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lat"]];
        self.longitude = [NSString stringWithFormat:@"%@",[location objectForKey:@"lng"]];
        _footer.locationLbl.text =  self.detailAddress;
    }];
    nearbyLocationVC.lat = self.latitude;
    nearbyLocationVC.lon = self.longitude;
    nearbyLocationVC.address = self.detailAddress;
    
    ZZNavigationController *zzNav = [[ZZNavigationController alloc] initWithRootViewController:nearbyLocationVC];
    [self presentViewController:zzNav animated:YES completion:nil];
}

#pragma mark- tableview delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    CGFloat yOffset  = scrollView.contentOffset.y;
//    if (yOffset < -HEADER_HEIGHT) {
//        CGRect f = _header.frame;
//        f.origin.y = yOffset;
//        f.size.height =  -yOffset;
//        _header.frame = f;
//    }
//}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PublishTopicModel *model = _dataArray[indexPath.row];
    PublishTopicSuperCell *cell = nil;
    
    if (model.image) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PublishTopicImageCell"];
        PublishTopicImageCell *topicImageCell = (PublishTopicImageCell *)cell;
        topicImageCell.contentIV.image = model.image;
        cell.editBlock = ^(PublishTopicSuperCell *editCell) {
            [self imageTap:editCell];
        };
        topicImageCell.marksArray = model.marksArray;
        [topicImageCell showMarksView];
    }else if (model.content) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PublishTopicTextCell"];
        PublishTopicTextCell *topicTextCell = (PublishTopicTextCell *)cell;
        topicTextCell.textLbl.text = model.content;
        cell.editBlock = ^(PublishTopicSuperCell *editCell) {
            [self textTap:editCell];
        };
    }else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"PublishTopicCell"];
        PublishTopicCell *topicCell = ((PublishTopicCell *)cell);
        
        if ([model.original isEqualToString:@"0"]) {
            topicCell.deleteBtn.hidden = YES;
            topicCell.addBtn.hidden = YES;
        }else {
            topicCell.deleteBtn.hidden = NO;
            topicCell.addBtn.hidden = NO;
        }
        topicCell.imageTapBlock = ^(PublishTopicSuperCell *editCell) {
            [self imageTap:editCell];
        };
        topicCell.textTapBlock = ^(PublishTopicSuperCell *editCell) {
            [self textTap:editCell];
        };
    }
    
    cell.addBlock = ^(PublishTopicSuperCell *editCell) {
        [self topicCellAdd:editCell];
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.deleteBlock = ^(PublishTopicSuperCell *editCell) {
        [self topicCellDelete:editCell];
    };
//    if ([self.tableView indexPathIsMovingIndexPath:indexPath])
//    {
//        [cell prepareForMove];
//    }
    //[cell setShouldIndentWhileEditing:NO];
    //[cell setShowsReorderControl:YES];
    cell.contentView.hidden = NO;
    return cell;
}
//添加栏目
-(void)topicCellAdd:(PublishTopicSuperCell *)editCell {
    PublishTopicModel *model = [[PublishTopicModel alloc] init];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:editCell];
    model.original = @"1";
    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    [_dataArray insertObject:model atIndex:newIndexPath.row];
    [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
}
//删除栏目
-(void)topicCellDelete:(PublishTopicSuperCell *)editCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:editCell];
    _editIndexPath = indexPath;
    
    if ([editCell isKindOfClass:[PublishTopicImageCell class]] && _imageModelArray.count == 1) {
        //至少保留一张图
        [self showAtLeastOneImageAlert];
    }else {
        [self showDeleteBlock];
    }
    
}
-(void)showDeleteBlock{
    if (down_IOS_8) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"确定要删除?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.tag = 1001;
        [alert show];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定放弃编辑?" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self deleteAlertMethod];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
-(void)deleteAlertMethod {
    PublishTopicSuperCell *editCell = (PublishTopicSuperCell *)[self tableView:self.tableView cellForRowAtIndexPath:_editIndexPath];
    if ([editCell isKindOfClass:[PublishTopicImageCell class]]) {
        //至少保留一张图
        if (_imageModelArray.count == 1) {
            [self showAtLeastOneImageAlert];
        }else {
            [_imageModelArray removeObject:_dataArray[_editIndexPath.row]];
            [_dataArray removeObjectAtIndex:_editIndexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[_editIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            //设置背景图
            PublishTopicModel *tmpModel = _imageModelArray[0];
            _header.mainIV.image = tmpModel.image;
        }
    }else {
        [_dataArray removeObjectAtIndex:_editIndexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[_editIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    }
}
-(void)showAtLeastOneImageAlert {
    NSString *message = @"请至少保留一张图片";
    if (down_IOS_8) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:message message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //[self laterOnPayClicked];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1234) {
        if (buttonIndex == 1) {
            [self.navigationController dismissViewController];
        }
    }else if (alertView.tag == 1001) {
        if (buttonIndex == 1) {
            [self deleteAlertMethod];
        }
        
    }else{
        
    }
}
//添加-图片
-(void)imageTap:(PublishTopicSuperCell *)editCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:editCell];
    _editIndexPath = indexPath;
    [self showPhotoAlertSheet];
}
//添加-文字
-(void)textTap:(PublishTopicSuperCell *)editCell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:editCell];
    PublishTopicModel *model = _dataArray[indexPath.row];
    PublishTopicTextController *vc = [[PublishTopicTextController alloc] init];
    vc.title = @"编辑文字";
    vc.sourceText = model.content;
    vc.completedBlock = ^(NSString *text){
        float height = [text calculateSize:CGSizeMake(_propertyTextCell.textLbl.frame.size.width + (SCREEN_WIDTH - 320), FLT_MAX) font:_propertyTextCell.textLbl.font].height;
        if ([model.original isEqualToString:@"0"]) {
            PublishTopicModel *newModel = [[PublishTopicModel alloc] init];
            newModel.content = text;
            newModel.original = @"1";
            newModel.contentHeight = height;
            [_dataArray insertObject:newModel atIndex:indexPath.row];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        }else {
            model.content = text;
            model.contentHeight = height;
            [self.tableView reloadData];
        }
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PublishTopicModel *model = _dataArray[indexPath.row];
    if (model.image) {
        return (CGRectGetHeight(_propertyImageCell.frame) / CGRectGetWidth(_propertyImageCell.frame)) * SCREEN_WIDTH;
    }else if (model.content) {
//        PublishTopicImageCell *cell = (PublishTopicImageCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        [cell layoutIfNeeded];
//        CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
//        return height;
        return CGRectGetHeight(_propertyTextCell.frame) + model.contentHeight - CGRectGetHeight(_propertyTextCell.textLbl.frame);
    }else if ([model.original isEqualToString:@"0"]){
        return CGRectGetHeight(_propertyTopicCell.frame) - 30;
    }
    return CGRectGetHeight(_propertyTopicCell.frame);
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return YES;
//}
//-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    [_dataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
//}
//- (BOOL)tableView: (UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return NO;
//}
- (void)moveTableView:(FMMoveTableView *)tableView moveRowFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
//    NSArray *movie = [[[self movies] objectAtIndex:[fromIndexPath section]] objectAtIndex:[fromIndexPath row]];
//    [[[self movies] objectAtIndex:[fromIndexPath section]] removeObjectAtIndex:[fromIndexPath row]];
//    [[[self movies] objectAtIndex:[toIndexPath section]] insertObject:movie atIndex:[toIndexPath row]];
    [_dataArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}
- (NSIndexPath *)moveTableView:(FMMoveTableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if ([sourceIndexPath section] != [proposedDestinationIndexPath section]) {
        proposedDestinationIndexPath = sourceIndexPath;
    }
    
    return proposedDestinationIndexPath;
}
#pragma mark- 添加图片
-(void)showPhotoAlertSheet {
    [self.view endEditing:YES];
    
    ODMCombinationPickerViewController *vc = [[ODMCombinationPickerViewController alloc] init];
    vc.delegate = self;
    //vc.maxSelCount = 6;
    [self presentViewController:vc animated:YES completion:nil];
    return;
    //#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIAlertController *alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self alertButtonAtIndex:0];
        }]];
        
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self alertButtonAtIndex:1];
        }]];
        [alertSheet addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }]];
        
        [self presentViewController:alertSheet animated:YES completion:nil];
    }else {
        UIActionSheet *alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
        [alertSheet showInView:self.view];
    }
}
-(void)imagePickerController:(ODMCombinationPickerViewController *)picker didFinishPickingImage:(UIImage *)image {
    [picker dismissViewControllerAnimated:YES completion:^{
        [self showAddTopicMarks:image];
    }];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self alertButtonAtIndex:buttonIndex];
}
-(void)alertButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        ZYQAssetPickerController *zYQAssetPicker = [[ZYQAssetPickerController alloc] init];
        zYQAssetPicker.maximumNumberOfSelection = 1;
        zYQAssetPicker.assetsFilter = [ALAssetsFilter allPhotos];
        zYQAssetPicker.showEmptyGroups=NO;
        zYQAssetPicker.delegate=self;
        [self presentViewController:zYQAssetPicker animated:YES completion:NULL];
        
    }else if(buttonIndex == 0){
        
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            //[LoadingView showErrMsg:@"该设备不支持相机！" WithInterval:1];
            return;
        }
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
}

#pragma Assets Picker Delegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    ALAsset *asset = assets[0];
    UIImage *image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
    
    //[self setTopicIndex:_editTopicIndex Image:image Content:nil];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAddTopicMarks:image];
    }];
}
#pragma  拍照/选择图片结束
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"如果允许编辑%@",info);//picker.allowsEditing= YES允许编辑的时候 字典会多一些键值。
    //获取图片
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];//原始图片
    //    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];//编辑后的图片
    
    //[self setTopicIndex:_editTopicIndex Image:image Content:nil];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:^{
        [self showAddTopicMarks:image];
    }];
    
}
-(void)showAddTopicMarks:(UIImage *)image {
    PublishTopicModel *editModel = _dataArray[_editIndexPath.row];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"AddTopicMark" bundle:[NSBundle mainBundle]];
    UINavigationController *nav = sb.instantiateInitialViewController;
    CropController *crop = nav.childViewControllers[0];
    crop.sourceImage = image;
    crop.marksCount = 3;
    
    crop.comleteBlock = ^(UIImage *image, NSArray *marksArray) {
        PublishTopicModel *imageModel = nil;
        if ([editModel.original isEqualToString:@"0"]) {
            PublishTopicModel *newModel = [[PublishTopicModel alloc] init];
            newModel.original = @"1";
            newModel.image = image;
            newModel.marksArray = marksArray;
            imageModel = newModel;
            [_dataArray insertObject:newModel atIndex:_editIndexPath.row];
            [self.tableView insertRowsAtIndexPaths:@[_editIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        }else {
            editModel.image = image;
            editModel.marksArray = marksArray;
            imageModel = editModel;
            [self.tableView reloadData];
        }
        if (![_imageModelArray containsObject:imageModel]) {
            [_imageModelArray addObject:imageModel];
            if (_imageModelArray.count == 1) {
                _header.mainIV.image = imageModel.image;
            }
        }
        if (_imageModelArray.count == 1) {
            _header.mainIV.image = imageModel.image;
        }
    };
    [self presentViewController:nav animated:YES completion:nil];
}
#pragma mark- 网络请求
- (void)uploadRequest {
    if (_topicTitle.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请填写标题"];
        return;
    }
    if (_topicTags.length == 0) {
        [AutoDismissAlert autoDismissAlertSecond:@"请添加标签"];
        return;
    }
    //至少一张图片
    if (_imageModelArray.count<1) {
        [AutoDismissAlert autoDismissAlertSecond:@"请至少上传一张图片"];
        return;
    }
    //锁定发布按钮，防止重复发布
    self.publishBtn.userInteractionEnabled = NO;
    _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hud.labelText = @"发布中,请稍后";
    _hud.dimBackground = YES;
    [_hud show:YES];
    [self uploadPhotoRequest];
}
-(void)uploadAllRequest {
    NSString * xyz = [NSString stringWithFormat:@"%@,%@", self.latitude ? self.latitude : @"",self.longitude ? self.longitude : @""];
    NSMutableArray *goods = [NSMutableArray arrayWithCapacity:0];
    for (PublishTopicModel *model in _dataArray) {
        if ([model.original isEqualToString:@"1"]) {
            NSDictionary *tempDict = @{ACCOUNT_PASSWORD, @"dealType":@"3", @"content":model.content ? model.content : @"", @"photos": model.imageUrl ? model.imageUrl : @"", @"labels":[model getMarks], @"uuid":@"0", @"categoryID":@"254"};
            [goods addObject:tempDict];
        }
        
    }
    //[goods removeObjectAtIndex:0];
    
    NSDictionary *param = nil;
    
    PublishTopicModel *mainModel = _imageModelArray[0];
    if (_footer.locationLbl.hidden == NO) {
        //拼接post参数
        param = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"dealType":@"3", @"xyz":xyz, @"position":_footer.locationLbl.text, @"city":_city ? _city : @"", @"positionView":@"1", @"title":_topicTitle, @"description":_topicDesc, @"categoryID":@"251", @"tags":_topicTags, @"content": @"", @"photos": mainModel.imageUrl, @"labels":[mainModel getMarks], @"goods": goods, @"uuid":@"0"}];
    }else {
        param = [self parametersForDic:@"accountCreatePost" parameters:@{ACCOUNT_PASSWORD, @"dealType":@"3", @"xyz":xyz, @"position":_footer.locationLbl.text, @"city":_city ? _city : @"", @"positionView":@"0", @"title":_topicTitle, @"description":_topicDesc, @"categoryID":@"251", @"tags":_topicTags, @"content": @"", @"photos": mainModel.imageUrl, @"labels":[mainModel getMarks], @"goods": goods, @"uuid":@"0"}];
    }
    //发送post请求
    [URLRequest postRequestWith:iOS_POST_URL parameters:param andblock:^(NSDictionary *dic) {
        self.publishBtn.userInteractionEnabled = YES;
        [_hud removeFromSuperview];
        int result = [[dic objectForKey:@"result"] intValue];
        if (result == 0) {
            //[self clearInput];
            //NSDictionary * tempdic = [dic objectForKey:@"data"];
            [AutoDismissAlert autoDismissAlertSecond:@"发布成功"];
            //
            //            TopicDetailListController *detail = [[TopicDetailListController alloc] init];
            //            NSDictionary *data = [dic objectForKey:@"data"];
            //            detail.modelId = data[@"id"];
            
            [self.navigationController dismissViewController];
            //发布通知刷新首页数据
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadVC" object:nil];
            [((AppDelegate *)APPDELEGATE) tabbarSelectedIndex:0];
            //[self.navigationController pushViewController:detail animated:YES];
            //[self.navigationController dismissViewController];
        }else{
            self.publishBtn.userInteractionEnabled = YES;
            [AutoDismissAlert autoDismissAlert:[dic objectForKeyedSubscript:@"message"]];
        }
    }];
}
-(void)uploadPhotoRequest {
    //NSString *url = @"http://120.27.52.97:8080/tusstar/servlet/JJUploadImageServlet";
    NSString *url = iOS_POST_REALPICTURE_URL;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    
    __block NSMutableArray *tmpImageArray = [NSMutableArray new];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (PublishTopicModel *model in _dataArray) {
            UIImage *image = model.image;
            if (image) {
                NSData *imageData = [image compressAndResize];
                [formData appendPartWithFileData:imageData name:@"filedata" fileName:[NSString stringWithFormat:@"%@.jpg", self.uuid] mimeType:@"image/*"];
                [tmpImageArray addObject:model];
            }
            
        }
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * dic = (NSDictionary*)responseObject;
        NSLog(@"Success: %@", dic);
        NSString * str = [dic objectForKey:@"msg"];
        //        NSString * str1 = [str substringWithRange:NSMakeRange(48, 36)];
        NSLog(@"%@",str);
        NSLog(@"message: %@", [dic objectForKey:@"message"]);
        NSArray *tempArray = [str componentsSeparatedByString:@","];
        for (int i=0; i<tempArray.count; i++) {
            if (i < tmpImageArray.count) {
                PublishTopicModel *model = tmpImageArray[i];
                model.imageUrl = tempArray[i];
            }
        }
        [self uploadAllRequest];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        [_hud removeFromSuperview];
        
        self.publishBtn.userInteractionEnabled = YES;
        //[UIAlertView autoDismissAlert:@"上传失败"];
        //[HUD removeFromSuperview];
    }];
}
-(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    return result;
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
