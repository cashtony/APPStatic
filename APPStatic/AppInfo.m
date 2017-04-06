//
//  AppInfo.m
//  APPStatic
//
//  Created by LiuXuan on 2017/2/13.
//  Copyright © 2017年 Xuan. All rights reserved.
//
/**
     dlopen 是打开库文件
     
     dlsym  是获取函数地址
     
     dlclose是关闭
 */

#import "AppInfo.h"

@interface AppInfo (){
    
    
}

@end

static mach_port_t  *p;
static void *sbserv;

@implementation AppInfo
+(id)shareAppInfo{
    static AppInfo *appInfo=nil;
    static dispatch_once_t onceT;
    dispatch_once(&onceT, ^{
        appInfo=[AppInfo new];
    });
    return appInfo;
}

-(void)setAppInfoInitState{
    void * uikit = dlopen(UIKITPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() =dlsym(uikit, "SBSSpringBoardServerPort");
    
    p = (mach_port_t *)SBSSpringBoardServerPort();
    NSLog(@"SBSSpringBoardServerPort:%p",p);
    dlclose(uikit);
    
    sbserv = dlopen(SBSERVPATH, RTLD_LAZY);
    NSLog(@"sbserv:%p",sbserv);
}



+(NSArray *)getAllActiveAppBundleIDs{
    
    NSArray* (*SBSCopyApplicationDisplayIdentifiers)(mach_port_t* port, BOOL runningApps,BOOL debuggablet) =
    
//    dlsym(sbserv, "SBSCopyApplicationDisplayIdentifiers");
    
    dlsym(sbserv, "displayName");
    NSArray *currentRunningAppBundleIdArray= SBSCopyApplicationDisplayIdentifiers(p,NO,YES);
    
    [currentRunningAppBundleIdArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"第几个 %ld APP 的 appBundelID 是:%@",idx,obj);
    }];
    
    return currentRunningAppBundleIdArray;
}

+(NSArray *)getAllForegroundAppBundleIDs
{
    void* (*SBFrontmostApplicationDisplayIdentifier)(mach_port_t* port,char * result) = dlsym(sbserv, "SBFrontmostApplicationDisplayIdentifier");
    char topapp[256];
    SBFrontmostApplicationDisplayIdentifier(p,topapp);
    NSString *currentTopAppBundleId=[NSString stringWithFormat:@"%s",topapp];
    NSLog(@"currentTopAppBundleId:%@",currentTopAppBundleId);
    return nil;
}

+(void)openAppByBundleId:(NSString*)bundleId
{
    void* sbServices = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_LAZY);
    int (*SBSLaunchApplicationWithIdentifier)(CFStringRef identifier, Boolean suspended) = dlsym(sbServices, "SBSLaunchApplicationWithIdentifier");
    const char *strBundleId = [bundleId cStringUsingEncoding:NSUTF8StringEncoding];
    NSString *boundleString=[NSString stringWithUTF8String:strBundleId];
    int result = SBSLaunchApplicationWithIdentifier((__bridge CFStringRef)boundleString, NO);
    NSLog(@"%d",result);
    dlclose(sbServices);
}

+(UIImage *)getAppIcon:(NSString *)bundleID{
    NSData* (*SBSCopyIconImagePNGDataForDisplayIdentifier)(NSString * bundleid) =
    dlsym(sbserv, "SBSCopyIconImagePNGDataForDisplayIdentifier");
    UIImage *icon = nil;
    NSData *iconData = SBSCopyIconImagePNGDataForDisplayIdentifier(bundleID);
    if (iconData != nil) {
        icon = [UIImage imageWithData:iconData];
    }
    return icon;
}

+(NSString *)getAppName:(NSString *)bundleID
{
    NSString * (*SBSCopyLocalizedApplicationNameForDisplayIdentifier)(NSString* bundleID) =   dlsym(sbserv, "SBSCopyLocalizedApplicationNameForDisplayIdentifier");
    
    NSString *strAppName = SBSCopyLocalizedApplicationNameForDisplayIdentifier(bundleID);
    
    return strAppName;
}

+(NSString *)imsi{
    #if !TARGET_IPHONE_SIMULATOR
        void *kit = dlopen(PRIVATE_PATH,RTLD_LAZY);
        NSString *imsi = nil;
        int (*CTSIMSupportCopyMobileSubscriberIdentity)() = dlsym(kit, "CTSIMSupportCopyMobileSubscriberIdentity");
        imsi = [NSString stringWithFormat:@"%d",CTSIMSupportCopyMobileSubscriberIdentity(nil)];
        dlclose(kit);
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"IMSI"
                                                        message:imsi
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        return imsi;
    #endif
}

+ (void) setAirplaneMode: (BOOL)status;
{
    mach_port_t *thePort;
    void *uikit = dlopen(UIKITPATH, RTLD_LAZY);
    int (*SBSSpringBoardServerPort)() = dlsym(uikit, "SBSSpringBoardServerPort");
    thePort = (mach_port_t *)SBSSpringBoardServerPort();
    dlclose(uikit);
    
    // Link to SBSetAirplaneModeEnabled
    void *sbserv = dlopen(SBSERVPATH, RTLD_LAZY);
    int (*setAPMode)(mach_port_t* port, BOOL status) = dlsym(sbserv, "SBSetAirplaneModeEnabled");
    
    if (setAPMode) {
        setAPMode(thePort, status);
    }
    
    dlclose(sbserv);
}

@end
