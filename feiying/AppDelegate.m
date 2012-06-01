//
//  AppDelegate.m
//  feiying
//
//  Created by  on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "./customComponents/tabTabController.h"

#import "userAccountSettingViewController.h"

#import "./customComponents/tabViewNavigationController.h"
#import "./appViews/shareTabViewController.h"
#import "./appViews/favTabViewController.h"
#import "./appViews/homeTabViewController.h"
#import "./appViews/channelTabViewController.h"
#import "./appViews/moreTabViewController.h"

#import "./common/UserManager.h"
#import "./util/commonUtil.h"

#import "./openSource/ASIHTTPRequest/Reachability/Reachability.h"
#import "./openSource/Toast/iToast.h"
#import "./openSource/MediaPlayer/feiyingVideoPlayerViewController.h"

@implementation AppDelegate

// private methods
// called by network reachability whenever status changes.
-(void) netWorkReachabilityChanged:(NSNotification* ) pNSNotification{
    //NSLog(@"AppDelegate - netWorkReachabilityChanged - notification = %@", pNSNotification);
    
    // get currently network reachability object
	Reachability *_curReach = [pNSNotification object];
	NSParameterAssert([_curReach isKindOfClass: [Reachability class]]);
	
    // get network status and init net status string
    NetworkStatus _netStatus = [_curReach currentReachabilityStatus];
    NSString *_statusString= @"";
    switch (_netStatus){
        case NotReachable:
            _statusString = @"您的网络暂不可用";
            break;
            
        case ReachableViaWWAN:
            // if user cann't open feiying business and is watching video
            if([[[UserManager shareSingleton] userBean] businessState] == unopened && [feiyingVideoPlayerViewController videoIsPlaying]) {
                // notify feiyingVideoPlayer
                [[feiyingVideoPlayerViewController getFeiyingVideoPlayerRef] show3GWatchVideoAlertView:watching];
                
                // return immediately
                return;
            }
            // if user cann't open feiying business
            else if([[[UserManager shareSingleton] userBean] businessState] == unopened) {
                _statusString = @"您目前处于3G网络, 继续浏览会产生3G流量,流量费将由当地运营商收取";
            }
            else {
                _statusString = @"您目前处于3G网络";
            }
            break;
        case ReachableViaWiFi:
            // if user is watching video
            if ([feiyingVideoPlayerViewController videoIsPlaying]) {
                // return immediately
                return;
            }
            else {
                _statusString= @"您目前处于WiFi网络";
            }
            break;
    }
    
    // set currently network status toast tip
    iToast *_toast = [iToast makeText:_statusString];
    [_toast setDuration:iToastDurationNormal];
    [_toast setGravity:iToastGravityCenter];
    [_toast show];
}

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    // get user default setting
    NSUserDefaults *_userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL _isAutoLogin = ((NSNumber*)[_userDefaults objectForKey:@"autoLogin"]).boolValue;
    NSString *_loginName = [_userDefaults objectForKey:@"loginName"];
    NSString *_loginUserKey = [_userDefaults objectForKey:@"loginUserKey"];
    NSString *_loginPwd = [_userDefaults objectForKey:@"loginPwd"];
    feiyingBusinessState _businessState = ((NSNumber*)[_userDefaults objectForKey:@"businessState"]).intValue;
    NSLog(@"application - didFinishLaunchingWithOptions - auto login flag = %d, login name = %@, userKey = %@, login pwd = %@ and feiying business state = %d", _isAutoLogin, _loginName, _loginUserKey, _loginPwd, _businessState);
    // auto login
    if(_isAutoLogin){
        // add user bean
        if(_loginPwd){
            [[UserManager shareSingleton] setUser:_loginName andPwd:_loginPwd];
        }
        else{
            [[UserManager shareSingleton] setUser:_loginName andUserKey:_loginUserKey andBusinessOpened:_businessState];
        }
    }
    
    // globle variables init
    // sms ui init
    if([MFMessageComposeViewController canSendText]){
        gMsgViewController = [[MFMessageComposeViewController alloc] init];
    }
    // get getAllContactsInAddressBook
    gPhoneNameDic = [NSMutableDictionary dictionaryWithDictionary:[commonUtil getAllContactsPhoneNameDictionary]];
    // init application global image cache dictionary
    gImageCacheDic = [[NSMutableDictionary alloc] init];
    
    // Observe the kNetworkReachabilityChangedNotification. When that notification is posted, the
    // method "netWorkReachabilityChanged" will be called. 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netWorkReachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    // create, init internet connection and start notifier
    [[Reachability reachabilityForInternetConnection] startNotifier];
        
    // tabItems view setting
    //UIViewController *_feilaiViewController = [[feilaiTabTableViewController alloc] init];
    UINavigationController *_shareTabViewController = [[tabViewNavigationController alloc] initWithRootViewController:[[shareTabViewController alloc] init]];
    //UIViewController *_feiquViewController = [[feiquTabTableViewController alloc] init];
    UINavigationController *_favTabViewController = [[tabViewNavigationController alloc] initWithRootViewController:[[favTabViewController alloc] init]];
    //UIViewController *_homeViewController = [[homeTabTableViewController alloc] init];
    UINavigationController *_homeTabViewController = [[tabViewNavigationController alloc] initWithRootViewController:[[homeTabViewController alloc] init]];
    //UIViewController *_channelViewController = [[channelTabTableViewController alloc] init];
    UINavigationController *_channelTabViewController = [[tabViewNavigationController alloc] initWithRootViewController:[[channelTabViewController alloc] init]];
    //UIViewController *_elseTabTableViewController = [[elseTabTableViewController alloc] init];
    UINavigationController *_moreTabViewController = [[tabViewNavigationController alloc] initWithRootViewController:[[moreTabViewController alloc] init]];
    
    // create and init tabBar controller
    self.tabBarController = [[tabTabController alloc] init];   
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:_shareTabViewController, _favTabViewController, _homeTabViewController, _channelTabViewController, _moreTabViewController, nil];
    [self.tabBarController setSelectedIndex:2];
    
    // set window rootView controller
    // old
    //self.window.rootViewController = self.tabBarController;
    // new, first need to set account
    // create and init user account setting view controller
    userAccountSettingViewController *_userAccountSettingViewController = [[userAccountSettingViewController alloc] initWithAppStarted];
    // set user register and login delegate
    _userAccountSettingViewController.userRegLoginDelegate = self;
    self.window.rootViewController = (_isAutoLogin) ? self.tabBarController : [[tabViewNavigationController alloc] initWithRootViewController:_userAccountSettingViewController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    // remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:kReachabilityChangedNotification];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"feiying" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"feiying.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

// userLoginDelegate methods implemetation
// user login succeed
-(void) userLoginSucceed{
    NSLog(@"userLoginSucceed - self = %@", self);
    
    // update single window root view controller
    self.window.rootViewController = self.tabBarController;
}

@end
