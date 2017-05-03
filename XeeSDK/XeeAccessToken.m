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

#import "XeeAccessToken.h"

@implementation XeeAccessToken

-(instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _access_token = [json objectForKey:@"access_token"];
        _refresh_token = [json objectForKey:@"refresh_token"];
        _token_type = [json objectForKey:@"token_type"];
        _expires_at = (int)[[json objectForKey:@"expires_at"] integerValue];
        _expires_in = (int)[[json objectForKey:@"expires_in"] integerValue];
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            access_token: %@\r\
            refresh_token: %@\r\
            token_type: %@\r\
            expires_at: %d\r\
            expires_in: %d\r",
            _access_token, _refresh_token, _token_type, _expires_at, _expires_in];
}

@end
