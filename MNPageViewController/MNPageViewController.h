//
//  MNPageViewController.h
//  MNPageViewController
//
//  Created by Min Kim on 7/22/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNPageViewControllerDelegate;
@protocol MNPageViewControllerDataSource;

@interface MNPageViewController : UIViewController

@property(nonatomic,readonly) UIScrollView *scrollView;

@property(nonatomic) UIViewController *viewController;

@property(nonatomic,weak) id <MNPageViewControllerDataSource> dataSource;
@property(nonatomic,weak) id <MNPageViewControllerDelegate>   delegate;

@end

@protocol MNPageViewControllerDataSource <NSObject>

@required

// View controllers coming 'before' would be to the left of the argument view controller, those coming 'after' would be to the right.
// Return 'nil' to indicate that no more progress can be made in the given direction.
- (UIViewController *)mn_pageViewController:(MNPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController;

- (UIViewController *)mn_pageViewController:(MNPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController;

@end

@protocol MNPageViewControllerDelegate <NSObject>

@optional

- (void)mn_pageViewController:(MNPageViewController *)pageViewController didPageToViewController:(UIViewController *)viewController;

- (void)mn_pageViewController:(MNPageViewController *)pageViewController didScrollViewController:(UIViewController *)viewController withRatio:(CGFloat)ratio;

@end