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

#import "XeeCar.h"

@implementation XeeCar

-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if (self) {
        _id = (int)[[JSON objectForKey:@"id"] integerValue];
        _name = [JSON objectForKey:@"name"];
        _make = [JSON objectForKey:@"make"];
        _model = [JSON objectForKey:@"model"];
        _year = (int)[[JSON objectForKey:@"year"] integerValue];
        _numberPlate = [JSON objectForKey:@"numberPlate"];
        _deviceId = [JSON objectForKey:@"deviceId"] != [NSNull null] ? [JSON objectForKey:@"deviceId"] : @"";
        _cardbId = (int)[[JSON objectForKey:@"cardbId"] integerValue];
        _creationDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"creationDate"]];
        _lastUpdateDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"lastUpdateDate"]];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            id: %d\r\
            name: %@\r\
            make: %@\r\
            model: %@\r\
            year: %d\r\
            numberPlate: %@\r\
            deviceId: %@\r\
            cardbId: %d\r\
            creationDate: %@\r\
            lastUpdateDate: %@",
            _id, _name, _make, _model, _year, _numberPlate, _deviceId, _cardbId, _creationDate, _lastUpdateDate];
}

@end
