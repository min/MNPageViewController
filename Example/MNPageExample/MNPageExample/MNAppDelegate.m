//
//  MNAppDelegate.m
//  MNPageExample
//
//  Created by Min Kim on 7/22/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNAppDelegate.h"
#import "MNViewController.h"

@interface MNAppDelegate() <MNPageViewControllerDataSource, MNPageViewControllerDelegate>

@property(nonatomic,strong) NSArray *colors;

@end

@implementation MNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    self.colors = @[UIColor.greenColor, UIColor.blueColor, UIColor.orangeColor, UIColor.purpleColor];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    MNPageViewController *controller = [[MNPageViewController alloc] init];
    controller.viewController = [[MNViewController alloc] initWithColor:self.colors[0] atIndex:0];
    controller.dataSource = self;
    controller.delegate = self;
    
    self.window.rootViewController = controller;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
}

#pragma mark - MNPageViewControllerDataSource

- (UIViewController *)mn_pageViewController:(MNPageViewController *)pageViewController viewControllerBeforeViewController:(MNViewController *)viewController {
    NSUInteger index = [self.colors indexOfObject:viewController.color];
    if (index == NSNotFound || index == 0) {
        return nil;
    }
    return [[MNViewController alloc] initWithColor:self.colors[index - 1] atIndex:index - 1];
}

- (UIViewController *)mn_pageViewController:(MNPageViewController *)pageViewController viewControllerAfterViewController:(MNViewController *)viewController {
    NSUInteger index = [self.colors indexOfObject:viewController.color];
    
    if (index == NSNotFound || index == (self.colors.count - 1)) {
        return nil;
    }
    return [[MNViewController alloc] initWithColor:self.colors[index + 1] atIndex:index + 1];
}

#pragma mark - MNPageViewControllerDelegate

- (void)mn_pageViewController:(MNPageViewController *)pageViewController didScrollViewController:(MNViewController *)viewController withRatio:(CGFloat)ratio {
    [viewController setRatio:ratio];
}

@end
