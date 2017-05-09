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

-(void)carWithCarId:(NSNumber *)carId
  completionHandler:(void (^)(XeeCar *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"cars/%@", carId]
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              XeeCar *car = [XeeCar withJSON:responseObject];
                              completionHandler(car, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)statusWithCarId:(NSNumber *)carId
     completionHandler:(void (^)(XeeCarStatus *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"cars/%@/status", carId]
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              XeeCarStatus *carStatus = [XeeCarStatus withJSON:responseObject];
                              completionHandler(carStatus, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)locationsWithCarId:(NSNumber *)carId
                    limit:(NSNumber *)limit
                    begin:(NSDate *)begin
                      end:(NSDate *)end
        completionHandler:(void (^)(NSArray<XeeLocation *> *, NSError *))completionHandler {
    
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
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"cars/%@/locations", carId]
                       parameters:params
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSMutableArray *locations = [NSMutableArray array];
                              for(NSDictionary *locationJSON in responseObject) {
                                  [locations addObject:[XeeLocation withJSON:locationJSON]];
                              }
                              completionHandler(locations, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)locationsGeoJSONWithCarId:(NSNumber *)carId
                           limit:(NSNumber *)limit
                           begin:(NSDate *)begin
                             end:(NSDate *)end
               completionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    
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

    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"cars/%@/locations.geojson", carId]
                       parameters:params
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              completionHandler(responseObject, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)signalsWithCarId:(NSNumber *)carId
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
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"cars/%@/signals", carId]
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

-(void)tripsWithCarId:(NSNumber *)carId
                begin:(NSDate *)begin
                  end:(NSDate *)end
    completionHandler:(void (^)(NSArray<XeeTrip *> *, NSError *))completionHandler {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (begin) {
        [params setObject:[[NSDateFormatter RFC3339DateFormatter] stringFromDate:begin] forKey:@"begin"];
    }
    if (end) {
        [params setObject:[[NSDateFormatter RFC3339DateFormatter] stringFromDate:end] forKey:@"end"];
    }
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"cars/%@/trips", carId]
                       parameters:params
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSMutableArray *trips = [NSMutableArray array];
                              for(NSDictionary *tripJSON in responseObject) {
                                  [trips addObject:[XeeTrip withJSON:tripJSON]];
                              }
                              completionHandler(trips, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

@end
