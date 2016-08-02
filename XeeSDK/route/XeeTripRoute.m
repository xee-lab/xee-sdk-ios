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

-(void)tripWithId:(NSString*)tripId completionHandler:(void (^)(XeeTrip *, NSArray<XeeError *> *))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"trips/%@", tripId];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            XeeTrip *trip = [XeeTrip withJSON:JSON];
            completionHandler(trip, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)locationsWithTripId:(NSString*)tripId completionHandler:(void (^)(NSArray<XeeLocation *> *, NSArray<XeeError *> *))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"trips/%@/locations", tripId];
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

-(void)locationsGeoJSONWithTripId:(NSString*)tripId completionHandler:(void (^)(NSArray *, NSArray<XeeError *> *))completionHandler {
    NSString *urlString = [NSString stringWithFormat:@"trips/%@/locations.geojson", tripId];
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

-(void)signalsWithTripId:(NSString*)tripId name:(NSArray<NSString *> *)name completionHandler:(void (^)(NSArray<XeeSignal *> *, NSArray<XeeError *> *))completionHandler {
    NSString *nameString = [client createURLEncodedStringWithCommaWithArray:name];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    if(![nameString isEqualToString:@""]) {
        [dic setValue:nameString forKey:@"name"];
    }
    NSString *params = [client createHTTPParamsWithDictionary:dic];
    NSString *urlString = [NSString stringWithFormat:@"trips/%@/signals%@%@", tripId, dic.count > 0 ? @"?" : @"", params];
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

@end
