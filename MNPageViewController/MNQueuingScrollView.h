//
//  MNQueuingScrollView.h
//  MNPageViewController
//
//  Created by Min Kim on 7/22/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MNQueuingScrollViewDelegate<NSObject, UIScrollViewDelegate>

@optional

- (void)queuingScrollViewDidPageForward:(UIScrollView *)scrollView;
- (void)queuingScrollViewDidPageBackward:(UIScrollView *)scrollView;

@end

@interface MNQueuingScrollView : UIScrollView

@property(nonatomic,weak) id <MNQueuingScrollViewDelegate> delegate;

@end
