#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "globals.h"
#import "XeeAccelerometer.h"
#import "XeeCar.h"
#import "XeeCarStatus.h"
#import "XeeDeviceStatus.h"
#import "XeeLocation.h"
#import "XeeModel.h"
#import "XeeSignal.h"
#import "XeeStat.h"
#import "XeeTrip.h"
#import "XeeUser.h"
#import "XeeCarRoute.h"
#import "XeeDeviceRoute.h"
#import "XeeRoute.h"
#import "XeeStatRoute.h"
#import "XeeTripRoute.h"
#import "XeeUserRoute.h"
#import "Xee.h"
#import "XeeAccessToken.h"
#import "XeeConfig.h"
#import "XeeConnectManager.h"
#import "XeeDevice.h"
#import "XeeError.h"
#import "XeeHTTPClient.h"
#import "XeeLoginButton.h"
#import "XeeRegisterButton.h"
#import "XeeRequestManager.h"
#import "XeeSDK.h"

FOUNDATION_EXPORT double XeeSDKVersionNumber;
FOUNDATION_EXPORT const unsigned char XeeSDKVersionString[];

