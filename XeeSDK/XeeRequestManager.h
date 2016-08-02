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

#import <Foundation/Foundation.h>

#import "XeeUserRoute.h"
#import "XeeCarRoute.h"
#import "XeeTripRoute.h"
#import "XeeStatRoute.h"

@interface XeeRequestManager : NSObject

@property (nonatomic, strong) XeeUserRoute *users;
@property (nonatomic, strong) XeeCarRoute *cars;
@property (nonatomic, strong) XeeTripRoute *trips;
@property (nonatomic, strong) XeeStatRoute *stats;

@end
