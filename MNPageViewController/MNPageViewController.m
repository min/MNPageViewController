//
//  MNPageViewController.m
//  MNPageViewController
//
//  Created by Min Kim on 7/22/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNPageViewController.h"
#import "MNQueuingScrollView.h"

@interface MNPageViewController() <MNQueuingScrollViewDelegate>

@property (nonatomic,strong,readwrite) UIScrollView *scrollView;

@property (nonatomic,assign,getter = hasInitialized)  BOOL initialized;
@property (nonatomic,assign,getter = isRotating)      BOOL rotating;

@property (nonatomic,assign) CGFloat leftInset;
@property (nonatomic,assign) CGFloat rightInset;

@property (nonatomic,strong,readwrite) UIViewController *beforeController;
@property (nonatomic,strong,readwrite) UIViewController *afterController;

- (void)initializeChildControllers;
- (void)didPage;

@end

@implementation MNPageViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  CGRect bounds = self.view.bounds;
  
  MNQueuingScrollView *scrollView = [[MNQueuingScrollView alloc] initWithFrame:bounds];
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.alwaysBounceHorizontal = YES;
  scrollView.contentSize = CGSizeMake(bounds.size.width * 3, bounds.size.height);
  scrollView.pagingEnabled = YES;
  scrollView.delegate = self;
  scrollView.contentOffset = CGPointMake(bounds.size.width, 0.f);
  scrollView.scrollsToTop = NO;
  self.scrollView = scrollView;
  
  [self.view addSubview:self.scrollView];
  
  self.initialized = NO;
  
  if (self.viewController) {
    CGRect bounds = self.view.bounds;
    bounds.origin.x = bounds.size.width;
    
    self.viewController.view.frame = bounds;
    [self addChildViewController:self.viewController];
    [self.scrollView addSubview:self.viewController.view];
    [self.viewController didMoveToParentViewController:self];
    
    self.leftInset  = 0.f;
    self.rightInset = 0.f;
    self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
    self.scrollView.contentOffset = CGPointMake(bounds.size.width, 0.f);
  }

  [self initializeChildControllers];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  
  CGRect bounds = self.view.bounds;
  
  self.scrollView.frame = bounds;
  self.scrollView.contentSize = CGSizeMake(bounds.size.width * 3.f, bounds.size.height);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  
  self.rotating = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
  
  CGRect bounds = self.view.bounds;
  
  self.scrollView.contentOffset = CGPointMake(bounds.size.width, 0.f);
  
  if (self.beforeController) {
    self.leftInset = 0.f;
    self.beforeController.view.frame = self.view.bounds;
  } else {
    self.leftInset = -bounds.size.width;
  }
  if (self.afterController) {
    self.rightInset = 0.f;
    self.afterController.view.frame = CGRectMake(bounds.size.width * 2.f, 0.f, bounds.size.width, bounds.size.height);
  } else {
    self.rightInset = -bounds.size.width;
  }
  
  bounds.origin.x = bounds.size.width;
  self.viewController.view.frame = bounds;

  self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
  [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
  
  self.rotating = NO;
}

#pragma mark - Private

- (void)initializeChildControllers {
  CGRect bounds = self.scrollView.bounds;
  
  self.beforeController =
  [self.dataSource mn_pageViewController:self
      viewControllerBeforeViewController:self.viewController];
  
  self.afterController =
  [self.dataSource mn_pageViewController:self
       viewControllerAfterViewController:self.viewController];
  
  if (self.beforeController) {
    CGRect beforeFrame = self.scrollView.bounds;
    beforeFrame.origin.x = 0.f;

    self.beforeController.view.frame = beforeFrame;
    [self addChildViewController:self.beforeController];
    [self.scrollView addSubview:self.beforeController.view];
    [self.beforeController didMoveToParentViewController:self];
  } else {
    self.leftInset = -bounds.size.width;
  }
  if (self.afterController) {
    CGRect afterFrame = self.scrollView.bounds;
    afterFrame.origin.x = afterFrame.size.width * 2.f;
    
    self.afterController.view.frame = afterFrame;
    [self addChildViewController:self.afterController];
    [self.scrollView addSubview:self.afterController.view];
    [self.afterController didMoveToParentViewController:self];
  } else {
    self.rightInset = -bounds.size.width;
  }
  
  self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
  self.initialized = YES;
}

- (void)didPage {
  UIViewController *visibleController = nil;
  for (UIViewController *controller in self.childViewControllers) {
    CGPoint point = [self.scrollView convertPoint:controller.view.frame.origin toView:self.view];
    
    if (point.x == 0.f) {
      visibleController = controller;
    }
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(mn_pageViewController:didPageToViewController:)]) {
    [self.delegate mn_pageViewController:self didPageToViewController:visibleController];
  }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (self.isRotating) {
    return;
  }
  if (!self.hasInitialized && self.scrollView.superview) {
    [self initializeChildControllers];

    self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
  } else {
    if (scrollView.tracking && scrollView.dragging) {
      self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
    }
  }
  
  CGRect bounds = self.scrollView.bounds;
  
  if (scrollView.contentOffset.x == bounds.size.width) {
    return;
  }
  
  if (CGRectIsEmpty(bounds)) {
    return;
  }
  UIViewController *controller =
  scrollView.contentOffset.x > bounds.size.width ? self.afterController : self.beforeController;
  
  CGFloat ratio = fabs((scrollView.contentOffset.x - bounds.size.width) / bounds.size.width);
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(mn_pageViewController:willPageToViewController:withRatio:)]) {
    [self.delegate mn_pageViewController:self willPageToViewController:controller withRatio:MIN(ratio, 1.f)];
  }
  
  if (self.delegate && [self.delegate respondsToSelector:@selector(mn_pageViewController:willPageFromViewController:withRatio:)]) {
    [self.delegate mn_pageViewController:self willPageFromViewController:self.viewController withRatio:MAX(1.f - ratio, 0.f)];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  if (self.isRotating) {
    return;
  }
  self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);

  for (UIViewController *controller in self.childViewControllers) {
    if (controller == self.viewController) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(mn_pageViewController:willPageToViewController:withRatio:)]) {
        [self.delegate mn_pageViewController:self willPageToViewController:controller withRatio:1.f];
      }
    } else {
      if (self.delegate && [self.delegate respondsToSelector:@selector(mn_pageViewController:willPageFromViewController:withRatio:)]) {
        [self.delegate mn_pageViewController:self willPageFromViewController:self.viewController withRatio:1.f];
      }
    }
  }
}

#pragma mark - MNQueuingScrollViewDelegate

- (void)queuingScrollViewDidPageForward:(UIScrollView *)scrollView {
  UIViewController *nextViewController = nil;

  CGRect frame;
  CGRect scrollBounds = self.scrollView.bounds;
  
  for (UIViewController *controller in self.childViewControllers) {
    frame = controller.view.frame;
    frame.origin.x -= scrollView.bounds.size.width;
    
    controller.view.frame = frame;
    
    if (frame.origin.x == scrollView.bounds.size.width) {
      nextViewController = controller;
    } else if (controller.view.frame.origin.x < 0.f) {
      [controller willMoveToParentViewController:nil];
      [controller.view removeFromSuperview];
      [controller removeFromParentViewController];
    }
  }
  
  self.afterController =
    [self.dataSource mn_pageViewController:self
         viewControllerAfterViewController:nextViewController];
  
  self.beforeController = self.viewController;
  
  self.leftInset = 0.f;
  if (self.afterController) {
    CGRect afterFrame = scrollBounds;
    afterFrame.origin.x = afterFrame.size.width * 2.f;
    
    self.beforeController = self.viewController;
    
    [self addChildViewController:self.afterController];
    [self.scrollView addSubview:self.afterController.view];
    self.afterController.view.frame = afterFrame;
    [self.afterController didMoveToParentViewController:self];
    self.rightInset = 0.f;
  } else {
    self.rightInset = -scrollBounds.size.width;
  }
  
  self.viewController = nextViewController;
  
  if (!scrollView.decelerating) {
    self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
  }

  [self didPage];
}

- (void)queuingScrollViewDidPageBackward:(UIScrollView *)scrollView {
  UIViewController *nextViewController = nil;
  
  CGRect frame;
  CGRect scrollBounds = scrollView.bounds;
  
  for (UIViewController *controller in self.childViewControllers) {
    frame = controller.view.frame;
    frame.origin.x += scrollBounds.size.width;
    controller.view.frame = frame;
    
    if (frame.origin.x == scrollBounds.size.width) {
      nextViewController = controller;
    }
    
    if (frame.origin.x > (scrollBounds.size.width * 2.f)) {
      [controller willMoveToParentViewController:nil];
      [controller.view removeFromSuperview];
      [controller removeFromParentViewController];
    }
  }
  
  self.beforeController = [self.dataSource mn_pageViewController:self viewControllerBeforeViewController:nextViewController];
  self.afterController = self.viewController;
  
  self.rightInset = 0.f;
  self.leftInset  = 0.f;
  
  if (self.beforeController) {
    CGRect beforeFrame = scrollView.bounds;
    beforeFrame.origin.x = 0.f;
    
    [self addChildViewController:self.beforeController];
    self.beforeController.view.frame = beforeFrame;
    [self.scrollView addSubview:self.beforeController.view];
    [self.beforeController didMoveToParentViewController:self];
  } else {
    self.leftInset = -scrollBounds.size.width;
  }
  
  self.viewController = nextViewController;
  
  if (!scrollView.decelerating) {
    self.scrollView.contentInset = UIEdgeInsetsMake(0.f, self.leftInset, 0.f, self.rightInset);
  }

  [self didPage];
}

@end
