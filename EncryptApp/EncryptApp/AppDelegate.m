//
//  AppDelegate.m
//  EncryptApp
//
//  Created by ppd-0202000710 on 2019/11/26.
//  Copyright © 2019 FengYang. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    UIStoryboard* s = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    id VC = [s instantiateInitialViewController];
    self.window.rootViewController = VC;
    [self.window makeKeyAndVisible];
    return YES;
}



@end
