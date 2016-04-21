//
//  ODCMenuView.m
//  testPhotoLib
//
//  Created by fengwanqi on 15/12/9.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import "ODCMenuView.h"
#import "ODCMenuViewCell.h"

static ODCMenuView *_menuView;
@interface ODCMenuView()
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong)ODCMenuViewCell *propertyCell;
@property (nonatomic, strong)UIControl *bgControl;

@end
@implementation ODCMenuView
+(ODCMenuView *)shareMenu {
    if (!_menuView) {
        _menuView = [[ODCMenuView alloc] init];
        UINib *nib = [UINib nibWithNibName:@"ODCMenuViewCell" bundle:[NSBundle mainBundle]];
        [_menuView.tableView registerNib:nib forCellReuseIdentifier:@"ODCMenuViewCell"];
        _menuView.propertyCell = [_menuView.tableView dequeueReusableCellWithIdentifier:@"ODCMenuViewCell"];
        _menuView.hidden = YES;
    }
    return _menuView;
}
-(id)init {
    if (self = [super init]) {
        self.topView = [[NSBundle mainBundle] loadNibNamed:@"ODCMenuView" owner:self options:nil][0];
        [self addSubview:self.topView];
        //self.topView.frame = self.bounds;
        self.topView.clipsToBounds = YES;
        self.clipsToBounds = YES;
    }
    return self;
}
+(void)showMenuInView:(UIView *)view FromRect:(CGRect)rect LibArray:(NSArray *)libArray Delegate:(id<ODCMenuViewDelegate>)delegate {
    ODCMenuView *menuView = [ODCMenuView shareMenu];
    menuView.delegate = delegate;
    
    float duration = 0.3;
    if (menuView.hidden) {
        //背景蒙层
        if (!menuView.bgControl) {
            menuView.bgControl = [[UIControl alloc] initWithFrame:CGRectMake(0, rect.origin.y, view.frame.size.width, view.frame.size.height - rect.origin.y)];
            menuView.bgControl.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
            [view addSubview:menuView.bgControl];
            [menuView.bgControl addTarget:menuView action:@selector(dismissMenuView) forControlEvents:UIControlEventTouchUpInside];
        }
        
        menuView.bgControl.hidden = NO;
        [view bringSubviewToFront:menuView.bgControl];
        
        menuView.frame = rect;
        menuView.topView.frame = menuView.bounds;
        [view addSubview:menuView];
        menuView.dataArray = libArray;
        [menuView.tableView reloadData];
        
        //menu 显示动画
        menuView.hidden = NO;
        [UIView animateWithDuration:duration animations:^{
            float height = menuView.propertyCell.frame.size.height *libArray.count < CGRectGetHeight(view.frame)/2 ? menuView.propertyCell.frame.size.height *libArray.count : CGRectGetHeight(view.frame)/2;
            menuView.frame = CGRectMake(CGRectGetMinX(menuView.frame), CGRectGetMinY(menuView.frame), CGRectGetWidth(menuView.frame), height);
        } completion:^(BOOL finished) {
            
        }];
    }else {
        menuView.bgControl.hidden = YES;
        
        [UIView animateWithDuration:0 animations:^{
            menuView.frame = CGRectMake(CGRectGetMinX(menuView.frame), CGRectGetMinY(menuView.frame), CGRectGetWidth(menuView.frame), 1);
        } completion:^(BOOL finished) {
            menuView.hidden = YES;
        }];
    }
    
}
-(void)dismissMenuView {
    ODCMenuView *menuView = [ODCMenuView shareMenu];
    [ODCMenuView showMenuInView:menuView.superview FromRect:menuView.frame LibArray:menuView.dataArray Delegate:menuView.delegate];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _propertyCell.frame.size.height;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = @"ODCMenuViewCell";
    ODCMenuViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ALAssetsGroup *group = self.dataArray[indexPath.row];
    CGImageRef imageRef = group.posterImage;
    cell.coverIV.image = [UIImage imageWithCGImage:imageRef];
    NSString *name = [group valueForProperty:ALAssetsGroupPropertyName];

    if ([ODCMenuView getSystemLibGroupName:[group valueForProperty:ALAssetsGroupPropertyType]]) {
        name = [ODCMenuView getSystemLibGroupName:[group valueForProperty:ALAssetsGroupPropertyType]];
    }
    cell.nameLbl.text = [NSString stringWithFormat:@"%@ %ld", name, [group numberOfAssets]];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ALAssetsGroup *group = self.dataArray[indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeGroup:)]) {
        [self.delegate changeGroup:group];
        [self dismissMenuView];
    }
}
//获取相册名称
+(NSString *)getSystemLibGroupName:(NSNumber *)groupType {
    NSString *name = nil;
    switch ([groupType unsignedIntegerValue]) {
//        case ALAssetsGroupAlbum:{
//            name = @"来自我的电脑或者是在设备上创建";
//            break;
//            
//        }
            
        case ALAssetsGroupSavedPhotos:{
            name = @"相机胶卷";
            break;
        }
        case ALAssetsGroupAll:
        case ALAssetsGroupPhotoStream:{
            name = @"我的照片流";
            break;
        }
        case ALAssetsGroupLibrary:{
            name = @"";
            break;
        }
        case ALAssetsGroupEvent:{
            name = @"";
            break;
        }
        case ALAssetsGroupFaces:{
            name = @"自拍";
            break;
        }
        default:
            
            break;
    }
    return name;
}
/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     Drawing code
}
*/

@end
