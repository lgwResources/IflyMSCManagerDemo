//
//  AppDelegate.m
//  IflyMSCDemo
//
//  Created by 刘功武 on 2019/4/11.
//  Copyright © 2019年 刘功武. All rights reserved.
//

#import "AppDelegate.h"
#import "RBIflyMSCManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)sharedInstaceAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

#pragma mark -当前控制器
- (UIViewController *)currentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[RBIflyMSCManager sharedManager] configIflyMSC];
    
    return YES;
}

@end
