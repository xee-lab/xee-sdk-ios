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

#import "ViewController.h"
#import <XeeSDK/XeeSDK.h>

@interface Cell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *label;

@end

@implementation Cell

@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource> {
    int carId;
    NSString *tripId;
}

@property (nonatomic, strong) IBOutlet UIButton *btnCarId;
@property (nonatomic, strong) IBOutlet UIButton *btnTripId;

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textView.text = @"";
    
    carId = 0;
    tripId = @"";
    
    [self.btnCarId setTitle:@"edit" forState:UIControlStateNormal];
    [self.btnTripId setTitle:@"edit" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)show:(NSString*)message {
    self.textView.contentOffset = CGPointZero;
    self.textView.text = message;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    switch (indexPath.row) {
        case 0:
            cell.label.text = @"Connect";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.9 alpha:1.0];
            break;
            
        case 1:
            cell.label.text = @"Me";
            cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            break;
        case 2:
            cell.label.text = @"Me/Cars";
            cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            break;
            
        case 3:
            cell.label.text = @"Car signals";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
            break;
        case 4:
            cell.label.text = @"Car locations";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
            break;
        case 5:
            cell.label.text = @"Car geoJSON";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
            break;
        case 6:
            cell.label.text = @"Car Status";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
            break;
        case 7:
            cell.label.text = @"Car trips";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
            break;
        case 8:
            cell.label.text = @"Car used time";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
            break;
        case 9:
            cell.label.text = @"Car mileage";
            cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
            break;
            
        case 10:
            cell.label.text = @"Trip";
            cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1.0];
            break;
        case 11:
            cell.label.text = @"Trip location";
            cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1.0];
            break;
        case 12:
            cell.label.text = @"Trip geoJSON";
            cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1.0];
            break;
        case 13:
            cell.label.text = @"Trip signals";
            cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1.0];
            break;
            
        case 14:
            cell.label.text = @"Device signals";
            cell.backgroundColor = [UIColor colorWithRed:0.4 green:0.9 blue:0.8 alpha:1.0];
            break;
            
        case 15:
            cell.label.text = @"disconnect";
            cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 16;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        //connect
        case 0: {
            [[Xee connectManager] connect:^(XeeAccessToken *accessToken, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:accessToken.description];
                } else {
                    [self show:errors[0].message];
                }
            }];
        }
            break;
            
        //me
        case 1: {
            [[Xee requestManager].users me:^(XeeUser *user, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:user.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 2: {
            [[Xee requestManager].users meCars:^(NSArray<XeeCar *> *cars, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:cars.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        //cars
        case 3: {
            [[Xee requestManager].cars signalsWithCarId:carId limit:0 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*10] end:nil name:nil completionHandler:^(NSArray<XeeSignal *> *signals, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:signals.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 4: {
            [[Xee requestManager].cars locationsWithCarId:carId limit:0 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*10] end:nil completionHandler:^(NSArray<XeeLocation *> *locations, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:locations.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 5: {
            [[Xee requestManager].cars locationsGeoJSONWithCarId:carId limit:0 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*10] end:nil completionHandler:^(NSArray *locations, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:locations.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 6: {
            [[Xee requestManager].cars statusWithCarId:carId completionHandler:^(XeeCarStatus *carStatus, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:carStatus.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 7: {
            [[Xee requestManager].cars tripsWithCarId:carId begin:[NSDate dateWithTimeIntervalSinceNow:-3600*24*7] end:nil completionHandler:^(NSArray<XeeTrip *> *trips, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:trips.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 8: {
            [[Xee requestManager].stats mileageWithCarId:carId begin:nil end:nil initialValue:0 completionHandler:^(XeeStat *stat, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:stat.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 9: {
            [[Xee requestManager].stats usedTimeWithCarId:carId begin:nil end:nil initialValue:0 completionHandler:^(XeeStat *stat, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:stat.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        //trips
        case 10: {
            [[Xee requestManager].trips tripWithId:tripId completionHandler:^(XeeTrip *trip, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:trip.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 11: {
            [[Xee requestManager].trips locationsWithTripId:tripId completionHandler:^(NSArray<XeeLocation *> *locations, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:locations.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 12: {
            [[Xee requestManager].trips locationsGeoJSONWithTripId:tripId completionHandler:^(NSArray *locations, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:locations.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        case 13: {
            [[Xee requestManager].trips signalsWithTripId:tripId name:nil completionHandler:^(NSArray<XeeSignal *> *signals, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:signals.description];
                } else {
                    [self show:errors.description];
                }
            }];
        }
            break;
            
        //devices
        case 14: {
            [[Xee requestManager].device signalsWithDeviceId:@"E130003911" limit:0 begin:nil end:nil name:nil completionHandler:^(NSArray<XeeSignal *> *signals, NSArray<XeeError *> *errors) {
                if(!errors) {
                    [self show:signals.description];
                } else {
                    [self show:errors.description];
                }
                    
            }];
        }
            break;
            
        case 15:
            [[Xee connectManager] disconnect];
            break;
            
        default:
            break;
    }
}

-(IBAction)btnSetCarIdHandler:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Set your test car id" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = [NSString stringWithFormat:@"%d", carId];
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        carId = (int)textField.text.integerValue;
        [self.btnCarId setTitle:[NSString stringWithFormat:@"%d", carId] forState:UIControlStateNormal];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

-(IBAction)btnSetTripIdHandler:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Set your test trip id" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = tripId;
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        tripId = textField.text;
        [self.btnTripId setTitle:tripId forState:UIControlStateNormal];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
