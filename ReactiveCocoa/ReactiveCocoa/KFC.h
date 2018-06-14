//
//  KFC.h
//  coco_use
//
//  Created by koala on 2018/6/7.
//  Copyright © 2018年 koala. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KFC : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *icon;

+ (instancetype)kfcWithDic:(NSDictionary *)dic;

@end
