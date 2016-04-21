//
//  ODCMenuView.h
//  testPhotoLib
//
//  Created by fengwanqi on 15/12/9.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol ODCMenuViewDelegate <NSObject>

- (void)changeGroup:(ALAssetsGroup *)aGroup;

@end
@interface ODCMenuView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *topView;

@property (nonatomic, assign)id<ODCMenuViewDelegate> delegate;
+(void)showMenuInView:(UIView *)view FromRect:(CGRect)rect LibArray:(NSArray *)libArray Delegate:(id<ODCMenuViewDelegate>)delegate;
+(NSString *)getSystemLibGroupName:(NSNumber *)groupType;
@end
