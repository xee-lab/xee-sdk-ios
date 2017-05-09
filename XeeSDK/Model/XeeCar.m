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
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            _id = [JSON objectForKey:@"id"];
            _name = [JSON objectForKey:@"name"];
            _make = [JSON objectForKey:@"make"];
            _model = [JSON objectForKey:@"model"];
            _year = [JSON objectForKey:@"year"];
            _numberPlate = [JSON objectForKey:@"numberPlate"];
            _deviceId = [JSON objectForKey:@"deviceId"];
            _cardbId = [JSON objectForKey:@"cardbId"];
            _creationDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"creationDate"]];
            _lastUpdateDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"lastUpdateDate"]];
        }
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            id: %@\r\
            name: %@\r\
            make: %@\r\
            model: %@\r\
            year: %@\r\
            numberPlate: %@\r\
            deviceId: %@\r\
            cardbId: %@\r\
            creationDate: %@\r\
            lastUpdateDate: %@",
            _id, _name, _make, _model, _year, _numberPlate, _deviceId, _cardbId, _creationDate, _lastUpdateDate];
}

-(NSDictionary *)asDictionary {
    NSMutableDictionary *carDictionary = [NSMutableDictionary dictionary];
    
    if (self.id) {
        [carDictionary setObject:self.id forKey:@"id"];
    }
    
    if (self.name) {
        [carDictionary setObject:self.name forKey:@"name"];
    }
    
    if (self.make) {
        [carDictionary setObject:self.name forKey:@"make"];
    }
    
    if (self.model) {
        [carDictionary setObject:self.model forKey:@"model"];
    }
    
    if (self.year) {
        [carDictionary setObject:self.year forKey:@"year"];
    }
    
    if (self.numberPlate) {
        [carDictionary setObject:self.numberPlate forKey:@"numberPlate"];
    }
    
    if (self.deviceId) {
        [carDictionary setObject:self.deviceId forKey:@"deviceId"];
    }
    
    if (self.cardbId) {
        [carDictionary setObject:self.cardbId forKey:@"cardbId"];
    }
    
    if (self.creationDate) {
        [carDictionary setObject:[[NSDateFormatter RFC3339DateFormatter] stringFromDate:self.creationDate] forKey:@"creationDate"];
    }
    
    if (self.lastUpdateDate) {
        [carDictionary setObject:[[NSDateFormatter RFC3339DateFormatter] stringFromDate:self.lastUpdateDate] forKey:@"lastUpdateDate"];
    }
    
    return carDictionary;
}

@end
