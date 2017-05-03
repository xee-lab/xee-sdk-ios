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

#import "XeeStatRoute.h"

@implementation XeeStatRoute

-(void)mileageWithCarId:(uint)carId begin:(NSDate *)begin end:(NSDate *)end initialValue:(float)initialValue completionHandler:(void (^)(XeeStat *, NSArray<XeeError *> *))completionHandler {
    NSString *beginString = stringWithRFC3339Date(begin);
    NSString *endString = stringWithRFC3339Date(end);
    NSString *urlString = [NSString stringWithFormat:@"cars/%d/stats/mileage?begin=%@&end=%@&initialValue=%f", carId, beginString, endString, initialValue];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            XeeStat *stat = [XeeStat withJSON:JSON];
            completionHandler(stat, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

-(void)usedTimeWithCarId:(uint)carId begin:(NSDate *)begin end:(NSDate *)end initialValue:(float)initialValue completionHandler:(void (^)(XeeStat *, NSArray<XeeError *> *))completionHandler {
    NSString *beginString = stringWithRFC3339Date(begin);
    NSString *endString = stringWithRFC3339Date(end);
    NSString *urlString = [NSString stringWithFormat:@"cars/%d/stats/usedtime?begin=%@&end=%@&initialValue=%f", carId, beginString, endString, initialValue];
    NSDictionary *headers = [self configureHeader];
    [[client method:@"GET" urlString:urlString params:nil headers:headers completionHandler:^(NSData *data, NSArray<XeeError *> *errors) {
        if(!errors) {
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
            XeeStat *stat = [XeeStat withJSON:JSON];
            completionHandler(stat, errors);
        } else {
            completionHandler(nil, errors);
        }
    }] resume];
}

@end
