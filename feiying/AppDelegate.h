//
//  AppDelegate.h
//  feiying
//
//  Created by  on 12-2-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

#import "./delegate/userLoginDelegate.h"

// globle variables
MFMessageComposeViewController *gMsgViewController;
NSMutableDictionary *gPhoneNameDic;
NSMutableDictionary *gImageCacheDic;

@interface AppDelegate : UIResponder <UIApplicationDelegate, userLoginDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
