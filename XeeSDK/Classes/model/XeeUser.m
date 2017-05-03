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
#import "globals.h"

@implementation XeeUser

-(instancetype)initWithJSON:(NSDictionary *)JSON {
    self = [super initWithJSON:JSON];
    if (self) {
        _id = (int)[[JSON objectForKey:@"id"] integerValue];
        _lastName = [JSON objectForKey:@"lastName"];
        _firstName = [JSON objectForKey:@"firstName"];
        _nickname = [JSON objectForKey:@"nickname"];
        _gender = [JSON objectForKey:@"gender"];
        _birthDate = dateWithRFC3339([JSON objectForKey:@"birthDate"]);
        _licenceDeliveryDate = dateWithRFC3339([JSON objectForKey:@"licenceDeliveryDate"]);
        _role = [JSON objectForKey:@"role"];
        _isLocationEnabled = [[JSON objectForKey:@"isLocationEnabled"] boolValue];
        _creationDate = dateWithRFC3339([JSON objectForKey:@"creationDate"]);
        _lastUpdateDate = dateWithRFC3339([JSON objectForKey:@"lastUpdateDate"]);
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            id: %d\r\
            lastName: %@\r\
            firstName: %@\r\
            nickname: %@\r\
            gender: %@\r\
            birthDate: %@\r\
            licenceDeliveryDate: %@\r\
            role: %@\r\
            isLocationEnabled: %d\r\
            creationDate: %@\r\
            lastUpdateDate: %@",
            _id, _lastName, _firstName, _nickname, _gender, _birthDate, _licenceDeliveryDate, _role, _isLocationEnabled, _creationDate, _lastUpdateDate];
}

@end
