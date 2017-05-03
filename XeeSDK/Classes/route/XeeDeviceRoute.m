//
//  XeeDeviceRoute.m
//  XeeSDK
//
//  Created by Anthony Pauriche on 22/08/2016.
//  Copyright © 2016 Eliocity. All rights reserved.
//

#import "XeeDeviceRoute.h"

@implementation XeeDeviceRoute

-(void)signalsWithDeviceId:(NSString*)deviceId limit:(NSInteger)limit begin:(NSDate *)begin end:(NSDate *)end name:(NSArray<NSString *> *)name completionHandler:(void (^)(NSArray<XeeSignal *> *, NSArray<XeeError *> *))completionHandler {
    NSString *beginString = stringWithRFC3339Date(begin);
    NSString *endString = stringWithRFC3339Date(end);
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
    NSString *urlString = [NSString stringWithFormat:@"devices/%@/signals%@%@", deviceId, dic.count > 0 ? @"?" : @"", params];
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

-(void)deviceStatusWithDeviceId:(NSString *)deviceId completionHandler:(void (^)(XeeDeviceStatus *, NSArray<XeeError *> *))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"devices/%@/status", deviceId];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            XeeDeviceStatus *deviceStatus = [XeeDeviceStatus withJSON:JSON];
            completionHandler(deviceStatus, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)associateDeviceId:(NSString*)deviceId withCar:(NSString*)carId completionHandler:(void (^)(NSArray<XeeError *> *errors))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"devices/%@/associate?carId=%@", deviceId, carId];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"POST" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        completionHandler(errors);
    }] resume];
}

-(void)associateDeviceId:(NSString*)deviceId withPin:(NSString*)pin completionHandler:(void (^)(NSArray<XeeError *> *errors))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"devices/%@/associate?pin=%@", deviceId, pin];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"POST" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        completionHandler(errors);
    }] resume];
}

-(void)dissociateDeviceWithId:(NSString*)deviceId completionHandler:(void (^)(NSArray<XeeError *> *errors))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"devices/%@/dissociate", deviceId];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"POST" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        completionHandler(errors);
    }] resume];
}

@end
