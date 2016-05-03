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

   
}

-(void)request{
    
    NSURL *url = [NSURL URLWithString:@"http://api.openweathermap.org/data/2.5/weather?lat=40.101159&lon=116.275260&appid=e85d42a3899e3566035a1455f3f84cea"];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
     
                                       queue:[NSOperationQueue mainQueue]
     
                           completionHandler:^(NSURLResponse* response,NSData* data, NSError* connectionError){
                               
                               if (!connectionError) {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingMutableContainers error:nil];
                                   //将JSON数据和Model的属性进行绑定
                                   
                                   FirstInterfaceModel *model = [MTLJSONAdapter modelOfClass:[FirstInterfaceModel class] fromJSONDictionary:dict error:nil];
                                   
                                  
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
