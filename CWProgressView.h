//
//  CWProgressView.h
//  CWProgressView
//
//  Created by 陆尘风 on 16/1/8.
//  Copyright © 2016年 陆尘风. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    NZProgressTypeDefault = 0,
    NZProgressTypeRing,
}NZProgressType;

@interface CWProgressView : UIView

/*
 *进度条进度
 */
@property (nonatomic,assign) float progress;
/*
 *进度条颜色
 */
@property (nonatomic,strong) UIColor *progressColor;
/*
 *进度条类型
 */
@property (nonatomic,assign) NZProgressType type;

/*
 *默认风格进度条是否为圆角
 */
@property (nonatomic,assign) BOOL isRect;

/*
 *是否使用动画效果
 */
@property (nonatomic,assign) BOOL isAnimation;

@end