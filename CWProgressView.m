//
//  CWProgressView.m
//  CWProgressView
//
//  Created by 陆尘风 on 16/1/8.
//  Copyright © 2016年 陆尘风. All rights reserved.
//

#import "CWProgressView.h"
#import "UIColor+ColorFrom16.h"

#define CW_PROGRESS_BG_COLOR [UIColor colorWithRed:218/255.0 green:221/255.0 blue:221/255.0 alpha:1]

@interface CWProgressView()
{
    UILabel *_progressText;
    
    NSTimer *_vTimer;
    CGFloat _interimProgress;
}
@end

@implementation CWProgressView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _isRect = YES;
        _isAnimation = YES;
        _type = NZProgressTypeDefault;
    }
    return self;
}

- (void)addDefaultLabel
{
    self.backgroundColor = [UIColor clearColor];
    _progressText = [[UILabel alloc] initWithFrame:self.bounds];
    _progressText.adjustsFontSizeToFitWidth = YES;
    _progressText.backgroundColor = [UIColor clearColor];
    _progressText.textAlignment = NSTextAlignmentRight;
    _progressText.text = [NSString stringWithFormat:@"%.0f%%",self.progress * 100];
    _progressText.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_progressText];
}

- (void)addRingLabel
{
    self.backgroundColor = [UIColor clearColor];
    _progressText = [[UILabel alloc] initWithFrame:self.bounds];
    _progressText.adjustsFontSizeToFitWidth = YES;
    _progressText.backgroundColor = [UIColor clearColor];
    _progressText.textAlignment = NSTextAlignmentCenter;
    _progressText.text = [NSString stringWithFormat:@"%.0f%%",self.progress * 100];
    _progressText.font = [UIFont boldSystemFontOfSize:14];
    [self addSubview:_progressText];
}

- (void)setType:(NZProgressType)type
{
    _type = type;
    if (_type == NZProgressTypeDefault) {
        [self addDefaultLabel];
    }else{
        [self addRingLabel];
    }
}

- (void)setProgress:(float)progress
{
    if (_isAnimation == YES) {
        if (_interimProgress != progress) {
            _interimProgress = progress;
            if (_vTimer) {
                [_vTimer invalidate];
                _vTimer = nil;
            }
            _vTimer = [NSTimer scheduledTimerWithTimeInterval:0.008 target:self selector:@selector(incrementProgress:) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_vTimer forMode:UITrackingRunLoopMode];
        }
    }
    else
    {
        _progress = progress;
    }
    [self setNeedsDisplay];
}

- (void)setProgressColor:(UIColor *)progressColor
{
    _progressColor = progressColor;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    if (_type == NZProgressTypeDefault) {
        [self drawBackground:contextRef Rect:CGRectMake(0, 0, rect.size.width-60, rect.size.height)];
    }
    else
    {
        [self drawBackground:contextRef Rect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    }
    
    if (_progress) {
        //绘制进度条
        if (_type == NZProgressTypeDefault) {
            [self drawProgress:contextRef WithRect:CGRectMake(0, 0, rect.size.width-60, rect.size.height)];
        }
        else
        {
            [self drawProgress:contextRef WithRect:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        }
    }
}

//1、绘制进度条背景
- (void)drawBackground:(CGContextRef)context Rect:(CGRect)rect
{
    if (_type == NZProgressTypeDefault) {
        //直线
        //绘制基础背景区域
        float cornerRadius = 0;
        if (_isRect) {
            cornerRadius = rect.size.height/2.0;
        }
        UIBezierPath *bgPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
        CGContextSetFillColorWithColor(context, CW_PROGRESS_BG_COLOR.CGColor);
        [bgPath fill];
        
        //绘制背景阴影
        UIBezierPath *negativePath = [UIBezierPath bezierPathWithRect:CGRectMake(-10, -10, rect.size.width + 10, rect.size.height +10)];
        [negativePath appendPath:bgPath];
        [negativePath setUsesEvenOddFillRule:YES];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, CGSizeMake(0.5, 0.5), 5, [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor);
        [bgPath addClip];
        
        CGAffineTransform transform = CGAffineTransformMakeTranslation(0.1, 0.1);
        [negativePath applyTransform:transform];
        [negativePath fill];
        CGContextRestoreGState(context);
        [bgPath addClip];
    }else{
        //圆环
        CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, center.x, center.y);
        CGContextAddArc(context, center.x, center.y, rect.size.height/2.0, -0.5*M_PI, 1.5*M_PI, 0);
        CGContextSetFillColorWithColor(context, CW_PROGRESS_BG_COLOR.CGColor);
        CGContextFillPath(context);
    }
}

//2、绘制进度
- (void)drawProgress:(CGContextRef)context WithRect:(CGRect)rect
{
    CGColorRef color = (_progressColor == nil)?[UIColor blueColor].CGColor:_progressColor.CGColor;
    CGContextSaveGState(context);
    if (_type == NZProgressTypeDefault) {
        float cornerRadius = 0;
        if (_isRect) {
            cornerRadius = rect.size.height/2.0;
        }
        CGRect rectToDrawIn = CGRectMake(0, 0, rect.size.width * self.progress, rect.size.height);
        CGRect insetRect = CGRectInset(rectToDrawIn, self.progress > 0.03 ? 0.5 : -0.5, 0.5);
        UIBezierPath *progressPath = [UIBezierPath bezierPathWithRoundedRect:insetRect cornerRadius:cornerRadius];
        CGContextSetFillColorWithColor(context, color);
        [progressPath fill];
        CGContextSaveGState(context);
        [progressPath addClip];
        
        //Y 轴渐变
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat locations[] = {0.1, 1.0};//Y轴位置
        NSArray *colors = @[(__bridge id)[[self.progressColor lighterColor] lighterColor].CGColor, (__bridge id)self.progressColor.CGColor];
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
        
        CGContextDrawLinearGradient(context, gradient, CGPointMake(insetRect.size.width / 2, 0), CGPointMake(insetRect.size.width / 2, insetRect.size.height), 0);
        CGContextRestoreGState(context);
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
        CGContextStrokePath(context);
        CGContextFillPath(context);
    }else{
        float ringWidth = _ringWidth>0?_ringWidth:5;
        if (_progress == 1) {
            CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, rect.size.height/2.0, -0.5*M_PI, 1.5*M_PI, 0);
            CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
            CGContextFillPath(context);
            
            //绘制进度label背景
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, rect.size.height/2.0-ringWidth, -0.5*M_PI, 1.5*M_PI, 0);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillPath(context);
        }else{
            float endAngle = (2 * _progress) * M_PI - M_PI/2.0;
            CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, rect.size.height/2.0, -0.5*M_PI, endAngle, 0);
            CGContextSetFillColorWithColor(context, self.progressColor.CGColor);
            CGContextFillPath(context);
            
            //绘制进度label背景
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, center.x, center.y);
            CGContextAddArc(context, center.x, center.y, rect.size.height/2.0-ringWidth, -0.5*M_PI, 1.5*M_PI, 0);
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGContextFillPath(context);
        }
    }
    NSString* text = [NSString stringWithFormat:@"%.2f%%",(self.progress > 0.01 ? self.progress : 0) * 100];
    _progressText.text = text;
    _progressText.textColor = self.textColor?self.textColor:[UIColor colorWithHex:0x999999 alpha:1];
}

//进度条增长动画
- (void)incrementProgress:(NSTimer *)timer
{
    /*临时进度值 和 进度值 相等*/
    if (_interimProgress - 0.01 < _progress && _interimProgress + 0.01 > _progress) {
        _progress = _interimProgress;
        [_vTimer invalidate];
    }else{
        _progress = (_interimProgress > _progress) ? _progress + 0.01 : _progress - 0.01;
    }
    [self setNeedsDisplay];
}

@end
