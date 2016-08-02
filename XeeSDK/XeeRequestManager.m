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

#import "XeeRequestManager.h"

@implementation XeeRequestManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _users = [[XeeUserRoute alloc] init];
        _cars = [[XeeCarRoute alloc] init];
        _trips = [[XeeTripRoute alloc] init];
        _stats = [[XeeStatRoute alloc] init];
    }
    return self;
}

@end
