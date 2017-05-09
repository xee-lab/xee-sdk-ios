//
//  XeeDeviceRoute.m
//  XeeSDK
//
//  Created by Anthony Pauriche on 22/08/2016.
//  Copyright © 2016 Eliocity. All rights reserved.
//

#import "XeeDeviceRoute.h"

@implementation XeeDeviceRoute

-(void)signalsWithDeviceId:(NSString*)deviceId
                     limit:(NSNumber *)limit
                     begin:(NSDate *)begin
                       end:(NSDate *)end
                      name:(NSArray<NSString *> *)name
         completionHandler:(void (^)(NSArray<XeeSignal *> *, NSError *))completionHandler {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (begin) {
        [params setObject:[[NSDateFormatter RFC3339DateFormatter] stringFromDate:begin] forKey:@"begin"];
    }
    if (end) {
        [params setObject:[[NSDateFormatter RFC3339DateFormatter] stringFromDate:end] forKey:@"end"];
    }
    if (limit) {
        [params setObject:limit forKey:@"limit"];
    }
    if (name && [name isKindOfClass:[NSArray class]]) {
        [params setObject:[name componentsJoinedByString:@","] forKey:@"name"];
    }
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"devices/%@/signals", deviceId]
                       parameters:params
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSMutableArray *signals = [NSMutableArray array];
                              for(NSDictionary *signalJSON in responseObject) {
                                  [signals addObject:[XeeSignal withJSON:signalJSON]];
                              }
                              completionHandler(signals, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)deviceStatusWithDeviceId:(NSString *)deviceId
              completionHandler:(void (^)(XeeDeviceStatus *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"devices/%@/status", deviceId]
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              XeeDeviceStatus *deviceStatus = [XeeDeviceStatus withJSON:responseObject];
                              completionHandler(deviceStatus, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)associateDeviceId:(NSString*)deviceId
                 withCar:(NSString*)carId
       completionHandler:(void (^)(NSError *))completionHandler {
    
    [[XeeClient sharedClient] POST:[NSString stringWithFormat:@"devices/%@/associate?carId=%@", deviceId, carId]
                        parameters:nil
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               completionHandler(nil);
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               completionHandler(error);
                           }];
}

-(void)associateDeviceId:(NSString*)deviceId
                 withPin:(NSString*)pin
       completionHandler:(void (^)(NSError *))completionHandler {
    
    [[XeeClient sharedClient] POST:[NSString stringWithFormat:@"devices/%@/associate?pin=%@", deviceId, pin]
                        parameters:nil
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               completionHandler(nil);
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               completionHandler(error);
                           }];
}

-(void)dissociateDeviceWithId:(NSString*)deviceId
            completionHandler:(void (^)(NSError *))completionHandler {
    
    [[XeeClient sharedClient] POST:[NSString stringWithFormat:@"devices/%@/dissociate", deviceId]
                        parameters:nil
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               completionHandler(nil);
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               completionHandler(error);
                           }];
}

@end
