//
//  appModel.h
//  APPStatic
//
//  Created by LiuXuan on 2017/2/13.
//  Copyright © 2017年 Xuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject
@property(nonatomic,strong)id model;

@property(nonatomic,strong)NSString *appName;
@property(nonatomic,strong)NSString *appVersion;
@property(nonatomic,strong)NSString *appBundelID;
@property(nonatomic,strong)NSString *appImageurl;
@property(nonatomic,strong)UIImage  *iconImage;


-(id)initWithModel:(id)model;
@end
