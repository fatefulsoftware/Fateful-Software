//
//  DeviceDetection.m
//  Max Horváth
//
//  Created by Max Horváth on 1/20/10.
//  Copyright 2010 Max Horváth. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "DeviceDetection.h"

@implementation DeviceDetection

+ (DeviceDetectionModel)detectDevice {
    NSString *model= [[UIDevice currentDevice] model];
    
    // Some iPod Touch return "iPod Touch", others just "iPod"
    
    NSString *iPodTouch = @"iPod Touch";
    NSString *iPodTouchLowerCase = @"iPod touch";
    NSString *iPodTouchShort = @"iPod";
    
    NSString *iPhoneSimulator = @"iPhone Simulator";
    
    uint detected;
    
    if ([model compare:iPhoneSimulator] == NSOrderedSame) {
        // iPhone simulator
        detected = MODEL_IPHONE_SIMULATOR;
    } else if ([model compare:iPodTouch] == NSOrderedSame) {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    } else if ([model compare:iPodTouchLowerCase] == NSOrderedSame) {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    } else if ([model compare:iPodTouchShort] == NSOrderedSame) {
        // iPod Touch
        detected = MODEL_IPOD_TOUCH;
    } else {
        // Could be an iPhone V1 or iPhone 3G (model should be "iPhone")
        struct utsname u;
        
        // u.machine could be "i386" for the simulator, "iPod1,1" on iPod Touch, "iPhone1,1" on iPhone V1 & "iPhone1,2" on iPhone3G
        
        uname(&u);
        
        if (!strcmp(u.machine, "iPhone1,1")) {
            detected = MODEL_IPHONE;
        } else {
            detected = MODEL_IPHONE_3G;
        }
    }
    return detected;
}

+ (NSString *)returnDeviceName:(BOOL)ignoreSimulator {
    NSString *returnValue = @"Unknown";
    
    switch ([DeviceDetection detectDevice]) {
        case MODEL_IPHONE_SIMULATOR:
            if (ignoreSimulator) {
                returnValue = @"iPhone 3G";
            } else {
                returnValue = @"iPhone Simulator";
            }
            break;
        case MODEL_IPOD_TOUCH:
            returnValue = @"iPod Touch";
            break;
        case MODEL_IPHONE:
            returnValue = @"iPhone";
            break;
        case MODEL_IPHONE_3G:
            returnValue = @"iPhone 3G";
            break;
        default:
            break;
    }
    
    return returnValue;
}

@end

@implementation UIDevice (UIDevicePadAdditions)

+ (DeviceDetectionModel)detectDevice {
	UIDevice *device;
	
	device = [UIDevice currentDevice];
	
	if ([device respondsToSelector:@selector(userInterfaceIdiom)] && [device userInterfaceIdiom] > 0)
		return MODEL_IPAD;
	
	return [DeviceDetection detectDevice];
}

@end
