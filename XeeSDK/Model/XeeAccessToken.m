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
        if ([json isKindOfClass:[NSDictionary class]]) {
            _access_token = [json objectForKey:@"access_token"];
            _refresh_token = [json objectForKey:@"refresh_token"];
            _token_type = [json objectForKey:@"token_type"];
            _expires_at = [json objectForKey:@"expires_at"];
            _expires_in = [json objectForKey:@"expires_in"];
        }
    }
    return self;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"\
            access_token: %@\r\
            refresh_token: %@\r\
            token_type: %@\r\
            expires_at: %@\r\
            expires_in: %@\r",
            _access_token, _refresh_token, _token_type, _expires_at, _expires_in];
}

@end
