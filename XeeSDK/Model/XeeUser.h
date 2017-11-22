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

#import "XeeModel.h"

@interface XeeUser : XeeModel

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSDate *birthDate;
@property (nonatomic, strong) NSDate *licenceDeliveryDate;

@property (nonatomic, strong) NSString *role;

@property (nonatomic, strong) NSNumber *isLocationEnabled;

@property (nonatomic, strong) NSDate *creationDate;
@property (nonatomic, strong) NSDate *lastUpdateDate;

@end
