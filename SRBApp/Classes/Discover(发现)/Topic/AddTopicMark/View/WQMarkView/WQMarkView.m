//
//  NewWQMarkView.m
//  testMark
//
//  Created by fengwanqi on 15/10/14.
//  Copyright © 2015年 fengwanqi. All rights reserved.
//
//基角度
#define ANGLE 0.125
//角度圆半径
#define RADIUS 30.0
//X轴投影长度
#define X_SHADOW sin(KDGREED(ANGLE)) * RADIUS
#define TITLE_BOTTOME_SPACE 2

#define K_PI 3.1415
#define KDGREED(x) ((x)  * K_PI * 2)

#define FONT [UIFont boldSystemFontOfSize:12]

#import "WQMarkView.h"

@interface WQMarkView()
{
    NSMutableArray *_titleWidthArray;
    NSMutableArray *_layerArray;
    float _startAngle;
    UIImageView *_centerBtn;
    float _titleHeight;
    
    //CAShapeLayer *_superLayer;
    int _direction;
    
    //位移
    CGPoint _startPoint;
    
    CGPoint _beginPoint;
    
    NSMutableArray *_titleLblArray;
}
@property (nonatomic, strong)NSArray *dataArray;
@end
@implementation WQMarkView

//初始化
-(id)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        //圆心按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [btn setImage:[UIImage imageNamed:@"ic_center"] forState:UIControlStateNormal];
        btn.backgroundColor = [UIColor clearColor];
        btn.center = self.center;
        //btn.layer.cornerRadius = btn.frame.size.width * 0.5;
        //[self addSubview:btn];
        //_centerBtn = btn;
        //[btn addTarget:self action:@selector(reDraw) forControlEvents:UIControlEventTouchUpInside];
        
        NSMutableArray *imageArray = [NSMutableArray new];
        for (int i=1; i<6; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_center%d", i]];
            [imageArray addObject:image];
        }
        
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        iv.animationImages = imageArray;
        iv.animationDuration = 1;
        iv.animationRepeatCount = 0;
        [self addSubview:iv];
        iv.contentMode = UIViewContentModeScaleAspectFit;
        //iv.backgroundColor = [UIColor redColor];
        _centerBtn = iv;
        [iv startAnimating];
        [iv addTapAction:@selector(reDraw) forTarget:self];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedClicked)]];
        
        _titleLblArray = [NSMutableArray new];
    }
    return self;
}
-(void)tappedClicked {
    if (self.tappedBlock) {
        self.tappedBlock();
    }
}
//生产(工厂模式)
+(id)produceWithData:(TPMarkModel *)markModel{
    WQMarkView *markView = [WQMarkView alloc];
    markView.sourceModel = markModel;
    markView.dataArray = [markView modelToArray];
    [markView setData];
    markView = [markView initWithFrame:CGRectMake(50, 50, 300, 300)];
    [markView resetFrame];
    return markView;
}
//格式化标签显示
-(NSArray *)modelToArray {
    TPMarkModel *model = self.sourceModel;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    NSString *str1 = @"";
    NSString *str2 = @"";
    NSString *str3 = @"";
    if (model.brand && model.brand.length != 0) {
        str1 = [str1 stringByAppendingString:model.brand];
    }
    if (model.name && model.name.length != 0) {
        str1 = [str1 stringByAppendingFormat:@" %@", model.name];
    }
    
    if (model.origin && model.origin.length != 0) {
        str2 = [str2 stringByAppendingString:model.origin];
    }
    if (model.shopland && model.shopland.length != 0) {
        str2 = [str2 stringByAppendingFormat:@" %@", model.shopland];
    }
    
    if (model.unit && model.unit.length != 0) {
        str3 = [str3 stringByAppendingString:model.unit];
    }
    if (model.shopprice && model.shopprice.length != 0) {
        str3 = [str3 stringByAppendingFormat:@" %@", model.shopprice];
    }
    
    if (str1.length) {
        [array addObject:str1];
    }
    if (str2.length) {
        [array addObject:str2];
    }
    if (str3.length) {
        [array addObject:str3];
    }
    return array;
}
//数据初始化
-(void)setData {
    _titleWidthArray = [NSMutableArray new];
    if (self.sourceModel.shape && self.sourceModel.shape.length != 0) {
        NSArray *shape = [self.sourceModel.shape componentsSeparatedByString:@","];
        _startAngle = ANGLE * [shape[0] intValue];
        _direction = [shape[1] intValue];
    }else {
        _startAngle = ANGLE * 2;
        _direction = 1;
        
        self.sourceModel.shape = [NSString stringWithFormat:@"%.f,%d", _startAngle / ANGLE, _direction];
    }
    
    NSMutableArray *tempArray = [NSMutableArray new];
    for (NSString *s in _dataArray) {
        //留边空
        NSString *tempS = [NSString stringWithFormat:@"  %@  ", s];
        [tempArray addObject:tempS];
        CGSize size = [tempS sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:FONT, NSFontAttributeName, nil]];
        _titleHeight = size.height;
        [_titleWidthArray addObject:[NSString stringWithFormat:@"%f", size.width]];
    }
    _dataArray = tempArray;
}
//计算大小和btn位置
-(void)resetFrame {
    float width = 0.0, height = 0.0;
    float centerBtnX = 0.0, centerBtnY = 0.0;
    
    int angleMultiple = _startAngle / ANGLE;
    float centerBtnRaduis = _centerBtn.frame.size.width/2;
    switch (_dataArray.count) {
        case 1:
        {
            float titleWidth = [_titleWidthArray[0] floatValue];
            if (angleMultiple == 1 || angleMultiple == 3) {
                width = titleWidth + X_SHADOW + centerBtnRaduis;
                height = centerBtnRaduis + X_SHADOW + TITLE_BOTTOME_SPACE + _titleHeight;
            }else {
                width = titleWidth + centerBtnRaduis;
                height = centerBtnRaduis + TITLE_BOTTOME_SPACE + _titleHeight;
            }
            
            centerBtnY = height - centerBtnRaduis;
            if (angleMultiple == 1 || angleMultiple == 2) {
                centerBtnX = centerBtnRaduis;
                
            }else {
                centerBtnX = width - centerBtnRaduis;
            }
            break;
        }
        case 2:{
            float titleWidth0 = [_titleWidthArray[0] floatValue];
            float titleWidth1 = [_titleWidthArray[1] floatValue];
            if (angleMultiple == 1 || angleMultiple == 3) {
                width = (titleWidth0 > titleWidth1 ? titleWidth0 : titleWidth1) + 2*X_SHADOW;
                height = 2 * X_SHADOW + TITLE_BOTTOME_SPACE + _titleHeight;
                if (angleMultiple == 1) {
                    centerBtnX = centerBtnRaduis;
                }else {
                    centerBtnX = width - X_SHADOW;
                }
                centerBtnY = height - X_SHADOW;
            }else {
                float tempWidth = titleWidth1 > titleWidth0 ? titleWidth1 : titleWidth0;
                width = tempWidth + centerBtnRaduis;
                height = RADIUS * 2 + TITLE_BOTTOME_SPACE + _titleHeight;
                
                centerBtnY = height - RADIUS;
                if (angleMultiple == 2) {
                    centerBtnX = centerBtnRaduis;
                }else {
                    centerBtnX = width - centerBtnRaduis;
                }
            }
            break;
        }
        default:
        {
            float titleWidth0 = [_titleWidthArray[0] floatValue];
            float titleWidth1 = [_titleWidthArray[1] floatValue];
            float titleWidth2 = [_titleWidthArray[2] floatValue];
            if (angleMultiple == 1 || angleMultiple == 3) {
                if (angleMultiple == 1) {
                    width = (titleWidth0 > titleWidth2 ? titleWidth0 : titleWidth2) + titleWidth1 + 2*X_SHADOW;
                    centerBtnX = titleWidth1 + X_SHADOW;
                }else {
                    width = (titleWidth0 > titleWidth1 ? titleWidth0 : titleWidth1) + titleWidth2 + 2*X_SHADOW;
                    centerBtnX = width - titleWidth2 - X_SHADOW;
                }
                height = 2 * X_SHADOW + TITLE_BOTTOME_SPACE + _titleHeight;
                centerBtnY = height - X_SHADOW;
            }else {
                float tempWidth = titleWidth0 > titleWidth1 ? titleWidth0 : titleWidth1;
                width = (tempWidth > titleWidth2 ? tempWidth : titleWidth2) + centerBtnRaduis;
                height = RADIUS * 2 + TITLE_BOTTOME_SPACE + _titleHeight;
                
                centerBtnY = height - RADIUS;
                if (angleMultiple == 2) {
                    centerBtnX = centerBtnRaduis;
                }else {
                    centerBtnX = width - centerBtnRaduis;
                }
                
            }
            break;
        }
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, height);
    _centerBtn.center = CGPointMake(centerBtnX, centerBtnY);
    float toCenterWidth = self.frame.size.width/2 - _centerBtn.center.x;
    float toCenterHeight = self.frame.size.height/2 - _centerBtn.center.y;
    self.toCenterSize = CGSizeMake(toCenterWidth, toCenterHeight);
    
    
    [self resetCenter];
    
    [self draw];
}


-(void)reDraw {
    if (_isFreeze) {
        return;
    }
    int angleMultiple = _startAngle / ANGLE;
    switch (angleMultiple) {
        case 1:
            _startAngle = ANGLE * 2;
            _direction = 1;
            break;
        case 2:
            _startAngle = ANGLE * 3;
            _direction = -1;
            break;
        case 3:
            _startAngle = ANGLE * 6;
            _direction = -1;
            break;
        default:
            _startAngle = ANGLE;
            _direction = 1;
            break;
    }
    
    self.sourceModel.shape = [NSString stringWithFormat:@"%.f,%d", _startAngle/ANGLE, _direction];
    //[_superLayer removeFromSuperlayer];
    //_superLayer = nil;
    for (CALayer *layer in _layerArray) {
        [layer removeFromSuperlayer];
    }
    [self resetFrame];
    //[self setNeedsDisplay];
}
-(void)draw{
    //_superLayer = [[CAShapeLayer alloc] init];
    for (UILabel *lbl in _titleLblArray) {
        [lbl removeFromSuperview];
    }
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];

    animation.duration = 0.0;
    
    animation.fromValue = @(0.0);
    animation.toValue = @(1.0);
    
    //当前view 的frame
    float tempStartAngel = _startAngle;
    int angleMultiple = _startAngle / ANGLE;
    if (_dataArray.count == 1) {
        if (angleMultiple == 2) {
            tempStartAngel = 0;
        }else if (angleMultiple == 6){
            tempStartAngel = 4 * ANGLE;
        }
    }
    //文字和线左右两端
    _layerArray = [NSMutableArray new];
    for (int i=0; i<_dataArray.count; i++) {
        //初始化
        CAShapeLayer *ployLineLayer = [[CAShapeLayer alloc] init];
        ployLineLayer.frame = self.bounds;
        ployLineLayer.fillColor = [UIColor clearColor].CGColor;
        ployLineLayer.backgroundColor = [UIColor clearColor].CGColor;
        
        UIColor *color = [UIColor whiteColor];
        //UIColor *color = [UIColor blackColor];
        
        ployLineLayer.strokeColor = color.CGColor;
        [ployLineLayer setLineWidth:1.0f];
        
        [_layerArray addObject:ployLineLayer];
        if (_needAnimation) {
            [ployLineLayer addAnimation:animation forKey:@"strokeEnd"];
        }else {
        
        }
        
        ployLineLayer.zPosition = 1;
        
        CGMutablePathRef ployLinePath = CGPathCreateMutable();
        
        //计算点
        int pointCount = 3;
        if (tempStartAngel == 0 || (_dataArray.count == 1 && tempStartAngel / ANGLE == 4)) {
            pointCount = 2;
        }
        float titleWidth = [_titleWidthArray[i] floatValue];
        CGPoint points[pointCount];
        points[0] = _centerBtn.center;
        if (pointCount == 3) {
            points[1] = CGPointMake(points[0].x + RADIUS * cos(KDGREED(tempStartAngel)), points[0].y - RADIUS * sin(KDGREED(tempStartAngel)));
            points[2] = CGPointMake(points[1].x + titleWidth * _direction, points[1].y);
        }else {
            points[1].x = points[0].x + titleWidth * _direction;
            points[1].y = points[0].y;
        }
        
        //绘制文字
        CGPoint strPoint;
        strPoint = pointCount == 3 ? points[1] : points[0];
        
        //CGContextRef context = UIGraphicsGetCurrentContext();
        
        //CGContextSetShadow(context, CGSizeMake(1.0f, 2.0f), 2.0f);
        //CGContextRef context = UIGraphicsGetCurrentContext();
        //CGContextSetShadow(context, CGSizeMake(20.0f, 20.0f), 10.0f);
        //[_dataArray[i] drawAtPoint:CGPointMake(_direction > 0 ? strPoint.x  : strPoint.x - titleWidth, strPoint.y - _titleHeight - TITLE_BOTTOME_SPACE) withAttributes:@{NSFontAttributeName: FONT, NSForegroundColorAttributeName: [UIColor whiteColor]}];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(_direction > 0 ? strPoint.x  : strPoint.x - titleWidth, strPoint.y - _titleHeight - TITLE_BOTTOME_SPACE, titleWidth, _titleHeight)];
        lbl.font = FONT;
        lbl.textColor = [UIColor whiteColor];
        lbl.text = _dataArray[i];
        lbl.shadowColor = [UIColor grayColor];
        lbl.shadowOffset = CGSizeMake(1.0f, 1.0f);
        [self addSubview:lbl];
        [_titleLblArray addObject:lbl];
        
        CGPathAddLines(ployLinePath, NULL, points, pointCount);
        ployLineLayer.path = ployLinePath;
        
        
        [self.layer addSublayer:ployLineLayer];
        //[_superLayer addSublayer:ployLineLayer];
        
        if (angleMultiple == 6) {
            if (i == 0) {
                if (_dataArray.count == 2) {
                    tempStartAngel -= ANGLE * 4;
                }else {
                    tempStartAngel = 0;
                }
                
            }else {
                tempStartAngel -= ANGLE * 6;
            }
            _direction = -1;
        }else if (angleMultiple == 1) {
            if (i == 0) {
                if (_dataArray.count == 2) {
                    tempStartAngel += 6 * ANGLE;
                    _direction = 1;
                }else {
                    tempStartAngel += 4 * ANGLE;
                    _direction = -1;
                }
            }else {
                tempStartAngel += 2 * ANGLE;
                _direction = 1;
            }
        }else  if (angleMultiple == 3) {
            if (i == 0) {
                tempStartAngel += 2 * ANGLE;
                _direction = -1;
            }else {
                tempStartAngel += 2*ANGLE;
                _direction = 1;
            }
        }else if (angleMultiple == 2){
            if (i == 0) {
                if (_dataArray.count == 2) {
                    tempStartAngel -= 4*ANGLE;
                }else {
                    tempStartAngel -= 2*ANGLE;
                }
            }else {
                tempStartAngel -= 2*ANGLE;
            }
            _direction = 1;
            
        }
    }
    
    //[self.layer addSublayer:_superLayer];
}

#pragma mark- 位移
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:self];
    
    _beginPoint = [touch locationInView:self.superview];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isFreeze) {
        return;
    }
    UITouch *touch = [touches anyObject];
    if ([touch view] == self)
    {
        CGPoint locationPoint = [touch locationInView:self];
        self.center = locationPoint;
        //计算位移
        CGPoint point = [[touches anyObject] locationInView:self];
        float detaX = point.x - _startPoint.x;
        float detaY = point.y - _startPoint.y;
        
        //计算位移后的view的中心点
        CGPoint newCenter = CGPointMake(self.center.x + detaX, self.center.y + detaY);
        //限制用户不可将试图拖出屏幕
        float halfX = CGRectGetMidX(self.bounds);
        //x坐标左边界
        newCenter.x = MAX(halfX, newCenter.x);
        //x坐标右边界
        newCenter.x = MIN(self.superview.bounds.size.width - halfX, newCenter.x);
        
        float halfY = CGRectGetMidY(self.bounds);
        //y坐标的上边界
        newCenter.y = MAX(halfY, newCenter.y);
        //y坐标的下边界
        newCenter.y = MIN(self.superview.bounds.size.height - halfY, newCenter.y);
        
        self.center = newCenter;
    }
    return;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    float space = 5.0;
    UITouch *touch = [touches anyObject];
    //CGPoint endLocation = [touch locationInView:self];
    
    CGPoint endLocation1 = [touch locationInView:self.superview];
    if (fabs(endLocation1.x - _beginPoint.x) < space && fabs(endLocation1.y - _beginPoint.y) < space) {
        [self tappedClicked];
    }
    
    self.currentPoint = [self convertPoint:_centerBtn.center toView:self.superview];
    
    if (self.resetPointBlock) {
        self.resetPointBlock();
    }
//    NSString * xScale = [NSString stringWithFormat:@"%.3f", self.currentPoint.x/self.superview.width];
//    NSString *yScale = [NSString stringWithFormat:@"%.3f", self.currentPoint.y/self.superview.height];
//    self.sourceModel.xyz = [NSString stringWithFormat:@"%@,%@",xScale, yScale];
}

-(void)resetCenter {
    float x = self.currentPoint.x + self.toCenterSize.width;
    float y = self.currentPoint.y + self.toCenterSize.height;
    self.center = CGPointMake(x, y);
    
    CGPoint newCenter = self.center;
    //限制用户不可将试图拖出屏幕
    float halfX = CGRectGetMidX(self.bounds);
    //x坐标左边界
    newCenter.x = MAX(halfX, newCenter.x);
    //x坐标右边界
    newCenter.x = MIN(self.superview.bounds.size.width - halfX, newCenter.x);
    
    float halfY = CGRectGetMidY(self.bounds);
    //y坐标的上边界
    newCenter.y = MAX(halfY, newCenter.y);
    //y坐标的下边界
    newCenter.y = MIN(self.superview.bounds.size.height - halfY, newCenter.y);
    self.center = newCenter;
    
    self.currentPoint = [self convertPoint:_centerBtn.center toView:self.superview];
    
    if (self.resetPointBlock) {
        self.resetPointBlock();
    }
    
//    NSString * xScale = [NSString stringWithFormat:@"%.3f", self.currentPoint.x/self.superview.width];
//    NSString *yScale = [NSString stringWithFormat:@"%.3f", self.currentPoint.y/self.superview.height];
//    self.sourceModel.xyz = [NSString stringWithFormat:@"%@,%@",xScale, yScale];
}
@end
