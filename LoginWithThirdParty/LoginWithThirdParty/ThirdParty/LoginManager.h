//
//  LoginManager.h
//  LoginWithThirdParty
//
//  Created by bruce on 15/8/25.
//  Copyright (c) 2015年 bruce. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface LoginManager : NSObject

+ (LoginManager *)shareInstance;

- (void)initConfig;

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;


@end
