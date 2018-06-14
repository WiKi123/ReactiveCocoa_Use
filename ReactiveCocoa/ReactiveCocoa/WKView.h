//
//  WKView.h
//  coco_use
//
//  Created by koala on 2018/6/6.
//  Copyright © 2018年 koala. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

@interface WKView : UIView

@property (nonatomic, strong) RACSubject *clickSignal;

@end
