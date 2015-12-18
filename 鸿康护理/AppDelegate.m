//
//  AppDelegate.m
//  鸿康护理
//
//  Created by CaiNiao on 15/10/23.
//  Copyright (c) 2015年 zgcainiao. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMSSDK.h>
#define appKey @"b8f4139cf950"
#define appSecret @"88432c11e2885e7507842922d6f86476"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [SMSSDK registerApp:appKey withSecret:appSecret];
    [self hasImpower];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self hasImpower];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)hasImpower {
    
    [DataService requestURL:[NSString stringWithFormat:@"%@hasImpower",BaseUrl] httpMethod:@"post" timeout:10 params:nil responseSerializer:nil completion:^(id result, NSError *error) {
        
        if (error == nil) {
            
            if (![result[@"err"] isEqualToNumber:@1]) {
                
            }
            else {
                [SVProgressHUD showErrorWithStatus:result[@"msg"]];
                [self performSelector:@selector(crash) withObject:nil afterDelay:.5];
                
            }
        }
        else {
            //            [SVProgressHUD showErrorWithStatus:error.domain];
        }
    }];
}

- (void)crash {
    
    NSArray *arr = @[];
    NSLog(@"%@",arr[5]);
}

@end
