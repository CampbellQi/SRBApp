//
//  PPLabel.h
//  PPLabel
//
//  Created by Petr Pavlik on 12/26/12.
//  Copyright (c) 2012 Petr Pavlik. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PPLabel;


@protocol PPLabelDelegate <NSObject>
//
//- (void)label:(PPLabel*)label didBeginTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
//- (void)label:(PPLabel*)label didMoveTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
//- (void)label:(PPLabel*)label didEndTouch:(UITouch*)touch onCharacterAtIndex:(CFIndex)charIndex;
//- (void)label:(PPLabel*)label didCancelTouch:(UITouch*)touch;
- (void)highlightWordContainingCharacterAtIndex:(CFIndex)charIndex;
- (void)removeHighlight;
- (void)clickedTextClicked:(NSString *)aClickedText;
@end


@interface PPLabel : UILabel

@property(nonatomic, weak) id <PPLabelDelegate> delegate;

- (CFIndex)characterIndexAtPoint:(CGPoint)point;

@property (nonatomic, copy)NSString *clickedText;
@end
