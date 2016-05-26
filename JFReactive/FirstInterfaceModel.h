//
//  FirstInterfaceModel.h
//  JFReactive
//
//  Created by Sun on 16/4/28.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import <Mantle/Mantle.h>
@interface SysModel:MTLModel<MTLJSONSerializing>
/**
 "type": 1,
 "id": 7405,
 "message": 0.0126,
 "country": "CN",
 "sunrise": 1461791897,
 "sunset": 1461841609
 */

@property (nonatomic,copy) NSString * sys_type;
@property (nonatomic,copy) NSString * sys_id;
@property (nonatomic,copy) NSString * sys_message;
@property (nonatomic,copy) NSString * sys_country;
@property (nonatomic,copy) NSString * sys_sunrise;
@property (nonatomic,copy) NSString * sys_sunset;
@end

@interface WeatherModel : MTLModel<MTLJSONSerializing>
/**
 *  
 "id": 800,
 "main": "Clear",
 "description": "clear sky",
 "icon": "01d"
 */
@property (nonatomic,copy) NSString * weather_id;
@property (nonatomic,copy) NSString * weather_main;
@property (nonatomic,copy) NSString * weather_description;
@property (nonatomic,copy) NSString * weather_icon;

@end


@interface FirstInterfaceModel : MTLModel <MTLJSONSerializing>

@property (nonatomic,strong) NSDate *date;

@property (nonatomic,strong) NSNumber *humidity;

@property (nonatomic,strong) NSNumber *temperature;

@property (nonatomic,strong) NSString *cod;

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *xxxTestStr;

@property (nonatomic,strong) NSArray *weathers;//

@property (nonatomic,copy) NSString * country;

@property (nonatomic,strong) SysModel *sys;

@property (nonatomic,strong) NSArray *datas;
@end
