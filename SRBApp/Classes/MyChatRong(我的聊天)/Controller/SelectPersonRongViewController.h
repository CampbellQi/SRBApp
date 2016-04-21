//
//  SelectPersonRongViewController.h
//  
//
//  Created by lizhen on 14/12/24.
//
//

#import "RCSelectPersonViewController.h"

typedef void (^AloneBlock)(NSString *type);

@interface SelectPersonRongViewController : RCSelectPersonViewController
@property (nonatomic, copy) AloneBlock aloneBlock;

- (void)alone:(AloneBlock)block;

@end
