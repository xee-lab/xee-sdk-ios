//
//  XeeDeviceRoute.h
//  XeeSDK
//
//  Created by Anthony Pauriche on 22/08/2016.
//  Copyright © 2016 Eliocity. All rights reserved.
//

#import "XeeRoute.h"

@interface XeeDeviceRoute : XeeRoute

/*!
 Get all signals (data) history from a specific device
 @param deviceId The id of the device you are looking for the signals
 @param limit The maximum number of signals you want in return
 @param begin The start of the interval when you want the signals, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is First day of month at 00:00:00+00:00
 @param end The end of the interval when you want the signals, Format is 2016-04-20T13:37:42Z(+/-HH:mm) default value is Current moment when you send request
 @param name The list of signals you want. By default, all the signals available are sent back.
 */
-(void)signalsWithDeviceId:(NSString*)deviceId limit:(NSInteger)limit begin:(NSDate *)begin end:(NSDate *)end name:(NSArray<NSString *> *)name completionHandler:(void (^)(NSArray<XeeSignal*> *signals, NSArray<XeeError *> *errors))completionHandler;

/*!
 Get the current status of a specific device
 @param deviceId The id of the device you are looking for the status
 */
-(void)deviceStatusWithDeviceId:(NSString*)deviceId completionHandler:(void (^)(XeeDeviceStatus *deviceStatus, NSArray<XeeError *> *errors))completionHandler;

-(void)associateDeviceId:(NSString*)deviceId withCar:(NSString*)carId completionHandler:(void (^)(NSArray<XeeError *> *errors))completionHandler;

-(void)associateDeviceId:(NSString*)deviceId withPin:(NSString*)pin completionHandler:(void (^)(NSArray<XeeError *> *errors))completionHandler;

-(void)dissociateDeviceWithId:(NSString*)deviceId completionHandler:(void (^)(NSArray<XeeError *> *errors))completionHandler;

@end
