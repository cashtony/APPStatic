//
//  AppDelegate.h
//  APPStatic
//
//  Created by LiuXuan on 2017/2/13.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

