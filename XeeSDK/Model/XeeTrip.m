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

#import "XeeTrip.h"

@implementation XeeTrip

-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if(self) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            _id = [JSON objectForKey:@"id"];
            
            _beginLocation = [XeeLocation withJSON:[JSON objectForKey:@"beginLocation"]];
            _endLocation = [XeeLocation withJSON:[JSON objectForKey:@"endLocation"]];
            
            _beginDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"beginDate"]];
            _endDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"endDate"]];
            
            _creationDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"creationDate"]];
            _lastUpdateDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"lastUpdateDate"]];
            
            _mileage = [XeeStat withJSON:[JSON objectForKey:@"mileage"]];
        }
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            id: %@\r\
            beginLocation: %@\r\
            endLocation: %@\r\
            beginDate: %@\r\
            endDate: %@\r\
            creationDate: %@\r\
            lastUpdateDate: %@\r\
            mileage: %@",
            _id, _beginLocation, _endLocation, _beginDate, _endDate, _creationDate, _lastUpdateDate, _mileage];
}

@end
