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

@interface XeeTripRoute : XeeRoute

/*!
 Get a specific trip from its id
 @param tripId The id of the trip you are looking for
 */
-(void)tripWithId:(NSString*)tripId
completionHandler:(void (^)(XeeTrip *trip, NSError *error))completionHandler;

/*!
 Get the locations history from a specific trip
 @param tripId The id of the trip you are looking for the locations
 */
-(void)locationsWithTripId:(NSString*)tripId
         completionHandler:(void (^)(NSArray<XeeLocation*> *locations, NSError *error))completionHandler;

/*!
 Get the locations history from a specific trip as a Geojson LineString
 @param tripId The id of the trip you are looking for the locations
 */
-(void)locationsGeoJSONWithTripId:(NSString*)tripId
                completionHandler:(void (^)(NSArray *locations, NSError *error))completionHandler;

/*!
 Get all signals history from a specific trip
 @param tripId The id of the trip you are looking for the signals
 @param name The list of signals you want, for example, if you want LockSts and Odometer, you'll have name=LockSts,Odometer, by default, all the signals available are sent back. You can see the full list here: https://github.com/xee-lab/xee-api-docs/blob/master/api/api/v3/cars/signals_list.md
 */
-(void)signalsWithTripId:(NSString*)tripId
                    name:(NSArray<NSString*>*)name
       completionHandler:(void (^)(NSArray<XeeSignal*> *signals, NSError *error))completionHandler;

-(void)statsWithTripId:(NSString*)tripId
     completionHandler:(void (^)(NSArray<XeeStat*> *stats, NSError *error))completionHandler;

@end
