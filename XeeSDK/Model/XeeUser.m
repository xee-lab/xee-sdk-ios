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

#import "XeeUser.h"

@implementation XeeUser

-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if (self) {
        if ([JSON isKindOfClass:[NSDictionary class]]) {
            _id = [JSON objectForKey:@"id"];
            _lastName = [JSON objectForKey:@"lastName"];
            _firstName = [JSON objectForKey:@"firstName"];
            _nickname = [JSON objectForKey:@"nickname"];
            _gender = [JSON objectForKey:@"gender"];
            _birthDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"birthDate"]];
            _licenceDeliveryDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"licenceDeliveryDate"]];
            _role = [JSON objectForKey:@"role"];
            _isLocationEnabled = [JSON objectForKey:@"isLocationEnabled"];
            _creationDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"creationDate"]];
            _lastUpdateDate = [[NSDateFormatter RFC3339DateFormatter] dateFromString:[JSON objectForKey:@"lastUpdateDate"]];
        }
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            id: %@\r\
            lastName: %@\r\
            firstName: %@\r\
            nickname: %@\r\
            gender: %@\r\
            birthDate: %@\r\
            licenceDeliveryDate: %@\r\
            role: %@\r\
            isLocationEnabled: %@\r\
            creationDate: %@\r\
            lastUpdateDate: %@",
            _id, _lastName, _firstName, _nickname, _gender, _birthDate, _licenceDeliveryDate, _role, _isLocationEnabled, _creationDate, _lastUpdateDate];
}

@end
