//
//  XeeViewController.m
//  XeeSDK
//
//  Created by jbdujardin on 05/02/2017.
//  Copyright (c) 2017 jbdujardin. All rights reserved.
//

#import "XeeViewController.h"
#import "XeeSDK.h"

@interface Cell : UITableViewCell
    
@property (nonatomic, strong) IBOutlet UILabel *label;
    
@end

@implementation Cell
    
@end

@interface XeeViewController () <UITableViewDelegate, UITableViewDataSource, XeeConnectManagerDelegate>

@property (nonatomic, strong) NSNumber *carId;
@property (nonatomic, strong) NSString *tripId;
@property (nonatomic, strong) NSString *deviceId;
    
@property (nonatomic, strong) IBOutlet UIButton *btnCarId;
@property (nonatomic, strong) IBOutlet UIButton *btnTripId;
@property (nonatomic, strong) IBOutlet UIButton *btnDeviceId;
    
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation XeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.textView.text = @"";
    
    self.carId = @0;
    self.tripId = @"";
    self.deviceId = @"";
    
    [self.btnCarId setTitle:@"edit" forState:UIControlStateNormal];
    [self.btnTripId setTitle:@"edit" forState:UIControlStateNormal];
    [self.btnDeviceId setTitle:@"edit" forState:UIControlStateNormal];
    
    // TEST - create programmatically xee login button
    /*XeeLoginButton *button = [[XeeLoginButton alloc] init];
     button.delegate = self;
     button.style = XeeLoginButtonStyleDark;
     button.center = self.view.center;
     [self.view addSubview:button];*/
}
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
-(void)show:(NSString*)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.textView.contentOffset = CGPointZero;
        self.textView.text = message;
    });
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
        cell.label.text = @"Me/Devices";
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        break;
        
        case 4:
        cell.label.text = @"Car signals";
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
        break;
        case 5:
        cell.label.text = @"Car locations";
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
        break;
        case 6:
        cell.label.text = @"Car geoJSON";
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
        break;
        case 7:
        cell.label.text = @"Car Status";
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
        break;
        case 8:
        cell.label.text = @"Car trips";
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
        break;
        case 9:
        cell.label.text = @"Car used time";
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
        break;
        case 10:
        cell.label.text = @"Car mileage";
        cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.9 blue:0.8 alpha:1.0];
        break;
        
        case 11:
        cell.label.text = @"Trip";
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1.0];
        break;
        case 12:
        cell.label.text = @"Trip location";
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1.0];
        break;
        case 13:
        cell.label.text = @"Trip geoJSON";
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1.0];
        break;
        case 14:
        cell.label.text = @"Trip signals";
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.8 alpha:1.0];
        break;
        
        case 15:
        cell.label.text = @"Device signals";
        cell.backgroundColor = [UIColor colorWithRed:0.4 green:0.9 blue:0.8 alpha:1.0];
        break;
        case 16:
        cell.label.text = @"Device status";
        cell.backgroundColor = [UIColor colorWithRed:0.4 green:0.9 blue:0.8 alpha:1.0];
        break;
        
        case 17:
        cell.label.text = @"disconnect";
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        break;
        
        default:
        break;
    }
    
    return cell;
}
    
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 17;
}
    
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        //connect
        case 0: {
            [Xee connectManager].delegate = self;
            [[Xee connectManager] connect];
        }
        break;
        
        //me
        case 1: {
            [[Xee requestManager].users me:^(XeeUser *user, NSError *error) {
                if(!error) {
                    [self show:user.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 2: {
            [[Xee requestManager].users meCars:^(NSArray<XeeCar *> *cars, NSError *error) {
                if(!error) {
                    [self show:cars.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
            
        case 3: {
            [[Xee requestManager].users meDevices:^(NSArray<XeeDevice *> *devices, NSError *error) {
                if(!error) {
                    [self show:devices.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        //cars
        case 4: {
            [[Xee requestManager].cars signalsWithCarId:self.carId limit:@0 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*10] end:nil name:nil completionHandler:^(NSArray<XeeSignal *> *signals, NSError *error) {
                if(!error) {
                    [self show:signals.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 5: {
            [[Xee requestManager].cars locationsWithCarId:self.carId limit:@0 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*10] end:nil completionHandler:^(NSArray<XeeLocation *> *locations, NSError *error) {
                if(!error) {
                    [self show:locations.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 6: {
            [[Xee requestManager].cars locationsGeoJSONWithCarId:self.carId limit:@0 begin:[NSDate dateWithTimeIntervalSinceNow:-3600*10] end:nil completionHandler:^(NSArray *locations, NSError *error) {
                if(!error) {
                    [self show:locations.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 7: {
            [[Xee requestManager].cars statusWithCarId:self.carId completionHandler:^(XeeCarStatus *carStatus, NSError *error) {
                if(!error) {
                    [self show:carStatus.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 8: {
            [[Xee requestManager].cars tripsWithCarId:self.carId begin:[NSDate dateWithTimeIntervalSinceNow:-3600*24*7] end:nil completionHandler:^(NSArray<XeeTrip *> *trips, NSError *error) {
                if(!error) {
                    [self show:trips.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 9: {
            [[Xee requestManager].stats usedTimeWithCarId:self.carId begin:nil end:nil initialValue:@0 completionHandler:^(XeeStat *stat, NSError *error) {
                if(!error) {
                    [self show:stat.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 10: {
            [[Xee requestManager].stats mileageWithCarId:self.carId begin:nil end:nil initialValue:@0 completionHandler:^(XeeStat *stat, NSError *error) {
                if(!error) {
                    [self show:stat.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        //trips
        case 11: {
            [[Xee requestManager].trips tripWithId:self.tripId completionHandler:^(XeeTrip *trip, NSError *error) {
                if(!error) {
                    [self show:trip.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 12: {
            [[Xee requestManager].trips locationsWithTripId:self.tripId completionHandler:^(NSArray<XeeLocation *> *locations, NSError *error) {
                if(!error) {
                    [self show:locations.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 13: {
            [[Xee requestManager].trips locationsGeoJSONWithTripId:self.tripId completionHandler:^(NSArray *locations, NSError *error) {
                if(!error) {
                    [self show:locations.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 14: {
            [[Xee requestManager].trips signalsWithTripId:self.tripId name:nil completionHandler:^(NSArray<XeeSignal *> *signals, NSError *error) {
                if(!error) {
                    [self show:signals.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        //devices
        case 15: {
            [[Xee requestManager].device signalsWithDeviceId:self.deviceId limit:@0 begin:nil end:nil name:nil completionHandler:^(NSArray<XeeSignal *> *signals, NSError *error) {
                if(!error) {
                    [self show:signals.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 16: {
            [[Xee requestManager].device deviceStatusWithDeviceId:self.deviceId completionHandler:^(XeeDeviceStatus *deviceStatus, NSError *error) {
                if(!error) {
                    [self show:deviceStatus.description];
                } else {
                    [self show:error.description];
                }
            }];
        }
        break;
        
        case 17:
        [[Xee connectManager] disconnect];
        break;
        
        default:
        break;
    }
}
    
-(IBAction)btnSetCarIdHandler:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Set your test car id" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = [NSString stringWithFormat:@"%@", self.carId];
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        self.carId = [NSNumber numberWithInteger:[textField.text integerValue]];
        [self.btnCarId setTitle:[NSString stringWithFormat:@"%@", self.carId] forState:UIControlStateNormal];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
    
-(IBAction)btnSetTripIdHandler:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Set your test trip id" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.tripId;
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        self.tripId = textField.text;
        [self.btnTripId setTitle:self.tripId forState:UIControlStateNormal];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)btnSetDeviceIdHandler:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Set your test device id" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.deviceId;
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alert.textFields[0];
        self.deviceId = textField.text;
        [self.btnDeviceId setTitle:self.deviceId forState:UIControlStateNormal];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}
    
-(UIView *)connectManagerViewForSignUp {
    return self.view;
}
    
-(UIView *)connectManagerViewForLogin {
    return self.view;
}
    
-(void)connectManager:(XeeConnectManager *)connectManager didFailWithError:(NSError *)error {
    [self show:error.description];
}
    
-(void)connectManager:(XeeConnectManager *)connectManager didSuccess:(XeeAccessToken *)accessToken {
    [self show:accessToken.description];
}
    
-(void)connectManagerDidCancel:(XeeConnectManager *)connectManager {
    
}

@end
