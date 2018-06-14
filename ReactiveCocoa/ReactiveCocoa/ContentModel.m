//
//  ContentModel.m
//  ReactiveCocoa_Use
//
//  Created by koala on 2018/6/13.
//  Copyright © 2018年 koala. All rights reserved.
//

#import "ContentModel.h"

@implementation ContentModel

- (NSArray *)headNameArray {
    
    if (_headNameArray == nil) {
        _headNameArray = @[@"信号的基本使用",@"RACCommand",@"信号的值操作",@"信号的数量操作",@"信号的时间操作", @"组合信号的操作",@"降阶操作"];
    }
    return _headNameArray;
}

- (NSArray *)demoArray{
    
    if (_demoArray == nil) {
        _demoArray = @[
                       //信号的基本使用
                       @[@"RACSignal",
                         @"RACSubject",
                         @"rac_signalForSelector",
                         @"rac_observeKeyPath",
                         @"rac_signalForControlEvents",
                         @"rac_addObserverForName",
                         @"rac_textSignal",
                         @"RACTupe",
                         @"RACSequence",
                         @"RACSequence_jsonToModel",
                         @"RACSignal_interval_replace_timer",
                         @"RACMulticastConnection",
                         @"rac_liftSelector",
                         @"RAC_Macro"],
                       //RACCommand
                       @[ @"RACCommand_Demo1",
                          @"RACCommand_Demo2",
                          @"RACCommand_executing"],
                       //信号的值操作
                       @[@"RACSignal_bind",
                         @"RACSignal_map",
                         @"RACSignal_flattenMap_DEMO1",
                         @"RACSignal_flattenMap_DEMO2",
                         @"RACSignal_distinctUntilChanged",
                         @"RACSignal_ReduceEach",
                         @"RACSignal_scan"],
                       //信号的数量操作
                       @[@"RACSubject_filter",
                         @"RACSignal_ignore",
                         @"RACSignal_take",
                         @"RACSignal_skip",
                         @"RACSignal_startWith",
                         @"RACSignal_repeat",
                         @"RACSignal_retry",
                         @"RACSignal_collect"
                         ,@"RACSignal_aggregate"],
                       //信号的时间操作
                       @[@"RACSignal_delay",
                         @"RACSubject_throttle"],
                       //组合信号的操作
                       @[@"RACSignal_concat",
                         @"RACSignal_merge",
                         @"RACSignal_zip",
                         @"RACSignal_combineLatest",
                         @"RACSignal_sample",
                         @"RACSignal_takeUntil",
                         @"RACSignal_takeUntilReplacement",
                         @"RACSignal_then"],
                       //降阶操作
                       @[@"RACSubject_switchToLatest",
                         @"ifThenElse",
                         @"RACSignal_flatten"]
                       
                       ];
    }
    return _demoArray;
}


- (NSDictionary *)describeDict {
    
    if (_describeDict == nil) {
        
        _describeDict = @{
                          //信号的基本使用
                          @"RACSignal":@"RACSteam的子类，基于时间的数据流，在时间上是离散的",
                          @"RACSubject":@"继承RACSignal，实现RACSubscriber协议。\n自己可以当信号，又能够发送信号",
                          @"rac_signalForSelector":@"信号获取之Cocoa桥接。\n监听方法的调用",
                          @"rac_observeKeyPath":@"信号获取之Cocoa桥接。\nKVO的RAC实现",
                          @"rac_signalForControlEvents":@"信号获取之Cocoa桥接。\n手势监听方法的RAC实现",
                          @"rac_addObserverForName":@"信号获取之Cocoa桥接。\nNSNotificationCenter的RAC实现",
                          @"rac_textSignal":@"信号获取之Cocoa桥接。\n编辑时获取文本内容",
                          @"RACTupe":@"元祖",
                          @"RACSequence":@"RACSteam的子类。基于空间的数据流，在时间上是连续的。\n可以快速的遍历,用来代替array，dic",
                          @"RACSequence_jsonToModel":@"使用RACSequence进行字典转模型",
                          @"RACSignal_interval_replace_timer":@"类似于NSTimer的实现",
                          @"RACMulticastConnection":@"多次订阅，单次执行。",
                          @"rac_liftSelector":@"信号1和2都执行完毕，实现方法sel",
                          @"RAC_Macro":@"RAC中的一些宏",
                          //RACCommand
                          @"RACCommand_Demo1":@"创建命令，执行命令",
                          @"RACCommand_Demo2":@"创建命令，执行命令",
                          @"RACCommand_executing":@"监听信号的执行状态",
                          //信号的值操作
                          @"RACSignal_bind":@"信号转发",
                          @"RACSignal_map":@"值操作 - Map(映射)。数据再处理",
                          @"RACSignal_flattenMap_DEMO1":@"信号发送信号",
                          @"RACSignal_flattenMap_DEMO2":@"信号发送信号",
                          @"RACSignal_distinctUntilChanged":@"忽略重复数据。数据不同才会接收到数据",
                          @"RACSignal_ReduceEach":@"值操作 - ReduceEach。信号a发送内容为元祖",
                          @"RACSignal_scan":@"值操作 - Scan。返回以往所有数据相加 和 即将发送的数据 的处理结果",
                          //信号的数量操作
                          @"RACSubject_filter":@"数量操作 - Filter。当满足的时候，才会接收到数据",
                          @"RACSignal_ignore":@"数量操作 - Ignore(忽略)。忽略信号发送的某个数据",
                          @"RACSignal_take":@"数量操作 - Take。获取前几次发送的数据",
                          @"RACSignal_skip":@"数量操作 - Skip。忽略掉前几个数据",
                          @"RACSignal_startWith":@"数量操作 - StartWith。在开始前添加数据",
                          @"RACSignal_repeat":@"数量操作 - Repeat。重复信号a发送数据",
                          @"RACSignal_retry":@"数量操作 - Retry。失败就一直重复，可以设置重复次数",
                          @"RACSignal_collect":@"数量操作 - Collect。收集信号a所有发出的数据，作为信号b的数据",
                          @"RACSignal_aggregate":@"数量操作 - Aggregate。信号a所有发出的数据最后汇总为一个数据，信号b发出",
                          //信号的时间操作
                          @"RACSignal_delay":@"时间操作 - Delay。信号发送延迟执行",
                          @"RACSubject_throttle":@"时间操作 - Throttle。做搜索常用此方法",
                          //组合信号的操作
                          @"RACSignal_concat":@"组合操作 - Concat。信号a执行完毕，再执行信号b，对ab的结果都关心",
                          @"RACSignal_merge":@"组合操作 - Merge。多信号同时执行，无序",
                          @"RACSignal_zip":@"组合操作 - Zip（拉链）。信号a，信号b 发送的信号两两一组，内容为元祖返回",
                          @"RACSignal_combineLatest":@"组合操作 - CombineLatest。根据信号ab的返回值作为新的信号返回",
                          @"RACSignal_sample":@"组合操作- Sample。可以理解为边走路边拍照",
                          @"RACSignal_takeUntil":@"组合操作 - TakeUntil。a发送数据直到b开始发送数据",
                          @"RACSignal_takeUntilReplacement":@"组合操作 - takeUntilReplacement。a发送数据直到b发送完数据",
                          @"RACSignal_then":@"组合操作 - Then。信号a执行完毕，再执行信号b，对a的结果不关心",
                          //降阶操作
                          @"RACSubject_switchToLatest":@"降阶操作 - switchToLatest。多个信号，执行最新的信号",
                          @"ifThenElse":@"降阶操作 - if/then/else。满足信号a,执行信号b否则执行信号c",
                          @"RACSignal_flatten":@"降阶操作 - Flatten。把多维信号变为线性信号。"
                          };
    }
    return _describeDict;
    
}


- (NSDictionary *)picUrlDict {
    
    if (_picUrlDict == nil) {
        
        _picUrlDict = @{
                        @"RACSignal_map":@[@"https://upload-images.jianshu.io/upload_images/2779714-85daa15c14d6224e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/2779714-a76b2df787e408ad.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_ReduceEach":@[@"(https://upload-images.jianshu.io/upload_images/2779714-063b75af12dc8caa.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_scan":@[@"https://upload-images.jianshu.io/upload_images/2779714-601f42a99fe57f78.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSubject_filter":@[@"https://upload-images.jianshu.io/upload_images/2779714-1afc00c37f4f2eb9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_take":@[@"https://upload-images.jianshu.io/upload_images/2779714-2d7f04614d3a8404.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_skip":@[@"https://upload-images.jianshu.io/upload_images/2779714-3892d2b4d2a37fca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_startWith":@[@"https://upload-images.jianshu.io/upload_images/2779714-7913a8af98bd41f3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_repeat":@[@"https://upload-images.jianshu.io/upload_images/2779714-9ec2b2558727da67.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_retry":@[@"https://upload-images.jianshu.io/upload_images/2779714-61684e77e5e00840.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_collect":@[@"https://upload-images.jianshu.io/upload_images/2779714-2e8a768f553c05cf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_aggregate":@[@"https://upload-images.jianshu.io/upload_images/2779714-158e4e2ec1807679.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_delay":@[@"https://upload-images.jianshu.io/upload_images/2779714-9edbc8d156f137bd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSubject_throttle":@[@"https://upload-images.jianshu.io/upload_images/2779714-663fb938f3a856b6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        
                        @"RACSignal_concat":@[@"https://upload-images.jianshu.io/upload_images/2779714-ca8a9d7aa6eac7dd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/2779714-b32cae772e8d219f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/2779714-b0788a89e3079bf9.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_merge":@[@"https://upload-images.jianshu.io/upload_images/2779714-8fb509cb31e1bf77.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_zip":@[@"https://upload-images.jianshu.io/upload_images/2779714-1bcf6ad420249325.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        
                        @"RACSignal_combineLatest":@[@"https://upload-images.jianshu.io/upload_images/2779714-7881b24722707bf0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/2779714-1b33002787c216d1.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/2779714-15c9517069dae75b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_takeUntil":@[@"https://upload-images.jianshu.io/upload_images/2779714-723670e282ded65c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_takeUntilReplacement":@[@"https://upload-images.jianshu.io/upload_images/2779714-73403ffc9868402d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSubject_switchToLatest":@[@"https://upload-images.jianshu.io/upload_images/2779714-6c10775a71b310a3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/2779714-c94eec438136c28d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"if/then/else":@[@"https://upload-images.jianshu.io/upload_images/2779714-ee23e1960857b9f2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        @"RACSignal_flatten":@[@"https://upload-images.jianshu.io/upload_images/2779714-f2312ce65c45d5fe.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240",@"https://upload-images.jianshu.io/upload_images/2779714-d3b1c480ea157ecc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240"],
                        };
        
        
    }
    return _picUrlDict;
    
}

@end
