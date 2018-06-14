//
//  WKView.m
//  coco_use
//
//  Created by koala on 2018/6/6.
//  Copyright © 2018年 koala. All rights reserved.
//

#import "WKView.h"

@implementation WKView


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self wkload];
    }
    return self;
}

- (void)wkload{
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.borderWidth = 0.5f;
    btn.frame = self.bounds;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    
}

- (void)click:(id)sender {
    
    [self.clickSignal sendNext:@"我被点击了，哎呀~"];
    
    self.frame = CGRectMake(0, 0, 120, 120);
    
}

- (RACSubject *)clickSignal {
    
    if (_clickSignal == nil) {
        _clickSignal = [[RACSubject alloc] init];
    }
    return _clickSignal;
}


@end
