//
//  RACViewController.m
//  ReactiveCocoa_Use
//
//  Created by koala on 2018/6/12.
//  Copyright © 2018年 koala. All rights reserved.
//

#import "RACViewController.h"
#import "WKView.h"

@interface RACViewController ()

@property (nonatomic, strong) WKView *wkView;
@property (nonatomic, strong) RACDisposable *disposable;

@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    
    ( (void (*) (id, SEL)) objc_msgSend ) (self, NSSelectorFromString(self.selName));
    
}


- (void)RACSubject_filter {
    
    
    UITextField *field = [[UITextField alloc] init];
    field.frame =  CGRectMake(10, 50, 200, 80);
    field.layer.borderWidth = 1.0f;
    field.layer.borderColor = [UIColor redColor].CGColor;
    field.placeholder = @"请输入多个数字";
    [self.view addSubview:field];
    
    //过滤
    [[field.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        //        NSLog(@"valus : %@",value);
        
        return value.length > 3;
        
    }] subscribeNext:^(NSString * _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
}


//组合
- (void)RACSignal_combineLatest {
    
    UITextField *field = [[UITextField alloc] init];
    field.frame =  CGRectMake(10, 50, 200, 80);
    field.layer.borderWidth = 1.0f;
    field.layer.borderColor = [UIColor redColor].CGColor;
    field.placeholder = @"请输入用户名";
    [self.view addSubview:field];
    
    UITextField *field1 = [[UITextField alloc] init];
    field1.frame =  CGRectMake(10, 200, 200, 80);
    field1.layer.borderWidth = 1.0f;
    field1.layer.borderColor = [UIColor redColor].CGColor;
    field1.placeholder = @"请输入密码";
    [self.view addSubview:field1];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(10, 300, 200, 80);
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    
    [self.view addSubview:btn];
    
    //实现方式一：

    /*
    //(NSString *account , NSString *pwd) 根据组合信号的返回值来写

    [[RACSignal combineLatest:@[field.rac_textSignal, field1.rac_textSignal] reduce:^id _Nonnull(NSString *account , NSString *pwd){

        return @(account.length && pwd.length);
    }] subscribeNext:^(id  _Nullable x) {

        NSLog(@"%@",x);
        btn.enabled = [x boolValue];

    }];
     */
    
    
    //实现方式二：
    RACSignal *signal = [RACSignal combineLatest:@[field.rac_textSignal, field1.rac_textSignal] reduce:^id _Nonnull(NSString *account , NSString *pwd){

        return @(account.length && pwd.length);
    }];

    RAC(btn,enabled) = signal;

}


- (void)RAC_Macro {

    //RAC(TARGET, ...)
    //给某个对象的某个属性绑定信号，一旦信号产生数据，就会将内容赋值给属性!
    //例如，textField绑定信号产生的数据是filed的text，将值赋值给label。完美！
    
    UITextField *field = [[UITextField alloc] init];
    field.frame =  CGRectMake(10, 50, 200, 80);
    field.layer.borderWidth = 1.0f;
    field.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:field];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame =  CGRectMake(10, 300, 200, 80);
    label.layer.borderWidth = 1.0f;
    label.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:label];
    
    RAC(label,text) = field.rac_textSignal;
    
    
    //RACObserve(<#TARGET#>, <#KEYPATH#>)  监听的宏，返回的是个信号
    //下面监听的是label的text
    
    [RACObserve(label, text) subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
    
    //强弱引用
    
    @weakify(self);
    void(^name)(void) = ^(void) {
        
        @strongify(self);
        NSLog(@"%@",self);
    };
    name();
    
    
    // RACTuplePack(<#...#>)  包装元祖，扩展参数
    RACTuple *tuple = RACTuplePack(@1,@2,@"3");
    
    NSLog(@"tuple is : %@",tuple);
    NSLog(@"tuple[0] is : %@",tuple[0]);
    NSLog(@"tuple[2] is : %@",tuple[2]);
    
    // RACTupleUnpack(<#...#>) 解包
    
    NSDictionary *dic = @{@"name":@"wiki",@"age":@12};
    [dic.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        RACTupleUnpack(NSString *key ,NSString *value) = x;
        NSLog(@"%@:%@",key,value);
    }];

}

- (void)RACSignal_interval_replace_timer {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(10, 50, 200, 80);
    btn.layer.borderWidth = 1.0f;
    btn.layer.borderColor = [UIColor redColor].CGColor;
    [btn setTitle:@"取消定时器请点我" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    @weakify(self)
    [[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [self.disposable dispose];
        NSLog(@"定时器取消了");

    }];
    
    static int num = 0;
    self.disposable =  [[RACSignal interval:1.0 onScheduler:[RACScheduler scheduler]] subscribeNext:^(NSDate * _Nullable x) {
        
        num ++;
        NSLog(@"%d",num);
        
    }];
    
}

- (void)rac_textSignal {
    
    UITextField *field = [[UITextField alloc] init];
    field.frame =  CGRectMake(10, 50, 200, 80);
    field.layer.borderWidth = 1.0f;
    field.layer.borderColor = [UIColor redColor].CGColor;
    field.placeholder = @"请点击输入内容";
    [self.view addSubview:field];
    
    [field.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        NSLog(@"%@",x);  //x是field内容
    }];
    
}


- (void)rac_addObserverForName {
    
    UITextField *field = [[UITextField alloc] init];
    field.frame =  CGRectMake(10, 50, 300, 80);
    field.layer.borderWidth = 1.0f;
    field.layer.borderColor = [UIColor redColor].CGColor;
    field.placeholder = @"监听键盘事件，请点击输入内容";
    [self.view addSubview:field];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        NSLog(@"%@",x);
    }];
    
}

- (void)rac_signalForControlEvents{
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(10, 50, 200, 80);
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    [[btn rac_signalForControlEvents:(UIControlEventTouchUpInside)] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        NSLog(@"%@",x);  //x is UIButton
        
    }];
}


//使用RAC代替KVO
- (void)rac_observeKeyPath {
    
    self.wkView = [[WKView alloc] initWithFrame:CGRectMake(10, 50, 200, 80)];
    [self.view addSubview:self.wkView ];
    
    [self.wkView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        
        NSLog(@"valus ： %@ ， change ： %@",value,change);
    }];
    
    
    //只获取到修改后的内容！
    [[self.wkView rac_valuesForKeyPath:@"frame" observer:self] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"只获取到修改后的内容！ : %@",x);
    }];
    
}

- (void)rac_signalForSelector {
    
    self.wkView = [[WKView alloc] initWithFrame:CGRectMake(10, 50, 200, 80)];
    [[self.wkView rac_signalForSelector:NSSelectorFromString(@"click:")] subscribeNext:^(RACTuple * _Nullable x) {
        
        NSLog(@"按钮被点击了-->%@",x);
    }];
    [self.view addSubview:self.wkView ];
}


@end
