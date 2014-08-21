//
//  MNViewController.m
//  MNPageExample
//
//  Created by Min Kim on 7/22/13.
//  Copyright (c) 2013 min. All rights reserved.
//

#import "MNViewController.h"

@interface MNColorView : UIView

@property(nonatomic) UILabel *label;

@end

@implementation MNColorView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.label.font = [UIFont systemFontOfSize:144.f];
        self.label.textColor = [UIColor whiteColor];
        self.label.textAlignment = NSTextAlignmentCenter;

        
        [self addSubview:self.label];
    }
    return self;
}

@end

@interface MNViewController ()

@property(nonatomic) UIColor  *color;
@property(nonatomic) MNColorView *colorView;
@property(nonatomic) NSInteger index;

@end

@implementation MNViewController

- (id)initWithColor:(UIColor *)color atIndex:(NSInteger)index {
    if (self = [super init]) {
        self.color = color;
        self.index = index;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.colorView = [[MNColorView alloc] initWithFrame:self.view.bounds];
    self.colorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.colorView.backgroundColor = self.color;
    self.colorView.label.text = @(self.index).stringValue;
    
    [self.view addSubview:self.colorView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (NSString *)description {
    return @(self.index).stringValue;
}

- (void)setRatio:(CGFloat)ratio {
    CGFloat scale = 1.f - (0.05f - (ratio * 0.05f));
    self.colorView.transform = CGAffineTransformScale(CGAffineTransformIdentity, scale, scale);
}

@end
