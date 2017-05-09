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

#import "XeeUserRoute.h"

@implementation XeeUserRoute

-(void)me:(void (^)(XeeUser *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:@"users/me"
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              XeeUser *user = [[XeeUser alloc] initWithJSON:responseObject];
                              completionHandler(user, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)meCars:(void (^)(NSArray<XeeCar *> *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:@"users/me/cars"
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSMutableArray *cars = [NSMutableArray array];
                              for(NSDictionary *jsonCar in responseObject) {
                                  [cars addObject:[[XeeCar alloc] initWithJSON:jsonCar]];
                              }
                              completionHandler(cars, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)meDevices:(void (^)(NSArray<XeeDevice*> *, NSError *))completionHandler {
    
    [[XeeClient sharedClient] GET:@"users/me/devices"
                       parameters:nil
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              NSMutableArray *devices = [NSMutableArray array];
                              for(NSDictionary *jsonDevice in responseObject) {
                                  [devices addObject:[[XeeDevice alloc] initWithJSON:jsonDevice]];
                              }
                              completionHandler(devices, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}
    
-(void)meCreateCarWithCar:(XeeCar *)car Completion:(void (^)(XeeCar *, NSError *))completionHandler {
    
    NSDictionary *params = [car asDictionary];
    
    [[XeeClient sharedClient] POST:@"users/me/cars"
                        parameters:params
                          progress:nil
                           success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                               XeeCar *car = [[XeeCar alloc] initWithJSON:responseObject];
                               completionHandler(car, nil);
                           } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               completionHandler(nil, error);
                           }];
}

@end
