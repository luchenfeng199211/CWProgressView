//
//  UIColor+ColorFrom16.h
//  PocketMedicalManagement
//
//  Created by AaronLee on 14-8-7.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ColorFrom16)

/*
 * Tip：根据0x值生成UIColor
 */
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;

/*
 * Tip：返回UIColor的0x值
 */
+ (NSString *) hexFromUIColor: (UIColor*) color;
/*
 * Tip：返回当前颜色下偏暗的颜色，每次偏移20
 */
- (UIColor*)darkerColor;
/*
 * Tip：返回当前颜色下偏暗的颜色，每次偏移20
 */
- (UIColor*)lighterColor;

@end
