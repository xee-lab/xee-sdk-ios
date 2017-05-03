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

#import "XeeRoute.h"

@interface XeeStatRoute : XeeRoute

/*!
 Get the mileage value for a specific car
 @param carId The id of the car you are looking for the mileage
 @param begin The start of the interval when you want the mileage to be computed, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is First day of month at 00:00:00+00:00
 @param end The end of the interval when you want the mileage to be computed, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is Current moment when you send request
 @param initialValue An offset to add to the mileage stat. Default value is 0
 */
-(void)mileageWithCarId:(uint)carId begin:(NSDate *)begin end:(NSDate *)end initialValue:(float)initialValue completionHandler:(void (^)(XeeStat *stat, NSArray<XeeError *> *errors))completionHandler;

/*!
 Get the used time value for a specific car
 @param carId The id of the car you are looking for the used time
 @param begin The start of the interval when you want the used time to be computed, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is First day of month at 00:00:00+00:00
 @param end The end of the interval when you want the used time to be computed, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is Current moment when you send request
 @param initialValue An offset to add to the used time stat (in seconds). Default value is 0
 */
-(void)usedTimeWithCarId:(uint)carId begin:(NSDate *)begin end:(NSDate *)end initialValue:(float)initialValue completionHandler:(void (^)(XeeStat *stat, NSArray<XeeError *> *errors))completionHandler;

@end
