//
//  MNViewController.h
//  MNPageExample
//
//  Created by Min Kim on 7/22/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNViewController : UIViewController

@property(nonatomic,readonly) UIColor *color;

- (id)initWithColor:(UIColor *)color atIndex:(NSInteger)index;

- (void)setRatio:(CGFloat)ratio;

@end
