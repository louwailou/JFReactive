//
//  ViewController.m
//  JFReactive
//
//  Created by Sun on 15/12/11.
//  Copyright © 2015年 Sun. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACReturnSignal.h>
#import "JFModel.h"
#import "AFHTTPRequestOperationManager.h"
//#import "RACSignal.h"
//#import "RACDisposable.h"
//#import "RACSubscriber.h"
@interface ViewController ()
@property (nonatomic,strong)RACCommand * command;
@property (nonatomic,strong)RACCommand * loginCommand;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *labelForName;
@property (nonatomic,strong)JFModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self.textField setText:value];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(200, 200, 80, 44)];
    [btn addTarget:self action:@selector(subScribeSingle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"cilick me" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    
    NSString * st = [NSString stringWithFormat:@"ddd"];
    NSString * st2 = [NSString stringWithFormat:@"ddd"];
    if ([st isEqualToString:st2]) {
        NSLog(@"%p",&st);
        NSLog(@"%p",&st2);
        NSLog(@"is equal..............");
    }
      self.model = [[JFModel alloc] init];
    
    [RACObserve(self.textField, text) subscribeNext:^(id x) {
        self.model.name = x;
        NSLog(@"self.model.name =%@",self.model.name);
        NSLog(@"%@",x);// 订阅多次也是触发一次，与上述相比 无副作用，但是需要外部触发，自身没办法触发,即 在其他地方调用 self.textfield.text = @"ddddd"
    }];
    
  
    [[RACObserve(self, model.name) map:^id(id value) {
        NSLog(@"value =%@",value);
        return value ? @YES : @NO;
    }]subscribeNext:^(id x) {
        NSLog(@"xxxxxx =%@",x);
    }];
    // 1 需要subscribe 订阅
    // 2 无论是(self.model, name) 还是(self ,model.name) 均需要在另外的方法中去修改name的值才会触发
    // 3 (self,model)是不会触发的
    

    // 2.KVO
    // 把监听redV的center属性改变转换成信号，只要值改变就会发送信号
    // observer:可以传入nil

    [RACObserve(self.textField, frame) subscribeNext:^(id x) {
        NSLog(@"frame =%@",x);
    }];
    
    
    
    /*
     
     2015-12-23 10:26:55.450 JFReactive[43048:2159463] 输出:
     2015-12-23 10:26:57.190 JFReactive[43048:2159463] 输出:
     2015-12-23 10:26:57.451 JFReactive[43048:2159463] 输出:d
     2015-12-23 10:26:57.641 JFReactive[43048:2159463] 输出:dd
     2015-12-23 10:26:57.832 JFReactive[43048:2159463] 输出:ddd
     2015-12-23 10:26:58.760 JFReactive[43048:2159463] 输出:dddd
     2015-12-23 10:26:58.971 JFReactive[43048:2159463] 输出:ddddd
     2015-12-23 10:26:59.273 JFReactive[43048:2159463] 输出:dddddd
     2015-12-23 10:27:01.232 JFReactive[43048:2159463] 输出:ddddddd
     */
    
//
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)subScirbe{
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"0000");
       [subscriber sendNext:@1];// 如果 注释掉subscribeNext就不会发送
        NSLog(@"1111");
        
        [subscriber sendCompleted];
        NSLog(@"2222");
        return [RACDisposable disposableWithBlock:^{
            
            // block调用时刻：当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            
            // 执行完Block后，当前信号就不在被订阅了。
            
            NSLog(@"信号被销毁");
            
        }];
    }];
    // 3.订阅信号,才会激活信号.
    [signal subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];
    
    [signal subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"2接收到数据:%@",x);
    }];
    // 上述订阅了两次就会触发两次 subscriber的block  0000 1111 2222 被调用两次  可以使用RACMulticastConnection 进行解决
//    
//    
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"100"];
     [subject sendNext:@"100"];
    
    
    /*
     2015-12-26 18:56:26.749 JFReactive[61732:2934337] 0000
     2015-12-26 18:56:26.749 JFReactive[61732:2934337] 接收到数据:1
     2015-12-26 18:56:26.750 JFReactive[61732:2934337] 1111
     2015-12-26 18:56:26.750 JFReactive[61732:2934337] 2222
     2015-12-26 18:56:26.750 JFReactive[61732:2934337] 信号被销毁
     2015-12-26 18:56:26.750 JFReactive[61732:2934337] 0000
     2015-12-26 18:56:26.750 JFReactive[61732:2934337] 2接收到数据:1
     2015-12-26 18:56:26.750 JFReactive[61732:2934337] 1111
     2015-12-26 18:56:26.751 JFReactive[61732:2934337] 2222
     2015-12-26 18:56:26.751 JFReactive[61732:2934337] 信号被销毁
     2015-12-26 18:56:26.751 JFReactive[61732:2934337] 第一个订阅者100
     2015-12-26 18:56:26.751 JFReactive[61732:2934337] 第二个订阅者100
     2015-12-26 18:56:26.751 JFReactive[61732:2934337] 第一个订阅者100
     2015-12-26 18:56:26.751 JFReactive[61732:2934337] 第二个订阅者100
     
     */
    
}
#pragma 使用subject实现代理
- (void)subjectImpDelegate{
    
    /*
     
     // 需求:
     // 1.给当前控制器添加一个按钮，modal到另一个控制器界面
     // 2.另一个控制器view中有个按钮，点击按钮，通知当前控制器
     
     步骤一：在第二个控制器.h，添加一个RACSubject代替代理。
     @interface TwoViewController : UIViewController
     
     @property (nonatomic, strong) RACSubject *delegateSignal;
     
     @end
     
     步骤二：监听第二个控制器按钮点击
     @implementation TwoViewController
     - (IBAction)notice:(id)sender {
     // 通知第一个控制器，告诉它，按钮被点了
     
     // 通知代理
     // 判断代理信号是否有值
     if (self.delegateSignal) {
     // 有值，才需要通知
     [self.delegateSignal sendNext:nil];
     }
     }
     @end
     
     步骤三：在第一个控制器中，监听跳转按钮，给第二个控制器的代理信号赋值，并且监听.
     @implementation OneViewController
     - (IBAction)btnClick:(id)sender {
     
     // 创建第二个控制器
     TwoViewController *twoVc = [[TwoViewController alloc] init];
     
     // 设置代理信号
     twoVc.delegateSignal = [RACSubject subject];
     
     // 订阅代理信号
     [twoVc.delegateSignal subscribeNext:^(id x) {
     
     NSLog(@"点击了通知按钮");
     }];
     
     // 跳转到第二个控制器
     [self presentViewController:twoVc animated:YES completion:nil];
     
     }
     @end
     */
    
}

#pragma mark replaySubject  重复发送之前保存的值
- (void)replaySubject{
    
    // RACReplaySubject使用步骤:
    // 1.创建信号 [RACSubject subject]，跟RACSiganl不一样，创建信号时没有block。
    // 2.可以先订阅信号，也可以先发送信号。
    // 2.1 订阅信号 - (RACDisposable *)subscribeNext:(void (^)(id x))nextBlock
    // 2.2 发送信号 sendNext:(id)value
    
    // RACReplaySubject:底层实现和RACSubject不一样。
    // 1.调用sendNext发送信号，把值保存起来，然后遍历刚刚保存的所有订阅者，一个一个调用订阅者的nextBlock。
    // 2.调用subscribeNext订阅信号，遍历保存的所有值，一个一个调用订阅者的nextBlock
    
    // 如果想当一个信号被订阅，就重复播放之前所有值，需要先发送信号，在订阅信号。
    // 也就是先保存值，在订阅值。
    
    // 1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
    /*
     2015-12-26 17:29:07.467 JFReactive[60987:2909146] 第一个订阅者接收到的数据1
     2015-12-26 17:29:07.467 JFReactive[60987:2909146] 第一个订阅者接收到的数据2
     2015-12-26 17:29:07.468 JFReactive[60987:2909146] 第二个订阅者接收到的数据1
     2015-12-26 17:29:07.468 JFReactive[60987:2909146] 第二个订阅者接收到的数据2
     */
    
}
- (void)sequence{
    // 1.遍历数组
    NSArray *numbers = @[@1,@2,@3,@4];
    
    // 这里其实是三步
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
    [numbers.rac_sequence.signal subscribeNext:^(id x) {
        
        NSLog(@"thread = %@",[NSThread currentThread]);
         NSLog(@"main thread = %@",[NSThread mainThread]);
        NSLog(@"%@",x);
    }];
    
    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"xmg",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        
        // 相当于以下写法
               NSString *keys = x[0];
                NSString *values = x[1];
        
        NSLog(@"%@ %@",key,value);
         NSLog(@"s %@ s%@",keys,values);
        
    }];
    
    
    // 3.字典转模型
    // 3.1 OC写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    
//    NSMutableArray *items = [NSMutableArray array];
//    
//    for (NSDictionary *dict in dictArr) {
//        FlagItem *item = [FlagItem flagWithDict:dict];
//        [items addObject:item];
//    }
//    
//    // 3.2 RAC写法
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
//    
//    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
//    
//    NSMutableArray *flags = [NSMutableArray array];
//    
//    _flags = flags;
//    
//    // rac_sequence注意点：调用subscribeNext，并不会马上执行nextBlock，而是会等一会。
//    [dictArr.rac_sequence.signal subscribeNext:^(id x) {
//        // 运用RAC遍历字典，x：字典
//        
//        FlagItem *item = [FlagItem flagWithDict:x];
//        
//        [flags addObject:item];
//        
//    }];
//    
//    NSLog(@"%@",  NSStringFromCGRect([UIScreen mainScreen].bounds));
//    
    
    // 3.3 RAC高级写法:
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"flags.plist" ofType:nil];
    
    NSArray *dictArr = [NSArray arrayWithContentsOfFile:filePath];
    // map:映射的意思，目的：把原始值value映射成一个新值
    // array: 把集合转换成数组
    // 底层实现：当信号被订阅，会遍历集合中的原始值，映射成新值，并且保存到新的数组里。
//    NSArray *flags = [[dictArr.rac_sequence map:^id(id value) {
//        
//        return [FlagItem flagWithDict:value];
//        
//    }] array];
    
}
#pragma mark command
- (void)comomand{
    // 一、RACCommand使用步骤:
    // 1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
    // 2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
    // 3.执行命令 - (RACSignal *)execute:(id)input
    
    // 二、RACCommand使用注意:
    // 1.signalBlock必须要返回一个信号，不能传nil.
    // 2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
    // 3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
    // 4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
    // 三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
    // 1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
    // 2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
    // 四、如何拿到RACCommand中返回信号发出的数据。
    // 1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    // 五、监听当前命令是否正在执行executing
    
    // 六、使用场景,监听按钮点击，网络请求
    
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        NSLog(@"执行命令");
        NSLog(@"input =%@",input);
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _command = command;
    
    // 3.订阅RACCommand中的信号
    //RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    [command.executionSignals subscribeNext:^(id x) {
        
         NSLog(@"subscribe signal  %@",x);
        [x subscribeNext:^(id x) {
            
            NSLog(@"singnal's next  %@",x);
        }];
        
    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"switchToLast subnext: %@",x);
    }];
    
    // 4.监听命令是否执行完毕,默认会先触发 正在执行 x= yes，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        
        NSLog(@"excuting xx = %@",x);
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    [command.executing subscribeNext:^(id x) {
        NSLog(@"excuting next :%@",x);
    }];
    
    // 5.执行命令
    [self.command execute:@100];// 无此语句则无法触发所有的command
    
    /*
     2015-12-26 18:48:23.728 JFReactive[61623:2932153] excuting next :0
     2015-12-26 18:48:23.728 JFReactive[61623:2932153] 执行命令
     2015-12-26 18:48:23.728 JFReactive[61623:2932153] input =100
     2015-12-26 18:48:23.729 JFReactive[61623:2932153] excuting xx = 1
     2015-12-26 18:48:23.729 JFReactive[61623:2932153] 正在执行
     2015-12-26 18:48:23.730 JFReactive[61623:2932153] excuting next :1
     2015-12-26 18:48:23.730 JFReactive[61623:2932153] subscribe signal  <RACDynamicSignal: 0x7fa053437f20> name:
     2015-12-26 18:48:23.730 JFReactive[61623:2932153] singnal's next  请求数据
     2015-12-26 18:48:23.730 JFReactive[61623:2932153] switchToLast subnext: 请求数据
     2015-12-26 18:48:23.731 JFReactive[61623:2932153] excuting xx = 0
     2015-12-26 18:48:23.731 JFReactive[61623:2932153] 执行完成
     2015-12-26 18:48:23.731 JFReactive[61623:2932153] excuting next :0

     */
}

#pragma mark RACMulticastConnection 解决signal中每订阅subscribeNext 就触发一次block 的问题
-(void)multicast{
    // // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求---- 发送请求调用多次。
    // 解决：使用RACMulticastConnection就能解决.

    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        NSLog(@"发送请求");
        [subscriber sendNext:@"200"];
        return nil;
    }];
//    // 2.订阅信号
//    [signal subscribeNext:^(id x) {
//        
//        NSLog(@"接收数据");
//        
//    }];
//    // 2.订阅信号
//    [signal subscribeNext:^(id x) {
//        
//        NSLog(@"接收数据");
//        
//    }];
    
    
    // 使用muticastConnection 替代 解决 了多个订阅，发多次请求的问题
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者一信号");
        
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者二信号");
        
    }];
    
    // 4.连接,激活信号
    [connect connect];

}
#pragma mark 多个信号统一处理 只有两个信号均发送成功才可以，发送error 都不会触发selector
- (void)multiSignal{
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        
       // [subscriber sendError:nil];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        return nil;
    }];
    
    // 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。
    [self rac_liftSelector:@selector(updateUIWithR1:r2:) withSignalsFromArray:@[request1,request2]];
    

}

- (void)updateUIWithR1:(id)data r2:(id)data1
{
    NSLog(@"更新UI%@  %@",data,data1);
    
   
}

#pragma mark bing 文本改变自动触发，不用 sendNext
- (void)bind{
    
    [[_textField.rac_textSignal bind:^RACStreamBindBlock{
        
        // 什么时候调用:
        // block作用:表示绑定了一个信号.
        NSLog(@"revoke streamBindBlock");
        
        return ^RACStream *(id value, BOOL *stop){
            
            // 什么时候调用block:当信号有新的值发出，就会来到这个block。
            
            // block作用:做返回值的处理
            NSLog(@"RacStream RetunBlock");
            // 做好处理，通过信号返回出去.
            return [RACReturnSignal return:[NSString stringWithFormat:@"输出:%@",value]];
        };
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"输出XXX %@",x);
        
    }];
    /*
     2015-12-23 10:52:13.825 JFReactive[43788:2172838] RacStream RetunBlock
     2015-12-23 10:52:13.825 JFReactive[43788:2172838] 输出XXX 输出:ghh
     2015-12-23 10:54:23.266 JFReactive[43788:2172838] RacStream RetunBlock
     2015-12-23 10:54:23.266 JFReactive[43788:2172838] 输出XXX 输出:ghhv
     2015-12-23 10:54:23.718 JFReactive[43788:2172838] RacStream RetunBlock
     2015-12-23 10:54:23.718 JFReactive[43788:2172838] 输出XXX 输出:hhhhhhhjk

     */
}
#pragma mark flattenMap 文本改变自动触发，不用 sendNext
- (void)flattenMap{
    // 监听文本框的内容改变，把结构重新映射成一个新值.绑定后 值的改变都会触发subscribe
    // flattenMap作用:把源信号的内容映射成一个新的信号，信号可以是任意类型
    // flattenMap使用步骤:
    // 1.传入一个block，block类型是返回值RACStream，参数value
    // 2.参数value就是源信号的内容，拿到源信号的内容做处理
    // 3.包装成RACReturnSignal信号，返回出去。

    [[self.textField.rac_textSignal flattenMap:^RACStream *(id value) {
        NSLog(@"value =%@",value);
        return [RACReturnSignal return:@[[NSString stringWithFormat:@"%@",value]]];
        
    }]subscribeNext:^(id x) {
        NSLog(@"xxx = %@",x);
    }];
    /*
     value 先执行   将输入的value 包装成其他的signal 返回，这里使用的是string 构造的returnSignal 还可以其他形式 如数组 字典...
     2015-12-23 11:05:23.091 JFReactive[44079:2179592] value =jjjjj
     2015-12-23 11:05:23.091 JFReactive[44079:2179592] xxx = jjjjj
     2015-12-23 11:05:25.469 JFReactive[44079:2179592] value =jjjjjh
     2015-12-23 11:05:25.469 JFReactive[44079:2179592] xxx = jjjjjh

     换成数组后
     2015-12-23 11:08:30.733 JFReactive[44164:2181092] value =dd
     2015-12-23 11:08:30.733 JFReactive[44164:2181092] xxx = (
     dd
     )
     2015-12-23 11:08:31.633 JFReactive[44164:2181092] value =ddd
     2015-12-23 11:08:31.633 JFReactive[44164:2181092] xxx = (
     ddd
     )
     */
}

#pragma mark map  将值映射为其他的类型  文本改变自动触发，不用 sendNext
- (void)map{
    // Map作用:把源信号的值映射成一个新的值
    
    // Map使用步骤:
    // 1.传入一个block,类型是返回对象，参数是value
    // 2.value就是源信号的内容，直接拿到源信号的内容做处理
    // 3.把处理好的内容，直接返回就好了，不用包装成信号，返回的值，就是映射的值。
    
    // Map底层实现:
    // 0.Map底层其实是调用flatternMap,Map中block中的返回的值会作为flatternMap中block中的值。
    // 1.当订阅绑定信号，就会生成bindBlock。
    // 3.当源信号发送内容，就会调用bindBlock(value, *stop)
    // 4.调用bindBlock，内部就会调用flattenMap的block
    // 5.flattenMap的block内部会调用Map中的block，把Map中的block返回的内容包装成返回的信号。
    // 5.返回的信号最终会作为bindBlock中的返回信号，当做bindBlock的返回信号。
    // 6.订阅bindBlock的返回信号，就会拿到绑定信号的订阅者，把处理完成的信号内容发送出来。
    
    
    [[self.textField.rac_textSignal map:^id(id value) {
        return [NSString stringWithFormat:@"%@",value];
    }]subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    /*
    FlatternMap和Map的区别
    
    1.FlatternMap中的Block返回信号。
    2.Map中的Block返回对象。
    3.开发中，如果信号发出的值不是信号，映射一般使用Map
    4.开发中，如果信号发出的值是信号，映射一般使用FlatternMap。
     
     flattenMap 在map的基础上使其flatten，也就是当Signal嵌套（一个Signal的事件是另一个Signal）的时候，会将内部Signal的事件传递给外部Signal
*/
}
#pragma  mark 信号中的信号
- (void)signalOfSignal{
    // 创建信号中的信号
    RACSubject *signalOfsignals = [RACSubject subject];
    RACSubject *signal = [RACSubject subject];
    
    [[signalOfsignals flattenMap:^RACStream *(id value) {
        
        // 当signalOfsignals的signals发出信号才会调用
        NSLog(@"value class = %@",[value class]);// value 值为信号
        NSLog(@"value= %@",value);
        return value;
        
    }] subscribeNext:^(id x) {
        
        // 只有signalOfsignals的signal发出信号才会调用，因为内部订阅了bindBlock中返回的信号，也就是flattenMap返回的信号。
        // 也就是flattenMap返回的信号发出内容，才会调用。
        
        NSLog(@"输出 ：%@",x);
    }];
    
    // 信号的信号发送信号
    [signalOfsignals sendNext:signal];/*******************************/
    
    // 信号发送内容
    [signal sendNext:@1];
    
    /*
     2015-12-23 11:33:28.497 JFReactive[44471:2191318] value class = RACSubject
     2015-12-23 11:33:28.498 JFReactive[44471:2191318] value= <RACSubject: 0x7f8ea3e1d0a0> name:
     2015-12-23 11:33:28.498 JFReactive[44471:2191318] 输出 ：1
     
     */
}

#pragma mark 信号拼接 concat 按一定顺序拼接信号，执行完A 后才执行 B ，而且A必须成功，B才会执行，他们是异步请求.
- (void)concat{
    //* `concat`:按一定顺序拼接信号，当多个信号发出的时候，有顺序的接收信号。
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return nil;
    }];
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 把signalA拼接到signalB后，signalA发送完成，signalB才会被激活。
    RACSignal *concatSignal = [signalA concat:signalB];
    
    // 以后只需要面对拼接信号开发。
    // 订阅拼接的信号，不需要单独订阅signalA，signalB
    // 内部会自动订阅。
    // 注意：第一个信号必须发送完成，第二个信号才会被激活
    [concatSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);// 依次输出 1，2
        
    }];
    
    // concat底层实现:
    // 1.当拼接信号被订阅，就会调用拼接信号的didSubscribe
    // 2.didSubscribe中，会先订阅第一个源信号（signalA）
    // 3.会执行第一个源信号（signalA）的didSubscribe
    // 4.第一个源信号（signalA）didSubscribe中发送值，就会调用第一个源信号（signalA）订阅者的nextBlock,通过拼接信号的订阅者把值发送出来.
    // 5.第一个源信号（signalA）didSubscribe中发送完成，就会调用第一个源信号（signalA）订阅者的completedBlock,订阅第二个源信号（signalB）这时候才激活（signalB）。
    // 6.订阅第二个源信号（signalB）,执行第二个源信号（signalB）的didSubscribe
    // 7.第二个源信号（signalA）didSubscribe中发送值,就会通过拼接信号的订阅者把值发送出来.
}
#pragma mark 连接信号 then 用于连接两个信号，当第一个信号完成，才会连接then返回的信号 过滤掉之前的信号，只输出then 信号
- (void)then{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        NSLog(@"subscriber ...");
        [subscriber sendCompleted];
        return nil;
    }] then:^RACSignal *{
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@2];
            return nil;
        }];
    }] subscribeNext:^(id x) {
        
        // 只能接收到第二个信号的值，也就是then返回信号的值
        NSLog(@"%@",x);// 输出 2
    }];
    
}
#pragma mark  合并信号，`merge`:把多个信号合并为一个信号，任何一个信号有新值的时候就会调用
// 底层实现：
// 1.合并信号被订阅的时候，就会遍历所有信号，并且发出这些信号。
// 2.每发出一个信号，这个信号就会被订阅
// 3.也就是合并信号一被订阅，就会订阅里面所有的信号。
// 4.只要有一个信号被发出就会被监听。
- (void)merge{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"dddd"];
        
        return nil;
    }];
    
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    //2015-12-27 14:07:01.923 JFReactive[91948:3179215] 1
    //2015-12-27 14:07:01.923 JFReactive[91948:3179215] dddd
}
#pragma mark zipWith`:把两个信号压缩成一个信号，只有当两个信号同时发出信号内容时，并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件。 当且仅当两个均发送信号才 会触发
- (void)zipSignal{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    
    
    // 压缩信号A，信号B
    RACSignal *zipSignal = [signalA zipWith:signalB];
    
    [zipSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    /*
     
     <RACTuple: 0x7fdffa519bf0> (
     1,
     2
     )
     */
}
#pragma mark  `combineLatest`:将多个信号合并起来，并且拿到各个信号的最新的值,必须每个合并的signal至少都有过一次sendNext，才会触发合并的信号。
-(void)combinLast{

    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 把两个信号组合成一个信号,跟zip一样，没什么区别
#pragma mark   combineLatest需要每个signal至少都有过一次sendNext-->触发过一次
    RACSignal *combineSignal = [signalA combineLatestWith:signalB];
    
    [combineSignal subscribeNext:^(id x) {
        
        NSLog(@"with %@",x);
        /*
         <RACTuple: 0x7fa900c22bf0> (
         1,
         2
         )

         */
    }];
    
    /*
     // 底层实现：
     // 1.当组合信号被订阅，内部会自动订阅signalA，signalB,必须两个信号都发出内容，才会被触发。
     // 2.并且把两个信号组合成元组发出。
     */
}
#pragma mark `reduce`聚合:用于信号发出的内容是元组，把信号发出元组的值聚合成一个值
- (void)reduce{
    RACSignal *signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@2];
        
        return nil;
    }];
    
    // 聚合
    // 常见的用法，（先组合在聚合）。combineLatest:(id<NSFastEnumeration>)signals reduce:(id (^)())reduceBlock
    // reduce中的block简介:
    // reduceblcok中的参数，有多少信号组合，reduceblcok就有多少参数，每个参数就是之前信号发出的内容
    // reduceblcok的返回值：聚合信号之后的内容。
    RACSignal *reduceSignal = [RACSignal combineLatest:@[signalA,signalB] reduce:^id(NSNumber *num1 ,NSNumber *num2){
        
        return [NSString stringWithFormat:@"%@ %@",num1,num2];
        
    }];
    
    [reduceSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);//2015-12-23 14:07:21.242 JFReactive[45802:2240147] 1 2
    }];
    // 底层实现:
    // 1.订阅聚合信号，每次有内容发出，就会执行reduceblcok，把信号内容转换成reduceblcok返回的值。
}

#pragma mark filter 过滤方法 ****************************************

- (void)filterSignal{
    [self.textField.rac_textSignal filter:^BOOL(NSString* value) {
        return value.length > 4;
    }];
    
}
#pragma mark 忽略text 值为 @“1” 的输入信号，只是 x 没有值 但是并不代表不调用 block
- (void)ignore{
    // 文字值改变就会触发
    [[self.textField.rac_textSignal ignore:@"1"]subscribeNext:^(id x) {
        NSLog(@"输出：%@",x)
        ;
    }];
    
}
#pragma mark 前后文本的值有多次改变，仅仅触发最后的依次更新   ？？？distinctUntilChanged 比较数值流中当前值和上一个值，如果不同，就返回当前值，简单理解为“流”的值有变化时反馈变化的值，求异存同

- (void)distinctUntilChanged{
    self.textField.text = @"100";
    self.textField.text = @"120";
    [[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    //
    self.textField.text = @"15000";
    // 仍旧输出 120 ？？？
}
#pragma mark  限定处理信号的个数
- (void)takeSignal{
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal take:4] subscribeNext:^(id x) {// 可以处理4 个信号
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号  不能先send 再订阅，
    [signal sendNext:@1];
    
    [signal sendNext:@2];
}
- (void)takeLastSignal{
    RACSubject *signal = [RACSubject subject];
    
    // 2、处理信号，订阅信号
    [[signal takeLast:1] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    // 3.发送信号
    [signal sendNext:@1];
    
    [signal sendNext:@2];
    
    [signal sendCompleted];//订阅者必须调用完成，因为只有完成，就知道总共有多少信号
    
    
    
    /*  
     
     takeUntil:(RACSignal *):获取信号直到某个信号执行完成
     
     // 监听文本框的改变直到当前对象被销毁
     [_textField.rac_textSignal takeUntil:self.rac_willDeallocSignal];
     skip:(NSUInteger):跳过几个信号,不接受。
     
     // 表示输入第一次，不会被监听到，跳过第一次发出的信号
     [[_textField.rac_textSignal skip:1] subscribeNext:^(id x) {
     
     NSLog(@"%@",x);
     }];
     */

}
#pragma mark  next 调用次序 是在sendNext 发送之前调用 也就是所谓的副作用
- (void)doNext{
    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"sendNextBefor");
        [subscriber sendNext:@1];
        NSLog(@"sendNextafer");
        [subscriber sendCompleted]; // 不发送 不会触发doCompleted
        NSLog(@"sendcompleted finished");
        return nil;
    }] doNext:^(id x) {
        // 执行[subscriber sendNext:@1];之前会调用这个Block
        NSLog(@"doNext %@",x);;
    }] doCompleted:^{
        // 执行[subscriber sendCompleted];之前会调用这个Block
        NSLog(@"doCompleted");;
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    /*
     2015-12-23 15:48:35.211 JFReactive[47589:2282095] sendNextBefor
     2015-12-23 15:48:35.212 JFReactive[47589:2282095] doNext 1
     2015-12-23 15:48:35.213 JFReactive[47589:2282095] 1
     2015-12-23 15:48:35.213 JFReactive[47589:2282095] sendNextafer
     2015-12-23 15:48:35.213 JFReactive[47589:2282095] doCompleted
     2015-12-23 15:48:35.213 JFReactive[47589:2282095] sendcompleted finished
     
     */
}

/////////************************** 时间 ************************************/////////

- (void)signalTime{
    /*
     timeout：超时，可以让一个信号在一定的时间后，自动报错。
     
     RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
     return nil;
     }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
     
     [signal subscribeNext:^(id x) {
     
     NSLog(@"%@",x);
     } error:^(NSError *error) {
     // 1秒后会自动调用
     NSLog(@"%@",error);
     }];
     interval 定时：每隔一段时间发出信号
     
     [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
     
     NSLog(@"%@",x);
     }];
     delay 延迟发送next。
     
     RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
     
     [subscriber sendNext:@1];
     return nil;
     }] delay:2] subscribeNext:^(id x) {
     
     NSLog(@"%@",x);
     }];

     
     */
}
- (void)kvo{
    self.model.name = @"sdd";
    [self.textField setFrame:CGRectMake(100, 320, 80, 40)];
}
- (void)takes{
    NSArray *pins = @[@172230988, @172230947, @172230899, @172230777, @172230707];
    __block NSInteger index = 0;
    
//    RACSignal *signal = [[[[RACSignal interval:0.1 onScheduler:[RACScheduler scheduler]]
//                           take:pins.count]
//                          map:^id(id value) {
//                             
//                              return [[[HBAPIManager sharedManager] fetchPinWithPinID:[pins[index++] intValue]] doNext:^(id x) {
//                                  NSLog(@"这里只会执行一次");
//                              }];
//                              
//                              
//                          }]
//                         switchToLatest];
//    
//    [signal subscribeNext:^(HBPin *pin) {
//        NSLog(@"pinID:%d", pin.pinID);
//    } completed:^{
//        NSLog(@"completed");
//    }];
    
    // output
    // 2014-06-05 17:40:49.851 这里只会执行一次
    // 2014-06-05 17:40:49.851 pinID:172230707
    // 2014-06-05 17:40:49.851 completed
}

#pragma mark 测试当图片下载完后 按钮才可以用
-(void)btnAvliableWhenImgOK{

    //  观察img 是否修改，如果修改就会触发
    RACSignal * imagAvaibaleSignal = [RACObserve(self, self.imageView.image) map:^id(id value) {
        return  value ? @YES : @NO;
    }];
    self.imageView.image = [UIImage imageNamed:@"img"];
    [imagAvaibaleSignal subscribeNext:^(id x) {
        NSLog(@"xx =%@",x);
    }];
    //
    self.shareBtn.rac_command = [[RACCommand alloc] initWithEnabled:imagAvaibaleSignal signalBlock:^RACSignal *(id input) {
        // do share logic
        
        NSLog(@"input =%@",input);
        return [RACSignal empty];// 必须返回一个信号，不能返回nil
    }];
    // 一个command 需要execute 才能触发执行
     //  [self.shareBtn.rac_command execute:@"100"];
    /*
     2015-12-27 13:08:22.669 JFReactive[90007:3150988] xx =1
     2015-12-27 13:08:25.960 JFReactive[90007:3150988] input =100
     ///
     */
}

- (void)tapGesture{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    [[tapGesture rac_gestureSignal] subscribeNext:^(id x) {
        [self.shareBtn.rac_command execute:@"300"];
    }];
}
#pragma mark time interval
- (void)interval{
    NSArray *pins = @[@172230988, @172230947, @172230899, @172230777, @172230707];
    __block NSInteger index = 0;
    
    
    // take  表示接收几次
    RACSignal * signal = [[[[RACSignal interval:0.1 onScheduler:[RACScheduler scheduler]]take:2]map:^id(id value) {
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@(index++)];
            [subscriber sendCompleted];
            return nil;
        }] doNext:^(id x) {
            NSLog(@"do next =%@",x);
        }];
    }]switchToLatest];
    
    [signal subscribeNext:^(id value) {
        NSLog(@"pinID:%@", value);
    } completed:^{
        NSLog(@"completed");
    }];
    
    
    /*
     do next =0
     2015-12-27 13:42:40.920 JFReactive[90704:3165939] pinID:0
     2015-12-27 13:42:41.015 JFReactive[90704:3165939] do next =1
     2015-12-27 13:42:41.015 JFReactive[90704:3165939] pinID:1
     2015-12-27 13:42:41.119 JFReactive[90704:3165943] do next =2
     2015-12-27 13:42:41.120 JFReactive[90704:3165943] pinID:2
     2015-12-27 13:42:41.219 JFReactive[90704:3165939] do next =3
     2015-12-27 13:42:41.219 JFReactive[90704:3165939] pinID:3
     2015-12-27 13:42:41.318 JFReactive[90704:3165943] do next =4
     2015-12-27 13:42:41.319 JFReactive[90704:3165943] pinID:4
     2015-12-27 13:42:41.319 JFReactive[90704:3165943] completed
     
     */

}
- (void)racSelector{
    
    /*
     rac_signalForSelector: 这个方法会返回一个signal，当selector执行完时，会sendNext，也就是当某个方法调用完后再额外做一些事情。用在category会比较方便，因为Category重写父类的方法时，不能再通过[super XXX]来调用父类的方法，当然也可以手写Swizzle来实现，不过有了rac_signalForSelector:就方便多了。
     
     rac_signalForSelector: fromProtocol: 可以直接实现对protocol的某个方法的实现（听着有点别扭呢），比如，我们想实现UIScrollViewDelegate的某些方法，可以这么写
     注意，这里的delegate需要先设置为nil，再设置为self，而不能直接设置为self，如果self已经是该scrollView的Delegate的话。
     
     有时，我们想对selector的返回值做一些处理，但很遗憾RAC不支持，如果真的有需要的话，可以使用Aspects
     
     
     */
    [[self rac_signalForSelector:@selector(scrollViewDidEndDecelerating:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        // do something
    }];
    
    [[self rac_signalForSelector:@selector(scrollViewDidScroll:) fromProtocol:@protocol(UIScrollViewDelegate)] subscribeNext:^(RACTuple *tuple) {
        // do something
    }];
    
   // self.scrollView.delegate = nil;
   // self.scrollView.delegate = self;
}
-(void)requestTwilce{
    /*
      场景：
     token过期后自动获取新的
     
     开发APIClient时，会用到AccessToken，这个Token过一段时间会过期，需要去请求新的Token。比较好的用户体验是当token过期后，自动去获取新的Token，拿到后继续上一次的请求，这样对用户是透明的。
     
     
     有些地方很容易被忽略，比如RACObserve(thing, keypath)，看上去并没有引用self，所以在subscribeNext时就忘记了weakify/strongify。但事实上RACObserve总是会引用self，即使target不是self，所以只要有RACObserve的地方都要使用weakify/strongify。

     
     */
    RACSignal *requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // suppose first time send request, access token is expired or invalid
        // and next time it is correct.
        // the block will be triggered twice.
        static BOOL isFirstTime = 0;
        NSString *url = @"http://httpbin.org/ip";
        if (!isFirstTime) {
            url = @"http://nonexists.com/error";
            isFirstTime = 1;
        }
        NSLog(@"url:%@", url);
        [[AFHTTPRequestOperationManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [subscriber sendNext:responseObject];
            [subscriber sendCompleted];
            NSLog(@"subscriber sendcompleted");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"subscriber send error");
            [subscriber sendError:error];
            
        }];
        return nil;
    }];
    
    self.labelForName.text = @"sending request...";
    [[requestSignal catch:^RACSignal *(NSError *error) {// requestSignal 发送error 触发 catch{}  catch 中返回的signal 发送next 在subcribeNext接收后，再追加一次requestSignal
        self.labelForName.text = @"oops, invalid access token";
        NSLog(@"catch ....");
        // simulate network request, and we fetch the right access token
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            double delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [subscriber sendNext:@YES];
                NSLog(@"subscriber sendNext...");
                [subscriber sendCompleted];
            });
            return nil;
        }] concat:requestSignal];//在发送成功后再追加一个信号 依次执行信号,
        
        
        
    }] subscribeNext:^(id x) {
        NSLog(@"next =%@",x);
        if ([x isKindOfClass:[NSDictionary class]]) {
            self.labelForName.text = [NSString stringWithFormat:@"result:%@", x[@"origin"]];
        }
    } completed:^{
        NSLog(@"completed");
    }];
    
    
    /*
     2015-12-27 15:55:29.144 JFReactive[99545:3229476] url:http://nonexists.com/error
     2015-12-27 15:55:29.166 JFReactive[99545:3229476] subscriber send error
     2015-12-27 15:55:29.166 JFReactive[99545:3229476] catch ....
     2015-12-27 15:55:30.192 JFReactive[99545:3229476] next =1
     2015-12-27 15:55:30.192 JFReactive[99545:3229476] subscriber sendNext...
     2015-12-27 15:55:30.193 JFReactive[99545:3229476] url:http://httpbin.org/ip
     2015-12-27 15:55:31.117 JFReactive[99545:3229476] next ={
     origin = "114.241.14.225";
     }
     2015-12-27 15:55:31.117 JFReactive[99545:3229476] completed
     2015-12-27 15:55:31.117 JFReactive[99545:3229476] subscriber sendcompleted
     */
}
- (void)takeT{
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1"];
        [subscriber sendNext:@"2"];
        [subscriber sendNext:@"3"];
        [subscriber sendCompleted];
        return nil;
    }] take:2] subscribeNext:^(id x) {
        NSLog(@"only 1 and 2 will be print: %@", x);
    }];
    /*
     2015-12-27 16:51:11.254 JFReactive[99908:3250727] only 1 and 2 will be print: 1
     2015-12-27 16:51:11.255 JFReactive[99908:3250727] only 1 and 2 will be print: 2
     */
}
#pragma mark 节流  如果上个next 在规定的interval 内没有返回，这是下一个next 已发送，就会放弃上个next
- (void)throttle{
    
    /*
     我们公司曾经有一个需求，当用户再输入框输入的文本发生改变的时候可以请求数据，做到及时搜索的功能。就像百度现在的搜索体验。做到这个如果不考虑服务器压力其实没那么难，但是我们是追求完美的人，怎么能不考虑服务器性能呢。那么就有一个问题，一旦输入框发生改变我们就要从服务器获取数据吗，当然不能这样，这里我们如果有一个时间延迟那就最好了，那就是节流。
     这里再介绍一下switchToLatest，当我们搜索的时候下一个搜索已经开始了可能上一个搜索还没返回结果，我们就没必要开启上一个搜索了，肯定是去最新的吧。所以switchToLatest就是这样的一个功能。好了，下面就是两者结合给我们的搜索优化的一段代码
     
     */
    [[[[[[self.textField.rac_textSignal throttle:1]distinctUntilChanged]ignore:@""] map:^id(id value) {
        NSLog(@"value =%@",value);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //  network request
            [subscriber sendNext:value];
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                
                //  cancel request
            }];
        }];
    }]switchToLatest] subscribeNext:^(id x) {// 如果不switchToLastest 则返回一个signal
        
        NSLog(@"x = %@",x);
    }];
    
   /*
    2015-12-27 20:41:32.210 JFReactive[1034:3269512] value =fff
    2015-12-27 20:41:32.210 JFReactive[1034:3269512] x = fff
    2015-12-27 20:41:35.815 JFReactive[1034:3269512] value =fffffff
    2015-12-27 20:41:35.815 JFReactive[1034:3269512] x = fffffff
    2015-12-27 20:41:41.688 JFReactive[1034:3269512] value =ffffff
    2015-12-27 20:41:41.688 JFReactive[1034:3269512] x = ffffff
    2015-12-27 20:41:46.154 JFReactive[1034:3269512] value =ffffffgg
    2015-12-27 20:41:46.155 JFReactive[1034:3269512] x = ffffffgg
    */
}
#pragma mark repaet 定时器一直触发操作
- (void)repeat{
    [[[[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        
        [subscriber sendNext:@"rac"];
        [subscriber sendCompleted];
        
        return nil;
    }]delay:1]repeat]take:10] subscribeNext:^(id x) {
        
        NSLog(@"x = %@",x);
    } completed:^{
        
        NSLog(@"完成");
    }];
    /*
    // 如果没有take指定次数,则一直运行下去
    [[[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        
        [subscriber sendNext:@"racxx"];
        [subscriber sendCompleted];
        
        return nil;
    }]delay:1]repeat] subscribeNext:^(id x) {
        
        NSLog(@"xx = %@",x);
    } completed:^{
        
        NSLog(@"x完成");
    }];
     */
    /*
    // 去掉 delay 一直触发，间隔很短时间
    [[[RACSignal createSignal:^RACDisposable *(id subscriber) {
        
        [subscriber sendNext:@"racxxx"];
        [subscriber sendCompleted];
        
        return nil;
    }]repeat] subscribeNext:^(id x) {
        
        NSLog(@"xxx = %@",x);
    } completed:^{
        
        NSLog(@"xxx完成");
    }];
     */
}
-(void)biding{
    //
    //
    RACSignal * singal = [RACSignal
                          combineLatest:@[ RACObserve(self, self.model.age), RACObserve(self, self.model.name) ]
                          reduce:^(NSString *password, NSString *passwordConfirm) {
                              return @([passwordConfirm isEqualToString:password]);
                          }];
    [singal subscribeNext:^(id x) {
        NSLog(@"xx =%@",x) ;
    }];
    
    /* //  如果是直接RAC()的话 自动进行了subscribeNext:
    RAC(self, self.textField.enabled) =[RACSignal
                                        combineLatest:@[ RACObserve(self, self.model.age), RACObserve(self, self.model.name) ]
                                        reduce:^(NSString *password, NSString *passwordConfirm) {
                                            return @([passwordConfirm isEqualToString:password]);
                                        }];
     */

}

- (void)simulateLogin{
 
    // Hooks up a "Log in" button to log in over the network.
    //
    // This block will be run whenever the login command is executed, starting
    // the login process.
//    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^(id sender) {
//        // The hypothetical -logIn method returns a signal that sends a value when
//        // the network request finishes.
//        return [client logIn];
//    }];
    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@"1000"];
            [subscriber sendCompleted];
            return nil;
        }];
    }];
    // -executionSignals returns a signal that includes the signals returned from
    // the above block, one for each time the command is executed.
    [self.loginCommand.executionSignals subscribeNext:^(RACSignal *loginSignal) {
        // Log a message whenever we log in successfully.
        [loginSignal subscribeNext:^(id x) {
            NSLog(@"xxx  %@",x);
        }];
        [loginSignal subscribeCompleted:^{
            NSLog(@"Logged in successfully!");
        }];
    }];
    // Executes the login command when the button is pressed. 按钮点击触发
    self.shareBtn.rac_command = self.loginCommand;
}
-(void)subcribeComplted{
   RACSignal *siga = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"1000"];
        [subscriber sendCompleted];
        return nil;
    }];
    RACSignal *sigb = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"20000"];
        [subscriber sendCompleted];
        return nil;
    }];
    [[RACSignal
      merge:@[ siga, sigb ]]
     subscribeCompleted:^{
         NSLog(@"They're both done!");
     }];
    // //
    // +merge: takes an array of signals and returns a new RACSignal that passes
    // through the values of all of the signals and completes when all of the
    // signals complete.
    //
    // -subscribeCompleted: will execute the block when the signal completes.
    // 先执行第一个signal 然后第二个 接着 log they‘re both done
    
}
- (RACSignal*)loginSignal{
    RACSignal *siga = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@[@"1000"]];
        NSLog(@"__%s",__func__);
        [subscriber sendCompleted];
        return nil;
    }];
    return siga;
}
-(RACSignal*)loadCachedMessagesForUser:(NSString*)user{
    RACSignal *siga = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@[@"11111"]];
        NSLog(@"__%s",__func__);

        [subscriber sendCompleted];
        return nil;
    }];
    return siga;
}
-(RACSignal*)fetchMessagesAfterMessage:(NSString*)arr{
    RACSignal *siga = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@[@"1",@"2"]];
        NSLog(@"__%s",__func__);

        [subscriber sendCompleted];
        return nil;
    }];
    return siga;
}
-(void)asychronize{
   // Signals能够顺序地执行异步操作,而不是嵌套block回调.这个和futures and promises很相似:
   
    // Logs in the user, then loads any cached messages, then fetches the remaining
    // messages from the server. After that's all done, logs a message to the
    // console.
    //
    // The hypothetical -logInUser methods returns a signal that completes after
    // logging in.
    //
    // -flattenMap: will execute its block whenever the signal sends a value, and
    // returns a new RACSignal that merges all of the signals returned from the block
    // into a single signal.
    [[[[self
        loginSignal]
       flattenMap:^(NSString *user) {
           // Return a signal that loads cached messages for the user.
           return [self loadCachedMessagesForUser:user];
       }]
      flattenMap:^(NSArray *messages) {
          // Return a signal that fetches any remaining messages.
          return [self fetchMessagesAfterMessage:messages.lastObject];
      }]
     subscribeNext:^(NSArray *newMessages) {
         NSLog(@"New messages: %@", newMessages);
     } completed:^{
         NSLog(@"Fetched all messages.");
     }];
    /*
     New messages: (
     1,
     2
     )
     2015-12-29 20:56:37.356 JFReactive[16147:3742041] Fetched all messages.
     
     */
}
-(void)racBinding{
    // Creates a one-way binding so that self.imageView.image will be set as the user's
    // avatar as soon as it's downloaded.
    //
    // The hypothetical -fetchUserWithUsername: method returns a signal which sends
    // the user.
    //
    // -deliverOn: creates new signals that will do their work on other queues. In
    // this example, it's used to move work to a background queue and then back to the main thread.
    //
    // -map: calls its block with each user that's fetched and returns a new
    // RACSignal that sends values returned from the block.
    
    /*
    RAC(self.imageView, image) = [[[[self
                                     fetchUserWithUsername:@"joshaber"]
                                    deliverOn:[RACScheduler scheduler]]
                                   map:^(User *user) {
                                       // Download the avatar (this is done on a background queue).
                                       return [[NSImage alloc] initWithContentsOfURL:user.avatarURL];
                                   }]
     
     */
                                  // Now the assignment will be done on the main thread.
}
#pragma mark 当下一个对服务器网络请求需要构建在前一个完成时,
-(void)loginThen{

    [[[[self loginSignal]
       then:^{
          
           return [self fetchMessagesAfterMessage:@"d"];
       }]
      flattenMap:^(NSArray *messages) {
         
          return [self loadCachedMessagesForUser:messages.lastObject];
      }]
     subscribeError:^(NSError *error) {
         NSLog(@"error....");
     } completed:^{
         NSLog(@"Fetched all messages.");
     }];
    
    /*
     2015-12-29 21:24:03.463 JFReactive[16399:3754666] ____29-[ViewController loginSignal]_block_invoke
     2015-12-29 21:24:03.463 JFReactive[16399:3754666] ____44-[ViewController loadCachedMessagesForUser:]_block_invoke
     2015-12-29 21:24:03.463 JFReactive[16399:3754666] ____44-[ViewController fetchMessagesAfterMessage:]_block_invoke
     2015-12-29 21:24:03.463 JFReactive[16399:3754666] Fetched all messages.
     */
    
    /*
     
     */
    
    /*
     
     */
    
}
- (void)subScribeSingle{
    [self loginThen];
}
- (IBAction)shareAction:(id)sender {
    NSLog(@"shareActoin ...");
   self.model.name = @"ssss";
    self.model.age = @100;
}

@end
