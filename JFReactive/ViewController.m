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
#import <ReactiveCocoa/NSObject+RACKVOWrapper.h>
#import "AFHTTPRequestOperationManager.h"
//#import "RACSignal.h"
//#import "RACDisposable.h"
//#import "RACSubscriber.h"
@interface RACViewController ()
@property (nonatomic,strong)RACCommand * command;
@property (nonatomic,strong)RACCommand * loginCommand;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *labelForName;
@property (nonatomic,strong)JFModel * model;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic,strong)RACSignal *signal;
@property (weak, nonatomic) IBOutlet UITextField *otherField;
@end

@implementation RACViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[JFModel alloc] init];
    
    // [self subscribeSelector];
//    UIImageView * aview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [aview setImage:[UIImage imageNamed:@"2"]];
  
    [self rac_observeKeyPath:@"model.name" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"dic = %@",change);
        NSLog(@"rac_observeKeyPath监听到值改变了");
        
    }];
    //也可以将值改变转换为一个信号 然后订阅这个信号
    [[self rac_valuesForKeyPath:@"model.name" observer:nil] subscribeNext:^(id x) {
        NSLog(@"rac_valuesForKeyPath监听到值改变了  %@ ",x );
    }];
    
    UIButton * aview = [UIButton buttonWithType:UIButtonTypeCustom];
    [aview setBackgroundColor:[UIColor redColor]];
    [aview setBackgroundImage:[UIImage imageNamed:@"2"] forState:UIControlStateNormal];
    [aview setFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:aview];
    aview.layer.anchorPoint = CGPointMake(0, 0);
    [aview setTransform:CGAffineTransformMakeScale(1, -1)];
   // aview.transform = CGAffineTransformTranslate(aview.transform, 0, -100);
    NSLog(@"frame = %@",NSStringFromCGRect(aview.frame));
    NSLog(@"bound = %@",NSStringFromCGRect(aview.bounds));
    NSLog(@"position =%@",NSStringFromCGPoint(aview.layer.position));
    NSLog(@"anchorPoint =%@",NSStringFromCGPoint(aview.layer.anchorPoint));
    
    /**
     2016-01-17 14:03:35.953 JFReactive[65598:8234328] frame = {{0, 100}, {100, 100}}
     
     2016-01-17 14:03:35.953 JFReactive[65598:8234328] bound = {{0, 0}, {100, 100}}
     
     2016-01-17 14:03:35.954 JFReactive[65598:8234328] position ={50, 50}
     
     2016-01-17 14:03:35.954 JFReactive[65598:8234328] anchorPoint ={0.5, 0.5}
     */
//    
//    CALayer * layer = [CALayer layer];
//    [layer setFrame:CGRectMake(0, 0, 100, 100)];
//    layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"2"].CGImage);
//    [layer setBackgroundColor:[UIColor redColor].CGColor];
//    [layer setAffineTransform: CGAffineTransformMakeScale(1, -1)];
//    layer.affineTransform = CGAffineTransformTranslate(layer.affineTransform, 0, -100);
//    [self.view.layer addSublayer:layer];
//    NSLog(@"frame = %@",NSStringFromCGRect(layer.frame));
//     NSLog(@"bound = %@",NSStringFromCGRect(layer.bounds));
//    NSLog(@"position =%@",NSStringFromCGPoint(layer.position));
//    NSLog(@"anchorPoint =%@",NSStringFromCGPoint(layer.anchorPoint));
   /*
    
    frame.origin.x = position.x - anchorPoint.x * bounds.size.width；
    
    frame.origin.y = position.y - anchorPoint.y * bounds.size.height；
    

    2016-01-16 18:16:14.203 JFReactive[57750:8076076] frame = {{0, 0}, {100, 100}}
    2016-01-16 18:16:14.203 JFReactive[57750:8076076] position ={50, 50}
    2016-01-16 18:16:14.204 JFReactive[57750:8076076] anchorPoint ={0.5, 0.5}
    修改anchorPisition 不会影响position  所以anchorPoint 和position无关系
    
    
    
    
    id obj1 = [NSArray alloc];
    id obj2 = [NSArray alloc];
    id obj3 = [NSMutableArray alloc];
    id obj4 = [NSMutableArray alloc];
    2016-01-15 17:21:18.752 JFReactive[47516:7787044] p 1 =0x7f874350dab0
    2016-01-15 17:21:18.753 JFReactive[47516:7787044] p 1 =0x7f874350dab0
    2016-01-15 17:21:18.753 JFReactive[47516:7787044] p 1 =0x7f87435102e0
    2016-01-15 17:21:34.130 JFReactive[47516:7787044] p 1 =0x7f87435102e0
    (lldb)
    id obj1 = [[NSArray alloc]init];
    id obj2 = [[NSArray alloc]init];
    id obj3 = [[NSMutableArray alloc]init];
    id obj4 = [[NSMutableArray alloc]init];
    2016-01-15 17:31:12.509 JFReactive[47792:7792982] p 1 =0x7feda3f02bd0
    2016-01-15 17:31:12.510 JFReactive[47792:7792982] p 1 =0x7feda3f02bd0
    2016-01-15 17:31:12.510 JFReactive[47792:7792982] p 1 =0x7feda3c0ed20
    2016-01-15 17:31:12.510 JFReactive[47792:7792982] p 1 =0x7feda3c25c80
    2016-01-15 17:31:12.510 JFReactive[47792:7792982] view will appear
    
    */
    
   // [self.textField setText:value];
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(200, 130, 80, 44)];
    [btn addTarget:self action:@selector(subScribeSingle) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"cilick me" forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:btn];
    
    self.model.name = @"sun";
   
   
//    [self.textField.rac_textSignal subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
    
//    [RACObserve(self.textField, text) subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);// 订阅多次也是触发一次，与上述相比 无副作用，但是需要外部触发，自身没办法触发,即 在其他地方调用 self.textfield.text = @"ddddd"
//    }];
//    
  
    RACSignal * signal = [RACObserve(self, model.name) map:^id(id value) {
        NSLog(@"value =%@",value);
        return value ? @YES : @NO;
    }];
    
    [signal subscribeNext:^(id x) {
        NSLog(@"xxxxxx =%@",x);
    }];
    
    
    
    // 1 需要subscribe 订阅
    // 2 无论是(self.model, name) 还是(self ,model.name) 均需要在另外的方法中去修改name的值才会触发
    // 3 (self,model)是不会触发的
    
}

- (void)subScirbe{
    /*
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
    
    */
//    
//    
    RACSubject *subject = [RACSubject subject];
    
    // 2.订阅信号
    [subject subscribeNext:^(id x) {
    
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
      
        NSLog(@"第二个订阅者%@",x);
    }];
    
    // 3.发送信号
    [subject sendNext:@"100"];
     [subject sendNext:@"200"];
    
    
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
     subject 既可以订阅下一步 也可以自己发送信息，signal只能订阅下一步，不能自身发送信息
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
- (void)Subject{
    
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
    [replaySubject subscribeNext:^(id x) {// 创建第一个subscriber
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {// 创建第二个subscriber
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
    
    
    [replaySubject sendCompleted];//
    /*
      如果sendNext发生在 subscribeNext之前就打印如下
     2015-12-26 17:29:07.467 JFReactive[60987:2909146] 第一个订阅者接收到的数据1
     2015-12-26 17:29:07.467 JFReactive[60987:2909146] 第一个订阅者接收到的数据2
     2015-12-26 17:29:07.468 JFReactive[60987:2909146] 第二个订阅者接收到的数据1
     2015-12-26 17:29:07.468 JFReactive[60987:2909146] 第二个订阅者接收到的数据2
     
     如果是发生在之后
     2016-01-04 16:46:28.693 JFReactive[32869:4260996] 第一个订阅者接收到的数据1
     2016-01-04 16:46:28.693 JFReactive[32869:4260996] 第二个订阅者接收到的数据1
     2016-01-04 16:46:28.694 JFReactive[32869:4260996] 第一个订阅者接收到的数据2
     2016-01-04 16:46:28.696 JFReactive[32869:4260996] 第二个订阅者接收到的数据2
     */
    
}
- (void)sequence{
    // 1.遍历数组
//    NSArray *numberSequnence = @[@1,@2,@3,@4];
//    
//    // 这里其实是三步
//    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
//    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
//    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
//    [numberSequnence.rac_sequence.signal subscribeNext:^(id x) {
//        
//        NSLog(@"thread = %@",[NSThread currentThread]);
//        NSLog(@"main thread = %@",[NSThread mainThread]);
//        NSLog(@"%@",x);
//    }];
    
//    
    // 2.遍历字典,遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"sun",@"age":@18};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        
        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSString *keys = x[0];
        NSString *values = x[1];
        
        NSLog(@"%@ %@",keys,values);
        NSLog(@"thread = %@",[NSThread currentThread]);
        NSLog(@"main thread = %@",[NSThread mainThread]);
        
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
        // return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        RACSignal * rSignal =[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"请求数据"];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        NSLog(@"innerSiganl = %@",rSignal);
        return rSignal;
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _command = command;
    
    // 3.订阅RACCommand中的信号
    //RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
    // 2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
    [command.executionSignals subscribeNext:^(id x) {
        
         NSLog(@"subscribe signal  %@",x);//返回signal
        [x subscribeNext:^(id x) {
            
         NSLog(@"singnal's next  %@",x);//返回signal的数据
        }];
        
    }];
    

    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {
        
        NSLog(@"switchToLast subnext: %@",x);//signal的数据
    }];
    
    // 4.监听命令是否执行完毕,默认会先触发 正在执行 x= yes，可以直接跳过，skip表示跳过第一次信号。
    [[command.executing skip:1] subscribeNext:^(id x) {
        // skip 跳过外部的信号的执行处理，只处理command内部信号，所以只执行了2次 1 ，0
        
        NSLog(@"excuting skip  xx = %@",x);
        if ([x boolValue] == YES) {
            // 正在执行
            NSLog(@"正在执行");
            
        }else{
            // 执行完成
            NSLog(@"执行完成");
        }
        
    }];
    [command.executing subscribeNext:^(id x) {
        NSLog(@"excuting next :%@",x);// 输出 0 1 0  三次
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

#pragma mark RACMulticastConnection 解决signal中每订阅subscribeNext 就触发一次信号内部subscriber的发送问题
-(void)multicast{
    // // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求---- 发送请求调用多次。
    // 解决：使用RACMulticastConnection就能解决.

    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送请求");
        // 如果是使用subject 的话，这里的subscriber是passThroughSubscriber ，
        [subscriber sendNext:@"200"];
        return nil;
    }];
    // 2.订阅信号
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
    
    /*
     2016-01-04 18:13:59.609 JFReactive[33508:4292401] 发送请求
     2016-01-04 18:13:59.609 JFReactive[33508:4292401] 接收数据
     2016-01-04 18:13:59.611 JFReactive[33508:4292401] 发送请求
     2016-01-04 18:13:59.611 JFReactive[33508:4292401] 接收数据
     */
  
   /*
  RACSignal * a =  [signal flattenMap:^RACStream *(id value) {
        return [RACSignal return:@"desc"];
    }];
   RACSignal * b = [signal flattenMap:^RACStream *(id value) {
        return [RACSignal return:@"array"];
    }];
    
    RAC(self.labelForName, text) =[[a catchTo:[RACSignal return:@"Error"]]  startWith:@"Loading..."];
    RAC(self.textField, text) = [[b catchTo:[RACSignal return:@"Error"]] startWith:@"Loading..."];
   */
    
    

    //******这里有一个很重要的概念，就是任何的信号转换即是对原有的信号进行订阅从而产生新的信号****////

    // 使用muticastConnection 替代 解决 了多个订阅，发多次请求的问题
    RACMulticastConnection *connect = [signal publish];
    
    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组，必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
     // signal 为subject --> subscriber(也是subscriber) sendNext: 
    
    
    // 生成一个subscriber。并添加到subscriber数组中
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者一信号 %@",x);
        
    }];
    
    [connect.signal subscribeNext:^(id x) {
        
        NSLog(@"订阅者二信号 %@",x);
        
    }];
    
    // 4.连接,激活信号 sourceSignal subscribe:subject
    //调用sourceSignal的didSubscribe(subject)
    // 执行createSignal的block(subject),发送信息， subject sendNext:@200
    // 无论connect.signal subscribeNext：执行多少次，didSubscribe(subject)都是执行一次，
    // connect.signal subscribeNext 仅仅是生成新的subscriber 添加到subscribers数组中
   [connect connect];// 如果先连接 不会发送subscribeNext中的信息，仅仅打印出 发送请求
    /*
     2016-01-04 18:15:07.287 JFReactive[33616:4293575] 发送请求
     2016-01-04 18:15:07.287 JFReactive[33616:4293575] 订阅者一信号
     2016-01-04 18:15:07.287 JFReactive[33616:4293575] 订阅者二信号
     */

}
#pragma mark 多个信号统一处理 初始时必须两个信号均发送成功，然后任意信号发送都会触发，发送error 都不会触发selector
- (void)multiSignalWithSelector{
    // 6.处理多个请求，都返回结果的时候，统一做处理.
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
       [subscriber sendNext:@"发送请求1"];
        
        //[subscriber sendError:nil];
        return nil;
    }];
    
    RACSignal *request2 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        // 发送请求2
        [subscriber sendNext:@"发送请求2"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [subscriber sendNext:@"发送请求2"];
        });
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
    /*
     Lazily binds a block to the values in the receiver.
     This should only be used if you need to terminate the bind early, or close over some state. -flattenMap: is more appropriate for all other cases.
     block - A block returning a RACStreamBindBlock. This block will be invoked each time the bound stream is re-evaluated. This block must not be nil or return nil.
     Returns a new stream which represents the combined result of all lazy applications of `block`
     */
    
    RACSignal *request1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 发送请求1
        [subscriber sendNext:@"发送请求1"];
        
        //[subscriber sendError:nil];
        return nil;
    }];
   RACSignal * signalC = [request1 bind:^RACStreamBindBlock{
        
        return ^RACStream *(id value, BOOL *stop){
            
            //当信号有新的值发出，就会来调用这个block。
            // 这里可以对原有subscriber send发送的值进行封装
            NSLog(@"%d",*stop);
            if ([value isEqualToString:@"fff"]) {
                *stop = YES;
            }
            // 该返回的signal 在bind方法中进行addSignal，然后调用signalC 的sendNext:
            return [RACSignal return:[NSString stringWithFormat:@"value:%@",value]];// 原值返回
        };
        
    }] ;
    [signalC subscribeNext:^(id x) {
        NSLog(@"输出XXX %@",x);///当stop = yes 后不再输出
    }];
    /*
     2016-01-04 18:35:54.731 JFReactive[33880:4304232] revoke streamBindBlock
     2016-01-04 18:35:54.731 JFReactive[33880:4304232] RacStream RetunBlock
     2016-01-04 18:35:54.731 JFReactive[33880:4304232] 输出XXX 输出:
     2016-01-04 18:36:02.587 JFReactive[33880:4304232] RacStream RetunBlock
     2016-01-04 18:36:02.587 JFReactive[33880:4304232] 输出XXX 输出:
     
     2016-01-04 18:36:04.420 JFReactive[33880:4304232] f
     2016-01-04 18:36:04.421 JFReactive[33880:4304232] RacStream RetunBlock
     2016-01-04 18:36:04.421 JFReactive[33880:4304232] 输出XXX 输出:f
     
     2016-01-04 18:36:05.736 JFReactive[33880:4304232] ff
     2016-01-04 18:36:05.736 JFReactive[33880:4304232] RacStream RetunBlock
     2016-01-04 18:36:05.737 JFReactive[33880:4304232] 输出XXX 输出:ff
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
    
    
//    [[self.textField.rac_textSignal map:^id(id value) {
//        return [NSString stringWithFormat:@"%@",value];
//    }]subscribeNext:^(id x) {
//        NSLog(@"%@",x);
//    }];
//    
    [[self.textField.rac_textSignal flattenMap:^RACStream *(id value) {
        NSLog(@"value =%@",value);
        return [RACReturnSignal return:@[[NSString stringWithFormat:@"%@",value]]];
        
    }]subscribeNext:^(id x) {
        NSLog(@"xxx = %@",x);
    }];

    /*
     
     2016-03-16 16:47:19.971 JFReactive[62795:7813928] ii
     2016-03-16 16:47:19.971 JFReactive[62795:7813928] value =ii
     2016-03-16 16:47:19.971 JFReactive[62795:7813928] xxx = (
     ii
     )
    FlatternMap和Map的区别
    
    1.FlatternMap中的Block返回信号。
    2.Map中的Block返回对象。
    3.开发中，如果信号发出的值不是信号，映射一般使用Map
    如果信号发出的值是信号，映射一般使用FlatternMap。
     
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
    /**
     Printing description of signalA: <RACDynamicSignal: 0x7fba8b695180> name:
     Printing description of signalB:<RACDynamicSignal: 0x7fba8b439390> name:
     Printing description of concatSignal:
     <RACDynamicSignal: 0x7fba8d950b20> name:

     
     */
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
       // [subscriber sendError:nil];// 如果是error 则不会有任何输出，signalB 也不会执行输出
        return nil;
    }];
    
    RACSignal *signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@"dddd"];
        return nil;
    }];
     NSLog(@" before subscriber ");
    // 合并信号,任何一个信号发送数据，都能监听到.
    RACSignal *mergeSignal = [signalA merge:signalB];
    
    [mergeSignal subscribeNext:^(id x) {
        NSLog(@" subscriber %@",x);
        
    }];
     NSLog(@" after subscriber ");
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
    RACSignal *fileSignal = [RACSignal startEagerlyWithScheduler:[RACScheduler scheduler] block:^(id subscriber) {
        NSMutableArray *filesInProgress = [NSMutableArray array];
        
        [subscriber sendNext:[filesInProgress copy]];
        [subscriber sendCompleted];
    }];

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
#pragma mark 前后文本的值有多次改变，仅仅触发最后的依次更新 distinctUntilChanged 比较数值流中当前值和上一个值，如果不同，就返回当前值，简单理解为“流”的值有变化时反馈变化的值，求异去同

- (void)distinctUntilChanged{

    [[RACObserve(self.textField, text) distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    self.textField.text = @"100";
   
//    [[_textField.rac_textSignal distinctUntilChanged] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
   
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
    [signal sendCompleted];
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
//    [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"sendNextBefor");
//        [subscriber sendNext:@1];
//        NSLog(@"sendNextafer");
//        [subscriber sendCompleted]; // 不发送 不会触发doCompleted
//        NSLog(@"sendcompleted finished");
//        return nil;
//    }] doNext:^(id x) {
//        // 执行[subscriber sendNext:@1];之前会调用这个Block
//        NSLog(@"doNext %@",x);;
//    }] doCompleted:^{
//        // 执行[subscriber sendCompleted];之前会调用这个Block
//        NSLog(@"doCompleted");;
//        
//    }] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",x);
//    }];
    
    /*
     2015-12-23 15:48:35.211 JFReactive[47589:2282095] sendNextBefor
     2015-12-23 15:48:35.212 JFReactive[47589:2282095] doNext 1
     2015-12-23 15:48:35.213 JFReactive[47589:2282095] 1
     2015-12-23 15:48:35.213 JFReactive[47589:2282095] sendNextafer
     2015-12-23 15:48:35.213 JFReactive[47589:2282095] doCompleted
     2015-12-23 15:48:35.213 JFReactive[47589:2282095] sendcompleted finished
     
     */

    [[[[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"sendNextBefor");
         NSLog(@"curretnThread1 =%@",[NSThread currentThread]);
        [subscriber sendNext:@1];
        NSLog(@"sendNextafer");
        [subscriber sendCompleted]; // 不发送 不会触发doCompleted
        NSLog(@"sendcompleted finished");
        NSLog(@"curretnThread4 =%@",[NSThread currentThread]);
        return nil;
    }]map:^id(id value) {
        NSLog(@"map 222");
         NSLog(@"map2 curretnThread =%@",[NSThread currentThread]);
        return @100;
    } ]deliverOn:[RACScheduler scheduler]] map:^id(id value) {
        NSLog(@"curretnThread2 =%@",[NSThread currentThread]);
        return @"123";
    }]deliverOn:[RACScheduler scheduler]]subscribeNext:^(id x) {
        NSLog(@"curretnThread3 =%@",[NSThread currentThread]);
    }];
/*
 2016-04-26 20:29:59.616 JFReactive[10763:360103] create subscribers = <RACSubscriber: 0x7f8241d2d930>
 2016-04-26 20:29:59.617 JFReactive[10763:360103] sendNextBefor
 2016-04-26 20:29:59.617 JFReactive[10763:360103] curretnThread1 =<NSThread: 0x7f8241c03a20>{number = 1, name = main}
 2016-04-26 20:29:59.618 JFReactive[10763:360103] sendNextafer
 2016-04-26 20:29:59.619 JFReactive[10763:360103] sendcompleted finished
 2016-04-26 20:29:59.619 JFReactive[10763:361395] curretnThread2 =<NSThread: 0x7f8241c7d810>{number = 6, name = (null)}
 2016-04-26 20:29:59.620 JFReactive[10763:361395] curretnThread3 =<NSThread: 0x7f8241c7d810>{number = 6, name = (null)}

 */
}

/////////************************** 时间 ************************************/////////

- (void)signalTime{
    
    // timeout：超时，可以让一个信号在一定的时间后，自动报错。
     
     RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
     return nil;
     }] timeout:1 onScheduler:[RACScheduler currentScheduler]];
     
     [signal subscribeNext:^(id x) {
     
     NSLog(@"%@",x);
     } error:^(NSError *error) {
     // 1秒后会自动调用
     NSLog(@"%@",error);
     }];
    // interval 定时：每隔一段时间发出信号
     
     [[RACSignal interval:1 onScheduler:[RACScheduler currentScheduler]] subscribeNext:^(id x) {
     
     NSLog(@"%@",x);
     }];
    // delay 延迟发送next。
     
//     RACSignal *signal = [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//     
//     [subscriber sendNext:@1];
//     return nil;
//     }] delay:2] subscribeNext:^(id x) {
//     
//     NSLog(@"%@",x);
//     }];

     
    
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
     2016-02-19 11:14:25.359 JFReactive[26455:2201124] xx =0
     2016-02-19 11:14:37.216 JFReactive[26455:2201124] xx =1
     2016-02-19 11:16:21.597 JFReactive[26455:2201124] input =<UIButton: 0x7f9d2bd6fc60; frame = (93 330; 151 30); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x7f9d2bd6bcc0>>     */
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
    RACSignal * signal = [[[[RACSignal interval:0.1 onScheduler:[RACScheduler scheduler]]map:^id(id value) {
        return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [subscriber sendNext:@(index++)];
            [subscriber sendCompleted];
            return nil;
        }] doNext:^(id x) {
            NSLog(@"do next =%@",x);
        }];
    }]take:2]switchToLatest];
    
    [signal subscribeNext:^(id value) {
        NSLog(@"pinID:%@", value);
    } completed:^{
        NSLog(@"completed");
    }];
    
    
    /*
     take 2  表示只取两次
     2016-02-19 11:30:28.733 JFReactive[26589:2208108] do next =0
     2016-02-19 11:30:28.733 JFReactive[26589:2208108] pinID:0
     2016-02-19 11:30:28.833 JFReactive[26589:2208102] do next =1
     2016-02-19 11:30:28.833 JFReactive[26589:2208102] pinID:1
     2016-02-19 11:30:28.834 JFReactive[26589:2208102] completed
     
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
-(void)requestTwice{
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
    //Subscribes to the returned signal when an error occurs.
    
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
        }]concat:requestSignal];//在发送成功后再追加一个信号 依次执行信号,
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
-(void)retry{
   __block int flag = 0;
    
  RACSignal *signal =  [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      
       if (flag == 4){
        [subscriber sendNext:@"1"];
        [subscriber sendCompleted];
        }else{
            flag ++;
            NSLog(@"flag= %d",flag);
            [subscriber sendError:[NSError errorWithDomain:@"myerror " code:100 userInfo:nil]];
        }
      return nil;
    }];
    [[signal retry:5]subscribeNext:^(id x) {
        NSLog(@"xxxx =%@",x);
    }];
    
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
#pragma mark 节流  如果上个next 在规定的interval 内没有返回，这时下一个next 已发送，就会放弃上个next
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
        //模拟login signal
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
//    [self.loginCommand.executionSignals.switchToLatest subscribeNext:^(id x) {
//        NSLog(@"xx =%@",x);
//    }];
    // Executes the login command when the button is pressed. 按钮点击触发
    self.shareBtn.rac_command = self.loginCommand;
}
-(void)subcribeCompleted{
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
        NSLog(@"loginSiganl...");
        [subscriber sendNext:@[@"1000"]];
        
        [subscriber sendCompleted];
        return nil;
    }];
    return siga;
}
-(RACSignal*)loadCachedMessagesForUser:(NSString*)user{
    RACSignal *siga = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        [subscriber sendNext:@[@"11111"]];
        
        [subscriber sendCompleted];
        return nil;
    }];
    return siga;
}
-(RACSignal*)fetchMessagesAfterMessage:(NSString*)arr{
    RACSignal *siga = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       
        [subscriber sendNext:@[@"1",@"2"]];
       
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
           NSLog(@"user == %@",user);
           return [self loadCachedMessagesForUser:user];
       }]
      flattenMap:^(NSArray *messages) {
          NSLog(@"messages =%@",messages);
          // Return a signal that fetches any remaining messages.
          return [self fetchMessagesAfterMessage:messages.lastObject];
      }]
     subscribeNext:^(NSArray *newMessages) {
         NSLog(@"New messages: %@", newMessages);
     } completed:^{
         NSLog(@"Fetched all messages.");
     }];
    /*
     2016-02-22 15:13:04.233 JFReactive[30740:2526738] loginSiganl...
     2016-02-22 15:13:04.233 JFReactive[30740:2526738] user == (
     1000
     )
     2016-02-22 15:13:04.234 JFReactive[30740:2526738] messages =(
     11111
     )
     2016-02-22 15:13:04.234 JFReactive[30740:2526738] New messages: (
     1,
     2
     )
     2016-02-22 15:13:04.234 JFReactive[30740:2526738] Fetched all messages.
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

    [[[[self loginSignal]// 1
       then:^{
           NSLog(@"then....");
           return [self fetchMessagesAfterMessage:@"d"]; //
       }]
      flattenMap:^(NSArray *messages) {
          NSLog(@"messages =%@",messages);
          return [self loadCachedMessagesForUser:messages.lastObject];//
      }]
     subscribeError:^(NSError *error) {
         NSLog(@"error....");
     } completed:^{
         NSLog(@"Fetched all messages.");
     }];
 
    /*
     2016-02-19 16:37:18.804 JFReactive[28625:2333701] then....
     2016-02-19 16:37:18.804 JFReactive[28625:2333701] messages =(
     1,
     2
     )
     2016-02-19 16:37:18.805 JFReactive[28625:2333701] Fetched all messages.
     */
    
   
    
    
}
-(void)testSubscriber{
    // signal 只要是subscribe就是热信号了，只是没有接受输出而已
    RACSignal *siga = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"__%s",__func__);
        [subscriber sendNext:@[@"1",@"2"]];
        
        NSLog(@"inc=voke ok %s ",__func__);
        [subscriber sendCompleted];
        return nil;
    }];
    RACSubject *subject = [RACSubject subject];
    [siga subscribe:subject];
    /*
     2016-01-05 16:27:35.231 JFReactive[37914:4473663] ____32-[ViewController testSubscriber]_block_invoke
     2016-01-05 16:27:35.231 JFReactive[37914:4473663] inc=voke ok __32-[ViewController testSubscriber]_block_invoke
     */
}
-(void)testSubject{
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"Cold signal be subscribed.");
        [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{
            [subscriber sendNext:@"A"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{
            [subscriber sendNext:@"B"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    
    RACSubject *subject = [RACSubject subject];
    NSLog(@"Subject created.");
    
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{
        [coldSignal subscribe:subject];
    }];
    
    [subject subscribeNext:^(id x) {
        NSLog(@"Subscriber 1 recieve value:%@.", x);
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 recieve value:%@.", x);
        }];
    }];
     
}

#pragma mark 冷信号被订阅 就会变成热信号 其余的工作让subject 来干
-(void)coldSignalSubscribeSubject{
    RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"Cold signal be subscribed.");
        NSLog(@"subscriber = %@",subscriber);//RACPassthroughSubscriber
        [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{// 4 这个时间是步骤3的基础上进行的
            [subscriber sendNext:@"A"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{ // 6
            [subscriber sendNext:@"B"];
        }];
        
        [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{ // 7
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
    
    RACSubject *subject = [RACSubject subject];
    NSLog(@"Subject created."); // 1
    
    [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{ // 3
        NSLog(@" coldSignal subscribe");
        [coldSignal subscribe:subject];//将subject作为了coldSignal的subscriber,coldSignal调用，此步调用后才会执行上面的subscriber()
    }];
    
    [subject subscribeNext:^(id x) { // 2
        NSLog(@"Subscriber 1 recieve value:%@.", x);
    }];
    
    [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{ // 5
        [subject subscribeNext:^(id x) {
            NSLog(@"Subscriber 2 recieve value:%@.", x);
        }];
    }];
    /*
     2016-04-22 22:34:34.031 JFReactive[933:25360] Subject created.
     2016-04-22 22:34:34.032 JFReactive[933:25360] create subscribers = <RACSubscriber: 0x7f8f91f089d0>
     2016-04-22 22:34:36.215 JFReactive[933:25360]  coldSignal subscribe
     2016-04-22 22:34:36.216 JFReactive[933:25360] Cold signal be subscribed.
     2016-04-22 22:34:36.216 JFReactive[933:25360] subscriber = <RACPassthroughSubscriber: 0x7f8f91c15860>
     2016-04-22 22:34:37.771 JFReactive[933:25360] Subscriber 1 recieve value:A.
     2016-04-22 22:34:38.324 JFReactive[933:25360] create subscribers = <RACSubscriber: 0x7f8f91cbc6d0>
     2016-04-22 22:34:39.512 JFReactive[933:25360] Subscriber 1 recieve value:B.
     2016-04-22 22:34:39.513 JFReactive[933:25360] Subscriber 2 recieve value:B.     */
}

#pragma mark RAC(a,b) 宏的使用  给RAC()绑定一个信号后 会自动触发 signal 的didSubsribeBlock 不必subscribeNext:
-(void)RACMicro{
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      
        [subscriber sendNext:@"dddd"];// 如果 注释掉subscribeNext就不会发送
        [subscriber sendCompleted];
      
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    //表示的意义是将一个对象的一个属性和一个signal绑定，signal每产生一个value（id类型），都会自动执行：
    RAC(self.labelForName,text) = signal;// 绑定之后会触发signal 的subscribeNext:
    /*
     参考：宏RAC_()    [[RACSubscriptingAssignmentTrampoline alloc] initWithTarget:(TARGET) nilValue:(NILVALUE)][@keypath(TARGET, KEYPATH)]
     See -[RACSignal setKeyPath:onObject:nilValue:] for more information about the
     /// binding's semantics.
     */
    
}
#pragma mark 订阅一个selector ,当selector发生后，会自动发送sendNext:   mapReplace替换原信号的值
-(void)subscribeSelector{
    RACSignal *presented = [self rac_signalForSelector:@selector(shareAction:)] ;
    [presented subscribeNext:^(id x) {
        NSLog(@"subscriberSelector %@",x);
        /* 
         button对象
         
         2016-05-23 17:14:19.259 JFReactive[17519:244512] subscriberSelector <RACTuple: 0x7fc9f84c5270> (
         "<UIButton: 0x7fc9f8554c20; frame = (93 330; 151 30); opaque = NO; autoresize = RM+BM; layer = <CALayer: 0x7fc9f8554fd0>>"
         )
         */
    }];
}


- (void)subScribeSingle{
 
    self.textField.text = [self getText];
      self.imageView.image = [UIImage imageNamed:@"img"];
}
- (IBAction)shareAction:(id)sender {
   // [self distinctUntilChanged];
     NSLog(@" before share %@",@"");
   [self bind];
   
    [self.navigationController setHidesBarsOnTap:YES];
    //  [self asychronize];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"view will appear");
//    [[[self.shareBtn
//       rac_signalForControlEvents:UIControlEventTouchUpInside]
//      map:^id(id x){//改为flattenMap
//          NSLog(@"xxx = %@",x);// button 对象
//          return @"d";
//      }]
//     subscribeNext:^(id x){
//         NSLog(@"Sign in result: %@", x);
//     }];
    // [self btnAvliableWhenImgOK];

}
-(NSString*)getText{
    return self.otherField.text;
}
//change field action
-(IBAction)changeField:(id)sender{
   

}
-(void)signalReplay{
    __block int num = 0;
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id  subscriber) {
        num++;
        NSLog(@"Increment num to: %i", num);
        [subscriber sendNext:@(num)];
        return nil;
    }] replay]; // 返回的信号是RACReplaySubject
    
    NSLog(@"Start subscriptions");
    
    // Subscriber 1 (S1)
    [signal subscribeNext:^(id x) {
        NSLog(@"S1: %@", x);
    }];
    
    // Subscriber 2 (S2)
    [signal subscribeNext:^(id x) {
        NSLog(@"S2: %@", x);
    }];
    
    // Subscriber 3 (S3)
    [signal subscribeNext:^(id x) {
        NSLog(@"S3: %@", x);
    }];
    
    /*
     Increment num to: 1
     Start subscriptions
     S1: 1
     S2: 1
     S3: 1
     */
}

@end

