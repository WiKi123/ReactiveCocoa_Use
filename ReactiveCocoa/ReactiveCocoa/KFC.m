//
//  KFC.m
//  coco_use
//
//  Created by koala on 2018/6/7.
//  Copyright © 2018年 koala. All rights reserved.
//

#import "KFC.h"

@implementation KFC

+ (instancetype)kfcWithDic:(NSDictionary *)dic {
    
    KFC *kfc = [[KFC alloc] init];
    kfc.name = [dic objectForKey:@"name"];
    kfc.icon = [dic objectForKey:@"icon"];
    return kfc;
}

@end
