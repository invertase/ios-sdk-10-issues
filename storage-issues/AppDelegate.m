//
//  AppDelegate.m
//  storage-issues
//
//  Created by Russell Wheatley on 18/10/2022.
//

#import "AppDelegate.h"
@import FirebaseCore;
@import FirebaseStorage;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [FIRApp configure];
  FIRStorage *storage = [FIRStorage storage];

  [storage useEmulatorWithHost:@"localhost" port:9199];
  self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];


  UIViewController *controller = [[UIViewController alloc] initWithNibName:@"StorageView" bundle:nil];

  
  self.window.rootViewController = controller;
  [self.window makeKeyAndVisible];

  return YES;
}

#pragma mark - UISceneSession lifecycle

- (UISceneConfiguration *)application:(UIApplication *)application
    configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                                   options:(UISceneConnectionOptions *)options {
  // Called when a new scene session is being created.
  // Use this method to select a configuration to create the new scene with.
  return [[UISceneConfiguration alloc] initWithName:@"Default Configuration"
                                        sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application
    didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
  // Called when the user discards a scene session.
  // If any sessions were discarded while the application was not running, this will be called
  // shortly after application:didFinishLaunchingWithOptions. Use this method to release any
  // resources that were specific to the discarded scenes, as they will not return.
}

@end
