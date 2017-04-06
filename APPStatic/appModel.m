//
//  appModel.m
//  APPStatic
//
//  Created by LiuXuan on 2017/2/13.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import "AppModel.h"

@implementation AppModel

-(id)initWithModel:(id)model{
    self=[super init];
    if (self) {
        self.model=model;
        self.appName=[model performSelector:NSSelectorFromString(@"localizedName")];
        self.appVersion=[model performSelector:NSSelectorFromString(@"shortVersionString")];
        self.appBundelID=[model performSelector:NSSelectorFromString(@"applicationIdentifier")];
    }
    return self;
}


- (UIImage *)iconImage {
    
    NSData *iconData = [self.model performSelector:NSSelectorFromString(@"iconDataForVariant:") withObject:@(2)];
    
    NSInteger lenth = iconData.length;
    NSInteger width = 87;
    NSInteger height = 87;
    
    uint32_t *pixels = (uint32_t *)malloc(width * height * sizeof(uint32_t));
    [iconData getBytes:pixels range:NSMakeRange(32, lenth - 32)];
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(pixels,
                                             width,
                                             height,
                                             8,
                                             (width + 1) * sizeof(uint32_t),
                                             colorSpace,
                                             kCGBitmapByteOrder32Little |
                                             kCGImageAlphaPremultipliedFirst);
    
    CGImageRef cgImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    UIImage *icon = [UIImage imageWithCGImage: cgImage];
    CGImageRelease(cgImage);
    
    return icon;
}

@end
