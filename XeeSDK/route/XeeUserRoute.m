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

-(void)me:(void (^)(XeeUser *, NSArray<XeeError *> *))completionHandler {
    NSString *urlString = @"users/me";
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            XeeUser *user = [[XeeUser alloc] initWithJSON:json];
            completionHandler(user, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)meCars:(void (^)(NSArray<XeeCar *> *, NSArray<XeeError *> *))completionHandler {
    NSString *urlString = @"users/me/cars";
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *cars = [NSMutableArray array];
            for(NSDictionary *jsonCar in json) {
                [cars addObject:[[XeeCar alloc] initWithJSON:jsonCar]];
            }
            completionHandler(cars, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

@end
