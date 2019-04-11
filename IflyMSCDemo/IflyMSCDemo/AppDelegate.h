//
//  AppDelegate.h
//  IflyMSCDemo
//
//  Created by 刘功武 on 2019/4/11.
//  Copyright © 2019年 刘功武. All rights reserved.
//

#import <UIKit/UIKit.h>

#define screenHeight    ([UIScreen mainScreen].bounds.size.height)
#define screenWidth     ([UIScreen mainScreen].bounds.size.width)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (AppDelegate *)sharedInstaceAppDelegate;

/**当前控制器*/
- (UIViewController *)currentViewController;
@end

