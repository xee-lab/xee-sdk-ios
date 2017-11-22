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

#import "XeeTripRoute.h"

@implementation XeeTripRoute

-(void)tripWithId:(NSString*)tripId
completionHandler:(void (^)(XeeTrip *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"trips/%@", tripId]
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              XeeTrip *trip = [XeeTrip withJSON:responseObject];
                              completionHandler(trip, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)locationsWithTripId:(NSString*)tripId
         completionHandler:(void (^)(NSArray<XeeLocation *> *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"trips/%@/locations", tripId]
                       parameters:nil
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

-(void)locationsGeoJSONWithTripId:(NSString*)tripId
                completionHandler:(void (^)(NSArray *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"trips/%@/locations.geojson", tripId]
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              completionHandler(responseObject, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)signalsWithTripId:(NSString*)tripId
                    name:(NSArray<NSString *> *)name
       completionHandler:(void (^)(NSArray<XeeSignal *> *, NSError *))completionHandler {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (name && [name isKindOfClass:[NSArray class]]) {
        [params setObject:[name componentsJoinedByString:@","] forKey:@"name"];
    }
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"trips/%@/signals", tripId]
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

-(void)statsWithTripId:(NSString *)tripId
     completionHandler:(void (^)(NSArray<XeeStat *> *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"trips/%@/stats", tripId]
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSMutableArray *stats = [NSMutableArray array];
                              for(NSDictionary *stat in responseObject) {
                                  [stats addObject:[XeeStat withJSON:stat]];
                              }
                              completionHandler(stats, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

@end
