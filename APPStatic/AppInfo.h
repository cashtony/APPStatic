//
//  AppInfo.h
//  APPStatic
//
//  Created by LiuXuan on 2017/2/13.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppInfo : NSObject

/**
 AppIInfo 单例

 @return AppIInfo 单例
 */
+(id)shareAppInfo;

/**
 设置APPInfo实例初始化信息
 */
-(void)setAppInfoInitState;

/**
 根据bundleId打开其他APP（仅限当前程序在前台时）

 @param bundleId 要被打开的APP bundleId
 */
+(void)openAppByBundleId:(NSString*)bundleId;

/**
 获取iphone上所有正在运行的app的bundle id列表

 @return 所有正在运行的app的bundle id列表
 */
+(NSArray *)getAllActiveAppBundleIDs;

/**
 得到iphone 前台运行的app的bundle id

 @return 前台运行的app的bundle id列表
 */
+(NSArray *)getAllForegroundAppBundleIDs;

/**
 获取App icon

 @param bundleID APP bundleID
 @return APP icon
 */
+(UIImage *)getAppIcon:(NSString *)bundleID;

/**
 获取APP名字

 @param bundleID PP bundleID
 @return APP 名字
 */
+(NSString *)getAppName:(NSString *)bundleID;


/**
 使用coreTelephony.framework获取imsi
 */
+(NSString *)imsi;

/**
 设置飞行模式

 @param status 飞行模式开关
 */
+ (void) setAirplaneMode: (BOOL)status;
@end
