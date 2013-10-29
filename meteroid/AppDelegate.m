//
//  AppDelegate.m
//  meteroid
//
//  Copyright (C) 2013  Gerrit Giehl <r4mp@chaosdorf.de>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize hostname;
@synthesize port;
@synthesize ssl;
@synthesize singleUserMode;
@synthesize isInternet;

- (BOOL) connectedToNetwork{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"google.com"];
    //[self getSettings];
    //Reachability* reachability = [Reachability reachabilityWithHostName:self.hostname];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable) {
        isInternet = NO;
    } else if (remoteHostStatus == ReachableViaWWAN) {
        isInternet = TRUE;
    } else if (remoteHostStatus == ReachableViaWiFi) {
        isInternet = TRUE;
    }
    return isInternet;
}

- (void) getSettings {
    self.hostname = [[NSUserDefaults standardUserDefaults] stringForKey:@"hostname_preference"];
    self.port = [[NSUserDefaults standardUserDefaults] integerForKey:@"port_preference"];
    self.ssl = [[NSUserDefaults standardUserDefaults] boolForKey:@"use_ssl_preference"];
    self.singleUserMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"use_single_user_mode_preference"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set the application defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *appDefaults = [[NSMutableDictionary alloc] init];
    
    [appDefaults setValue:@"mete" forKey:@"hostname_preference"];
    [appDefaults setValue:[NSNumber numberWithInt:80] forKey:@"port_preference"];
    [appDefaults setValue:[NSNumber numberWithBool:NO] forKey:@"use_ssl_preference"];
    [appDefaults setValue:[NSNumber numberWithBool:YES] forKey:@"use_single_user_mode_preference"];
    
    [defaults registerDefaults:appDefaults];
    [defaults synchronize];
    // ---
    
    if((self.hostname == nil) || (self.port == 0) || (self.hostname == nil)) {
        [self getSettings];
    }
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self getSettings];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self getSettings];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
