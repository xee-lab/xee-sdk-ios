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

@interface XeeCarRoute : XeeRoute

/*!
 Get a specific car from its id
 @param carId The id of the car you are looking for
 */
-(void)carWithCarId:(uint)carId completionHandler:(void (^)(XeeCar *car, NSArray<XeeError *> *errors))completionHandler;

/*!
 Get the current status of a specific car
 @param carId The id of the car you are looking for the status
 */
-(void)statusWithCarId:(uint)carId completionHandler:(void (^)(XeeCarStatus *carStatus, NSArray<XeeError *> *errors))completionHandler;

/*!
 Get the locations history from a specific car
 @param carId The id of the car you are looking for the locations
 @param limit The maximum number of locations you want in return
 @param begin The start of the interval when you want the locations, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is First day of month at 00:00:00+00:00
 @param end The end of the interval when you want the locations, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is Current moment when you send request
 */
-(void)locationsWithCarId:(uint)carId limit:(NSInteger)limit begin:(NSDate*)begin end:(NSDate*)end completionHandler:(void (^)(NSArray<XeeLocation*> *locations, NSArray<XeeError *> *errors))completionHandler;

/*!
 Get the locations history from a specific car as an array of Geojson points. More informations about geoJSON here: http://geojson.org/geojson-spec.html#id2
 @param carId The id of the car you are looking for the locations
 @param limit The maximum number of locations you want in return
 @param begin The start of the interval when you want the locations, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is First day of month at 00:00:00+00:00
 @param end The end of the interval when you want the locations, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is Current moment when you send request
 */
-(void)locationsGeoJSONWithCarId:(uint)carId limit:(NSInteger)limit begin:(NSDate*)begin end:(NSDate*)end completionHandler:(void (^)(NSArray *locations, NSArray<XeeError *> *errors))completionHandler;

/*!
 Get all signals (data) history from a specific car
 @param carId The id of the car you are looking for the signals
 @param limit The maximum number of signals you want in return
 @param begin The start of the interval when you want the signals, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is First day of month at 00:00:00+00:00
 @param end The end of the interval when you want the signals, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is Current moment when you send request
 @param name The list of signals you want, for example, if you want LockSts and Odometer, you'll have name=LockSts,Odometer, by default, all the signals available are sent back. You can see the full list here: https://github.com/xee-lab/xee-api-docs/blob/master/api/api/v3/cars/signals_list.md
 */
-(void)signalsWithCarId:(uint)carId limit:(NSInteger)limit begin:(NSDate*)begin end:(NSDate*)end name:(NSArray<NSString*>*)name completionHandler:(void (^)(NSArray<XeeSignal*> *signals, NSArray<XeeError *> *errors))completionHandler;

/*!
 Get the trips history from a specific car
 @param carId The id of the car you are looking for the trips
 @param begin The start of the interval when you want the trips, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is First day of month at 00:00:00+00:00
 @param end The end of the interval when you want the trips, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is Current moment when you send request
 */
-(void)tripsWithCarId:(uint)carId begin:(NSDate*)begin end:(NSDate*)end completionHandler:(void (^)(NSArray<XeeTrip*> *trips, NSArray<XeeError *> *errors))completionHandler;

@end
