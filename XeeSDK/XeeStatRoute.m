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

-(void)mileageWithCarId:(NSNumber *)carId
                  begin:(NSDate *)begin
                    end:(NSDate *)end
           initialValue:(NSNumber *)initialValue
      completionHandler:(void (^)(XeeStat *, NSError *))completionHandler {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (begin) {
        [params setObject:[NSDateFormatter xeeStringFromDate:begin] forKey:@"begin"];
    }
    if (end) {
        [params setObject:[NSDateFormatter xeeStringFromDate:end] forKey:@"end"];
    }
    if (initialValue) {
        [params setObject:initialValue forKey:@"initialValue"];
    }
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"cars/%@/stats/mileage", carId]
                       parameters:params
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              XeeStat *stat = [XeeStat withJSON:responseObject];
                              completionHandler(stat, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

-(void)usedTimeWithCarId:(NSNumber *)carId
                   begin:(NSDate *)begin
                     end:(NSDate *)end
            initialValue:(NSNumber *)initialValue
       completionHandler:(void (^)(XeeStat *, NSError *))completionHandler {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if (begin) {
        [params setObject:[NSDateFormatter xeeStringFromDate:begin] forKey:@"begin"];
    }
    if (end) {
        [params setObject:[NSDateFormatter xeeStringFromDate:end] forKey:@"end"];
    }
    if (initialValue) {
        [params setObject:initialValue forKey:@"initialValue"];
    }
    
    [[XeeClient sharedClient] GET:[NSString stringWithFormat:@"cars/%@/stats/usedtime", carId]
                       parameters:params
                         progress:nil
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              XeeStat *stat = [XeeStat withJSON:responseObject];
                              completionHandler(stat, nil);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              completionHandler(nil, error);
                          }];
}

@end
