//
//  UIColor+ColorFrom16.m
//  PocketMedicalManagement
//
//  Created by AaronLee on 14-8-7.
//  Copyright (c) 2014年 com.XINZONG. All rights reserved.
//

#import "UIColor+ColorFrom16.h"

@implementation UIColor (ColorFrom16)

// 0xff ff ff
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#%x%x%x", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

- (UIColor *)darkerColor
{
    return [UIColor colorWithRed:CGColorGetComponents(self.CGColor)[0] - 20 green:CGColorGetComponents(self.CGColor)[1] - 20 blue:CGColorGetComponents(self.CGColor)[2] - 20 alpha:CGColorGetComponents(self.CGColor)[3]];
}

- (UIColor *)lighterColor
{
    return [UIColor colorWithRed:CGColorGetComponents(self.CGColor)[0] + 20 green:CGColorGetComponents(self.CGColor)[1] + 20 blue:CGColorGetComponents(self.CGColor)[2] + 20 alpha:CGColorGetComponents(self.CGColor)[3]];
}

@end
