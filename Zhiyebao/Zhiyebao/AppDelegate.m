//
//  AppDelegate.m
//  Zhiyebao
//
//  Created by Apple on 14-4-29.
//
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "Macros.h"
#import "CustomMarcos.h"
#import "AFNetworkReachabilityManager.h"
#import "SingleSqlite.h"
#import "SDWebImage/UIImageView+WebCache.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"didFinishLaunchingWithOptions");

    
    //监听有无网络
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    // Create a 4MB in-memory, 32MB disk cache
    NSURLCache *cache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                      diskCapacity:64 * 1024 * 1024
                                                          diskPath:@"URLCache"];
    
    // Set the shared cache to our new instance
    [NSURLCache setSharedURLCache:cache];

    sleep(2.0);

    
    if (IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        //设置导航栏的背景
        UIImage* navigationBarImage = [UIImage imageNamed:@"ios7tabbarImage.png"];
        [[UINavigationBar appearance] setBackgroundImage:navigationBarImage
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearance] setShadowImage:[UIImage imageNamed:@"Transparent.png"]];
    } else {
        UIImage* barBackImage = [UIImage imageNamed:@"ios6tabbarImage.png"];
        [[UINavigationBar appearance] setBackgroundImage:barBackImage
                                           forBarMetrics:UIBarMetricsDefault];
    }
    
    //设置navigationbar上的字体颜色和大小
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                          [UIColor whiteColor], UITextAttributeTextColor,
//                                 
//                                                          [UIFont systemFontOfSize:20.0], UITextAttributeFont, nil]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    
    
    //判断是不是第一次进入欢迎页面参数设置
    NSDictionary* dictionary = @{IS_FIRST_ENTER_HOME_VC: @0,@"createMySqlite":@0};
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionary];

    [[NSUserDefaults standardUserDefaults]setBool:0 forKey:@"createMySqlite"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"createMySqlite"]) {
        
        SingleSqlite* sqlite = [SingleSqlite shareSingleSqlite];
        BOOL success  = [sqlite createSqlite];
        NSLog(@"success = %d",success);
        [[NSUserDefaults standardUserDefaults]setBool:1 forKey:@"createMySqlite"];
        [[NSUserDefaults standardUserDefaults] synchronize];
      }
    

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    self.window.rootViewController = [[RootViewController alloc] init];
    
//
    
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[SDImageCache sharedImageCache] clearMemory];
}
@end
