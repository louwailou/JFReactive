//
//  FirstInterfaceModel.m
//  JFReactive
//
//  Created by Sun on 16/4/28.
//  Copyright © 2016年 Sun. All rights reserved.
//

#import "FirstInterfaceModel.h"

/*
 {
 base = stations;
 clouds =     {
 all = 0;
 };
 cod = 200;
 coord =     {
 lat = "39.98";
 lon = "116.3";
 };
 dt = 1461836507;
 id = 1809104;
 main =     {
 humidity = 33;
 pressure = 1011;
 temp = "299.03";
 "temp_max" = "302.04";
 "temp_min" = "297.15";
 };
 name = Haidian;
 sys =     {
 country = CN;
 id = 7405;
 message = "0.01";
 sunrise = 1461791894;
 sunset = 1461841611;
 type = 1;
 };
 visibility = 10000;
 weather =     (
 {
 description = "clear sky";
 icon = 01d;
 id = 800;
 main = Clear;
 }
 );
 wind =     {
 deg = 150;
 speed = 6;
 };
 }
 
 */



@implementation FirstInterfaceModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    NSMutableDictionary *mutDic = [[NSDictionary mtl_identityPropertyMapWithModel:[self class]] mutableCopy];
    /*
     lldb) po mutDic
     {
     arrWeathers = arrWeathers;
     cod = cod;
     date = date;
     humidity = humidity;
     name = name;
     sys = sys;
     temperature = temperature;
     xxxTestStr = xxxTestStr;
     }
     */
    [mutDic setObject:@"dt"forKey:@"date"];
    
    [mutDic setObject:@"main.humidity"forKey:@"humidity"];
    
    [mutDic setObject:@"main.temp"forKey:@"temperature"];
    
    [mutDic setObject:@"weather"forKey:@"weathers"];
    
    return mutDic;
    
}
+ (NSValueTransformer *)codJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value,BOOL *success, NSError*__autoreleasing *error) {
        
        NSNumber *num = value;
        
        NSString *tempStr = [NSString stringWithFormat:@"%@", num];
        
        return tempStr;
        
    } reverseBlock:^id(id value,BOOL *success, NSError *__autoreleasing *error) {
        
        NSString *tempStr = value;
        
        NSNumber *tempNum = @(tempStr.integerValue);
        
        return tempNum;
        
    }];
    
}


+ (NSValueTransformer *)dateJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value,BOOL *success, NSError*__autoreleasing *error) {
        
        NSNumber *dateNum = (NSNumber *)value;
        
        return [NSDate dateWithTimeIntervalSince1970:dateNum.floatValue];
        
    } reverseBlock:^id(id value,BOOL *success, NSError *__autoreleasing *error) {
        
        NSDate *numDate = (NSDate *)value;
        
        return [NSString stringWithFormat:@"%f", [numDate timeIntervalSince1970]];
        
    }];
    
}


//5. 附一个model内嵌model的实现, 注意和上面最初的类型一样，是一个sysModel.class.
//
+ (NSValueTransformer *)sysJSONTransformer {
    
   return [MTLJSONAdapter dictionaryTransformerWithModelClass:SysModel.class];


}

//然后就会得到一个内嵌的sysModel对象。

//6. 再加上一个数组的对象。服务器返回的weather是一个数组， 然后数组中的对象是WeatherModel.

+ (NSValueTransformer *)weathersJSONTransformer {
    //NSLog(@"arrWeather = %@",[MTLJSONAdapter arrayTransformerWithModelClass:WeatherModel.class]);
    return [MTLJSONAdapter arrayTransformerWithModelClass:WeatherModel.class];
    
}


//7. 再来一个安全方法。如果我们要求其中的cod不能为空，我们就可以实现下面这个方法，来对当其中有数据为空时，进行一个容错处理。下面这个方法，当服务器有返回数据为null的键值时，而本地又对这个键做了属性匹配时，就会调用下面这个方法，一般情况下可能会崩溃， 所以建议如果有一些重要的不能为null的键，可以在这里进行处理。

- (void)setNilValueForKey:(NSString *)key {
    
    NSLog(@"nil value detect for key=%@", key);
    
    
    if ([key isEqualToString:@"cod"]) {
        
        [self setValue:@"something"forKey:@"cod"];
        
    }else {
        
        [super setNilValueForKey:key];
        
    }
    
}
- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;
    
    // Store a value that needs to be determined locally upon initialization.
   
    
    return self;
}

//注意这个方法仅对非指针类型有用，即int float, bool等， 其它类型要想容错[NSNull null]， 需要在MTLValueTransformertransformerUsingForwardBlock中进行识别处理。
@end

@implementation SysModel
/**
 *
 "type": 1,
 "id": 7405,
 "message": 0.0126,
 "country": "CN",
 "sunrise": 1461791897,
 "sunset": 1461841609


@property (nonatomic,copy) NSString * sys_type;
@property (nonatomic,copy) NSString * sys_id;
@property (nonatomic,copy) NSString * sys_message;
@property (nonatomic,copy) NSString * sys_country;
@property (nonatomic,copy) NSString * sys_sunrise;
@property (nonatomic,copy) NSString * sys_sunset;
 *

 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{@"sys_id":@"id",@"sys_type":@"type",@"sys_message":@"message",@"sys_country":@"country",@"sys_sunrise":@"sunrise",@"sys_sunset":@"sunset"};
}
+ (NSValueTransformer*)JSONTransformerForKey:(NSString *)key{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if (![value isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",value];
        }else
            return value;
        
    }];
}
@end

@implementation WeatherModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
 
    return @{@"weather_id":@"id",@"weather_main":@"main",@"weather_description":@"description",@"weather_icon":@"icon"};
}
// 将所有属于int 或者整形的value 包装为string，因为在.h文件声明的就是string，不然一个解析不出来就影响全部的，就返回nil
+ (NSValueTransformer*)JSONTransformerForKey:(NSString *)key{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if (![value isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"%@",value];
        }else
            return value;
        
    }];
}
@end



/*
 "rows":[
 [
 {
 "text":"text1",
 "icon" : "icon",
 "link" : "http://link"
 }
 ],
 [
 {
 "text":"text2",
 "icon" : "icon",
 "link" : "http://link"
 }
 ]
 
 ]
 
 
 
 + (NSValueTransformer *)allRowsJSONTransformer
 {
 return [MTLValueTransformer transformerWithBlock:^id(NSArray *inSectionJSONArray) {
 NSMutableArray *sectionArray = [[NSMutableArray alloc] initWithCapacity:inSectionJSONArray.count];
 for( NSArray *section in inSectionJSONArray )
 {
 NSError *error;
 NSArray *cardItemArray = [MTLJSONAdapter modelsOfClass:[CKMCardItem class] fromJSONArray:section error:&error];
 if( cardItemArray != nil )
 {
 [sectionArray addObject:cardItemArray];
 }
 }
 return sectionArray;
 }];
 }
*/