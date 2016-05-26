//
//  JFMantleController.m
//  JFReactive
//
//  Created by Sun on 16/4/28.
//  Copyright © 2016年 Sun. All rights reserved.
//
/*
 "coord": {
 "lon": 116.3,
 "lat": 39.98
 },
 "weather": [
 {
 "id": 800,
 "main": "Clear",
 "description": "clear sky",
 "icon": "01d"
 }
 ],
 "base": "cmc stations",
 "main": {
 "temp": 299.82,
 "pressure": 1011,
 "humidity": 31,
 "temp_min": 298.15,
 "temp_max": 303.15
 },
 "wind": {
 "speed": 6,
 "deg": 160
 },
 "clouds": {
 "all": 0
 },
 "dt": 1461833866,
 "sys": {
 "type": 1,
 "id": 7405,
 "message": 0.0126,
 "country": "CN",
 "sunrise": 1461791897,
 "sunset": 1461841609
 },
 "id": 1809104,
 "name": "Haidian",
 "cod": 200
 }
 
 */
#import "JFMantleController.h"
#import "FirstInterfaceModel.h"
#import "Xtrace.h"

@interface JFMantleController ()
@property (nonnull,strong) UIView *mainView;
@property (nonnull,strong) UIView *redView;
@end
@implementation JFMantleController
-(void)viewDidLoad{
    [super viewDidLoad];
    
    
    //http://api.openweathermap.org/data/2.5/weather?lat=40.101159&lon=116.275260&appid=e85d42a3899e3566035a1455f3f84cea
    
   // http://apistore.baidu.com/microservice/weather?citypinyin=beijing
    
    /*
     {
     "errNum": 0,
     "errMsg": "success",
     "retData": {
     "city": "北京",
     "pinyin": "beijing",
     "citycode": "101010100",
     "date": "16-04-28",
     "time": "11:00",
     "postCode": "100000",
     "longitude": 116.391,
     "latitude": 39.904,
     "altitude": "33",
     "weather": "多云",
     "temp": "26",
     "l_tmp": "13",
     "h_tmp": "26",
     "WD": "南风",
     "WS": "3-4级(10~17km/h)",
     "sunrise": "05:17",
     "sunset": "19:05"
     }
     }
     */
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self request];
[self.navigationController setHidesBarsOnTap:YES];
    [self addView];
   
}
static int  count = 0;
- (void)hideNav:(UIGestureRecognizer*)ges{
    NSLog(@" mainframe = %@",NSStringFromCGRect(_mainView.frame));
    NSLog(@" mainframebound = %@",NSStringFromCGRect(_mainView.bounds));
    
    for (UIView * view  in self.mainView.subviews) {
        NSLog(@" subviewFrame = %@",NSStringFromCGRect(view.frame));
        NSLog(@" subviewBiound = %@",NSStringFromCGRect(view.bounds));
    }

    if (count %2 == 0) {
       
    }else{
        CGRect origin = self.mainView.bounds;
        origin.origin = CGPointMake(count*10 + 50,count*10 + 100);
       self.mainView.bounds = origin;
       
    }
    count ++;
    CGAffineTransform  transform = self.mainView.transform;
   self.mainView.transform = CGAffineTransformRotate(transform,M_PI_4);
    NSLog(@"after mainframe = %@",NSStringFromCGRect(_mainView.frame));
    NSLog(@"after mainframebound = %@",NSStringFromCGRect(_mainView.bounds));
    
    for (UIView * view  in self.mainView.subviews) {
        NSLog(@"after subviewFrame = %@",NSStringFromCGRect(view.frame));
        NSLog(@"after subviewBiound = %@",NSStringFromCGRect(view.bounds));
    }
    
    CGAffineTransform  transform2 = self.mainView.transform;
    self.redView.transform = CGAffineTransformRotate(transform2,M_PI_4);
   
}

- (void)addView{
    self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_mainView];
    UITapGestureRecognizer *re = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideNav:)];
    [_mainView addGestureRecognizer:re];
    [re setNumberOfTapsRequired:1];
    // 父view的 bounds 改变不会影响到子类
    
    [_mainView setBackgroundColor:[UIColor redColor]];
    
  
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(150, 160, 150, 200)];
    self.redView.backgroundColor = [UIColor colorWithRed:0.494 green:0.827
                                                 blue:0.129 alpha:1];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(40, 400, 200, 150)];
    blueView.backgroundColor = [UIColor colorWithRed:0.29 green:0.564
                                                blue:0.886 alpha:1];
    
    UIView *yellowView = [[UIView alloc] initWithFrame:CGRectMake(100, 600, 180, 150)];
    yellowView.backgroundColor = [UIColor colorWithRed:0.972 green:0.905
                                                  blue:0.109 alpha:1]; 
    
    [_mainView addSubview:_redView];
 
    [_mainView addSubview:blueView];
    [_mainView addSubview:yellowView];
}
-(void)request{
    
    NSURL *url = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?lat=40.101159&lon=116.275260&appid=e85d42a3899e3566035a1455f3f84cea"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
     
                                       queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse* response,NSData* data, NSError* connectionError){
                               
                               if (!connectionError) {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:nil];
                                   //将JSON数据和Model的属性进行绑定
                                   NSMutableDictionary * dc = [[NSMutableDictionary alloc] initWithDictionary:dict];
                                   [dc setObject:@[@"1",@"2",@"3"] forKey:@"datas"];
                                    [Xtrace traceBundleContainingClass:[MTLJSONAdapter class]];
                                   FirstInterfaceModel *model = [MTLJSONAdapter modelOfClass:[FirstInterfaceModel class] fromJSONDictionary:dc error:nil];
                                   
                                  
                                   NSLog(@"dict=%@\nmodel:%@",dict, model);
                                   /*
                                    2016-05-03 18:18:07.401 JFReactive[6873:264447] log dic ={
                                    cod = 200;
                                    date = "2016-05-03 10:01:36 +0000";
                                    humidity = 9;
                                    name = Haidian;
                                    sys = "<SysModel: 0x7f9683079860> {\n    \"sys_country\" = CN;\n    \"sys_id\" = 7405;\n    \"sys_message\" = \"0.0124\";\n    \"sys_sunrise\" = 1462223519;\n    \"sys_sunset\" = 1462273914;\n    \"sys_type\" = 1;\n}";
                                    temperature = "300.05";
                                    weathers =     (
                                    "<WeatherModel: 0x7f9680c4cc20> {\n    \"weather_description\" = \"clear sky\";\n    \"weather_icon\" = 01d;\n    \"weather_id\" = 800;\n    \"weather_main\" = Clear;\n}"
                                    );
                                    }
                                    */
                                   
                                   
                                   NSError *testError =nil;
                                   
                                     NSDictionary *dicFromModel = [MTLJSONAdapter JSONDictionaryFromModel:model error:&testError];
                                    
                                    if (testError ==nil) {
                                    
                                    NSLog(@"after convert dic=%@", dicFromModel);
                                    
                                    }else {
                                    
                                    NSLog(@"after convert dic failed");
                                    
                                    }
                                   
                                   
                               }
                               
                           }];
}
@end
