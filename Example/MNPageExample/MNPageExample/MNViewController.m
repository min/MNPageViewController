//
//  MNViewController.m
//  MNPageExample
//
//  Created by Min Kim on 7/22/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNViewController.h"

@interface MNViewController ()

@property(nonatomic,strong,readwrite) UIColor *color;
@property(nonatomic,strong,readwrite) UIView  *colorView;

@end

@implementation MNViewController

- (id)initWithColor:(UIColor *)color {
  if (self = [super init]) {
    self.color = color;
  }
  return self;
}

- (void)dealloc {
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.colorView = [[UIView alloc] initWithFrame:self.view.bounds];
  self.colorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
  self.colorView.backgroundColor = self.color;
  
  [self.view addSubview:self.colorView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSString *)description {
  return [self.color description];
}

- (void)setRatio:(CGFloat)ratio {
  CGFloat scale = 1.f - (0.05f - (ratio * 0.05f));
  self.colorView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}

@end
