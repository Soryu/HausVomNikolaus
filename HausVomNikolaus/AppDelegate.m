//
//  AppDelegate.m
//  HausVomNikolaus
//
//  Created by Stanley Rost on 05.09.14.
//  Copyright (c) 2014 Stanley Rost.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  self.window.rootViewController = [ViewController new];
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  return YES;
}

@end
