# ReactiveCocoa_Use
* 对于使用MVC的小伙伴来说，随着业务的增多，代码会显得越来越臃肿。
* 本人也是如此感觉，于是学习ReactiveCocoa来进行MVVM+RAC架构。
* 对于ReactiveCocoa的使用，本人会不定时更新。
* 如果帮助到了各位看官，希望给个星星和Star。

![ReactiveCocoa的使用.png](https://upload-images.jianshu.io/upload_images/2779714-cf2b11aa654a4eeb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



![RACSignal常用操作.png](https://upload-images.jianshu.io/upload_images/2779714-7cd84f72e4898f0e.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

***

**什么是函数响应式编程？**

* 满足函数式的一些特性
* 面向离散事件流
* 流散事件流操作
***
**函数式编程的特性？**

* 闭包&高阶函数
* 惰性计算
* 不改变状态
* 递归
***
**什么是ReactiveCocoa？**

* Github mac客户端副产物
* FRP在Cocoa框架下的实现
* 富含了Cocoa框架多种组件
* 提供基于时间变化的数据流的组合和变化
* 简称RAC

***

**如何理解基于时间变化的数据流？**

![](https://upload-images.jianshu.io/upload_images/2779714-ba9ea0e656c6ed1d.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

![](https://upload-images.jianshu.io/upload_images/2779714-ee80c10eb5bed22b.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

![](https://upload-images.jianshu.io/upload_images/2779714-c1b34498b9714adf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)
***


#ReactiveCocoa基础知识

**核心组件**

* RACSteam、 RACSequence、 RACSignal
* RACSubscriber
* RACDisposable
* RACScheduler
* Cocoa框架适配工具

***

**① RACSteam**

RACSteam的两个子类：
* RACSequence：基于空间的数据流，在时间上是连续的。操作多，消耗高
* RACSignal：基于时间的数据流，在时间上是离散的。

![RACSteam.png](https://upload-images.jianshu.io/upload_images/2779714-ed5727e933d6e6d7.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)


**RACSequence VS RACSignal**
* Pull-driver vs Push-driver  (看书&看电视)
* Data vs Event
* 其他差异

**② Signal Subscirber Disposable**

![Signal Subscirber Disposable](https://upload-images.jianshu.io/upload_images/2779714-47e25f65594c92ae.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/400)

**③ RACScheduler**

* 用来做调度
* 代替GCD
*  异步与并发

***

