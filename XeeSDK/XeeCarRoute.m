/*
 * Copyright 2016 Eliocity
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "XeeCarRoute.h"

@implementation XeeCarRoute

-(void)carWithCarId:(uint)carId completionHandler:(void (^)(XeeCar *, NSArray<XeeError *> *))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"cars/%d", carId];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            XeeCar *car = [XeeCar withJSON:JSON];
            completionHandler(car, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)statusWithCarId:(uint)carId completionHandler:(void (^)(XeeCarStatus *, NSArray<XeeError *> *))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"cars/%d/status", carId];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            XeeCarStatus *carStatus = [XeeCarStatus withJSON:JSON];
            completionHandler(carStatus, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)locationsWithCarId:(uint)carId limit:(NSInteger)limit begin:(NSDate *)begin end:(NSDate *)end completionHandler:(void (^)(NSArray<XeeLocation *> *, NSArray<XeeError *> *))completionHandler {
    NSString *beginString = [[NSDateFormatter RFC3339DateFormatter] stringFromDate:begin];
    NSString *endString = [[NSDateFormatter RFC3339DateFormatter] stringFromDate:end];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(limit != 0) {
        [dic setValue:@(limit) forKey:@"limit"];
    }
    if(![beginString isEqualToString:@""]) {
        [dic setValue:beginString forKey:@"begin"];
    }
    if(![endString isEqualToString:@""]) {
        [dic setValue:endString forKey:@"end"];
    }
    NSString *params = [client createHTTPParamsWithDictionary:dic];
    NSString *urlString = [NSString stringWithFormat:@"cars/%d/locations%@%@", carId, dic.count > 0 ? @"?" : @"", params];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *locations = [NSMutableArray array];
            for(NSDictionary *locationJSON in JSON) {
                [locations addObject:[XeeLocation withJSON:locationJSON]];
            }
            completionHandler(locations, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)locationsGeoJSONWithCarId:(uint)carId limit:(NSInteger)limit begin:(NSDate *)begin end:(NSDate *)end completionHandler:(void (^)(NSArray *, NSArray<XeeError *> *))completionHandler {
    NSString *beginString = [[NSDateFormatter RFC3339DateFormatter] stringFromDate:begin];
    NSString *endString = [[NSDateFormatter RFC3339DateFormatter] stringFromDate:end];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(limit != 0) {
        [dic setValue:@(limit) forKey:@"limit"];
    }
    if(![beginString isEqualToString:@""]) {
        [dic setValue:beginString forKey:@"begin"];
    }
    if(![endString isEqualToString:@""]) {
        [dic setValue:endString forKey:@"end"];
    }
    NSString *params = [client createHTTPParamsWithDictionary:dic];
    NSString *urlString = [NSString stringWithFormat:@"cars/%d/locations.geojson%@%@", carId, dic.count > 0 ? @"?" : @"", params];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSArray *locations = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            completionHandler(locations, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)signalsWithCarId:(uint)carId limit:(NSInteger)limit begin:(NSDate *)begin end:(NSDate *)end name:(NSArray<NSString *> *)name completionHandler:(void (^)(NSArray<XeeSignal *> *, NSArray<XeeError *> *))completionHandler {
    NSString *beginString = [[NSDateFormatter RFC3339DateFormatter] stringFromDate:begin];
    NSString *endString = [[NSDateFormatter RFC3339DateFormatter] stringFromDate:end];
    NSString *nameString = [client createURLEncodedStringWithCommaWithArray:name];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(limit != 0) {
        [dic setValue:@(limit) forKey:@"limit"];
    }
    if(![beginString isEqualToString:@""]) {
        [dic setValue:beginString forKey:@"begin"];
    }
    if(![endString isEqualToString:@""]) {
        [dic setValue:endString forKey:@"end"];
    }
    if(![nameString isEqualToString:@""]) {
        [dic setValue:nameString forKey:@"name"];
    }
    NSString *params = [client createHTTPParamsWithDictionary:dic];
    NSString *urlString = [NSString stringWithFormat:@"cars/%d/signals%@%@", carId, dic.count > 0 ? @"?" : @"", params];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *signals = [NSMutableArray array];
            for(NSDictionary *signalJSON in JSON) {
                [signals addObject:[XeeSignal withJSON:signalJSON]];
            }
            completionHandler(signals, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)tripsWithCarId:(uint)carId begin:(NSDate *)begin end:(NSDate *)end completionHandler:(void (^)(NSArray<XeeTrip *> *, NSArray<XeeError *> *))completionHandler {
    NSString *beginString = [[NSDateFormatter RFC3339DateFormatter] stringFromDate:begin];
    NSString *endString = [[NSDateFormatter RFC3339DateFormatter] stringFromDate:end];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(![beginString isEqualToString:@""]) {
        [dic setValue:beginString forKey:@"begin"];
    }
    if(![endString isEqualToString:@""]) {
        [dic setValue:endString forKey:@"end"];
    }
    NSString *params = [client createHTTPParamsWithDictionary:dic];
    NSString *urlString = [NSString stringWithFormat:@"cars/%d/trips%@%@", carId, dic.count > 0 ? @"?" : @"", params];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSArray *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *trips = [NSMutableArray array];
            for(NSDictionary *tripJSON in JSON) {
                [trips addObject:[XeeTrip withJSON:tripJSON]];
            }
            completionHandler(trips, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

@end
