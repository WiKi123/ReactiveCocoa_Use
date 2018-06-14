//
//  ViewController.m
//  DesignModeDemo
//
//  Created by koala on 2018/4/12.
//  Copyright © 2018年 koala. All rights reserved.
//


#define HEADER_HEIGHT                       ((AFTER_IOS7)?64:44)
#define AFTER_IOS7                          ([[[UIDevice currentDevice] systemVersion] intValue] >= 7)
#define APP_SCREEN_WIDTH                    [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT                   [UIScreen mainScreen].bounds.size.height


#import "ViewController.h"
#import "KFC.h"
#import "WKView.h"
#import "RACViewController.h"

#import "MWPhotoBrowser.h"
#import "ContentModel.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate>

@property (nonatomic,strong) UITableView    *tbView;
@property (nonatomic, strong) UIBarButtonItem *rightItem;
@property (nonatomic, strong) ContentModel *contentModel;

@property (strong, nonatomic) UINavigationController *photoNavigationController;
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;
@property (nonatomic, strong) NSMutableArray *photos;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ReactiveCocoa-DEMO";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tbView];
    
    self.rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"picture"] style:(UIBarButtonItemStyleDone) target:self action:@selector(picClick:)];
    self.navigationItem.rightBarButtonItem = self.rightItem;
    self.rightItem.enabled = NO;
    
    
}

- (void)picClick:(id)sender {
    
    NSIndexPath *indexPath = [self.tbView indexPathForSelectedRow];
    NSString *type = self.contentModel.demoArray[indexPath.section][indexPath.row];
    NSArray *picUrl = [self.contentModel.picUrlDict objectForKey:type];
    
    self.photos = [NSMutableArray array];
    for (NSString *url in picUrl) {
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:url]];
        photo.caption = type;
        [self.photos addObject:photo];
    }
    
    [((UINavigationController *)[[UIApplication sharedApplication] keyWindow].rootViewController) presentViewController:self.photoNavigationController animated:YES completion:^{
        
    }];
    
}

#pragma mark - 信号的基本使用

- (void)RACSignal {
    
    //单元信号
    RACSignal *signal1 = [RACSignal return:@"Some Value"];
    RACSignal *signal2 = [RACSignal error:nil];
    RACSignal *signal3 = [RACSignal empty];
    RACSignal *signal4 = [RACSignal never];
    NSLog(@"%@,%@,%@,%@",signal1,signal2,signal3,signal4);
    
    
    //动态信号
    NSLog(@"1");
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        NSLog(@"2");
        
        [subscriber sendNext:@"qwe"];
        
        //self.subscriber = subscriber;
        
        return [RACDisposable disposableWithBlock:^{
            //只要信号取消订阅就会来这里
            //默认一个信号发送完毕就会取消订阅。只要订阅者在，就不会主动取消订阅
            //清空资源
            NSLog(@"disposableWithBlock");
        }];
        
    }];
    
    NSLog(@"3");
    
    //处理数据，展示UI界面
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"4");
        //X 信号发送的内容
        NSLog(@"%@",x);
        
    }];
    
    NSLog(@"5");
    
    [disposable dispose];
    
    NSLog(@"6");
    
}

- (void)RACSubject {
    
    //RACSubject 信号提供者. 自己可以充当信号，又能够发送信号。
    //继承RACSignal，实现RACSubscriber协议。
    
    RACSubject *subJect = [RACSubject subject];
    
    [subJect subscribeNext:^(id  _Nullable x) {
        NSLog(@"1-%@",x);
    }];
    
    [subJect subscribeNext:^(id  _Nullable x) {
        NSLog(@"2-%@",x);
    }];
    
    [subJect subscribeNext:^(id  _Nullable x) {
        NSLog(@"3-%@",x);
    }];
    
    [subJect sendNext:@"hello"];
    
}

- (void)rac_signalForSelector {
    [self pushWithName:NSStringFromSelector(_cmd)];
}

- (void)rac_observeKeyPath {
    [self pushWithName:NSStringFromSelector(_cmd)];
}

- (void)rac_signalForControlEvents {
    
    [self pushWithName:NSStringFromSelector(_cmd)];
}

- (void)rac_addObserverForName {
    [self pushWithName:NSStringFromSelector(_cmd)];
}

- (void)rac_textSignal {
    [self pushWithName:NSStringFromSelector(_cmd)];
}

- (void)RACTupe {
    
    //元组合
    RACTuple *tuple = [RACTuple tupleWithObjectsFromArray:@[@"aaa",@"bbb",@123]];
    NSString *str = tuple[0];
    NSLog(@"%@",str);
}

- (void)RACSequence {
    
    // RACSequence:用来代替array，dic.可以快速的遍历
    //最常用的应用场景，字典转模型。
    NSArray *arr = @[@"aaa",@"bbbb",@123];
    
    [arr.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"-----%@",x);
    }];
    
    //-----------------------------------------------------------
    
    NSDictionary *dic = @{@"name":@"wiki",@"age":@12};
    
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        RACTupleUnpack(NSString *key ,NSString *value) = x;
        NSLog(@"%@:%@",key,value);
    }];
    
}

- (void)RACSequence_jsonToModel {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"kfc" ofType:@"plist"];
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    
    //nil. 真正的arr保存的数据在block内! 此方法不可取！！
    
    //    NSMutableArray *arr = [NSMutableArray array];
    //
    //    [dictArr.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
    //
    //        KFC *kfc = [KFC kfcWithDic:x];
    //        [arr addObject:kfc];
    //
    //    }];
    //
    //   NSLog(@"%@",arr);
    
    
    //将集合中的所有元素映射成一个新的对象，然后装到新的集合。
    
    RACSequence *mapSequence = [dictArr.rac_sequence map:^id _Nullable(NSDictionary *value) {
        
        return [KFC kfcWithDic:value];
        
    }];
    
    NSArray *arr2 = mapSequence.array;
    NSLog(@"%@",arr2);
    
}

- (void)RACSignal_interval_replace_timer {
    [self pushWithName:NSStringFromSelector(_cmd)];
}

- (void)RACMulticastConnection {
    
    //   RACMulticastConnection 连接类。当一个信号被多次订阅的时候，避免多次调用创建信号中的block。
    
    //多次订阅了同一个信号。网络请求走了两次。
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //发送网络请求
        //发送数据
        NSLog(@"请求到的数据");
        [subscriber sendNext:@"请求到的数据"];
        return nil;
    }];
    
    //不管订阅多少次信号，之请求一次数据。用RACMulticastConnection、必须通过信号创建。
    //将信号转成连接类
    RACMulticastConnection *connection =  [signal publish];
    
    //订阅信号
    [connection.signal subscribeNext:^(id  _Nullable x) {
        //订阅信号
        NSLog(@"aaa : %@",x);
    }];
    
    [connection.signal subscribeNext:^(id  _Nullable x) {
        //订阅信号
        NSLog(@"bbb : %@",x);
    }];
    
    //连接
    [connection connect] ;  //信号只会被订阅一次。多次connect无效。
    
}

- (void)rac_liftSelector {
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //发送请求
        NSLog(@"请求网络数据1");
        //发送数据
        [subscriber sendNext:@"发送数据1"];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        //发送请求
        NSLog(@"请求网络数据2");
        //发送数据
        [subscriber sendNext:@"发送数据2"];
        return nil;
    }];
    
    [self rac_liftSelector:@selector(updateUIWithOne:andTwoData:) withSignalsFromArray:@[signal1,signal2]];
}

- (void)updateUIWithOne:(NSString *)oneData andTwoData:(NSString *)twoData{
    
    NSLog(@"updateUI --> %@ : %@" , oneData ,twoData);
}

- (void)RAC_Macro {
    
    [self pushWithName:NSStringFromSelector(_cmd)];
}

#pragma mark - RACCommand

- (void)RACCommand_Demo1 {
    
    //    RACCommand 命令。
    
    //创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"%@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //发送数据
            [subscriber sendNext:@"执行完命令后产生的数据"];
            return nil;
        }];
        
    }];
    
    //执行命令
    RACSignal *signal =  [command execute:@"输入命令！"] ;
    [signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
}

- (void)RACCommand_Demo2 {
    
    //创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        //        NSLog(@"%@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //发送数据
            [subscriber sendNext:@"数据"];
            return nil;
        }];
        
    }];
    
    //    command.executionSignals 信号源. 俗称：信号中的信号，发送信号的信号。
    
    [command.executionSignals subscribeNext:^(RACSignal  *x) {
        
        NSLog(@"executionSignals :%@",x);  //x is thie signal! <<RACDynamicSignal: 0x60c000030600> name:>
        
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"executionSignals : %@",x);
        }];
        
    }];
    
    
    //switchToLatest 获取最新发送额信号
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"switchToLatest : %@",x);
        
    }];
    
    //执行命令
    [command execute:@"输入命令！"] ;
    
}

- (void)RACCommand_executing {
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    activity.backgroundColor = [UIColor redColor];
    [activity setCenter:CGPointMake(APP_SCREEN_WIDTH/2, APP_SCREEN_HEIGHT/2)];
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];//设置进度轮显示类型
    [self.view addSubview:activity];
    
    
    //监听一个事件的变化，去执行一件事情，执行完毕，告诉我执行完毕，我去做事，例如刷新UI
    
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"%@",input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            //发送数据
            [subscriber sendNext:@"执行完命令后产生的数据"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendCompleted];   //发送完成.sendCompleted必须要写。
            });
            
            return nil;
        }];
        
    }];
    
    
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        
        NSLog(@"%@",x);
        
        if ([x boolValue]) {
            NSLog(@"正在执行");
            [activity startAnimating];
        }else{
            NSLog(@"还没执行 | 执行结束了");
            [activity stopAnimating];
        }
        
    }];
    
    
    RACSignal *signal =  [command execute:@"执行"];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"接受到了数据了 ： %@",x);
    }];
    
}

#pragma mark - 信号的值操作

- (void)RACSignal_bind {
    
    RACSubject *subject = [RACSubject subject];
    
    RACSignal *bindSignal = [subject bind:^RACSignalBindBlock _Nonnull{
        
        return ^RACSignal * (id value , BOOL *stop) {
            
            //            return [RACReturnSignal return:value];
            
            
            //可以对value二次处理，再转发。
            NSString *str = [NSString stringWithFormat:@"修改过原始数据 ： %@",value];
            return [RACReturnSignal return:str];
        };
        
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"发送数据"];
}

- (void)RACSignal_map {
    
    //映射
    RACSubject *subject = [RACSubject subject];
    
    [[subject map:^id _Nullable(id  _Nullable value) {
        
        //直接返回的数据，就是需要处理的数据。
        return [NSString stringWithFormat:@"处理 ： %@",value];
        
    }] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subject sendNext:@"123"];
    [subject sendNext:@"456"];
    
}

- (void)RACSignal_flattenMap_DEMO1 {
    
    //flattenMap 一般用于信号中的信号。
    //信号发送信号。
    //绑定信号的目的，是对信号做层处理，再传送出去。
    //用来包装修改过的内容
    
    //flattenMap内部也是bind
    
    RACSubject *subject =  [RACSubject subject];
    
    RACSignal *signal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        
        value = [NSString stringWithFormat:@"处理：%@",value];
        return [RACReturnSignal return:value];
        
    }];
    
    //RACSubject 继承自RACSignal。
    //使用下面这种方式获取到的是没有处理的value！ 不能这么写！
    
    //    [subject subscribeNext:^(id  _Nullable x) {
    //        NSLog(@"~~~ : %@",x);  // ~~~ : 123 。
    //    }];
    
    //对处理过的信号，进行订阅
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"### : %@",x); // ### : 处理：123
    }];
    
    [subject sendNext:@"123"];
    
}

- (void)RACSignal_flattenMap_DEMO2 {
    
    RACSubject *subject =  [RACSubject subject];
    
    RACSignal *signal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        
        NSLog(@"value is %@",value);    //valus is 123
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            [subscriber sendNext:@"发送信号中的信号"];
            return nil;
        }];
        
    }];
    
    //对处理过的信号，进行订阅
    [signal subscribeNext:^(id signal_x) {
        
        NSLog(@"%@",signal_x);
    }];
    
    [subject sendNext:@"123"];
    
}

- (void)RACSignal_distinctUntilChanged {
    
    RACSubject *subject = [RACSubject subject];
    
    //忽略掉重复数据
    [[subject distinctUntilChanged] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);  //A B A
        
    }];
    
    //网络请求，得到数据A
    [subject sendNext:@"A"];
    
    //警告，如果多次返回，请求结果相同
    [subject sendNext:@"A"];
    [subject sendNext:@"B"];
    [subject sendNext:@"B"];
    [subject sendNext:@"A"];
}

- (void)RACSignal_ReduceEach{
    
    RACTuple *tuple = RACTuplePack(@"1",@"2");
    RACSignal *signal = [RACReturnSignal return:tuple];
    
    
    RACSignal *signal2 = [signal reduceEach:^id(NSString *first, NSString *second){
        
        return [NSString stringWithFormat:@"%@:%@",first,second];
        
    }];
    
    [signal2 subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    
}

- (void)RACSignal_scan {
    
    
    RACSignal *signal = @[@1,@2,@3,@4].rac_sequence.signal;
    
    RACSignal *signal2 = [signal scanWithStart:@0 reduce:^id _Nullable(NSNumber  *running,NSNumber *next) {
        
        return @(running.integerValue + next.integerValue);
    }];
    
    [signal2 subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    
}

#pragma mark - 信号的数量操作

- (void)RACSubject_filter {
    
    [self pushWithName:NSStringFromSelector(_cmd)];
}

- (void)RACSignal_ignore {
    
    RACSubject *subject = [RACSubject subject];
    
    //    RACSignal *ignoreSignal = [subject ignoreValues];
    //    RACSignal *ignoreSignal = [subject ignore:@"1"];
    
    RACSignal *ignoreSignal = [[subject ignore:@"1"] ignore:@"2"];
    
    [ignoreSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"112321"];
}

- (void)RACSignal_take{
    
    //指定拿前几次发送的数据
    RACSubject *subject = [RACSubject subject];
    [[subject take:2] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);  //3 1
    }];
    
    //指定拿后几次发送的数据
    [[subject takeLast:2] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);  // 1 2
    }];
    
    [subject sendNext:@"3"];
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    
    [subject sendCompleted];  //从后往前拿一定要标记已经全部发送完毕了
    
}

- (void)RACSignal_skip{
    
    //skip 忽略掉几个
    
    RACSubject *subject = [RACSubject subject];
    
    [[subject skip:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [subject sendNext:@"3"];
    
}

- (void)RACSignal_startWith {
    
    RACSignal *signal = @[@1,@2,@3,@4].rac_sequence.signal;
    
    RACSignal *signal2 = [signal startWith:@"hello world"];
    
    [signal2 subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
        
    }];
    
}

-  (void)RACSignal_repeat {
    
    RACSignal *signal = @[@1,@2,@3,@4].rac_sequence.signal;
    
    RACSignal *signal2  = [signal repeat];
    
    RACDisposable *disposable = [signal2 subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [disposable dispose];
        
    });
    
    
}

- (void)RACSignal_retry {
    
    __block int i = 0;
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if (i == 10) {
            [subscriber sendNext:@1];
        }else{
            NSLog(@"接收到错误");
            [subscriber sendError:nil];
        }
        i++;
        return nil;
        
    }];
    
    RACSignal *signal2  = [signal retry];
    //    RACSignal *signal2  = [signal retry:2];
    
    [signal2 subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
    }];
}

-(void)RACSignal_collect {
    
    RACSignal *signal = @[@1,@2,@3,@4].rac_sequence.signal;
    
    [[signal collect] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
}

- (void)RACSignal_aggregate {
    
    RACSignal *signal = @[@1,@2,@3,@4].rac_sequence.signal;
    
    [[signal aggregateWithStart:@0 reduce:^id _Nonnull(NSNumber  *running,NSNumber *next) {
        return @(running.integerValue + next.integerValue);
        
    }] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
}

#pragma mark - 信号的时间操作

- (void)RACSignal_delay {
    
    RACSignal *signal = @[@1,@2,@3,@4].rac_sequence.signal;
    
    [[signal delay:1] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
}

- (void)RACSubject_throttle {
    
    //如果发送1，2秒内发送了2，那么1被抛弃了，如果2秒内，3又发送了，那么2就被抛弃了。那么保留了3.
    //比如搜索操作，2秒内有新内容被搜索，那么前面的搜搜索就取消。
    
    RACSubject *signal = [RACSubject subject];
    
    [[signal throttle:2] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
        
    }];
    
    [signal sendNext:@"1"];
    [signal sendNext:@"2"];
    [signal sendNext:@"3"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [signal sendNext:@"4"];
        [signal sendNext:@"5"];
        
    });
    
}

#pragma mark - 组合信号的操作

- (void)RACSignal_concat {
    
    //网络请求a b ，a返回处理a， b返回处理b
    
    //组合:信号的组合
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"数据A"];
        
        //告诉A发送完毕，组合信号才走下面的信号
        [subscriber sendCompleted];
        
        //[subscriber sendNext:nil];  error不可以。a完整结束，才会走b
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"数据B"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signalC = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"数据C"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    //创建组合信号 concat，按顺序组合
    //按照A C B 顺序执行
    
    //    RACSignal *concatSignal =  [[signalA concat:signalB] concat:signalC];
    RACSignal *concatSignal =  [RACSignal concat:@[signalA,signalC,signalB] ];
    
    
    //订阅组合信号
    [concatSignal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
}

- (void)RACSignal_merge {
    
    //一个页面N个请求，拿到哪个数据显示哪个数据
    
    //    subject发送数据的时候，是可以没有顺序的
    
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    RACSubject *signalC = [RACSubject subject];
    
    //组合信号
    //    RACSignal *mergeSignal = [signalA merge:signalB];
    
    RACSignal *mergeSignal = [RACSignal merge:@[signalA,signalB,signalC]];
    
    //根据发送的情况处理
    [mergeSignal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    [signalB sendNext:@"数据B"];
    [signalC sendNext:@"数据C"];
    [signalA sendNext:@"数据A"];
    
    //Ps:特别注意如果A在主线程，B在子线程，C有时候在主线程执行有时候在子线程执行，对于C的一些操作这是一个坑！
    
}

- (void)RACSignal_zip {
    
    //把两个信号压缩成一个信号。只有当两个信号同时发出信号内容，并且将内容合并成一个元祖返回
    //一个发一个，是一组。
    
    RACSubject *signalA = [RACSubject subject];
    RACSubject *signalB = [RACSubject subject];
    
    //压缩
    //    RACSignal *zipSignal =  [signalA zipWith:signalB];
    
    RACSignal *zipSignal = [RACSignal zip:@[signalA,signalB] ];
    
    
    [zipSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);  //result is a-b
    }];
    
    [signalB sendNext:@"number B1"];
    [signalA sendNext:@"number A1"];
    
    [signalB sendNext:@"number B2"];
    [signalA sendNext:@"number A2"];
    
    [signalB sendNext:@"number B3"];
    [signalB sendNext:@"number B4"];
    [signalA sendNext:@"number A3"];
    
    [signalA sendNext:@"number A4"];
    
    [signalA sendNext:@"number A5"];
    [signalA sendNext:@"number A6"];
    [signalA sendNext:@"number A7"];
    
    [signalB sendNext:@"number B5"];
}

- (void)RACSignal_combineLatest {
    
    [self pushWithName:NSStringFromSelector(_cmd)];
}

- (void)RACSignal_sample {
    
    RACSubject *signal1 = [RACSubject subject];
    RACSubject *signal2 = [RACSubject subject];
    
    RACSignal *signal3 = [signal1 sample:signal2];
    
    [signal3 subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@",x);
    }];
    
    [signal1 sendNext:@"1"];
    [signal2 sendNext:@"Z"];
    [signal1 sendNext:@"2"];
    [signal2 sendNext:@"Z"];
    [signal2 sendNext:@"Z"];
    [signal1 sendNext:@"3"];
    [signal1 sendNext:@"4"];
}

- (void)RACSignal_takeUntil {
    
    RACSubject *subject = [RACSubject subject];
    
    RACSubject *signal = [RACSubject subject];
    
    //直到标记信号开始发送数据，结束
    [[subject takeUntil:signal] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [signal sendNext:@"lol"];
    [signal sendCompleted];  //senderror 不行
    [subject sendNext:@"3"];
    [subject sendCompleted];
    
}

- (void)RACSignal_takeUntilReplacement {
    
    RACSubject *subject = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    //直到标记信号发送完数据，结束
    [[subject takeUntilReplacement:signal] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
        
    }];
    
    [subject sendNext:@"1"];
    [subject sendNext:@"2"];
    [signal sendNext:@"lol"];
    [signal sendCompleted];  //senderror 不行
    [subject sendNext:@"3"];
    [subject sendCompleted];
}

- (void)RACSignal_then {
    
    
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"数据A"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"数据B"];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    //忽略前面的信号，a信号数据发送完毕，忽略完毕，接收b的数据。
    //b的信号依赖a发送完毕。对于a的结果不关心，直接忽略掉！
    RACSignal *signal = [signalA then:^RACSignal * _Nonnull{
        
        return signalB;
    }];
    
    [signal subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
}

#pragma mark - 降阶操作

- (void)RACSubject_switchToLatest {
    
    //信号嵌套信号开始执行。先接受信号先拿到结果。把多维信号转为直线信号。
    
    RACSubject *signalOfSubject = [RACSubject subject];
    RACSubject *signal1 = [RACSubject subject];
    RACSubject *signal2 = [RACSubject subject];
    RACSubject *signal3 = [RACSubject subject];
    
    
    //   信号中的信号！
    //   [signalOfSubject subscribeNext:^(id  _Nullable x) {
    //
    //       [x subscribeNext:^(id  _Nullable x) {
    //            NSLog(@"signalOfSubject : %@",x);    //789  456 123
    //       }];
    //
    //    }];
    
    
    //switchToLatest 最新的信号。
    //发送信号1 ， 3 ，2  -->  2 是最新的信号。
    
    [signalOfSubject.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"switchToLatest : %@",x);  //result is <456>
    }];
    
    [signalOfSubject sendNext:signal1];
    [signalOfSubject sendNext:signal3];
    [signalOfSubject sendNext:signal2];
    
    [signal3 sendNext:@"789"];
    [signal2 sendNext:@"456"];
    [signal1 sendNext:@"123"];
    
}

-(void)ifThenElse {
    
    RACSignal *signal1 = @[@1,@2,@3,@4].rac_sequence.signal;
    RACSignal *signal2 = @[@"a",@"b",@"c",@"d"].rac_sequence.signal;
    
    
    RACSubject *subject = [RACSubject subject];
    
    [[RACSignal if:subject then:signal1 else:signal2] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    [subject sendNext:[NSNumber numberWithInt:1]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [subject sendNext:[NSNumber numberWithInt:0]];
    });
    
    
    
}

- (void)RACSignal_flatten {
    
    
    RACSignal *signal = @[@1, @2, @3, @4].rac_sequence.signal;
    
    RACSignal *signalGroup = [signal groupBy:^NSString *(NSNumber *object) {
        
        return object.integerValue % 2 == 0 ? @"odd" : @"even";
        
    }];
    
    [[[signalGroup take:1] flatten] subscribeNext:^(id x) {
        NSLog(@"next: %@", x);
    }];
    
    
}

#pragma mark - private

- (void)pushWithName:(NSString *)selName {
    
    RACViewController *subViewController = [[NSClassFromString(@"RACViewController") alloc] init];
    subViewController.title = subViewController.selName = selName;
    [self.navigationController pushViewController:subViewController animated:YES];
}

#pragma mark - delegate & dataSource;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, APP_SCREEN_WIDTH, 40)];
    label.backgroundColor = [UIColor lightGrayColor];
    label.text = [self.contentModel.headNameArray objectAtIndex:section];
    return label;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.contentModel.demoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.contentModel.demoArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSString *type = self.contentModel.demoArray[indexPath.section][indexPath.row];
    cell.textLabel.text = type;
    cell.detailTextLabel.text = [self.contentModel.describeDict objectForKey:type];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *type = self.contentModel.demoArray[indexPath.section][indexPath.row];
    ( (void (*) (id, SEL)) objc_msgSend ) (self, NSSelectorFromString(type));
    
    self.rightItem.enabled = [self.contentModel.picUrlDict objectForKey:type]? YES:NO;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

#pragma mark - getters and setters;

- (UITableView *)tbView{
    
    if (_tbView == nil) {
        //        CGRect tbRect = CGRectMake(0, 0, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT - HEADER_HEIGHT);
        _tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];;
        _tbView.delegate =  self;
        _tbView.dataSource = self;
        _tbView.tableFooterView = [[UIView alloc] init];
    }
    return _tbView;
}

#pragma mark - Getters and Setters
- (MWPhotoBrowser *)photoBrowser
{
    if (_photoBrowser == nil) {
        _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        _photoBrowser.displayActionButton = YES;
        _photoBrowser.displayNavArrows = YES;
        _photoBrowser.displaySelectionButtons = NO;
        _photoBrowser.alwaysShowControls = NO;
        _photoBrowser.zoomPhotosToFill = YES;
        _photoBrowser.enableGrid = NO;
        _photoBrowser.startOnGrid = NO;
    }
    
    return _photoBrowser;
}

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

- (ContentModel *)contentModel {
    
    if (_contentModel == nil) {
        _contentModel = [[ContentModel alloc] init];
    }
    return _contentModel;
    
}

@end
