//
//  MNQueuingScrollView.m
//  MNPageViewController
//
//  Created by Min Kim on 7/22/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNQueuingScrollView.h"

@implementation MNQueuingScrollView

- (void)layoutSubviews {
  [super layoutSubviews];
  
  CGFloat ratio = self.contentOffset.x / self.frame.size.width;
  
  if (ratio >= 2.f || ratio <= 0.f) {
    CGFloat width = self.frame.size.width;
    CGPoint offset = CGPointMake(width, 0.f);
    
    CGFloat diff = 0.f;
    
    if (ratio > 2.f) {
      diff = ratio - 2.f;
    } else if (ratio < 0.f) {
      diff = ratio - 0.f;
    }

    if (ratio >= 2.f) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(queuingScrollViewDidPageForward:)]) {
        [self.delegate queuingScrollViewDidPageForward:self];
      }
      self.contentOffset = CGPointMake(offset.x * (1 + diff), self.contentOffset.y);
    } else if (ratio <= 0.f) {
      if (self.delegate && [self.delegate respondsToSelector:@selector(queuingScrollViewDidPageBackward:)]) {
        [self.delegate queuingScrollViewDidPageBackward:self];
      }
      self.contentOffset = CGPointMake(offset.x * (1 + diff), self.contentOffset.y);
    }
  }
}

@end
