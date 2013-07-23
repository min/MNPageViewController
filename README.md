# MNPageViewController

Simple scrolling page view container for UIViewControllers modelled after UIPageViewController. Checkout the example app in Example folder of this repo.

Basic usage:

    #import <MNPageViewController/MNPageViewController.h>
    MNPageViewController *controller = [[MNPageViewController alloc] init];
    controller.viewController = [[UIViewController alloc] init];
  	controller.dataSource = self;
  	controller.delegate = self;

MNPageViewController provides delegate callbacks with a ratio variable from 0.f - 1.f on how far the controller is away from the center of the screen. This allows you to create custom transitions from controller to controller.
		
		- (void)mn_pageViewController:(MNPageViewController *)pageViewController willPageToViewController:(MNViewController *)viewController withRatio:(CGFloat)ratio;
		- (void)mn_pageViewController:(MNPageViewController *)pageViewController willPageFromViewController:(MNViewController *)viewController withRatio:(CGFloat)ratio;


## Installation

1. Add MNPageViewController as a submodule by running the following command from the root of your project

        $ git submodule add git@github.com:min/MNPageViewController.git Vendor/MNPageViewController
    
2. Drag the MNPageViewController.xcodeproj into your project.

3. Add `libMNPageViewController.a` to the Link Binary With Libraries section of you Build Phases

4. `#import <MNPageViewController/MNPageViewController.h>`

